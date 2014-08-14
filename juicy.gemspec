
Gem::Specification.new do |spec|

  spec.name = 'juicy'
  spec.version = '0.1.4'
  spec.date = '2014-08-10'
  spec.summary = 'Song writing tool'
  spec.description = 'Generates songs'
  spec.authors = ["Dominic Muller"]
  spec.email = 'nicklink483@gmail.com'
  spec.files = [
    "lib/juicy.rb",
    "lib/juicy/chord.rb",
    "lib/juicy/chord_progression.rb",
    "lib/juicy/duration.rb",
    "lib/juicy/key.rb",
    "lib/juicy/measure.rb",
    "lib/juicy/melody.rb",
    "lib/juicy/mode.rb",
    "lib/juicy/note.rb",
    "lib/juicy/pitch.rb",
    "lib/juicy/scale.rb",
    "lib/juicy/scale_degree.rb",
    "lib/juicy/song.rb",
    "lib/juicy/track.rb",
    "lib/juicy/voice.rb",
    "examples/juicy.rb"
  ]
  spec.add_runtime_dependency 'sound', '~> 0.0', '>= 0.0.9'
  spec.add_development_dependency 'rspec', '~> 0'
  spec.homepage = 'https://github.com/RSMP/juicy'
  spec.license = 'MIT'
  
end
