# require 'win32-sound'
# require_relative 'juicy/win32/sound.rb'
require_relative 'win32/sound'
require_relative 'win32/wave_out_play_freq'

require_relative 'juicy/pitch' #toned (or not) frequency in a chosen pitch space (temperament/intonation)
  require_relative 'juicy/note' #named pitch
  require_relative 'juicy/duration' #length of note in musical time (quarter note, eighth note, etc.)
    require_relative 'juicy/chord' #collection of notes
      require_relative 'juicy/chord_progression' #collection of chords in sequence
      require_relative 'juicy/melody' #collection of chords in sequence
      
    require_relative 'juicy/scale' #sequence of relative pitch changes ex. chromatic, diatonic, whole-note, pentatonic
  require_relative 'juicy/mode' #'flavor' of diatonic scale
  require_relative 'juicy/scale_degree' #index of given scale relative to root/tonic
  require_relative 'juicy/key' #scale at a given root note, i.e. Juicy::Note
  require_relative 'juicy/voice' #an instrument
  require_relative 'juicy/measure' #a measure of beats
  require_relative 'juicy/track' #a track of notes
  require_relative 'juicy/song' #
