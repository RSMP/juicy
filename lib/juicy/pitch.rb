module Juicy

  PITCHES = {
    _: -1,
    A: 0,
    A_sharp: 1,
    B_flat: 1,
    B: 2,
    B_sharp: 3,
    C_flat: 2,
    C: 3,
    C_sharp: 4,
    D_flat: 4,
    D: 5,
    D_sharp: 6,
    E_flat: 6,
    E: 7,
    E_sharp: 8,
    F_flat: 7,
    F: 8,
    F_sharp: 9,
    G_flat: 9,
    G: 10,
    G_sharp: 11,
    A_flat: 11
  }

  # This class encapsulates all of the pitch mechanics for a given temperament.
  #
  class Pitch

    include Comparable
    @temperament = :equal
    @pitch_standard = 440.0

    class << self
      attr_reader :temperament, :pitch_standard
    end

    attr_reader :frequency, :confidence

    def initialize(options = {frequency: Pitch.pitch_standard, tune_now: true})
      options[:frequency] ||= Pitch.pitch_standard
      options[:tune_now] ||= true

      if options[:frequency].kind_of? Numeric
        @frequency = options[:frequency]
        @tuned = false
        tune if options[:tune_now]
      else
        raise ArgumentError unless options[:frequency].kind_of? Symbol
        step = PITCHES[options[:frequency].to_sym]
        @frequency = Pitch.pitch_standard*2**(step/12.0)
        @tuned = true
      end

    end

    def to_s
      "#{@frequency}"
    end

    def tune
      if out_of_tune
        step = Math.log(@frequency/440.0,2)*12
        @confidence = (1.0-2*(step - step.round).abs)*100.0
        @frequency = Pitch.pitch_standard*2**((step.round)/12.0)
        @tuned = true
      end
      self
    end

    def +(interval)
      change_by(interval)
    end

    def -(interval)
      change_by(-interval)
    end

    def self.play(options = {duration: 200})
      Sound::Out.play_freq(options[:note].pitch.frequency, options[:note].duration)
    end

    def play(options = {duration: 200, octave: 0, volume: 1})
      options[:duration] ||= 200
      options[:octave] ||= 0
      options[:volume] ||= 1
      beep = Sound::Data.new.sine_wave(@frequency*2**(options[:octave]), options[:duration], options[:volume])
      Sound::Device.new {|d| d.write beep}
    end

    def prepare(options = {duration: 200, octave: 0, volume: 1})
      options[:duration] ||= 200
      options[:octave] ||= 0
      options[:volume] ||= 1
      beep = Sound::Data.new.sine_wave(@frequency*2**(options[:octave]), options[:duration], options[:volume])

      return Thread.new{Sound::Device.new {|d| d.write beep; Thread.stop; sleep Thread.current[:sleep_time]}}
    end

    def <=>(other_pitch)
      self.frequency <=> other_pitch.frequency
    end

    private

    def out_of_tune
      !@tuned
    end

    def change_by (interval)
      if Pitch.temperament.eql? :equal
        Pitch.new(frequency: @frequency*2**(interval/12.0))
      end
    end

  end

end