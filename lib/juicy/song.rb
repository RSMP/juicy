
module Juicy

  class Song
  
    attr_reader :measures, :tempo, :key, :mode
  
    def initialize
    
      #a song has a key, a mode, voices, tempo, time signature, 
      @voices = []
      @voices << Voice.new
      @key = :A
      @mode = :major
      @tempo = 100.0
      @time_signature = [4,4]
      @measures = []
      4.times {@measures << Measure.new(@time_signature)}

      #  have musical construct yield notes up to a note manager/beat sequencer for each track
      #  chords will eventually have a play style (various types of arpeggiation and such), but
      #  for now they'll all just play all their notes at once for the given duration
      
      @tracks = []
    
      key = Key.new
      chord_progression = ChordProgression.new(@key, @mode)
      
      @tracks << Track.new(0, demo_melody, @tempo)
      number_of_tracks = 1
      number_of_tracks.times do
        melody = Melody.new(chord_progression, self)
        @tracks << Track.new(melody.initial_play_time, melody, @tempo)
      end
      
    end
    
    def play
      
      Track.play_concurrently(@tracks, @tempo)
      
    end
    
    def beat_length_in_milliseconds
      60_000.0/@tempo
    end
    
    def demo_melody
      @demo_melody ||= [
        Note.new(name: "A", duration: :eighth, octave_change: -1),
        Note.new(name: "E", duration: :eighth, octave_change: -1),
        Note.new(name: "C#", duration: :eighth, octave_change: -1),
        Note.new(name: "E", duration: :eighth, octave_change: -1),
        Note.new(name: "A", duration: :eighth, octave_change: 0),
        Note.new(name: "E", duration: :eighth, octave_change: -1),
        Note.new(name: "C#", duration: :eighth, octave_change: -1),
        Note.new(name: "E", duration: :eighth, octave_change: -1),
        Note.new(name: "A", duration: :eighth, octave_change: -1),
        Note.new(name: "E", duration: :eighth, octave_change: -1),
        Note.new(name: "C#", duration: :eighth, octave_change: -1),
        Note.new(name: "E", duration: :eighth, octave_change: -1),
        Note.new(name: "A", duration: :eighth, octave_change: 0),
        Note.new(name: "E", duration: :eighth, octave_change: -1),
        Note.new(name: "C#", duration: :eighth, octave_change: -1),
        Note.new(name: "E", duration: :eighth, octave_change: -1),
        
        Note.new(name: "D", duration: :eighth, octave_change: -1),
        Note.new(name: "A", duration: :eighth, octave_change: 0),
        Note.new(name: "F#", duration: :eighth, octave_change: -1),
        Note.new(name: "A", duration: :eighth, octave_change: 0),
        Note.new(name: "D", duration: :eighth, octave_change: 0),
        Note.new(name: "A", duration: :eighth, octave_change: 0),
        Note.new(name: "F#", duration: :eighth, octave_change: -1),
        Note.new(name: "A", duration: :eighth, octave_change: 0),
        Note.new(name: "D", duration: :eighth, octave_change: -1),
        Note.new(name: "A", duration: :eighth, octave_change: 0),
        Note.new(name: "F#", duration: :eighth, octave_change: -1),
        Note.new(name: "A", duration: :eighth, octave_change: 0),
        Note.new(name: "D", duration: :eighth, octave_change: 0),
        Note.new(name: "A", duration: :eighth, octave_change: 0),
        Note.new(name: "F#", duration: :eighth, octave_change: -1),
        Note.new(name: "A", duration: :eighth, octave_change: 0)
      ]
    end
    
  end
  
end
