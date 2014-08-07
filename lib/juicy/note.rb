module Juicy

  class Note
  
    include Comparable
  
    class << self
      attr_reader :default_octave
    end
    @default_octave = 5
    attr_reader :name, :pitch, :duration, :octave, :occupying_beat
    attr_accessor :sum_of_queued_note_durations, :how_far_into_the_song_you_are
    attr_accessor :distance_from_beat_in_milliseconds
    
    def initialize(options = {name: "A", duration: :quarter, octave_change: 0})
      options[:name] ||= "A"
      options[:duration] ||= :quarter
      options[:octave_change] ||= 0
      @name = parse_note_name(options[:name])
      @pitch = Pitch.new(@name)
      @duration = Duration.new(options[:duration])
      @octave = Note.default_octave + options[:octave_change]
    end
    
    def to_s
      name = @name[0]
      name += "#" if @name=~/sharp/
      name += "b" if @name=~/flat/
      "#{name}#{@octave}"
    end
  
    def inspect
      "#{@name}#{@octave}"
    end
    
    def play(options = {duration: 200, octave: (@octave-Note.default_octave)})
      if @name == :_
        options[:volume] = 0
      end
      @pitch.play(options)
    end
    
    def prepare(options = {duration: 200, octave: (@octave-Note.default_octave)})
      options[:duration] = options[:duration] || 200
      options[:octave] = options[:octave] || (@octave-Note.default_octave)
      if @name == :_
        options[:volume] = 0
      end
        Thread.pass
      @prepared_note = @pitch.prepare(options)
      @prepared_note[:sleep_time] = @distance_from_beat_in_milliseconds/1000.0
      until @prepared_note.status.eql? "sleep"
        sleep 0.001
      end
      @prepared_note
      self
    end
    
    def play_prepared
      until @prepared_note.status.eql? "sleep"
        sleep 0.001
      end
      @prepared_note.wakeup
    end
    
    def +(interval)
      step(interval)
      Note.new(name: new_name, octave_change: octave_change)
    end
    
    def -(interval)
      step(-1*interval)
      Note.new(name: new_name, octave_change: octave_change)
    end
    
    def <=>(other_note)
      if same_octave(other_note)
        self.pitch <=> other_note.pitch
      else
        self.octave <=> other_note.octave
      end
    end
    
    def succ
      return (self+1)
    end
    
    def prev
      return (self-1)
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
    
    def plays_during(beat)
      @occupying_beat = beat
    end
    
    def plays_during?(beat)
      beat == @occupying_beat
    end
    
    def duration=(duration)
      @duration = Duration.new(duration)
    end
    
    private
    
    def octave_change
      @octave - Note.default_octave + @step/12
    end
    
    def step(interval)
      @step = PITCHES[@name]+interval
    end
    
    def new_name
      PITCHES.key((@step) % 12)
    end
    
    def parse_note_name(name)
      # parses note name input
      # user should be able to say "A#" or "a#" or "a sharp" or "A_sharp" or "a_s"
      groups = name.to_s.match(/(?<name>[a-gA-G])(?<space> |_)?(?<accidental>.*)/)
      if name.to_s.match "rest" || name.to_s.match(/^_$/)
        note_name = "_"
      else
        note_name = groups[:name].upcase
        unless groups[:accidental].nil? || groups[:accidental].empty?
          note_name += case groups[:accidental]
          when /^(s|#)/
            "_sharp"
          when /^(f|b)/
            "_flat"
          else
            puts "Unknown note modifier: '#{groups[:accidental]}'"
            ""
          end
        end
      end
      note_name.to_sym
    end
    
    def same_octave(other_note)
      (self.octave <=> other_note.octave) == 0
    end
    
  end

end
