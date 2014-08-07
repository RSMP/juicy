require 'spec_helper'
include Juicy

describe Scale do
  let(:scale) {Scale.new(:major, Note.new(name: "G"))} 
  it "should have a root of G" do
    expect(scale.root).to eq Note.new(name: "G")
  end
  it "should have a quality of major"
  it "should have solfege" do
    expect(scale.do).to eq Note.new(name: "G")
    expect(scale.re).to eq Note.new(name: "A", octave_change: 1)
    expect(scale.mi).to eq Note.new(name: "B", octave_change: 1)
    expect(scale.fa).to eq Note.new(name: "C", octave_change: 1)
    expect(scale.so).to eq Note.new(name: "D", octave_change: 1)
    expect(scale.la).to eq Note.new(name: "E", octave_change: 1)
    expect(scale.ti).to eq Note.new(name: "F#", octave_change: 1)
  end
end