
module Juicy

  class Track

    attr_accessor :notes

    class << self
      # consider extracting these to a PlaySession class or something
      attr_accessor :last_beat, :current_beat, :prepared_beats, :out_of_notes_to_prepare
    end

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

    # Play 1 or more tracks concurrently at a given tempo
    #
    def self.play_concurrently(tracks, tempo)

      threads = []
      Track.prepared_beats = []
      Track.out_of_notes_to_prepare = false

      threads << Track.prepare_beats_thread(tracks, tempo)
      threads << Track.play_prepared_beats_thread(tempo)

      threads.each {|t| t.join}

    end

    private

    def self.final_beat_in(tracks)
      final_beat = 0
      tracks.each do |track|
        track.notes.each do |playable_thing|
          if playable_thing.kind_of?(Note)
            final_beat = playable_thing.occupying_beat if playable_thing.occupying_beat > final_beat
          elsif playable_thing.kind_of?(Chord)
            playable_thing.notes.each do |note|
              final_beat = note.occupying_beat if note.occupying_beat > final_beat
            end
          end
        end
      end
      final_beat
    end

    def self.all_beats_prepared
      Track.current_beat > Track.last_beat
    end

    def self.room_in_prepared_beats_buffer
      Track.prepared_beats.size <= 20
    end

    def self.prepare_next_beat_given(tracks, tempo)
      this_beats_notes = []
      tracks.each do |track|
        while !track.notes[0].nil? && track.notes[0].plays_during?(Track.current_beat)
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
      Track.prepared_beats << this_beats_notes
      Track.current_beat += 1
    end

    def self.wait_until_beat_buffer_is_a_little_full
      until (Track.prepared_beats.size >= 4) || Track.out_of_notes_to_prepare
        sleep 0.01
      end
    end

    def self.no_more_to_play
      Track.prepared_beats.empty? && Track.out_of_notes_to_prepare
    end

    def total_duration_of_queued_notes_for_this_track
      @sum_of_queued_note_durations
    end

    def how_far_into_the_song_you_are
      a = (1000*(Time.now - @song_start_time)).round
      #puts "how_far_into_the_song_you_are: #{a}"
      a
    end

    def distance_from_beat_in_milliseconds
      (@track_length_in_milliseconds.round % Duration.duration_of_quarter_note_in_milliseconds(@tempo).round)
    end

    def occupying_beat
      @track_length_in_milliseconds.round / Duration.duration_of_quarter_note_in_milliseconds(@tempo).round + 1
    end

    # find the final beat of all tracks combined
    # until you've prepared all the notes, prepare each note in an array with
    # other notes who occupy the same beat
    # only add/prepare beats if there are fewer than 20 prepared already
    # so that we don't hit the thread limit.  This assumes that a buffer of 20
    # is sufficent and that each beat has, on average, fewer than 30 notes.
    # if there are too many notes, weird things start to happen, so don't do that.
    # Pass thread execution over to note playing so that there is no delay in playback
    #  If it's not passed, notes won't get played in time since the until loop is looping
    #  over an empty array
    #
    def self.prepare_beats_thread(tracks, tempo)
      Thread.new do
        Thread.current[:name] = "prepare beats thread"
        Track.current_beat = 1
        Track.last_beat = Track.final_beat_in(tracks)
        until Track.all_beats_prepared
          if Track.room_in_prepared_beats_buffer
            Track.prepare_next_beat_given(tracks, tempo)
          end
          Thread.pass
        end
        Track.out_of_notes_to_prepare = true
      end
    end

    # when prepared_beats has at least a few beats to play (a measure's worth?)
    # "start" the song by iterating through each element, waking up each note
    # and then waiting the remainder of a beat's worth of milliseconds until the
    # next beat
    #
    def self.play_prepared_beats_thread(tempo)
      Thread.new do
        Thread.current[:name] = "play prepared beats thread"
        Track.wait_until_beat_buffer_is_a_little_full
        last_note = Thread.new {}
        time = Time.now
        until Track.no_more_to_play
          time = Time.now
          beat = Track.prepared_beats.shift
          beat.each do |note|
            last_note = note.play_prepared
          end
          sleep_amount = Duration.duration_of_quarter_note_in_milliseconds(tempo)/1000.0 - (Time.now - time)
          sleep sleep_amount unless sleep_amount < 0
        end
        last_note.join
      end
    end

  end

end
