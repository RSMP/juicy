
module Juicy

  class Melody
  
    def initialize(chord_progression = ChordProgression.new, song = Song.new)
      
      @notes = [
        Note.new("C", "half", 1),Note.new("E", "", 1),Note.new("G", "", 1),
        Note.new("F", "", 1),Note.new("F", "eighth", 1),Note.new("G", "eighth", 1),Note.new("F", "half", 1),
        Note.new("C", "half", 1),Note.new("E", "", 1),Note.new("G", "", 1),
        Note.new("D", "", 1),Note.new("D", "eighth", 1),Note.new("E", "eighth", 1),Note.new("D", "half", 1)
      ]
      
      @notes = []
      
      # given the chord progression, make the first note of every chord change a chord tone within 1 octave of the previous.
      # then add in notes which over all step to the next, but don't have to be chord tones OR simply jump to the next chord tone
      song.measures.each do |measure|
        #until 
      end
      (10).times do
        @notes << Note.new((["A", "C", "E"]).sample + [""].sample, ["eighth"].sample, [*(-1)..1].sample)
      end
      (10).times do
        @notes << Note.new((["E", "G#", "B"]).sample + [""].sample, ["eighth"].sample, [*(-1)..1].sample)
      end
      (10).times do
        @notes << Note.new((["A", "C", "E"]).sample + [""].sample, ["eighth"].sample, [*(-1)..1].sample)
      end
      
      
      sum_of_durations = 0
      @notes.each do |note|
        sum_of_durations += note.duration_in_milliseconds(song.tempo)
        note.distance_from_beat_in_milliseconds = (sum_of_durations.round % Duration.duration_of_quarter_note_in_milliseconds(song.tempo).round)
        note.plays_during(sum_of_durations.round / Duration.duration_of_quarter_note_in_milliseconds(song.tempo).round + 1)
        #puts note.distance_from_beat_in_milliseconds
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
