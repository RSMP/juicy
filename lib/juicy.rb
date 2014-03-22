# require 'win32-sound'
# require_relative 'juicy/win32/sound.rb'
require_relative '../../win32-sound/lib/win32/sound.rb'

require_relative 'juicy/pitch.rb' #toned (or not) frequency in a chosen pitch space (temperament/intonation)
  require_relative 'juicy/note.rb' #named pitch
  require_relative 'juicy/duration.rb' #length of note in musical time (quarter note, eighth note, etc.)
    require_relative 'juicy/chord.rb' #collection of notes
      require_relative 'juicy/chord_progression.rb' #collection of chords in sequence
    require_relative 'juicy/scale.rb' #sequence of relative pitch changes ex. chromatic, diatonic, whole-note, pentatonic
  require_relative 'juicy/mode.rb' #'flavor' of diatonic scale
  require_relative 'juicy/scale_degree.rb' #index of given scale relative to root/tonic
  require_relative 'juicy/key.rb' #scale at a given root note, i.e. Juicy::Note
