module Juicy

  # a chord is an array of notes (played "simultaneously")
  # three ways for a chord to go "up":
  #  every note in the chord goes up some number of half steps (transposition)
  #  every note in the chord goes up some number of scale steps (progression)
  #   this only applies if a scale is involved
  #  the current bottom note goes up an octave (inversion)
  #  a note is added to the top (adding)
  # a chord has a root which is the first note in the uninverted
  # a chord's quality is a result of what notes are in it.
  # a note in a chord can remain unexpressed (say. G dominant 7 where the D isn't played)
  #
  class Chord

    QUALITIES = {
      :major => [0, 4, 7],
      :minor => [0, 3, 7],
      :diminished => [0, 3, 6],
      :augmented => [0, 4, 8]
    }

    attr_reader :duration, :notes
    attr_accessor :sum_of_queued_chord_durations, :how_far_into_the_song_you_are

    def initialize(options = {root: Note.new(name: :C), quality: :major, inversion: 0, context: :none, duration: Duration.new("quarter")})
      #binding.pry
      @root = (options[:root].kind_of?(Note) ? options[:root] : Note.new(name: options[:root])) || Note.new(name: :C)
      @quality = options[:quality] || :major
      @inversion = options[:inversion] || 0
      @context = options[:context] || :none
      @duration = options[:duration] || Duration.new("quarter")
	    @type = :triad
      @notes = [@root + QUALITIES[@quality][0], @root + QUALITIES[@quality][1], @root + QUALITIES[@quality][2]]
    end

    def to_s
      "chord type: #{@type}, quality: #{@quality}, root: #{@root}, inversion: #{@inversion}"
    end

    def inspect
      "#{@root.name} #{@quality} Chord, inversion: #{@inversion}"
    end

    def play(options = {duration: 200, style: :default})

      #Quick and dirty play function.  Not intended for genuine use

      duration = options[:duration] || 200
      style = options[:style] || :default
      notes = []
      pitches = QUALITIES[@quality]
      inversion = @inversion

      while inversion > 0
        pitches = pitches[1..-1] + [(pitches[0]+12)]
        inversion -= 1
      end

      pitches.each do |interval|
        notes << Note.new(name: PITCHES.key((PITCHES[@root.name]+interval) % 12))
      end

      case style
      when :arpeggiate
        notes.each do |note|
          Thread.new{note.play(duration: duration)}.join
        end
      when :default
        threads = []
        notes.each do |note|
          threads << Thread.new{note.play(duration: duration)}
        end
        threads.each {|t| t.join}
      else
        puts "Unknown style type"
      end

      self
    end

    def +(interval)
      #in the context of a scale, change the base pitch to the new scale
      # degree and the quality to match

      #in a context of :none, change the base pitch
      # up a half step times the interval
      if @context.eql? :none
        options = {
          root: (Pitch.new(@root) + interval).frequency,
          quality: @quality,
          inversion: @inversion,
          context: @context
        }
        Chord.new(options)
      end
    end

    def -(interval)

      if @context.eql? :none
        options = {
          root: (Pitch.new(@root) - interval).frequency,
          quality: @quality,
          inversion: @inversion,
          context: @context
        }
        Chord.new(options)
      end
    end

    def cycle(direction = :up, amount = 1)
      #inverts the chord
      # ex. 1, 3, 5 -> cycle(:up, 2) -> 5, 1, 3
      case direction
      when :up
        @inversion = @inversion + amount
      when :down
        @inversion = @inversion - amount
      else
        puts "Unknown Direction"
      end
      puts self.inspect
    end

    alias_method :invert, :cycle

    def prepare(options = {duration: 200, octave: (@octave-Note.default_octave)})
      @prepared_notes = []
      @notes.each do |note|
        options[:duration] = options[:duration] || 200
        options[:octave] = options[:octave] || (note.octave-Note.default_octave)

        @prepared_notes << note.prepare(options)
      end
    end

    def play_prepared
      th = []
      #puts @prepared_notes.inspect
      @prepared_notes.each do |note|
        th << Thread.new {
          note.play_prepared.join


        }
      end
     th.each {|t| t.join}
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

  end

end
