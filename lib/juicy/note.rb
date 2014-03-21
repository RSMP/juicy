module Juicy

  class Note
  
    include Comparable
  
	  @@default_octave = 4
    attr_reader :name, :pitch, :octave
    
    def initialize(name = "A", octave_change = 0)
      @name = parse_note_name(name)
      @pitch = Pitch.new(@name)
	    @octave = @@default_octave + octave_change
    end
    
    def to_s
      name = @name[0]
      name += "#" if @name=~/sharp/
      name += "b" if @name=~/flat/
      "#{name}#{@octave}"
    end
	
    def inspect
      "#{@name}"
    end
    
    def play(options = {duration: 200, octave: (@octave-@@default_octave)})
      @pitch.play(options)
    end
    
    def +(interval)
	  step = PITCHES[@name]+interval
	  octave_change = step/12 #mathy stuff to figure out how many octaves were traversed (cant assume just one was
      name = PITCHES.key((PITCHES[@name]+interval) % 12)
      Note.new(name, @octave-@@default_octave + octave_change)
    end
    
    def -(interval)
      Note.new(PITCHES.key((PITCHES[@name]-interval) % 12))
    end
    
    def <=>(other_note)
      if (self.octave <=> other_note.octave) == 0
        self.pitch <=> other_note.pitch
      else
        self.octave <=> other_note.octave
      end
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
