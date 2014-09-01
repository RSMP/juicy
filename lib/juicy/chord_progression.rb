module Juicy

  class ChordProgression

    attr_accessor :chords

    def initialize(options = {key: Key.new, mode: Mode.new, numerals: [1,4,1,5]})

      @key = options[:key] || Key.new
      @numerals = options[:numerals] || []
      @mode = options[:mode] || Mode.new

      #given a key and a mode, a number can tell me what chord.

      @chords = [
        Chord.new(root: "A", quality: @mode.type),
        Chord.new(root: "D", quality: @mode.type),
        Chord.new(root: "A", quality: @mode.type),
        Chord.new(root: "E", quality: @mode.type),
        Chord.new(root: "A", quality: @mode.type),
        Chord.new(root: "F", quality: :major),
        Chord.new(root: "A", quality: @mode.type),
        Chord.new(root: "E", quality: @mode.type)
      ]

    end

    def inspect
      output = ""
      @chords.each do |chord|
        output += chord.inspect + ", "
      end
      output[0..-3]
    end

    def to_s
      output = ""
      @progression.each do |scale_degree|
        output += scale_degree.to_s + ", "
      end
      output[0..-3]
    end

    def to_a
      [Chord.new(root: "C")]
      @chords
    end

    def initial_play_time
      0
    end

    def play
      @chords.each do |chord|
        4.times {chord.play}
      end
    end

  end

end
