// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;
contract Member {
    string name;
    uint age;

    constructor(string memory _name, uint _age) public {
        name = _name;
        age = _age;
    }
}

contract Teacher is Member{

    constructor(string memory n, uint m) Member(n, m) public {}

    function getName() public view returns(string memory) {
        return name;
    }

}

contract Base {
    uint data;

    constructor(uint _data) public {
        data = _data;
    }

    function getData() public view returns(uint){
        return data;
    }

}

contract Derived is Base (5) {

    uint public data2;

    constructor() public {
        data2 = 100;
    }

    function getBaseData() public view returns(uint){
        return data;
    }

}