// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;

contract GenerateRandomNumber {

    function randMod(uint range) external view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % range;
    }

}