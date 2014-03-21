
Gem::Specification.new do |spec|

  spec.name = 'juicy'
  spec.version = '0.0.8'
  spec.date = '2014-03-13'
  spec.summary = 'Song writing tool'
  spec.description = 'Generates songs'
  spec.authors = ["Dominic Muller"]
  spec.email = 'nicklink483@gmail.com'
  spec.files = [
    "lib/juicy.rb",
    "lib/juicy/chord.rb",
    "lib/juicy/chord_progression.rb",
    "lib/juicy/key.rb",
    "lib/juicy/mode.rb",
    "lib/juicy/note.rb",
    "lib/juicy/pitch.rb",
    "lib/juicy/scale.rb",
    "lib/juicy/scale_degree.rb",
    "lib/juicy/song.rb",
    "lib/juicy/voice.rb",
    "bin/juicy.rb"
  ]
  spec.homepage = 'https://github.com/nicklink483/juicy'
  spec.license = 'MIT'
  
end
