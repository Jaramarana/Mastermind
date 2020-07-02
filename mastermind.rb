=begin
I need to work out a way to add the red and white peg things for the codes.


=end

class String
    #String class polymorph to add colour options
    def black;          "\e[30m#{self}\e[0m" end
    def red;            "\e[31;1m#{self}\e[0m" end
    def green;          "\e[32;1m#{self}\e[0m" end
    def yellow;         "\e[33;1m#{self}\e[0m" end
    def blue;           "\e[34;1m#{self}\e[0m" end
    def magenta;        "\e[35;1m#{self}\e[0m" end
    def cyan;           "\e[36;1m#{self}\e[0m" end
    def white;           "\e[37;1m#{self}\e[0m" end
    
    def bg_black;       "\e[40m#{self}\e[0m" end
    def bg_red;         "\e[41;1m#{self}\e[0m" end
    def bg_green;       "\e[42;1m#{self}\e[0m" end
    def bg_yellow;      "\e[43;1m#{self}\e[0m" end
    def bg_blue;        "\e[44;1m#{self}\e[0m" end
    def bg_magenta;     "\e[45;1m#{self}\e[0m" end
    def bg_cyan;        "\e[46;1m#{self}\e[0m" end
    def bg_gray;        "\e[47m#{self}\e[0m" end
    
    def bold;           "\e[1m#{self}\e[22m" end
    def italic;         "\e[3m#{self}\e[23m" end
    def underline;      "\e[4m#{self}\e[24m" end
    def blink;          "\e[5m#{self}\e[25m" end
    def reverse_color;  "\e[7m#{self}\e[27m" end
end



#colours = {0 => peg.red, 1 => peg.blue, 2 => peg.yellow, 3 => peg.green, 4 =>peg.magenta, 5 => peg.cyan} 


class ColourCode
    
    @codeLength = 4

    attr_reader :code
    
    def initialize(colourArray , clue = [".",".",".","."] )
        @clue = clue
        @code = colourArray
        @peg = "●"
        @colours = {0 => @peg.red, 1 => @peg.blue, 2 => @peg.yellow, 3 => @peg.green, 4 => @peg.magenta, 5 => @peg.cyan, "R" =>"*".red, "W" => "*".white, "." => "-"} 
    end

    def self.buildCode
        tempList = []
        @codeLength.times do
            tempList.push(rand(0..5))
        end
        ColourCode.new(tempList)
    end
    
    def returnColouredCode
        c = @code.each.map { |value| @colours[value] }.join(" ")
    end

    def correctGuess?(guessArray)
        return true if guessArray == @code
        false
    end

    def attachClue(clueArray)
        @clue = clueArray
    end

    def displayClue
        @clue.map { |i| @colours[i]}.join(' ')    
    end
end

#********************************

class Board

    def initialize
        #codes[0] will always be the correct code.
        @codes = []
        @turns = 10
        @codes << ColourCode.buildCode        
    end

    def submitGuess(guess)
        if @codes[0].correctGuess?(guess)
            puts "Winner Winner Chicken Dinner!"
            print "Enter to exit..."
            gets
            exit
        else
            @codes << ColourCode.new(guess,checkCode(guess))
        end
         
    end
    
    def drawBoard
        system("clear")
        sleep(0.5)
        (0...@codes.length).each do |i|
            if i == 100
                puts "\r? ? ? ?\t#{@codes[i].displayClue}"
                puts "-------"
            else
                puts "\r#{@codes[i].returnColouredCode}\t#{@codes[i].displayClue}"
                puts "-------"
            end
        end
    end

    def enterGuess
        puts("#{"Colours are".yellow} #{"numbers".green}, #{"numbers".red} are #{"colours".blue}")
        puts("#{"0".red} #{"1".blue} #{"2".yellow} #{"3".green} #{"4".magenta} #{"5".cyan}")
        print("#{@turns} turns\nEnter a guess using the numbers that corrosponde to the colours you want\n:")
        guess = gets.chomp.split('').map(&:to_i)
        submitGuess(guess)
    end

    def checkCode(guess)
        ans = []
        (0...@codes[0].code.length).each do |i|
           if guess[i] == @codes[0].code[i]
               ans << "R"
           else
               if @codes[0].code.any?guess[i]
                   ans << "W"
               end   
           end
           
        end
        ans
    end

    def start
        while @turns > 0
            drawBoard
            enterGuess
            @turns -= 1    
        end
        puts "You Lose\nGame #{"Over".red}\n#{@codes[0].returnColouredCode} was the answer"
        
    end

end #class end



#*********************
#TESTING BELOW. BEWARE
#*********************
system("clear")
f = Board.new()
f.start

