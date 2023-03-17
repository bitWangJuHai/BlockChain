// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;

contract FallBack {

    event Log(uint gas);

    fallback() external payable {
        emit Log(gasleft());   //gasleft() returns(uint 256)返回当前剩余多少gas
    }

    receive() external payable {
        emit Log(msg.value);
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

}

contract SendToFallBack {

    //FallBack fallback1;

    function transferToFallBack(address payable _to) public payable {
        _to.transfer(msg.value);
    }

    // function setFallback1(FallBack addr) public  {
    //     fallback1 = addr;
    // }

    function callFallBack(address payable  _to) public payable {
        (bool sent, ) = _to.call{value:msg.value}("");
        require(sent, "Fail to send!");
    }

}