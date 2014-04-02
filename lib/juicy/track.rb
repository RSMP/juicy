
module Juicy

  class Track
  
    attr_accessor :notes
  
    def initialize(init_time, notes, tempo)
    
      @start_time = init_time
      @notes = notes
      @tempo = tempo
    
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
      @song_start_time = Time.now
      threads = []
      # iterate over each track over and over again, preparing notes in the current beat
      # in each iteration, store the notes you've prepared into an array and store that
      # array into the prepared_notes array which the playing thread will play notes from
      # when it has enough to play.
      # A track is an array of playable musical objects.  for now, these are individual
      # notes or chords.  a chord is an array of individual notes
      #
      prepared_beats = []
      out_of_notes_to_prepare = false
      threads << Thread.new do
        Thread.current[:name] = "prepare beats thread"
        current_beat = 1
        last_beat = 1
        tracks.each do |track|
          track.notes.each do |note|
            last_beat = note.occupying_beat if note.occupying_beat > last_beat
          end
        end
        until current_beat > last_beat
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
        until (prepared_beats.size >= 2) || out_of_notes_to_prepare
          sleep 0.01
        end
        last_note = Thread.new {}
        time = Time.now
        until prepared_beats.empty? && out_of_notes_to_prepare
          time = Time.now
          beat = prepared_beats.shift
          beat.each do |note|
            last_note = note.play_prepared
          end
          sleep rand(100..300)/1000.0
          sleep_amount = Duration.duration_of_quarter_note_in_milliseconds(tempo)/1000.0 - (Time.now - time)
          puts sleep_amount
          sleep sleep_amount unless sleep_amount < 0
        end
        last_note.join
      end
      
      #threads.each {|t| puts t[:name] }
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
