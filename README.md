# hangman

A hangman game strategy with no explicit hangman whatsoever.

First the game selects a random word from "google-10000-english-no-swears.txt"
then the player is given the length of that word and is required to guess it in 10 trials.

The number of trials left is minused only when the player guesses an incorrect letter.

The player can choose whether he/she prefers to start a new game or resume an unfinished game,
the game state is saved in 'game_state.yml'

The game state file is cleared once the game is over.