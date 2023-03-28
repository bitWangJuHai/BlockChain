// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract helloworld {
    string content;

    constructor(string memory _str){
        content = _str;
    }

    function getContent() view public returns (string memory){
        return content;
    }
}