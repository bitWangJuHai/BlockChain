// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;
contract test {
    uint16 a;
    bytes payload;

    constructor() {}

    function exercise() pure public returns (bytes memory) {
        // unchecked{ 
        //     return type(uint16).max + type(uint8).max;
        // }
        
        assert(1 minutes == 60 seconds);
        assert(24 hours == 1 days);

        return abi.encodeWithSignature("hahah(string1)", "Name1");

    }

}