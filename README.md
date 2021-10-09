Skynet 调试器

## 功能特性

这是一个基于skynet框架的Lua调试器，它提供如下特性：

- 将skynet.error输出到`DEBUG CONSOLE`面板，点击日志可跳转到代码行。
- 设置断点：除了普通断点，还支持以下几种：
    - 条件断点：当表达式为true时停下来。
    - Hit Count断点：命中一定次数后停下来。
    - 日志断点：命中时输出日志。
- 当程序停下来时可以：
    - 查看调用堆栈。
    - 查看每一层栈帧的局部变量，自由变量。
    - 通过`WATCH`面板增加监控的表达式。
    - 可在`DEBUG CONSOLE`底部输入表达式，甚至可以修改局部变量。
- 支持`Step into`, `Step over`, `Step out`, `Continue`等调试命令。


## Features
- Config
![completion](https://github.com/wjf1616/skynetdebuger/raw/master/images/01.png)

- launch
![completion](https://github.com/wjf1616/skynetdebuger/raw/master/images/02.png)
![completion](https://github.com/wjf1616/skynetdebuger/raw/master/images/03.png)

-Debug
![completion](https://github.com/wjf1616/skynetdebuger/raw/master/images/04.png)
![completion](https://github.com/wjf1616/skynetdebuger/raw/master/images/05.png)
![completion](https://github.com/wjf1616/skynetdebuger/raw/master/images/06.png)
