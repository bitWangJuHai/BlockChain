pragma solidity >= 0.7.0 < 0.9.0;
contract learnMapping {

    mapping(address => uint) public myMap;

    function setAddress(address _addr, uint _i) public {
        myMap[_addr] = _i;
    }

    function getAddress(address _addr) public view returns(uint) {
        return myMap[_addr];
    }

    function removeAddress(address _addr) public {
        delete myMap[_addr];
    }

}

contract practice {
    struct Movie {
        string title;
        string director;
    }

    mapping(uint => Movie) public movie;
    mapping(address => mapping(uint => Movie)) public myMovie;

    function addMovie(uint movie_id, string calldata title, string calldata director) public {
        movie[movie_id] = Movie(title, director);
    }

    function addMyMovie(uint movie_id, string calldata title, string calldata director) public {
        myMovie[msg.sender][movie_id] = Movie(title, director);
    }

    function getMovieTitleById(uint movie_id) public view returns(string memory) {
        return movie[movie_id].title;
    }

    function getMymovieTitleByAddressId(address _addr, uint movie_id) public view returns(string memory) {
        return myMovie[_addr][movie_id].title;
    }

}