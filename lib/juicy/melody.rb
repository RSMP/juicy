
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
      
      scale = Scale.new(@song.mode, Note.new(name: @song.key))
      
      #new_note = 0
      #old_note = 0
      @song.measures.each_with_index do |measure, index|
        @notes << Note.new(name: chord_progression.chords[index].notes[0].name, duration: :whole)
        #new_note = Note.new(name: chord_progression.chords[index].notes.sample.name, duration: :whole, octave_change: [*(-1)..(-1)].sample)
        #measure.insert_at(0, Note.new(name: "C"))
        #old_note = new_note
      end
      #binding.pry
      
      #song.measures.each_with_index do |measure, index|
      #  @notes[index].duration = "half"
      #  note = Note.new(name: chord_progression.chords[measure].notes.sample.name, duration: :half, octave_change: [*(-1)..(-1)].sample)
      #  direction = (@notes[measure] <=> @notes[measure+1])
      #  
      #  insert = false
      #  
      #  if direction == -1
      #    until note >= @notes[measure] && note <= @notes[measure+1]
      #      #binding.pry
      #      note = Note.new(name: [*"A".."G"].sample, duration: :half, octave_change: [*(-1)..(0)].sample)
      #    end
      #    insert = true
      #  elsif direction == 1
      #    until note <= @notes[measure] && note >= @notes[measure+1]
      #      #binding.pry
      #      note = Note.new(name: [*"A".."G"].sample, duration: :half, octave_change: [*(-1)..(0)].sample)
      #    end
      #    insert = true
      #  end
      #  @notes.insert(measure+1, note) if insert
      #end
      
      #binding.pry
      
      #duration = ["half"]
      #number_of_measures = 1
      #number_of_measures.times do
      #  chord_progression.chords.each do |chord|
      #    number_of_beats_per_measure = 2
      #    number_of_beats_per_measure.times do
      #      puts chord.notes.inspect
      #      @notes << Note.new(chord.notes.sample.name,  [duration].sample,  [*(-2)..0].sample)
      #    end
      #  end
      #end
      
      

      
    end
    
    def to_a
      @notes
    end
    
    def initial_play_time
      0
    end
    
  end
  
end
