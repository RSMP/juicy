module Juicy

  class Duration

    DURATIONS = ["whole", "half", "quarter", "eighth", "sixteenth", "thirty-second", "sixty-fourth"]
    MULTIPLIER = {:"" => 0, :triplet => -1, :dotted => 1}

    attr_reader :duration

    def initialize(duration)
      # @duration is a Rational number which represents the length of
      # a note relative to a quarter note
      # ex. Duration.new("dotted eighth")
      #  @duration = Rational(3,4)
      #
      if duration.kind_of? Rational
        @duration = duration
      else
        @duration = parse_duration(duration)
      end

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

    def to_f
      @duration.to_f
    end

    def +(other_duration)
      Duration.new(@duration + other_duration.duration)
    end

    def *(scalar)
      Duration.new(@duration*scalar)
    end

    private

    def beats_of_given_type_per_quarter_note
      @duration.to_f
    end

    #  takes user input and constructs a Rational number
    #  ex. "dotted eighth"
    #  Rational(3**
    #
    def parse_duration(duration)

      # parses note name input
      # user should be able to say "dotted sixteenth" or "quarter" or "triplet eighth"
      groups = duration.to_s.match(/^((dotted|triplet)( |_))?(.*)$/)
      puts "duration: #{duration}" if groups.nil?

      d = DURATIONS.index(groups[4])
      multiplier = MULTIPLIER[groups[2].to_s.to_sym]
      #binding.pry

      Rational(4*(3**multiplier),(2**(multiplier+d)))
    end

  end

end
