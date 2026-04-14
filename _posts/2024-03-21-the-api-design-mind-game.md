---
title: The API Design Mind Game
date: 2024-03-21 18:00:00 -0000
layout: post
tag: the-language-of-api-design
---

> When it comes to API puzzles, it's all in your head

I like puzzles and games, which (I think) is common for people in tech. Solving logic puzzles is what drew me to software in the first place. I can remember obsessing about programming puzzles, even at hours I was not actively coding them. When my hobbies first drew me towards ray tracing, my mind would look at the real world and imagine how I might reconstruct the scene with a ray tracing program, building 3-D models

![alt text]({{ '/assets/img/GEB-EGB-triplets.jpg' | relative_url}})<br>
<em>Ray Traced image of GEB:EGB triplets, inspired by the book cover of <a href='https://en.wikipedia.org/wiki/G%C3%B6del,_Escher,_Bach_'>G&ouml;del, Escher, Bach: An Eternal Golden Braid</a> by Douglas Hofstadter. POVRay source by David Biesack.</em>

Now that I work (mostly) with API design, when I see a new app or
program, one of my first thoughts is "How would I design the API for
that app?" I call it _The API Design Mind Game).

![alt text]({{ '/assets/img/The-API-Design-Mind-Game.png' | relative_url}})

For example, consider the world of [Wordle](https://www.nytimes.com/games/wordle/index.html) - a puzzle game created by Josh Wardle that became very popular a couple years ago. After it transitioned to the Games section of the New York Times, the Times introduced [Wordlebot](https://www.nytimes.com/2022/04/07/upshot/wordle-bot-introduction.html) (by Josh Katz and Matthew Conlen) in April 2022. Wordlebot is software connected to the NYT Wordle app that analyzes your play and provides hints to help you play the game better.

Let's look at a real example. Here is the first WordleBot "summary"
screen after I solved Wordle 984 on Feb 28, 2024 (playing hard mode,
which requires you to use letters that matched from previous plays when
making a new guess):

![alt text]({{ '/assets/img/wordlebot.png' | relative_url}})

Below is the WordleBot screen analysis of my first guess from Wordle
#984. My start word was "STALE".

![alt text]({{ '/assets/img/wordlebot-stats.png' | relative_url}})

Of my 5 letters, two letters are in the answer, but in different positions. 1% of Wordle players used the same start word. WordleBot claims it can (on average) solve Wordle in 3.7 steps using that start word. There are 103 possible 5 letter words that contain the letters "L" and "E" (in other than the 4th and 5th position) and which do not contain "S", "T", or "A".

My second guess was "LEVER", using the "L" and "E" from my first guess, but in different positions. This was somewhat of a lucky guess because "V" is pretty rare, and my word matched the "E" and "V" in positions 2 and 3. My last guess, based on those two letters in those positions and an "L" in position 4 or 5, was "DEVIL" which was the correct solution (and only possible word with the information at hand.)

Here is Wordlebot's analysis of my third guess, "DEVIL".

![alt text]({{ '/assets/img/wordlebot-result.png' | relative_url}})

So, let's imagine what kind of API might support this app. There is a lot of statistical data and app usage data that WordleBot has access to, so the analysis cannot be done in the client.

Inputs would need to include:

* The game number. In my mind, each game is a resource, so I would opt to put the game number in the URL instead of a query parameter or request body, yieldsing a resource URL such as `https://api.nytimes.com/wordlebot/analysis/game-684/` or `https://api.nytimes.com/wordlebot/games/684/analysis/` (I just made up the API host and path/routes. How would you lay out API resource paths for Wordlebot? Why? Feel free to leave comments!)
* The player's game mode ( "mode": "hard" in this example)
( The player's guesses, in order (the game allows up to 6 guesses):
"guesses": `[ "STALE", "LEVER", "DEVIL" ]`
* The guess/step that the client want's to render &mdash; guess i for i in 0 to 5). This feels more like a query parameter than a request body property, such as ?guess=2; see examples below.

The output consists of a lot of data:

* Summary:
  * the number of people who played in the same mode
  * The Wordle Map which shows the number of guesses and which letters are in the solution, in the correct position (coded as `"+"`, visual representation as green squares) and which letters are in the solution but in the wrong position (coded as `"-"` visual representation as yellow squares) and which letters were not part of the solution (coded as `"x"`; visual representation as grey squares), with one row for each of the player's guesses, such as
  `{ "map": [ "xxx--", "-++xx", "+++++" ] }`
  * Skill rating (out of 99) and the NTY average skill rating: `{ "skill": 99 }`
  * Luck rating (out of 99) and the NTY average luck: `{ "luck": 94 }`
  * Number of guesses taken to solve the puzzle, and the average number of guess for other NYT Wordle players: `{ "guesses": 3, "averageGuesses": 3.7 }`
* Guess _i_ Analysis (for _i_ in 0 to 5):
  * Previous guesses (if any) and their Wordle Map color coding
  * A boolean indicating if this guess correctly solved the puzzle.
  * A comment or statement evaluating the guess
  * Wordle Map color coding and the guessed word
  * This guess' skill rating (out of 99)
  * This guess' luck rating (out of 99)
  * Number of words left - the number of words which match all the information revealed by the guesses so far
  * Number of other players (p) who made the same guesses for guesses 0 through i-1 (for i >= 1)
  * Top words that those p other players guessed for guess i and the percentage who guessed those words
  * Information gained - how much information you have gained so far, out of 100% information needed to solve the puzzle. Information includes which letters are part of the solution and which positions they have (or do not have) in the solution, and what letters are not part of the solution.
  * WordleBot's "top picks" for this guess. For Guess #1, this shows WordleBot's start word, i.e. a good word to start the puzzle when you have 0% information about the solution. Wordlebot provides n words in each step and the corresponding "skill" level of that word.
  * Additional details - For each guess, WordleBot can "show details":
    * what other Wordle players guessed at this point given the same information
    * how many players guessed the same word,
    * the average number of steps Wordle players took to solve the puzzle after making that guess, and
    * their guess' skill rating (out of 99).
    * The details also show comparisons of your guess vs. WordleBot's guess.

* Everyone's guesses on Step _i_ (for _i) in 0 to 5)
  * A list of the top 20 words that players guessed on this step, and the percent of players who guessed that word as a percentage (one decimal point precision, such as 8.3% or 0.1%.) Your guess is highlighted if it is in the top 20.

With this in mind, I begin to image what a WordleBot API would look like (ok, I've already started writing down possible JSON property names and sample data and encoding of more structure data such as the letter color coding maps&hellip;). There are two high level design approaches that I thought of initially:

One API call to send the user's n guesses after finishing the puzzle for the day (either successfully, or failed after 6 guesses) and have it compute and return all the analysis and statistics for that player's effort that day - the summary data, and the detail data for each of the n player's guesses. This is not a huge amount of data, so it can be returned from a single API call. (But the time to generate the data may be an issue when the system is under heavy load)

```text
POST https://api.nytimes.com/wordlebot/analysis/game-684
```

I use `POST` here because the client must send some data with the
request (see above) to create the analysis; I prefer to use `POST` with
a request body rather than passing lots of request data to a `GET`
operation via query parameters. (OpenAPI 3.2 now supports using
the `QUERY` HTTP method, which supports `GET` semantics but with
a reuquest body)

One initial API call to get the first page of summary statistics
followed, by N calls to get the analysis of each of the player's N
guesses (N <= 6), and then N additional calls to get the top twenty
guesses from all players. This corresponds the gradual reveal of the
data that the app exhibits as the player advances through the app.

```text
POST https://api.nytimes.com/wordlebot/analysis/game-684/summary
POST https://api.nytimes.com/wordlebot/analysis/game-684/guess-analysis?guess=1
POST https://api.nytimes.com/wordlebot/analysis/game-684/guess-analysis?guess=2
POST https://api.nytimes.com/wordlebot/analysis/game-684/guess-analysis?guess=3
...
POST https://api.nytimes.com/wordlebot/analysis/game-684/top-guesses?guess=1
POST https://api.nytimes.com/wordlebot/analysis/game-684/top-guesses?guess=2
POST https://api.nytimes.com/wordlebot/analysis/game-684/top-guesses?guess=3
...
```

This API design decision reflects one of the common initial
decisions one makes when designing an API. As an API designer, you have
to make the distinction begtween what are true product/application
"requirements" and what are assumptions or proposed
implementations/solutions. The product owner should define _what_ the
application should do, not _how_ it is implemented. If the product owner
says they want one of these designs (i.e. they ask for a solution that
follows option 2), you should push back and get to the desired behavior
and be open to multiple API designs. There are liklyy several other high
level designs that satisfy the underlying application requirements. (Jot
your down in comments, please!)

Both solutions 1 and 2 can be done in a stateless manner, but it is
probably easier for the WordleBot back end to implement option #1.
Solution #2 can be implemented in a stateless manner and is likely
slightly easier for the front-end to use since it matches the
application flow, but doing so may require WordleBot to compute the same
data multiple times: in order to yield the analysis of guess #4, the
WordleBot may have to reconstruct the state and data for guesses 1, 2,
and 3; and in order to yield the analysis of guess #6, it may have to
reconstruct the state and data for guesses 1, 2, 3, 4, and 5.
Conversely, WordleBot could generate and cache the complete analysis at
the start, and then extract and return just the analysis data for guess
i when asked. (Such a solution is now no longer stateless, and incurs
hidden costs&hellip; caching is really just an implementation optimization. Or,
the service could just take the computational hit and repeat/regenerate
the partial analysis each time.)

If I were tasked with designing this API, I would consult with both the
front-end team and the back-end team to determine which solution each
prefers and what would be the additional development costs imposed if
they had to work with their second choice. Time to market often forces
the API designers hand in some of these situations.

In general, my preference is to weigh the input of the API consumer more
heavily &mdash; the purist in me wants to deliver the cleanest API abstraction
that can can be understood and used and which can also evolve over time,
since ease of use if a key driver for Developer Experience and API
success. This is much more important if one anticipates (or aspires to)
multiple or even many different consumers of an API.

That is not the case here, as there is really only one consumer, the
Wordle game/app; this is a private API, not a public API. If the work to
build the client is comparable for each solution option (I believe it
is) and the service team recommends solution #1 because building
solution #2 would incur a lot more work or yield an inefficient
implementation (or expensive compute costs to support thousands of daily
user), then we might weigh that recommendation more heavily.

The JSON data models for the request and response bodies for these
options is fairly straight forward. I'll provide that if enough people
leave comments below asking for it :-).

Please let me know if you play similar mind games or thought experiments with APIs.

{% include discuss.md %}

{% include orig.md %}
