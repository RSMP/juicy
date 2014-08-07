require 'spec_helper'
include Juicy
require 'pry'
describe Note do
  let(:note) {Note.new(name: "C", octave_change: 1)}
  it "should have a name of :C" do
    expect(note.name).to eq :C
  end
  it "should have a pitch of ~523.25" do
    expect(note.pitch.frequency.round 2).to eq 523.25
  end
  
  it "should parse the name" do
    expect(Note.new(name: "G sharp").name).to eq :G_sharp
    expect(Note.new(name: "G s").name).to eq :G_sharp
    expect(Note.new(name: "G_sharp").name).to eq :G_sharp
    expect(Note.new(name: "G_s").name).to eq :G_sharp
    expect(Note.new(name: "Gs").name).to eq :G_sharp
    expect(Note.new(name: "G #").name).to eq :G_sharp
    expect(Note.new(name: "G#").name).to eq :G_sharp
    expect(Note.new(name: "G_#").name).to eq :G_sharp
    
    expect(Note.new(name: "G flat").name).to eq :G_flat
    expect(Note.new(name: "G f").name).to eq :G_flat
    expect(Note.new(name: "G_flat").name).to eq :G_flat
    expect(Note.new(name: "G_f").name).to eq :G_flat
    expect(Note.new(name: "Gf").name).to eq :G_flat
    expect(Note.new(name: "G b").name).to eq :G_flat
    expect(Note.new(name: "Gb").name).to eq :G_flat
    expect(Note.new(name: "G_b").name).to eq :G_flat
  end
  
  describe "#+" do
    it "should take a integer as an argument" do
      expect {note + 1}.not_to raise_error
    end
    it "should return a note with a higher pitch" do
      expect((note+1).pitch).to be > note.pitch
    end
  end
end
