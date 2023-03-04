pragma solidity >= 0.7.0 < 0.9.0;
contract hello {
    uint oranges = 5;
    function validateOranges() public view returns (bool){
        if(oranges == 5){
            return true;
        } else {
            return false;
        }
    }

    uint a = 44;
    uint b = 31;
    function compare() public view {
        require(a <= b, "This compare is false!");
    } 

    uint [] public numberslist = [1,2,3,4,5,6,7,8,9,10];
    function checkMultiples(uint _number) public view returns (uint) {
        uint count = 0;
        for(uint i = 0; i < numberslist.length; i++){
            if (numberslist[i] % _number == 0){
                count++;
            }
        }
        return count;

    }

    uint [] x;
    function test1(uint[] memory arr1) public{
        x = arr1;
        uint[] storage y = x;
        uint[] storage z = x;
        uint[] storage w = y;
        uint[] storage k = w;
        k = x;
    }

}

