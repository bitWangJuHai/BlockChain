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
- Solidity使用将string类型转换为bytes类型来获取它的长度，因为通常的string.length低效且昂贵。
    ```
    bytes string1ToBytes = bytes(string1);
    string1ToBytes.length;
    ```
- Solidity函数的状态可变性
    - view函数：保证该函数不会修改状态，以下行为被视为修改了状态：
        1. 修改状态变量
        2. 产生事件（？？？）
        3. 创建其它合约
        4. 使用selfdestruct（自毁函数，用于销毁区块链上的合约系统。合约账户上剩余的以太币会发送给指定目标然后其储存和代码从状态中被移除）
        5. 通过调用发送以太币
        6. 调用任何没有被标记为view或pure的函数
        7. 使用低级调用（address.call）
        8. 使用包含某些操作码的内联汇编（Solidity支持的所有操作码请看[这里](https://docs.soliditylang.org/en/v0.8.19/yul.html#evm-dialect)）
    - pure函数：保证该函数既不读取也不修改状态，以下行为被视为读取了状态：
        1. 读取状态变量
        2. 访问this.balance或\<address\>.balance（？？？）
        3. 访问block，tx，msg中任意成员，msg.sig和msg.data除外（？？？）
        4. 调用任何未标记为pure的函数
        5. 使用包含某些操作码的内联汇编
- Solidity合约中的构造函数
    - 构造函数定义语法
        ```
        constructor(bytes32 name_) {

        }
        ```
    - 构造函数仅在合约创建时被执行一次
    - 未定义构造函数的合约使用默认的构造合约（构造函数是可选的）
    - 构造函数最多只能有一个
    - 节点执行构造函数的结果：部署最终代码到区块链
    - 最终代码包括所有public和external函数以及所有可以通过public函数访问到的代码
    - 最终代码不包括构造函数或者只被构造函数调用的内internal函数
    - 构造函数可以是public也可以是interal
- 数组操作
    - array.push(number)：向array结尾添加一个元素number，返回数组的新长度
    - array.pop()：移除数组最后一个元素，返回被移除的数
    - array.length：返回数组长度
    - delete array[i]：将数组i下标的元素重置为默认值（delete删除不会影响数组长度）
    - 特殊数组[bytes&string](https://docs.soliditylang.org/en/v0.8.19/types.html#bytes-and-string-as-arrays)
- msg.sender：该全局参数表示消息的发送者，或者说是执行这个合约/函数的用户（地址）
- uint类型
    - 无符号整数
    - uint默认uint256
    - 32位转换成16位时舍掉（数字的）高位，16位转换成32位时放在其低位。
- byte类型
    - [Fixed-size byte arrays&Dynamically-sized byte array](https://docs.soliditylang.org/en/v0.8.19/types.html#fixed-size-byte-arrays)
    - 当长字节转换成短字节时舍掉高位（数字的低位），短字节转换成长字节是高位补0
- solidity提供了很多[全局变量及常量](https://docs.soliditylang.org/en/v0.8.19/units-and-global-variables.html#units-and-globally-available-variables)。例如ether、wei、gwei(1e9)、second、minutes、weeks、msg.sender、block.number
- msg.sender/tx.origin/block.coinbase都是address payable类型，this可以被显示地转换为address或address payable类型
- 通常会使用x.f()调用合约对象x中的f方法。不推荐使用底层的call，delegatecall，staticcall除非万不得已，因为可能存在安全隐患。
- 不推荐在合约代码中硬编码使用的gas值
- 获得当前合约的余额：`address(this).balance`
- 一个Warning
  ```
  Unnamed return variable can remain unassigned. Add an explicit return with value to all non-reverting code paths or name the variable
  ```
  0.7.4版本以上的编译器不会检测程序是否会到达函数的return语句（函数尾）所以要对返回值进行定义以保证函数有一个默认的返回值