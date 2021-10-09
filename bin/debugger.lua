local cjson = require "cjson"
cjson.encode_empty_table_as_array(true)
local vscaux = require "vscaux"

local workdir = ""
local skynet = ""
local config = ""
local service = ""
local open_debug = true

local reqfuncs = {}
local breakpoints = {}

--初始化
function reqfuncs.initialize(req)
    vscaux.send_response(req.command, req.seq, {
        supportsConfigurationDoneRequest = true,
        supportsSetVariable = false,
        supportsConditionalBreakpoints = true,
        supportsHitConditionalBreakpoints = true,
    })
    vscaux.send_event("initialized")
    vscaux.send_event("output", {
        category = "console",
        output = "skynet debugger start!\n",
    })
end

--断点数量
local function calc_hitcount(hitexpr)
    if not hitexpr then return 0 end
    
    local f, msg = load("return " .. hitexpr, "=hitexpr")
    if not f then return 0 end
    
    local ok, ret = pcall(f)
    if not ok then return 0 end
    
    return tonumber(ret) or 0
end

--设置断点
function reqfuncs.setBreakpoints(req)
    local args = req.arguments
    local src = args.source.path
    local bpinfos = {}
    local bps = {}
    for _, bp in ipairs(args.breakpoints) do
        local logmsg
        if bp.logMessage and bp.logMessage ~= "" then
            logmsg = bp.logMessage .. '\n'
        end
        bpinfos[#bpinfos+1] = {
            source = {path = src},
            line = bp.line,
            logMessage = logmsg,
            condition = bp.condition,
            hitCount = calc_hitcount(bp.hitCondition),
            currHitCount = 0,
        }
        bps[#bps+1] = {
            verified = true,
            source = {path = src},
            line = bp.line,
        }
    end
    breakpoints[src] = bpinfos
    vscaux.send_response(req.command, req.seq, {
        breakpoints = bps,
    })
end

--设置异常断点
function reqfuncs.setExceptionBreakpoints(req)
    vscaux.send_response(req.command, req.seq)
end

function reqfuncs.configurationDone(req)
    vscaux.send_response(req.command, req.seq)
end

--启动调试
function reqfuncs.launch(req)
	workdir = req.arguments.workdir or "."
	if workdir:sub(-1) == "/" then
		workdir = workdir:sub(1, -2)
	end
    skynet = req.arguments.program
    config = req.arguments.config
	service = req.arguments.service
    open_debug = not req.arguments.noDebug
    return true
end

--接收命令
function handle_request()
    while true do
        local req = vscaux.recv_request()
        if not req or not req.command then
            return false
        end
        local func = reqfuncs[req.command]
        if func and func(req) then
            break
        elseif not func then
            vscaux.send_error_response(req.command, req.seq, string.format("%s not yet implemented", req.command))
        end
    end
    return true
end

--接收请求
if handle_request() then
    return workdir, skynet, config, service, open_debug, cjson.encode(breakpoints)
else
    error("launch error")
end
