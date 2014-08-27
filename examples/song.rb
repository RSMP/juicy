require_relative '../lib/juicy.rb'
include Juicy
play = true

song = Song.new
song2 = Song.new

song.play if play

song2.play if play
