require './serializable.rb'
class Player
  attr_accessor :guessed_letter
  attr_accessor :guessed_word

  include Serializable

  def initialize(word_length)
    @guessed_letter = ''
    @guessed_word = Array.new(word_length, '_')
  end

  def guess_letter(word_length, guessed_letters)
    loop do
      puts "Guess a letter in a #{word_length}-letter word: ".cyan
      @guessed_letter = gets.chomp
      @guessed_letter.downcase!

      unless @guessed_letter.between?('a', 'z')
        puts "Invalid letter. Try again.".red
        puts ""

      else

        if guessed_letters.include?(@guessed_letter)
          puts "This letter has been guessed before".yellow
          puts ""

        else
          @guessed_letter
          break
        end

      end
    end
  end

  def save_player_state
    serialize_variables
  end

  def retrieve_player_state(serialized_variables)
    unserialize_variables(serialized_variables)
  end
end
