// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;

// contract A {
//     function f(B value) public pure returns (B out) {
//         out = value;
//     }

//     function f(address value) public pure returns (address out){
//         out = value;
//     }
// }

// contract B { }

contract FunctionOverloading {

    function getSum(uint a, uint b) public pure returns (uint) { return a + b; }
    function getSum(uint a, uint b, uint c) public pure returns (uint) { return a + b + c; }

    function getSumTwoArgs() public pure returns (uint) { return getSum(2, 3); }
    function getSumThreeArgs() public pure returns (uint) { return getSum(2, 3, 4); }


}