
module Juicy

  class Song
  
    def initialize
    
      #a song has a key, a mode, voices, tempo, time signature, 
      @voices = []
      @voices << Voice.new
      @key = :A
      @mode = :major
      @tempo = 90.0
      @time_signature = [4,4]
      
      
      # play Do Mi So Do
      notes = [0, 4, 7, 12]
      @voices[0].notes = [
        Note.new(Pitch.new(440*2.0**(notes[0]/12)), beat_length_in_milliseconds),
        Note.new(Pitch.new(440*2.0**(notes[1]/12)), beat_length_in_milliseconds),
        Note.new(Pitch.new(440*2.0**(notes[2]/12)), beat_length_in_milliseconds),
        Note.new(Pitch.new(440*2.0**(notes[3]/12)), beat_length_in_milliseconds)
      ]
      
    end
    
    def beat_length_in_milliseconds
      60*1000/@tempo
    end
    
  end
  
end
