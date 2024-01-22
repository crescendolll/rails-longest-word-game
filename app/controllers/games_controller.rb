require 'open-uri'

class GamesController < ApplicationController
  def new
    def generate_grid(grid_size)
      alphabet = ('a'..'z').to_a
      grid = []
      (1..grid_size).each do
        grid << alphabet.sample
      end
      return grid
    end

    @letters = generate_grid(10)
  end

  def score
    @attempt = params[:attempt]
    @letters = params[:letters].split(' ')
    @message = ""

    def attempt_valid_english?(attempt)
      JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)["found"]
    end

    def attempt_in_letters?(attempt)
      attempt.chars.each do |letter|
        return false if @letters.none? { |element| letter == element }
      end
      return true
    end

    def attempt_overuses_letter?(attempt)
      scan_attempt = attempt.dup
      @letters.each do |letter|
        scan_attempt.sub!(letter, "") if scan_attempt.include?(letter)
      end
      return scan_attempt != ""
    end

    if !attempt_valid_english?(@attempt) then @message = "Sorry but #{@attempt.upcase} doesn't seem to be an English word!"
    elsif !attempt_in_letters?(@attempt) then @message = "Sorry but #{@attempt.upcase} can't be built out of #{@letters}!"
    elsif attempt_overuses_letter?(@attempt) then @message = "Sorry but #{@attempt.upcase} can't be built only out of #{@letters}!"
    # elsif (end_time - start_time) > 60 then @message = "You lost, you took too long - be quicker next time!"
    else
      # score = calculate_score(end_time - start_time, letters.length, attempt.length)
      @message = "Congratulations! #{@attempt.upcase} is a valid English word!"
    end

  end
end
