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

## Expressions Control Structures
### Function Calls
#### External Function Calls
- 调用函数使用`this.g(8)`（当前合约的g函数）或`c.g(2)`（合约对象c的g函数），调用类型是外部调用。
- 构造函数中不能使用`this`因为合约还未被创造
- 可以用{value: 10, gas: 10000}在括号前指定发送的ether及汽油费
- 调用其它合约中的函数时要小心谨慎因为无法预测其行为。先修改状态变量再发起转账可以避免重入攻击。
## Contract
### Function Modifiers
- 函数修饰符可以改变函数的行为，例如可以在函数执行之前执行自动检查，符合条件才可运行该函数。
- Modifier是可继承的
- 函数体将插入到`_;`所在的地方
- 函数修饰符可以在library中被定义，但是只能被本库中的函数使用
- 只能使用本合约或父合约中定义的函数修饰符，但是可以通过C.m引用到C合约中的m修饰符
- 使用空格分隔多个修饰符，修饰符会按顺序执行
- Modififer不能隐式访问到函数的参数及返回值，但可以显式的传递给它们
- `_;`可以在修饰符中出现多次，每次出现都会被替代为函数体
- `_;`也可以不出现，这时函数返回值会被设定为默认值就好像函数有一个空的函数体
- 修饰符中定义（引入）的符号对函数不可见
- 修饰符的实际参数可以是任意表达式，所有函数可见的符号都可以作为修饰符的参数，包括函数参数及返回值，但是返回值在`_;`之后才被赋值。目前没找到在修饰符中获取到函数目标返回值的方法（只能获取到定义返回值时的默认值……）
- 在modifier中可以使用不带参数的return来显式结束modifier，只要函数体被执行过就不会影响到函数的实际返回值。
### Function
#### Special Function
- Receive Ether Function
- Fallback Function
    ```
    fallback(bytes calldata input) [payable] external returns(bytes memory output)
    ```
    - 调用时机：调用合约时没有函数和给定的函数匹配（名称一样&&参数一样）；当合约意外收到以太时，此时若fallback函数不存在或未声明为payable则会报错并返还以太
    - 回调函数必需声明为external多数情况下要声明为payable。
    - 如果使用了参数`input`则input包含发给这个合约的用abi编码的所有数据，可以用abi.decode来解码，详见[fallback官方文档](https://docs.soliditylang.org/en/v0.8.19/contracts.html#fallback-function)
    - 当发送者使用`transfer`或`send`时回调函数可能只会被分配到很少的2300gas
#### Function Overloading
- 一个合约可以有多个函数名相同但参数不同的多个函数
- 同名函数的不同参数必须是外部类型不同的参数，比如合约类型和address类型虽然内部类型不同但是外部类型都是地址，例如下列代码无法通过编译
    ```
    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.16 <0.9.0;

    // This will not compile
    contract A {
        function f(B value) public pure returns (B out) {
            out = value;
        }

        function f(address value) public pure returns (address out) {
            out = value;
        }
    }

    contract B {
    }
    ```
- 重载时不考虑返回值
- 重载时实际参数能被隐式转换成哪个函数的形式参数就调用哪个函数，如果实际参数能同时被隐式转换成两个函数的形式参数则会报错。比如f(50)能同时被隐式转换成uint8、uint256。f(256)只能被隐式转换成uint256而不能转换成uint8。
### Interfaces
- 接口和抽象合约类似但是接口内只能声明函数不能定义
- 接口不能继承自其它合约，但是可以继承自其他接口
- 接口中的所有函数必须声明为外部函数即使在合约中他们是`public` ？？？
- 不能有构造函数
- 不能在其中声明状态变量
- 不能在其中声明函数修饰符
- 接口中声明的函数全部是隐式`virtual`，重载时必须使用`override`关键字
## Cheatsheet
### Global Variables
