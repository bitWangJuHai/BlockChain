// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;
contract test {
    uint16 a;

    constructor() {}

    function getA() pure public returns(uint16){
        // unchecked{ 
        //     return type(uint16).max + type(uint8).max;
        // }
        return exp(10,3);
    }

}