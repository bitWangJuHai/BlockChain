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
        (bool sent, ) = _to.call{value: msg.value}("");
        require(sent, "Fail to send!");
    }

}

contract FallbackInputOutput {
    //immutable类型是只能在构造函数中初始化一次的变量，初始化之后不可再修改
    address immutable public target;

    constructor(address _target) {
        target = _target;
    }

    receive() external payable {}

    fallback(bytes calldata data) external payable returns (bytes memory) {
        (bool ok, bytes memory res) = target.call{value: msg.value}(data);
        require(ok, "call failed");
        return res;
    }

}

contract Counter {
    uint public count;

    function get() external view returns (uint) {
        return count;
    }

    function inc() external  returns (uint) {
        count += 1;
        return count;
    }

}

contract TestFallbackInputOutput {
    event Log(bytes res);

    function test(address _fallback, bytes calldata data) external {
        (bool ok, bytes memory res) = _fallback.call(data);
        require(ok, "call failed");
        emit Log(res);
    }

    function getTestData() external pure returns (bytes memory, bytes memory) {
        return (abi.encodeCall(Counter.get, ()), abi.encodeCall(Counter.inc, ()));
    }

}