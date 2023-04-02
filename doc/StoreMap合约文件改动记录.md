> 原始的`StoreMap.sol`在[这里](../reference/investigation-cjzhuang2020/cjz_underg_2021_09/tree_blockchain/contracts/StoreMap.sol)  
### 改动记录
> `新增`或`修改`类型的改动位置为新文件，`删除`类型的改动位置为旧文件  

|改动类型|改动位置|描述|源文件|新文件|
| :---: | :---: | :---: | :---: | :---: |
|新增|-|增加了[SPDX许可证](https://docs.soliditylang.org/en/v0.8.19/layout-of-source-files.html#spdx-license-identifier)|-|//SPDX-License-Identifier: MIT|
|修改|-|修改因[版本问题](https://docs.soliditylang.org/en/v0.8.19/layout-of-source-files.html#pragmas)引起的语法错误|pragma solidity ^0.5.16;|pragma solidity >= 0.5.16;|
|修改|-|修改了未知原因的[类型声明](https://docs.soliditylang.org/en/v0.8.19/types.html#fixed-size-byte-arrays)问题|byte c = bytes(geohash)[i];|bytes1 c = bytes(geohash)[i];|
|修改|-|同上|byte c = bytes(geohash)[i];|bytes1 c = bytes(geohash)[i];|
|修改|-|将int类型统一为uint32|-|-|
|修改|-|修改不便于理解的变量名|-|-|
|分离|[Navigation](../src/contract_on_system/Navigation.sol)|将导航从地图存储中分离|-|-|
|新增|-|在[StoreMap](../src/contract_on_system/StoreMap.sol)中临时新增一些原有接口|-|-|
|修改|-|修改函数可见性以适应新接口|-|-|
|删除|-|删除了导航合约中一些冗余的状态变量|-|-|