## solidity程序示例1
```
pragma solidity >= 0.7.0 < 0.9.0;       //为编译器指定程序使用的solidity语言版本，详见解析1
```
## 示例程序解析
1. Solidity大版本更新都会引入breaking change，也就是不向前兼容。在编写solidity时必须告诉编译器该合约使用的是哪个版本的solidity以便该合约可以长时间运行在以太坊虚拟机上而不会因版本变化无法被他人调用。截至2023年2月最新版本是0.8.18，当前的版本信息详见[官方文档](https://docs.soliditylang.org/en/v0.8.18/)。