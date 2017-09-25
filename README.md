"# movie-rater" 

Description
=====
Read a JSON file filled with Movies and Star Rating.

Use Command Line options to:
- Add a movie (with or without rating);
- Remove a movie;
- Update a movie's rating;
- Display a specific movie and its rating (or all of them);
- Randomize, letting the gods of randomness choose a random listed movie for you.

Usage
=====
`$ ruby movies.rb -h`

Help info
=====
-a, --add MOVIE RATING           Add a new MOVIE with RATING (0-5) stars.
                                 (by default it adds 0 (zero) stars if RATE is omitted)
-r, --remove MOVIE               Remove an existing MOVIE.
-u, --update MOVIE RATING        Update an existing MOVIE with RATING stars.
-d, --display MOVIE              Display the MOVIE already included;
                                 Tip: display ALL to view all movies.
-?, --random                     Display a random movie
-h, --help                       Show this help.