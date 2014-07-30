
module Juicy

  class Track
  
    attr_accessor :notes
  
    def initialize(init_time, notes, tempo)
    
      @start_time = init_time
      @notes = notes.to_a
      @tempo = tempo
      
      @track_length_in_milliseconds = 0
      @notes.each do |note|
        note.distance_from_beat_in_milliseconds = distance_from_beat_in_milliseconds
        note.plays_during occupying_beat
        @track_length_in_milliseconds += note.duration_in_milliseconds(@tempo)
      end
    
    end
    
    def distance_from_beat_in_milliseconds
      (@track_length_in_milliseconds.round % Duration.duration_of_quarter_note_in_milliseconds(@tempo).round)
    end
    
    def occupying_beat
      @track_length_in_milliseconds.round / Duration.duration_of_quarter_note_in_milliseconds(@tempo).round + 1
    end
  
    def play
    
      # prepare notes ahead of time, and play them at a specified time.
      # each note must be prepared separately in it's own thread.
      # only 20 threads are allowed to be alive at a time in a current track, and each track is preparing its notes seperately
      # th = []
      # while(notes_left_to_prepare)
      #   if (th.count {|t| t.alive? }) <= 20
      #     note = notes_left_to_prepare.shift
      #     th << Thread.new do
      #       note.prepare
      #       sleep_amount = when_the_note_should_be_played - how_far_into_the_song_you_are
      #       unless sleep_amount < 0
      #         sleep sleep_amount
      #       end
      #       note.play_prepared
      #     end
      #   end
      # end
      # th.each {|t| t.join}
    
      notes = []
      if @notes[0].kind_of? Chord
        #notes << Thread.new { @notes.each { |chord| 4.times {chord.play} } }
        chords_left_to_prepare = @notes.dup
        @sum_of_queued_chord_durations = 0
        until chords_left_to_prepare.size == 1
          if (notes.count {|t| t.alive?} <= 20)
            notes << Thread.new do
              chord = chords_left_to_prepare.shift
              puts "#{chord}: #{chord.duration}"
              chord.sum_of_queued_chord_durations = @sum_of_queued_chord_durations
              @sum_of_queued_chord_durations += chord.duration_in_milliseconds(@tempo)
              chord.initial_play_time = @start_time + chord.sum_of_queued_chord_durations
              chord.how_far_into_the_song_you_are = how_far_into_the_song_you_are
              chord.prepare(duration: chord.duration_in_milliseconds(@tempo))
              sleep_amount = (chord.initial_play_time - chord.how_far_into_the_song_you_are)/1000.0
              unless sleep_amount < 0
                sleep sleep_amount
              end
              Thread.pass
              chord.play_prepared.join
              #puts "tehe"
              
              
            end
          end
          Thread.pass
        end
        
      elsif @notes[0].kind_of? Note
      
        # @notes.each do |note|
          # note.play
        # end
        notes_left_to_prepare = @notes.dup
        @sum_of_queued_note_durations = 0
        until notes_left_to_prepare.size == 1
          #puts notes_left_to_prepare.size
          if (notes.count {|t| t.alive? }) <= 20
            #Thread.pass
            notes << Thread.new do
              note = notes_left_to_prepare.shift
              puts "#{note}: #{note.duration}"
              note.sum_of_queued_note_durations = @sum_of_queued_note_durations
              @sum_of_queued_note_durations += note.duration_in_milliseconds(@tempo)
              #puts @sum_of_queued_note_durations
              note.initial_play_time = @start_time + note.sum_of_queued_note_durations
              #puts "note.initial_play_time: #{note.initial_play_time}"
              note.how_far_into_the_song_you_are = how_far_into_the_song_you_are
              #puts "note.how_far_into_the_song_you_are: #{note.how_far_into_the_song_you_are}"
              note.prepare(duration: note.duration_in_milliseconds(@tempo))
              # puts "note.initial_play_time: #{note.initial_play_time}"
              # puts "note.how_far_into_the_song_you_are: #{note.how_far_into_the_song_you_are}"
              sleep_amount = (note.initial_play_time - note.how_far_into_the_song_you_are)/1000.0
              #puts sleep_amount
              unless sleep_amount < 0
                sleep sleep_amount
              end
              Thread.pass
              note.play_prepared
            end
            
          end
            Thread.pass
        end
      end
      notes.each {|t| t.join}
    end
    
    def self.tracks_is_empty(tracks)
      empty = true
      tracks.each do |track|
        #puts track.object_id
        puts track.notes.inspect
        unless track.notes.empty?
          empty = false
        end
      end
      empty
    end
    
    def self.play_concurrently(tracks, tempo)
      #@song_start_time = Time.now
      threads = []
      # iterate over each track over and over again, preparing notes in the current beat
      # in each iteration, store the notes you've prepared into an array and store that
      # array into the prepared_notes array which the playing thread will play notes from
      # when it has enough to play.
      # A track is an array of playable musical objects.  for now, these are individual
      # notes or chords.  a chord is an array of individual notes to be played simultaneously
      #
      prepared_beats = []
      out_of_notes_to_prepare = false
      threads << Thread.new do
        Thread.current[:name] = "prepare beats thread"
        current_beat = 1
        last_beat = 1
        # find the final beat of all tracks combined
        tracks.each do |track|
          track.notes.each do |playable_thing|
            if playable_thing.kind_of?(Note)
              last_beat = playable_thing.occupying_beat if playable_thing.occupying_beat > last_beat
            elsif playable_thing.kind_of?(Chord)
              playable_thing.notes.each do |note|
                last_beat = note.occupying_beat if note.occupying_beat > last_beat
              end
            end
          end
        end
        # until you've prepared all the notes, prepare each note in an array with
        # other notes who occupy the same beat
        until current_beat > last_beat
          # only add/prepare beats if there are fewer than 20 prepared already
          # so that we don't hit the thread limit.  This assumes that a buffer of 20
          # is sufficent and that each beat has, on average, fewer than 30 notes.
          # if there are too many notes, weird things start to happen, so don't do that.
          if prepared_beats.size <= 20
            this_beats_notes = []
            tracks.each do |track|
              while !track.notes[0].nil? && track.notes[0].plays_during?(current_beat)
                playable_thing = track.notes.shift
                if playable_thing.kind_of?(Note)
                  this_beats_notes << playable_thing.prepare(duration: playable_thing.duration_in_milliseconds(tempo))
                elsif playable_thing.kind_of?(Chord)
                  playable_thing.notes.each do |note|
                    this_beats_notes << note.prepare(duration: note.duration_in_milliseconds(tempo))
                  end
                end
              end
            end
            prepared_beats << this_beats_notes
            current_beat += 1
          end
          # Pass thread execution over to note playing so that there is no delay in playback
          Thread.pass
        end
        out_of_notes_to_prepare = true
      end

      threads << Thread.new do
        Thread.current[:name] = "play prepared beats thread"
        # when prepared_beats has at least a few beats to play (a measure's worth?)
        # "start" the song by iterating through each element, waking up each note
        # and then waiting the remainder of a beat's worth of milliseconds until the
        # next beat
        until (prepared_beats.size >= 4) || out_of_notes_to_prepare
          sleep 0.01
        end
        last_note = Thread.new {}
        time = Time.now
        until prepared_beats.empty? && out_of_notes_to_prepare
          time = Time.now
          # take the next beat's worth of notes
          beat = prepared_beats.shift
          # start each note in the beat as its own thread
          beat.each do |note|
            last_note = note.play_prepared
          end
          # to ensure simultaneity, sleep for however much longer a beat lasts
          # at the current tempo
          sleep_amount = Duration.duration_of_quarter_note_in_milliseconds(tempo)/1000.0 - (Time.now - time)
          sleep sleep_amount unless sleep_amount < 0
        end
        last_note.join
      end
      
      threads.each {|t| t.join}
    end
    
    private
    
    def total_duration_of_queued_notes_for_this_track
      @sum_of_queued_note_durations
    end
    
    def how_far_into_the_song_you_are
      a = (1000*(Time.now - @song_start_time)).round
      #puts "how_far_into_the_song_you_are: #{a}"
      a
    end
    
  end
  
end
