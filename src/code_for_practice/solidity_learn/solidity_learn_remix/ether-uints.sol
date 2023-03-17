// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;
contract learnEtherUints {

    function test() public {
        assert(1000000000000000000 wei == 1 ether);
        assert(1 ether == 1e18 wei);
    }
}