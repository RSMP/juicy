module Juicy
  
  class ChordProgression
  
    attr_accessor :chords
    
    def initialize
      #@chords = []
      #@chords << Chord.new(root: :C)
      #@chords << Chord.new(root: :G, inversion: 1)-12
      #@chords << Chord.new(root: :A, quality: :minor)
      #@chords << Chord.new(root: :F, inversion: 1)-12
      @chords = []
      @chords << Chord.new(root: :C)
      @chords << Chord.new(root: :F, inversion: 2)-12
      @chords << Chord.new(root: :G, inversion: 1)-12
      @chords << Chord.new(root: :C)
      #@progression = []
      #@progression << ScaleDegree.new("I")
      #@progression << ScaleDegree.new("IV")
      #@progression << ScaleDegree.new("V")
      #@progression << ScaleDegree.new("I")
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
    
    def play
      @chords.each do |chord|
        4.times {chord.play}
      end
    end
    
  end
  
end
