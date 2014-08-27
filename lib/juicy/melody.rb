
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

    def strat_1
      # Fill first note with chord tone within octave of previous note.
      first_part
      # fill third note within measure melodically in between two notes surrounding
      second_part
      # recursively add notes which result in either (single steps to successors) or are sixteenth notes which minimize distance
      third_part
    end

    def first_part
      @song.measures.each_with_index do |measure, index|
        note = @chord_progression.chords[index].notes.sample
        unless @notes.empty?
          tries = 5
          while Note.distance_between_notes(@notes[-1], note) > 12
            note = @chord_progression.chords[index].notes.sample
            tries -= 1
            break if tries <= 0
          end
          puts "no avail" if tries <= 0
        end
        @notes << Note.new(name: note.name, duration: :whole)
      end
    end

    def second_part
      @notes.map! do |note|
        new_note = @scale.notes.sample
        note = [Note.new(name: note.name, duration: :half), Note.new(name: new_note.name, duration: :half)]
      end.flatten!
    end

    def third_part
      steps_small_enough = false
      notes_too_short = false
      until steps_small_enough || notes_too_short
        steps_small_enough = true
        @notes = @notes.each_with_index.map do |note, index|
          #if last note, target is imaginary root note of key as if song will resolve to I chord on first beat of next measure
          successor = Note.new
          if @notes[index+1]
            successor = @notes[index+1]
          else
            successor = @scale.root
          end
          result = 0
          #puts note if !note.kind_of? Note
          #  BUG Should be checking for distance in the scale, not in the notespace
          if Note.distance_between_notes(note, successor) <= 1
            result = note
          else
            steps_small_enough = false
            distance = Note.distance_between_notes(note, successor)
            new_note = note + distance/2
            until @scale.notes.include? new_note
              proto_new_up = new_note + 1
              proto_new_down = new_note - 1
              if rand < 0.5
                if @scale.notes.include? proto_new_up
                  new_note = proto_new_up
                else
                  new_note = proto_new_down
                end
              else
                if @scale.notes.include? proto_new_down
                  new_note = proto_new_down
                else
                  new_note = proto_new_up
                end
              end
            end
            if note.duration.duration/2 < Rational(1,2)
              notes_too_short = true
            end
            result = [Note.new(name: note.name, duration: note.duration.duration/2), Note.new(name: new_note.name, duration: note.duration.duration/2)]
          end
          #binding.pry
          result
        end.flatten
      end
    end

  end

end
