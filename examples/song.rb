require_relative '../lib/juicy.rb'
include Juicy
play = true
$my_seed = Random.new(1)
$time_to_play = Time.now
time_to_generate = Time.now
song = Song.new
#song2 = Song.new
puts "gen: #{Time.now - time_to_generate}"
song.play if play

#song2.play if play
