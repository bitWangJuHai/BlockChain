// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;
contract String {
    string favoriteColor = "blue";

    function showFavoriteColor() public view returns(string memory) {
        return favoriteColor;
    }

    function changeFavoriteColor(string calldata _new) public {
        favoriteColor = _new;
    }

    function getStringLength() public view returns(uint) {
        bytes memory stringToBytes = bytes(favoriteColor);
        return  stringToBytes.length;
    }

}