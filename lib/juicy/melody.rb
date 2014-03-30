
module Juicy

  class Melody
  
    def initialize(chord_progression = ChordProgression.new)
      
      @notes = [
        Note.new("C", "half", 1),Note.new("E", "", 1),Note.new("G", "", 1),
        Note.new("F", "", 1),Note.new("F", "eighth", 1),Note.new("G", "eighth", 1),Note.new("F", "half", 1),
        Note.new("C", "half", 1),Note.new("E", "", 1),Note.new("G", "", 1),
        Note.new("D", "", 1),Note.new("D", "eighth", 1),Note.new("E", "eighth", 1),Note.new("D", "half", 1)
      ]
      
      @notes = []
      
      (125).times do
        @notes << Note.new(([*"A".."G"]+["rest"]).sample + ["#", "b", ""].sample, ["eighth", "half", "quarter"].sample, [*0..1].sample)
      end
      
    end
    
    def to_a
      @notes
    end
    
    def initial_play_time
      0
    end
    
  end
  
end
