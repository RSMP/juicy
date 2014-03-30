module Juicy

  class Note
  
    include Comparable
  
	  @@default_octave = 4
    attr_reader :name, :pitch, :duration, :octave
    attr_accessor :sum_of_queued_note_durations, :how_far_into_the_song_you_are
    
    def initialize(name = "A", duration = "quarter", octave_change = 0)
      @name = parse_note_name(name)
      @pitch = Pitch.new(@name)
      @duration = Duration.new(duration)
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
      if @name == :_
        options[:volume] = 0
      end
      @pitch.play(options)
    end
    
    def prepare(options = {duration: 200, octave: (@octave-@@default_octave)})
      options[:duration] = options[:duration] || 200
      options[:octave] = options[:octave] || (@octave-@@default_octave)
      if @name == :_
        options[:volume] = 0
      end
      @prepared_note = @pitch.prepare(options)
      #puts @prepared_note.status
      until @prepared_note.status.eql? "sleep"
        sleep 0.001
        #puts @prepared_note.status
        #Thread.pass
      end
      @prepared_note
    end
    
    def play_prepared
      #puts @prepared_note.status
      until @prepared_note.status.eql? "sleep"
        sleep 0.001
        #puts @prepared_note.status
        #Thread.pass
      end
      #puts "waking up"
      @prepared_note.wakeup
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
      if same_octave
        self.pitch <=> other_note.pitch
      else
        self.octave <=> other_note.octave
      end
    end
    
    def length
      duration
    end
    
    def size
      duration
    end
    
    def initial_play_time=(time)
      @initial_play_time = time
    end
    
    def initial_play_time
      @initial_play_time
    end
    
    def duration_in_milliseconds(tempo)
      @duration.duration_in_milliseconds(tempo)
    end
    
    private
    
    def parse_note_name(name)
      # parses note name input
      # user should be able to say "A#" or "a#" or "a sharp" or "A_sharp" or "a_s"
      groups = name.to_s.match(/([a-gA-G])( |_)?(.*)/)
      if name.to_s.match "rest"
        note_name = "_"
      else
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
      end
      note_name.to_sym
    end
    
    def same_octave
      (self.octave <=> other_note.octave) == 0
    end
    
  end

end
