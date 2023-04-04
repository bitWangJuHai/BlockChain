> 原始的`StoreTraffic.sol`在[这里](../reference/investigation-cjzhuang2020/cjz_underg_2021_09/tree_blockchain/contracts/StoreTraffic.sol)  
> 改动后的合约文件在[这里](../src/contract_on_system/StoreTraffic.sol)
### 改动记录
> `新增`或`修改`类型的改动位置为新文件，`删除`类型的改动位置为旧文件 

|改动类型|改动位置|描述|源文件|新文件|
| :---: | :---: | :---: | :---: | :---: |
|新增|-|增加了[SPDX许可证](https://docs.soliditylang.org/en/v0.8.19/layout-of-source-files.html#spdx-license-identifier)|-|`//SPDX-License-Identifier: MIT`|
|修改|-|修改因[版本问题](https://docs.soliditylang.org/en/v0.8.19/layout-of-source-files.html#pragmas)引起的语法错误|`pragma solidity ^0.5.16`|`pragma solidity >= 0.5.16`|
|修改|-|修改了未知原因的[类型声明](https://docs.soliditylang.org/en/v0.8.19/types.html#fixed-size-byte-arrays)问题|`byte c = bytes(geohash)[i]`|`bytes1 c = bytes(geohash)[i]`|
|修改|-|同上|`byte c = bytes(geohash)[i]`|`bytes1 c = bytes(geohash)[i]`|
|修改|-|将getVehicleStatus函数的参数从int32改为uint256|||
|增加|-|在getVehicle函数中增加执行条件|-|`require(vehiclesLength > 0, "No vehicle in system!")`|
|增加|-|在getVehicleByRegion函数中增加执行条件|-|`require(regionVehicles.length > 0, "No vehicle in this area")`|