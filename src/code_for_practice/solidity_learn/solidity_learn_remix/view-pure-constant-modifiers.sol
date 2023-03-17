// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;

contract MyContract {
    uint value;

    function setValue(uint _value) external {
        value = _value;
    }

    function getValue() external view returns(uint) {
        return value;
    }

}

contract Practice {

    uint value;

    function multiply() public pure returns(uint){
        return 3 * 7;
    }

    function valuePlusThree() public returns(uint){
        return value = value + 3;
    }

}