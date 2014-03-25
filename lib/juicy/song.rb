
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
      
    end
    
    def play
    
      c_chord = [Note.new("C"), Note.new("E"), Note.new("G")]
      f_chord = [Note.new("C"), Note.new("F", ""), Note.new("A", "", 1)]
      g_chord = [Note.new("B"), Note.new("D"), Note.new("G")]
    
      chords = [c_chord, f_chord, c_chord, g_chord]
      
      melody = [
        Note.new("C", "", 1),Note.new("C", "", 1),Note.new("E", "", 1),Note.new("G", "", 1),
        Note.new("F", "", 1),Note.new("F", "", 1),Note.new("G", "", 1),Note.new("F", "", 1),
        Note.new("C", "", 1),Note.new("C", "", 1),Note.new("E", "", 1),Note.new("G", "", 1),
        Note.new("D", "", 1),Note.new("D", "", 1),Note.new("E", "", 1),Note.new("D", "", 1)
        
      ]
      
        chords.each do |chord|
          4.times do
            threads = []
            chord.each do |note|
              threads << Thread.new {
                note.play
              }
            end
            
            threads.each {|t| t.join }
          end
        end
      
      
      tracks = []
      tracks << Thread.new {
        chords.each do |chord|
            threads = []
          4.times do
            chord.each do |note|
              threads << Thread.new {
                note.play
              }
            end
          end
            
            threads.each {|t| t.join }
        end
      }
      tracks << Thread.new {
        melody.each do |note|
          Thread.pass
          note.play
          Thread.pass
        end
        
      }
      
      tracks.each {|t| t.join}
      
      threads = []
      c_chord.each do |note|
        threads << Thread.new {
          note.play
        }
        
      end
      threads.each {|t| t.join }
    
    end
    
    def beat_length_in_milliseconds
      60_000.0/@tempo
    end
    
  end
  
end
