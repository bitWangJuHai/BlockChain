// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;

contract A {
    function foo() public pure virtual returns (string memory) {
        return "A";
    }
}

contract B is A {
    function foo() public pure virtual override returns(string memory) {
        return "B";
    }
}

contract C is A {
    function foo() public pure virtual override returns(string memory) {
        return "C";
    }   
}

//super关键字表示最近的父合约
contract D is B, C {
    function foo() public pure override(B, C) returns (string memory) {
        //会调用C.foo()因为C是D最后一个继承的父合约
        return super.foo();
    }
}

//继承的顺序必需是从基础到派生，交换A和B的顺序会导致编译错误
contract F is A, B {
    function foo() public pure override(A, B) returns(string memory){
        return super.foo();
    }
}