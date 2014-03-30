module Juicy
  
  class ChordProgression
  
    attr_accessor :chords
    
    def initialize
      @chords = []
      @chords << Chord.new(root: :C)
      @chords << Chord.new(root: :F, inversion: 2)
      @chords << Chord.new(root: :G, inversion: 1)
      @chords << Chord.new(root: :C)
    end
    
    def inspect
      output = ""
      @chords.each do |chord|
        output += chord.inspect + ", "
      end
      output[0..-3]
    end
  
    def to_s
      output = ""
      @progression.each do |scale_degree|
        output += scale_degree.to_s + ", "
      end
      output[0..-3]
    end
    
    def to_a
      [Chord.new(root: "C"), Chord.new(root: "F", inversion: 1), Chord.new(root: "C"), Chord.new(root: "G")]
      @chords
    end
    
    def initial_play_time
      0
    end
    
    def play
      @chords.each do |chord|
        4.times {chord.play}
      end
    end
    
  end
  
end
