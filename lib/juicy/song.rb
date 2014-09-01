
module Juicy

  class Song

    attr_reader :measures, :tempo, :key, :mode

    def initialize

      #a song has a key, a mode, voices, tempo, time signature,
      @voices = []
      @voices << Voice.new
      @key = :A
      @mode = Mode.new(type: :minor)
      @tempo = 50.0
      @time_signature = [4,4]
      @measures = []
      8.times {@measures << Measure.new(@time_signature)}

      #  have musical construct yield notes up to a note manager/beat sequencer for each track
      #  chords will eventually have a play style (various types of arpeggiation and such), but
      #  for now they'll all just play all their notes at once for the given duration

      @tracks = []

      key = Key.new
      chord_progression = ChordProgression.new(key: @key, mode: @mode)

      bassline = Melody.new(chord_progression: chord_progression, song: self, strategy: :arp)
      @tracks << Track.new(bassline.initial_play_time, bassline, @tempo)
      number_of_tracks = 2
      number_of_tracks.times do |num|
        melody = Melody.new(chord_progression: chord_progression, song: self, strategy: :strat_1)
        @tracks << Track.new(melody.initial_play_time, melody, @tempo)
      end

    end

    def play

      Track.play_concurrently(@tracks, @tempo)

    end

    def beat_length_in_milliseconds
      60_000.0/@tempo
    end

    def demo_melody
      @demo_melody
    end

  end

end
