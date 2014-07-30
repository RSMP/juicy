module Juicy
  
  class ChordProgression
  
    attr_accessor :chords
    
    def initialize(key, mode, numerals = [1,4,1,5])
    
      @numerals = numerals
      
      #given a key and a mode, a number can tell me what chord.
      
      @chords = [
        Chord.new(root: "A", quality: :major),
        Chord.new(root: "D", quality: :major),
        Chord.new(root: "A", quality: :major),
        Chord.new(root: "E", quality: :major)
      ]
     #@numerals.each do |numeral|
     #  @chords << Chord.new(numeral)
     #end
      
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
      [Chord.new(root: "C")]
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
