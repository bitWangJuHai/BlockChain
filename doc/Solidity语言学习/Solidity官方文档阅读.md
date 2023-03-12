## Layout of a Solidity Source File 
### SPDX License Identifier
- 每个源文件都应该在file level指示许可证，编译器会把License的字符串包含在字节码元数据中
### Pragmas
- 每个原文件都要用pragma指示编译版本
- 对于import的文件，该文件中pragma指示的版本不会自动应用
#### Version Pragma
- pragmas不会启动或禁用编译器功能，它只是指示编译器检查文件编译所需版本是否与指定的版本匹配。若不匹配将发出错误
#### ABI Coder Pragma
#### Experimental Pragma
### Importing other Source Files
- 在global level指定import哪些文件使用
```
//直接在该文件中使用所有filename文件中的global symbol
import "filename";
//使用alias使用filename中的symbol1，使用filename中的symbol2
import {symbol1 as alias, symbol2} from "filename";
//使用symbolName.xxx使用filename中的xxx
import * as symbolName from "filename"
```
### Comments
## Structure of a Contract
### State Variables
### Function
### Function Modifiers
### Events
### Errors
### Struct Types
### Enum Types
## Types
- solidity中没有undefined或null，新声明的变量都会有一个默认值
### Value Type（值类型）
- 值类型总是数值传递，在作为函数参数或赋值时总是复制
#### Booleans
- ||和&&：如果第一个参数已经能判断表达式的结果第二个表达式不会被执行
#### Integers
- uint8、uint16、uint24、……、uint256（步长8）
- int8、int16、int24、……、int256（步长8）
- int、uint有256位
- 使用`type(X).min`或`type(X).max`获得类型X的最小/大值
- 整数计算默认进行checked溢出检测，溢出则报错并revert事务。可以使用`uncheck{ …… }`不对结果进行溢出检测
- 使用x\*x\*x比x**3更便宜
#### Address
- address类型地址只能发送以太币而不能接受以太币，接受以太币使用address payable类型。address类型只能显示地转换成address payable类型，address payable类型可以隐式地转换为address类型。
- address类型的成员
    - balance：获取账户余额
        ```
        <address>.balance
        ```
    - transfer
        ```
        <address>.transfer(uint256 amount)
        ```
    &emsp;&emsp;向address发送amount数量的wei附带2300gas。如果x是合约地址那么该合约会被执行。执行失败（汽油费不足等原因）会被revert
    - send：
        ```
        <address>.send(uint256 amount) returns(bool)
        ```
    &emsp;&emsp;向address发送amount数量的wei并附带2300gas。如果x是合约地址那么该合约会被执行，执行失败会返回false并不throw
    - call
        ```
        <address>.call(bytes memory) returns(bool, bytes memeory)
        ```
    &emsp;&emsp;以address的身份调用address内的函数，调用函数时使用其abi二进制编码。默认传送所有可用gas，返回执行是否成功以及返回值的abi二进制编码。调用时还可以指定gas数量和转账数量，例如`msg.sender.call{gas:100000000, value: 1 ether}(abi.encodeWithSignature("register(string)", "MyName"));`
    - delegatecall
    使用方法和call相同，但在调用时仅仅使用被调用函数的代码，调用的环境还是当前合约（存储，账户金额等）。该方法的目的是使用存储在其它合约中的库函数代码。仅可指定gas，value不可用。
    - staticcall
    使用方法和call相同，但会在被调用的函数试图修改状态变量是revert。仅可指定gas，value不可用。
    - code：获取目标合约的bytes memory类型的字节码
    - codehash：获取字节码的bytes32类型的Keccak-256哈希值，比直接使用Keccak256(addr.code)更cheap
#### Contract Type
- 
## Contract
### Function Modifiers
- 函数Modififers可以改变函数的行为，例如可以在函数执行之前执行自动检查，符合条件才可运行该函数。
- Modifier是可继承的
## Cheatsheet
### Global Variables
