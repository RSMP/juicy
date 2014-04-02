module Juicy

  class Duration
  
    def initialize(duration)
      @duration = parse_duration(duration)
      
    end
    
    def self.duration_of_quarter_note_in_milliseconds(tempo)
      60_000.0/tempo
    end
    
    def duration_in_milliseconds(tempo)
      # how long a note is depends on the tempo and the musical duration
      # e.g. at 120 bpm, and a duration of an eighth note, the duration
      # in milliseconds would be 60_000.0/120/2
      # milliseconds_per_second*seconds_per_minute/bpm/beats_of_given_type_per_quarter_note
      60_000.0/tempo*beats_of_given_type_per_quarter_note
    end
    
    def to_s
      @duration.to_s
    end
  
    private
    
    def beats_of_given_type_per_quarter_note
      case @duration
      when "quarter"
        1.0
      when "half"
        2.0
      when "whole"
        4.0
      when "eighth"
        0.5
      when "sixteenth"
        0.25
      else
        1.0
      end
    end
    
    def parse_duration(duration)
      case duration
      when "quarter"
        return "quarter"
      when "half"
        return "half"
      when "eighth"
        return "eighth"
      when "sixteenth"
        return "sixteenth"
      else
        return "quarter"
      end
    end
  
  end
  
end
