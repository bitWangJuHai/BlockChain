> 原始的`credit.sol`在[这里](../reference/GraduationProject-main/code/Credit/contractInfo/credit.sol)  
> 改动后的合约文件在`src/contract_on_system`目录下
### 改动记录
> `新增`或`修改`类型的改动位置为新文件，`删除`类型的改动位置为旧文件  

|改动类型|改动位置|描述|源文件|新文件|
| :---: | :---: | :---: | :---: | :---: |
|新增|-|增加了[SPDX许可证](https://docs.soliditylang.org/en/v0.8.19/layout-of-source-files.html#spdx-license-identifier)|-|`//SPDX-License-Identifier: MIT`|
|修改|-|修改因[版本问题](https://docs.soliditylang.org/en/v0.8.19/layout-of-source-files.html#pragmas)引起的语法错误|`pragma solidity ^0.5.16`|`pragma solidity >= 0.5.16`|
|修改|-|各函数的书写格式|-|-|
|删除|-|冗余的状态变量|`usr tempuser`|-|
|修改|-|合约名字修改|`Contract`|`Credit`|
|修改|-|根据调用关系调整了函数顺序|-|-|