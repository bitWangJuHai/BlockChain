// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;

contract InfoFeed {
    function info() public payable returns (uint ret) { return 42; }
}

contract Consumer {
    InfoFeed public feed;
    function setFeed(InfoFeed addr) public { feed = addr; }
    function callFeed() public { feed.info{gas: 8000}(); }
}