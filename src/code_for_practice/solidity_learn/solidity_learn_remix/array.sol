pragma solidity >= 0.7.0 < 0.9.0;

contract learnArrays {

    // uint[] public myArray;
    // uint[] public myArray2;
    // uint[200] public myFixedSizedArray;

    // function push(uint number) public {
    //     myArray.push(number);
    // }

    // function pop() public {
    //     myArray.pop();
    // }

    // function getLength() public view returns (uint){
    //     return myArray.length;
    // }

    uint[] public changeArray;

    function removeElement(uint i) public {
        changeArray[i] = changeArray[changeArray.length - 1];
        changeArray.pop();
    }

    function test() public {
        for(uint i = 1; i <= 4; i++) {
            changeArray.push(i);
        }
    }

    function getChangeArray() public view returns(uint[] memory) {
        return changeArray;
    }


}
