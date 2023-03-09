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

}