require_relative '../lib/juicy.rb'
include Juicy
play = true
# To make a pitch, give it a frequency.
# By default, the frequency will be tuned to the nearest
# frequency in equal temperament.
#
pitch = Pitch.new(445)
puts pitch
pitch.play if play

puts "----------"
# A Note is a Pitch with a name.
# You give it a note name and an octave
#
note = Note.new(name: "G#", octave_change: -1)
puts note
note.play if play

puts "----------"
# You can also add or subtract from a note to go to the next half step
note += 1
puts note
note.play if play
note -= 2
puts note
note.play if play

puts "----------"
# With this much, you can make your own scales!
note = Note.new(name: "C")
major_scale = [2,2,1,2,2,2,1]
major_scale.each do |step|
  puts note
  note.play if play
  note += step
end
puts note
note.play if play

puts "----------"
# Of course, this is cumbersome to do all on our own,
# so you have a Scale available to you.
scale = Scale.new(:major, Note.new(name: "D", octave_change: -1))
puts scale
scale.each_note do |note|
  note.play if play
end
# 
# ch = Chord.new(root: note)
# ch.play
# 
# ch2 = Chord.new(root: note)
# ch2.play
# ch2.play(duration: 500)

# while there is enough here to write out your own scales,
# current development work is being done on scale objects
# and a beat sequencer to bring it all together.

scale = Scale.new(:major, Note.new(name: "G", octave_change: -1))
puts scale
scale.each_note do |note|
  note.play
end