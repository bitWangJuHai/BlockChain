// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;

// interface Calculator {
//     function getResult() external view returns(uint);
// }

// contract Test is Calculator {
//     constructor(){}

//     function getResult() public pure override returns(uint) {
//         return 3;
//     }

// }

contract Counter {
    uint public count;

    function increment() external {
        count += 1;
    }
}

interface ICounter {
    function count() external view returns(uint);

    function increment() external;
}

contract MyContract {
    function incrementCounter(address _counter) external pure {
        //使用时需要传入定义函数的合约的地址
        ICounter(_counter).increment;
    }
    function getCount(address _counter) external view returns (uint) {
        return ICounter(_counter).count();
    }
}