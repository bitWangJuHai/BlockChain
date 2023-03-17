// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;

contract GenerateRandomNumber {

    Oracle oracle;

    constructor(address _oracle) {
        oracle = Oracle(_oracle);
    }

    function randMod(uint range) external view returns (uint) {
        return uint(keccak256(abi.encodePacked(oracle.rand, block.timestamp, block.prevrandao, msg.sender))) % range;
    }

}

contract Oracle {
    address admin;
    uint public rand;

    constructor() {
        admin = msg.sender;
    }

    function changeRand(uint _rand) public {
        require(msg.sender == admin, "You have no permission");
        rand = _rand;
    }

}