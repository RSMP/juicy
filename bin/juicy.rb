require_relative '../lib/juicy.rb'
include Juicy

p = Pitch.new(445)
puts p
p.play

note = Note.new("A")
#12.times {(n+=1).play}

ch = Chord.new(root: note)
ch.play

ch2 = Chord.new(root: note)
ch2.play
ch2.play(duration: 500)

# while there is enough here to write out your own scales,
# current development work is being done on scale objects
# and a beat sequencer to bring it all together.

intervals = [0,2,2,1,2,2,2,1]
intervals.each do |interval|
  (note+=interval).play
end

puts ch
