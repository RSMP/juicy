
module Juicy

  class Song
  
    attr_reader :measures, :tempo
  
    def initialize
    
      #a song has a key, a mode, voices, tempo, time signature, 
      @voices = []
      @voices << Voice.new
      @key = :A
      @mode = :major
      @tempo = 150.0
      @time_signature = [4,4]
      @measures = []
      4.times {@measures << Measure.new(@time_signature)}
      
    end
    
    def play
    
      #  have musical construct yield notes up to a note manager/beat sequencer for each track
      #  chords will eventually have a play style (various types of arpeggiation and such), but
      #  for now they'll all just play all their notes at once for the given duration
      
      tracks = []
    
      chord_progression = ChordProgression.new
      
      #tracks << Track.new(chord_progression.initial_play_time, chord_progression.to_a, @tempo)
      
      melody = Melody.new(chord_progression, self)
      puts melody.inspect
      tracks << Track.new(melody.initial_play_time, melody.to_a, @tempo)
      melody = Melody.new(chord_progression, self)
      puts melody.inspect
      tracks << Track.new(melody.initial_play_time, melody.to_a, @tempo)
      melody = Melody.new(chord_progression, self)
      puts melody.inspect
      tracks << Track.new(melody.initial_play_time, melody.to_a, @tempo)
      melody = Melody.new(chord_progression, self)
      puts melody.inspect
      tracks << Track.new(melody.initial_play_time, melody.to_a, @tempo)
      
      Track.play_concurrently(tracks, @tempo)
      
    
    end
    
    def beat_length_in_milliseconds
      60_000.0/@tempo
    end
    
  end
  
end
