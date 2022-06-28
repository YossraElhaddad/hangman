require 'yaml'
require './player.rb'
require './colors.rb'

class Game
  attr_accessor :count
  attr_accessor :letters
  attr_accessor :word
  attr_accessor :player

  include Serializable

  private

  def get_all_words
    filename = 'google-10000-english-no-swears.txt'
    words = File.readlines(filename)
  end

  # If the word has multiple similar letter then get all the indices of that letter,
  # so that these letters can be displayed to the user once they guessed the letter.
  def get_letter_index(letter)
    result = []

    word.split('').each_with_index do |char, index|
      if char == letter
        result << index
      end
    end
    result
  end

  public

  def initialize
    @count = 10
    @word = get_all_words.sample.chomp
    @letters = {
      correct_letters: [],
      incorrect_letters: []
    }
    @player = Player.new(@word.length)
  end

  def game_over?
    game_over = false
    if count == 0 || player.guessed_word.join == word
      game_over = true
    end
    game_over
  end

  def save_game_state
    file = File.open('game_state.yml', 'w')

    game_variables = {}

    for variable in instance_variables
      unless variable == :@player
        game_variables[variable] = instance_variable_get(variable)
      else
        game_variables[variable] = player.save_player_state
      end
    end

    file.write(game_variables.to_yaml)
    file.close

    game_variables
  end

  def retrieve_game_state
    game_state = YAML.load(File.open('game_state.yml', 'r'))

    game_state.each do |key, value|
      unless key == :@player
        instance_variable_set(key, value)
      else
        player.retrieve_player_state(value)
        instance_variable_set(key, player)
      end
    end
  end

  def start
    until count == 0 || player.guessed_word.join == word do

      save_game_state if count == 10

      player.guessed_word.each { |letter| print "#{letter} ".bold }
      puts ""
      puts ""
      puts "Incorrect guessed letters:".red.bold + "#{letters[:incorrect_letters]}"

      puts "Guess the word. You have #{count.to_s.red} trials left."

      # use flatten twice to flatten all nested arrays to be more useful to check whether a specific letter has been guessed before
      player.guess_letter(word.length, letters.flatten.flatten)

      if word.include?(player.guessed_letter)
        indices = get_letter_index(player.guessed_letter)
        indices.each { |index| player.guessed_word[index] = player.guessed_letter }
        letters[:correct_letters] << player.guessed_letter

      else
        @count -= 1
        letters[:incorrect_letters] << player.guessed_letter
        puts "Incorrect letter!".red
      end

      save_game_state

    end

    if player.guessed_word.join == word
      puts "Yay, you got the word!".green.bold
    else
      puts "Aww.. you hang the man!. The word is: ".red.bold
    end

    word.each_char { |letter| print "#{letter} ".magenta.bold }
    puts ""

    # clearing the file so there won't be an option for loading game if it is finished.
    File.open('game_state.yml', 'w') { |file| file.truncate(0) }
  end

  def resume
    retrieve_game_state
    start
  end
end
