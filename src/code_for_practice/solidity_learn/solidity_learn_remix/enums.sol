pragma solidity >= 0.7.0 < 0.9.0;

contract enumsLearn {
    enum frenchFriesSize {LARGE,MEDIUM,SMALL}
    frenchFriesSize constant defaultChoice = frenchFriesSize.MEDIUM;        //声明一个枚举常量
    frenchFriesSize choice;     //声明一个枚举变量

    function setSmall() public {
        choice = frenchFriesSize.SMALL;
    }

}