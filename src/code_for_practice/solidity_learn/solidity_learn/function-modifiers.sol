// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.1 < 0.9.0;

contract owned {
    address payable owner;
    constructor(){
        owner = payable(msg.sender);
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

}

contract destructible is owned {
    function destory() public onlyOwner{
        selfdestruct(owner);
    }
}

contract priced {
    modifier costs(uint price){
        if(msg.value >= price){
            _;
        }
    }
}

contract Register is priced, destructible {

    mapping (address => bool) registeredAddresses;
    uint price;

    constructor(uint initialPrice){
        price = initialPrice;
    }

    //price为注册费
    function register() public payable costs(price) {
        registeredAddresses[msg.sender] = true;
    }

    function changePrice(uint _price) public onlyOwner {
        price = _price;
    }

}

contract Mutex {    //互斥锁
    bool public locked;
    uint public a = 1;
    modifier noReentrancy(uint _num) {   //不可重入
        require(!locked,"Reentrant call");
        locked = true;
        _;
        locked = false;
    }

    function f(uint _num) public noReentrancy(_num) returns(uint) {
        (bool success,) = msg.sender.call("");      //这个call不可重入
        require(success);
        return _num + 10;
    }

}