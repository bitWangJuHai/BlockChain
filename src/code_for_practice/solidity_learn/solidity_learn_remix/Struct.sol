// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;
contract learnStructs {

    struct Movie {
        string title;
        string director;
        uint movie_id;
    }

    Movie movie;

    function setMovie() public {
        movie = Movie("aaa", "bbb", 2);
    }


    function  getMovieId() public view returns(uint) {
        return movie.movie_id;
    }

    Movie[] public movies;

    function create(string calldata _title, string calldata _director, uint _movie_id) public {

        movies.push(Movie(_title, _director, _movie_id));

        movies.push(Movie({title: _title, director: _director, movie_id: _movie_id}));

        Movie memory movie2;
        movie2.title = _title;
        movie2.director = _director;
        movie2.movie_id = _movie_id;
        movies.push(movie2);

    }

}