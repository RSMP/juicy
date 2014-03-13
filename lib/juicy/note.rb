module Juicy

  class Note
  
    attr_reader :name, :pitch
    
    def initialize(name)
      @name = parse_note_name(name)
      @pitch = Pitch.new(@name)
    end
    
    def inspect
      "#{@name}"
    end
    
    def play(options = {duration: 200})
      @pitch.play(options)
    end
    
    def +(interval)
      Note.new(PITCHES.key((PITCHES[@name]+interval) % 12))
    end
    
    def -(interval)
      puts self
      puts PITCHES.key((PITCHES[@name]-interval) % 12)
      Note.new(PITCHES.key((PITCHES[@name]-interval) % 12))
    end
    
    private
    
    def parse_note_name(name)
      # parses note name input
      # user should be able to say "A#" or "a#" or "a sharp" or "A_sharp" or "a_s"
      groups = name.to_s.match(/([a-gA-G])( |_)?(.*)/)
      note_name = groups[1].upcase
      unless groups[3].nil? || groups[3].empty?
        note_name += case groups[3]
        when /^(s|#)/
          "_sharp"
        when /^(f|b)/
          "_flat"
        else
          puts "Unknown note modifier: '#{groups[3]}'"
        end
      end
      note_name.to_sym
    end
    
  end

end
