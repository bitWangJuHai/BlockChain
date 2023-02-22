- 官方文档：[Solidity语言](https://docs.soliditylang.org/en/v0.8.18/)、[RemixIDE使用文档](https://remix-ide.readthedocs.io/en/latest/)
- Solidity中的数据类型
    - 按访问范围来分：  
    public：不限制可见性  
    private：只能在当前合约中访问  
    external：只能在当前合约之外访问  
    internal：只能在当前合约及其子合约中访问
    - 按性质来分：  
    Value：在参数传递或赋值时总是值拷贝
    Reference：在参数传递或赋值时可以是值拷贝或**指针**拷贝
- Reference（引用）数据类型
    1. 引用类型包括结构、数组（字符串）、映射
    2. 使用引用类型时必须明确提供存储该数据的区域，三种区域如下：
    memory：该区域的数据在其所在函数执行结束后就会被销毁
    storage：该区域的数据与合约的寿命一致即storage类型的变量会随该合约储存在区块链上
    calldata：专门用于存储函数参数（不能用于局部变量的声明）的只读区域，该区域的数据在函数执行之后就会被销毁，由于是只读区域如果可以请尽量使用calldata作为函数参数的类型避免意外更改
    3. storage区域和memory或calldata区域的数据之间的赋值总是值拷贝；memory区域和memory区域的数据之间的赋值总是引用；将storage中的数据赋值给局部storage类型的变量是引用；其它对storage区域的数据进行赋值均是值拷贝；
    4. 状态变量强制是storage类型，这是唯一一处可以在声明引用类型的变量时省略变量存储位置的地方
    5. 外部函数（external）的参数强制是calldata类型
- Solidity的三种异常处理：revert()、require()、assert()
```
revert("Something bad happened");           //无条件撤销交易所有的状态更改，返回指定的异常信息，将剩余的gas退还给调用者
require(condition, "something bad happened")    //一旦条件不成立则撤销交易所有的状态更改，返回指定的异常信息，将剩余的gas退还给调用者
assert(condition)               //一旦条件不成立则撤销交易所有的状态更改，消耗掉所有的gas
```
&emsp;&emsp;注：assert应该用于程序错误的检测比如溢出，避免“永远无法发生”的情况发生。revert和require用于判断某些行为是否违反了合同，assert用于判断合同本身是否出现异常。
- 单双引号均可表示字符串

