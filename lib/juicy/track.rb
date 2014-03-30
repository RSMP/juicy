
module Juicy

  class Track
  
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
        notes << Thread.new { @notes.each { |chord| 4.times {chord.play} } }
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
              note.play_prepared.join
            end
            
          end
            Thread.pass
        end
      end
      notes.each {|t| t.join}
    end
    
    def self.play_concurrently(tracks)
      @@song_start_time = Time.now
      threads = []
      tracks.each do |track|
        threads << Thread.new {track.play}
      end
      threads.each {|t| t.join}
    end
    
    private
    
    def total_duration_of_queued_notes_for_this_track
      @sum_of_queued_note_durations
    end
    
    def how_far_into_the_song_you_are
      a = (1000*(Time.now - @@song_start_time)).round
      #puts "how_far_into_the_song_you_are: #{a}"
      a
    end
    
  end
  
end
