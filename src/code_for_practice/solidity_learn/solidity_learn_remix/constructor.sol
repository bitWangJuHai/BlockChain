// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;

contract X {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }
}

contract Y {
    string public text;

    constructor(string memory _text) {
        text = _text;
    }
}

// 在继承列表里初始化父合约
contract B is X("X"), Y("Y") {

}

contract C is X, Y {
    //在构造函数中初始化父合约，初始化顺序按照继承顺序忽视子合约构造器中的顺序
    //这个例子中构造顺序为X Y C
    constructor(string memory _name, string memory _text) Y(_name) X(_text) {}
}