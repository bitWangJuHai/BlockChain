> 原始的`StoreMap.sol`在[这里](../reference/investigation-cjzhuang2020/cjz_underg_2021_09/tree_blockchain/contracts/StoreMap.sol)  
> 改动后的合约在[这里]()
### 改动记录
|改动类型|新文件中的位置（行）|描述|源文件|新文件|
| :---: | :---: | :---: | :---: | :---: |
|新增|1|增加了[SPDX许可证](https://docs.soliditylang.org/en/v0.8.19/layout-of-source-files.html#spdx-license-identifier)|-|SPDX-License-Identifier: MIT|
|修改|2|修改因[版本问题](https://docs.soliditylang.org/en/v0.8.19/layout-of-source-files.html#pragmas)引起的语法错误|pragma solidity ^0.5.16;|pragma solidity >= 0.5.16;|
|修改|291|修改了未知原因的[类型声明](https://docs.soliditylang.org/en/v0.8.19/types.html#fixed-size-byte-arrays)问题|byte c = bytes(geohash)[i];|bytes1 c = bytes(geohash)[i];|
|修改|318|同上|byte c = bytes(geohash)[i];|bytes1 c = bytes(geohash)[i];|