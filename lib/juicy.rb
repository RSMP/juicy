
#require 'pry'
require 'sound'

require 'juicy/pitch' #toned (or not) frequency in a chosen pitch space (temperament/intonation)
require 'juicy/note' #named pitch
require 'juicy/duration' #length of note in musical time (quarter note, eighth note, etc.)
require 'juicy/chord' #collection of notes
require 'juicy/chord_progression' #collection of chords in sequence
require 'juicy/melody' #collection of chords in sequence
require 'juicy/scale' #sequence of relative pitch changes ex. chromatic, diatonic, whole-note, pentatonic
require 'juicy/mode' #'flavor' of diatonic scale
require 'juicy/scale_degree' #index of given scale relative to root/tonic
require 'juicy/key' #scale at a given root note, i.e. Juicy::Note
require 'juicy/voice' #an instrument
require 'juicy/measure' #a measure of beats
require 'juicy/track' #a track of notes
require 'juicy/song' #
