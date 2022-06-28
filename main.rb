require './game.rb'

filename = 'game_state.yml'

loop do
    game = Game.new
    
    if(!File.file?(filename) || File.zero?(filename))
        puts "Starting new game..."
        game.start

    else
            puts "Press 1 if you want to start a new game."
            puts "Press 2 if you want to pick where you left off."

            choice = gets.chomp
            unless choice.to_i.between?(1,2)
                puts "Invalid choice!".red
            else
                choice.to_i == 1 ? game.start : game.resume
               
            end
        
    end

    puts "Play again? Press 'y' if you want to and any other key to exit."
    choice = gets.chomp
    break unless choice.downcase == 'y'

end
