# duration_test.rb

require_relative '../lib/juicy.rb'
include Juicy

puts duration = Duration.new("dotted eighth")
puts duration = Duration.new("quarter")*2
puts duration = Duration.new("triplet sixteenth")
puts duration = ((Duration.new("quarter")+Duration.new("quarter")+Duration.new("triplet eighth")+Duration.new("triplet eighth"))*17).to_f