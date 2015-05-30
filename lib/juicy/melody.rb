
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

      @scale = Scale.new(mode: @song.mode, root: Note.new(name: @song.key))

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
      when :strat_1
        strat_1
      when :arp
        arp
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
        @notes << Note.new(name: @chord_progression.chords[index].notes[0..1].sample.name, duration: :half)
        @notes << Note.new(name: @chord_progression.chords[index].notes[1..2].sample.name, duration: :half)
      end
    end

    def arp
      @song.measures.each_with_index do |measure, index|
        @notes << Note.new(name: @chord_progression.chords[index].notes[0].name, duration: :eighth, octave_change: -1)
        @notes << Note.new(name: @chord_progression.chords[index].notes[2].name, duration: :eighth, octave_change: -1)
        @notes << Note.new(name: @chord_progression.chords[index].notes[1].name, duration: :eighth, octave_change: -1)
        @notes << Note.new(name: @chord_progression.chords[index].notes[2].name, duration: :eighth, octave_change: -1)
        @notes << Note.new(name: @chord_progression.chords[index].notes[0].name, duration: :eighth, octave_change: 0)
        @notes << Note.new(name: @chord_progression.chords[index].notes[2].name, duration: :eighth, octave_change: -1)
        @notes << Note.new(name: @chord_progression.chords[index].notes[1].name, duration: :eighth, octave_change: -1)
        @notes << Note.new(name: @chord_progression.chords[index].notes[2].name, duration: :eighth, octave_change: -1)
      end
    end

    def strat_1
      # Fill first note with chord tone within octave of previous note.
      one_chord_tone_per_chord
      # fill third note within measure melodically in between two notes surrounding
      #cut_each_note_in_half_and_replace_second_half_with_scale_tone_between_notes
      # recursively add notes which result in either (single steps to successors) or are sixteenth notes which minimize distance
      # goal is minimal scale stepping between notes
      third_part
    end

    def one_chord_tone_per_chord
      @song.measures.each_with_index do |measure, index|
        note = @chord_progression.chords[index].notes.sample
        @notes << Note.new(name: note.name, duration: :whole, octave_change: [*0..2].sample)
      end
    end

    def cut_each_note_in_half_and_replace_second_half_with_scale_tone_between_notes
      @notes.map! do |note|
        new_note = @scale.notes.sample
        note = [Note.new(name: note.name, duration: :half, octave_change: note.octave - Note.default_octave), Note.new(name: new_note.name, duration: :half, octave_change: note.octave - Note.default_octave)]
      end.flatten!
    end

    def third_part
      steps_small_enough = false
      notes_too_short = false
      until steps_small_enough || notes_too_short
        steps_small_enough = true
        @notes = @notes.each_with_index.map do |note, index|
          # if last note, target is imaginary root note of key as if song will resolve to I chord on first beat of next measure
          successor = note_after(index)
          result = 0
          #puts note if !note.kind_of? Note
          #  BUG Should be checking for distance in the scale, not distance in half steps
          if Note.distance_between_notes(note, successor).abs <= 1
            result = note
          else
            steps_small_enough = false
            distance = Note.distance_between_notes(note, successor)
            new_note = choose_new_note(note, distance)
            if note.duration.duration/2 < Rational(1,4)
              notes_too_short = true
            end
            new_note = Note.new(name: new_note.name, duration: note.duration.duration/2, octave_change: note.octave - Note.default_octave)
            note = Note.new(name: note.name, duration: note.duration.duration/2, octave_change: note.octave - Note.default_octave)
            result = [note, new_note]
          end
          #binding.pry
          result
        end.flatten
      end
    end

    def note_after(index)
      if @notes[index+1]
        @notes[index+1]
      else
        @scale.root
      end
    end

    def choose_new_note(note, distance)
      puts distance
      new_note = note + distance/2
      loop_tries = 10
      until @scale.include? new_note
        break if loop_tries <= 0
        proto_new_up = new_note + 1
        proto_new_down = new_note - 1
        if rand < 0.5
          if @scale.include? proto_new_up
            new_note = proto_new_up
          else
            new_note = proto_new_down
          end
        else
          if @scale.include? proto_new_down
            new_note = proto_new_down
          else
            new_note = proto_new_up
          end
        end
        loop_tries -= 1
      end
      new_note
    end
  end

end
