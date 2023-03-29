### 使用truffle框架
- 使用开发框架truffle在私链上部署测试用智能合约及合约的调用执行
    - 创建并初始化工程
        ```
        truffle version
        mkdir truffle_solidity
        cd truffle_solidity
        truffle init
        ```
        truffle项目结构如下
        - contracts/：Solidity合约目录，我们编写的合约放在这里
        - migration/：部署脚本文件目录
        - test/：测试脚本目录
        - truffle.js：truffle配置文件