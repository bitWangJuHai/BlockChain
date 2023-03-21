// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;

contract B {
    uint256 public num;
    address public sender;
    uint256 public value;
    uint256 public b;

    function setVars(uint256 _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract A {
    uint256 public num;
    address public sender;
    uint256 public value;

    event Log(bool);

    function setVars(address _contract, uint256 _num) public payable {
        (bool success, ) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );

        emit Log(success);
    }
}