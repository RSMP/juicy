
module Juicy

  class Melody

    def initialize(chord_progression = ChordProgression.new, song = Song.new)

      @song = song
      @notes = []

      # given the chord progression, make the first note of every chord change a chord tone within 1 octave of the previous.
      # then add in notes which over all step to the next, but don't have to be chord tones OR simply jump to the next chord tone
      #song.measures.each do |measure|
        #until
      #end

      # given a chord progression, make the first note of every measure a chord tone within 1 octave of the previous

      # while distance_between_notes > 1
      #  insert notes between
      # end

      scale = Scale.new(mode: @song.mode, root: Note.new(name: @song.key))

      @song.measures.each_with_index do |measure, index|
        @notes << Note.new(name: chord_progression.chords[index].notes[0].name, duration: :whole)
      end

    end

    def to_a
      @notes
    end

    def initial_play_time
      0
    end

  end

end
