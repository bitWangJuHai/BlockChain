- 官方文档：[Solidity语言](https://docs.soliditylang.org/en/v0.8.18/)、[RemixIDE使用文档](https://remix-ide.readthedocs.io/en/latest/)
- Solidity中的数据类型
    - 按访问范围来分：  
    public：不限制可见性  
    private：只能在定义了这个函数的合约中访问  
    external：只能在当前合约之外访问，状态变量不能被声明为external类型  
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
&emsp;&emsp;注：assert应该用于程序错误的检测比如溢出，避免“永远无法发生”的情况发生。revert和require用于判断某些行为是否违反了合同，assert用于判断合同本身是否出现异常。`require`常用于检测函数输入，执行之前的条件判断，检测函数的返回值是否符合预期等；`revert`是无条件抛出异常用于异常条件比较复杂的情况。
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
        9. 读取状态变量
        10. 访问this.balance或\<address\>.balance（？？？）
        11. 访问block，tx，msg中任意成员，msg.sig和msg.data除外（？？？）
        12. 调用任何未标记为pure的函数
        13. 使用包含某些操作码的内联汇编
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
- 数组
    - array.push(number)：向array结尾添加一个元素number，返回数组的新长度
    - array.pop()：移除数组最后一个元素，数组长度-1，返回被移除的数
    - array.length：返回数组长度
    - delete array[i]：将数组i下标的元素重置为默认值（delete删除不会影响数组长度）
    - 特殊数组[bytes&string](https://docs.soliditylang.org/en/v0.8.19/types.html#bytes-and-string-as-arrays)
    - 使用`uint[] memory a = new uint[](5)`在memory中创建一个新数组
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
- 通常会使用x.f()调用合约对象x中的f方法。不推荐使用底层的call，delegatecall，staticcall除非万不得已，因为可能存在安全隐患并且使用call时会报告一个安全警告。但是推荐使用call调用合约中的fallback函数
- 不推荐在合约代码中硬编码使用的gas值
- 获得当前合约的余额：`address(this).balance`
- 一个Warning
  ```
  Unnamed return variable can remain unassigned. Add an explicit return with value to all non-reverting code paths or name the variable
  ```
  0.7.4版本以上的编译器不会检测程序是否会到达函数的return语句（函数尾）所以要对返回值进行定义以保证函数有一个默认的返回值
- fallback函数
  - 不能命名
  - 必需声明为external
- fabllback和receive函数的调用条件
    收到以太币-->msg.data为空？否-->fallback():是-->receive()存在?否fallback():是-->receive()  
    mag.data不为空说明消息发送者是要调用点儿什么东西而不是简单的转账，调用者想要转账但是没定义receive()没办法只能调用fallback了。
- solidity中的密码学函数
    - sha256(bytes memory) returns (bytes32)
    - keccak256(bytes memory) returns (bytes32)
    - ripemd160(bytes memory) returns (bytes20)
    - blockhash(uint blockNumber) returns (bytes32)
    - ecrecover(byts32 hash, uint8 v, bytes32 r, bytes32 s) returns (address)
- 关于`ecrecover`
&emsp;&emsp;ecrecover是solidity提供的全局函数用于校验以太坊签名数据。以太坊使用椭圆曲线签名算法对添加`\x19Ethereum Signed Message:\n消息长度`前缀的数据哈希的哈希进行签名，添加前缀的目的是防止DApp将用户要签名的一般消息篡改为转账等恶意操作，添加前缀后若篡改为交易。我们使用ecrecover来校验签名，若校验成功则返回签名者的公钥地址，失败则返回0。其中hash是待验证数据的hash，r是签名的前32个字节、s是签名的次32个字节、v是签名的最后一个字节。 
- constants标注不可修改的常量，immutable标注只能在构造器中初始化一次的量
- 读取状态变量不需要发送交易，修改状态变量需要发送交易
- `map[index]`若index未被设定则返回默认值
- 枚举和结构可以在contract之外定义，所以可以单独创建一个定义枚举的sol文件然后在其他文件中import
- `delete enum1`删除枚举变量，将其重新设置为默认值0
- map不能作为函数的输入输出，数组可以作为函数的输入输出
- 可以以键值对的形式调用函数，如下代码
    ```
    function aaa(
        uint x,
        uint y,
        address a,
        bool b,
        string memory c
    ) public pure returns(uint){}
    function callAaa() public pure returns(uint){
        return aaa({a: address(0), b: true, x: 1, c: "sssss", y: 2});
    }
    ```
- Solidity大版本更新都会引入breaking change，也就是不向前兼容。在编写solidity时必须告诉编译器该合约使用的是哪个版本的solidity以便该合约可以长时间运行在以太坊虚拟机上而不会因版本变化无法被他人调用。截至2023年2月最新版本是0.8.18，当前的版本信息详见[官方文档](https://docs.soliditylang.org/en/v0.8.18/)。
    ```
    pragma solidity >= 0.7.0 < 0.9.0;       //为编译器指定程序使用的solidity语言版本
    ```
- 同一个函数从多个父合约继承时要使用`override(A,B,C……)`关键字对函数进行重写，同时父合约中的相应函数要标记为`virtual`，只有标记为`virtual`的函数才可以重写。
- 接口（interface）中的函数都是隐式虚函数，所以实现接口时必须显示地将其重写。接口可以继承接口，派生的接口是所有接口的组合，实现合约的时候必须实现（重载override）其继承的所有接口
- 未实现所有函数的合约必须标记为`abstract contract X {……}`
- 继承的顺序必需是从基础到派生
- 继承时可以在子合约的构造函数内重新给状态变量赋值而不能重新声明一个同名状态变量
    ```
    contract A {
        string public name = "Contract A";
        function getName() public view returns (string memory) {
            return name;
        }
    }
    contract C is A {
        constructor() {
            name = "Contract C";
        }
    }
    ```
- 因为solidity对多重继承采用C3线性优化所以super可能获取到兄妹而不是父母。例子见[这里](../../src/code_for_practice/solidity_learn/solidity_learn_remix/inheritance-call-parent-contracts.sol)
- 接口（interface）类型
  - 定义接口中声明的函数的合约必须继承自相应接口，并且定义时使用`override`对函数进行重载。（接口中的函数都是隐式`virtual`函数）
  - 使用接口中的函数时需要传入定义该函数的合约的地址，如`MyInterface(_addr).func1()`
- 手动计算函数选择器`bytes4(keccak256(bytes("func1(address,address,uint256,address)")))`注意bytes内参数之间没有空格，uint要写uint256。
- 若能获取到合约对象则使用`abi.encodeCall(C1.fun1, (para1, para2))`计算出abi编码避免手动计算出错
- 使用`Contract1.state1()`来获取Contract1的状态变量，`Contract1.state1`是一个返回值是state1的类型的函数