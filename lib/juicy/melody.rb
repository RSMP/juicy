
module Juicy

  class Melody

    attr_reader :initial_play_time

    def initialize(options = {chord_progression: ChordProgression.new, song: Song.new, initial_play_time: 0, strategy: :whole_notes_root_of_chord})

      @song = options[:song] || Song.new
      @chord_progression = options[:chord_progression] || ChordProgression.new
      @initial_play_time = options[:initial_play_time] || 0
      @strategy = options[:strategy] || :whole_notes_root_of_chord
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

      choose_notes

    end

    def to_a
      @notes
    end

    def choose_notes
      case @strategy
      when :whole_notes_root_of_chord
        whole_notes_root_of_chord
      when :half_notes_root_first_3rd_second
        half_notes_root_first_3rd_second
      else
      end
    end

    def whole_notes_root_of_chord
      @song.measures.each_with_index do |measure, index|
        @notes << Note.new(name: @chord_progression.chords[index].notes[0].name, duration: :whole)
      end
    end

    def half_notes_root_first_3rd_second
      @song.measures.each_with_index do |measure, index|
        @notes << Note.new(name: @chord_progression.chords[index].notes[0].name, duration: :half)
        @notes << Note.new(name: @chord_progression.chords[index].notes[1].name, duration: :half)
      end
    end

  end

end
