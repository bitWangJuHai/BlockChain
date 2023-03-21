// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Receiver {
    event Received(address caller, uint amount, string message);

    receive() external payable { }

    fallback() external payable {
        emit Received(msg.sender, msg.value, "Fallback was called");
    }

    function foo(string memory _message, uint _x) public payable returns (uint) {
        emit Received(msg.sender, msg.value, _message);

        return _x + 1;
    }

    function getFooAbi() public view returns (bytes memory){
        return abi.encodeCall(this.foo, ("call foo", 123));
    }

}

contract Caller {
    event Response(bool success, bytes data);

    function testCallFoo(
        address payable _addr
        //bytes memory _data
    ) public payable {
        (bool success, bytes memory data) = _addr.call{value: msg.value, gas: 5000}(
            abi.encodeWithSignature("foo(string,uint256)", "call foo", 123)
            //_data
        );

        emit Response(success, data);
    }

    function getFooAbi() public pure returns (bytes memory){
        //return abi.encodeWithSignature("foo(string, uint)", "call foo", 123);
        //return abi.encodeCall(rec1.foo, ("call foo", 123));
        //return rec1.foo.selector;
        return abi.encodeWithSignature("foo(string, uint256)");
    }

    function testCallDoesNotExist(address payable _addr) public payable {
        (bool success, bytes memory data) = _addr.call{value: msg.value}(
            abi.encodeWithSignature("doesNotExit()")
        );

        emit Response(success, data);
    }

}