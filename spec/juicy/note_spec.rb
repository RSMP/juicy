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
    context "if the argument is positive" do
      it "should return a higher note" do
        expect((note+1)).to be > note
        expect((note+2)).to be > note
        expect((note+5)).to be > note
        expect((note+10)).to be > note
        expect((note+20)).to be > note
      end
    end
    context "if the argument is negative" do
      it "should return a lower note" do
        expect((note+(-1))).to be < note
        expect((note+(-2))).to be < note
        expect((note+(-5))).to be < note
        expect((note+(-10))).to be < note
        expect((note+(-20))).to be < note
      end
    end
  end
  
  describe "#-" do
    it "should take a integer as an argument" do
      expect {note - 1}.not_to raise_error
    end
    context "if the argument is positive" do
      it "should return a lower note" do
        expect((note-1)).to eq Note.new(name: "B", octave_change: 1)
        expect((note-2)).to eq Note.new(name: "Bb", octave_change: 1)
        expect((note-5)).to eq Note.new(name: "G")
        expect((note-10)).to eq Note.new(name: "D")
        expect((note-20)).to eq Note.new(name: "E", octave_change: -1)
      end
    end
    context "if the argument is negative" do
      it "should return a higher note" do
        expect((note-(-1))).to be > note
        expect((note-(-2))).to be > note
        expect((note-(-5))).to be > note
        expect((note-(-10))).to be > note
        expect((note-(-20))).to be > note
      end
    end
  end

  context "when two notes are compared" do
    context "when the first note is higher" do
      it "should return 1" do
        comparison = (Note.new(name: "G", octave_change: 1) <=> Note.new(name: "G"))
        expect(comparison).to eq(1)
      end
    end
    context "when the second note is higher" do
      it "should return -1" do
        comparison = (Note.new(name: "G") <=> Note.new(name: "G", octave_change: 1))
        expect(comparison).to eq(-1)
      end
    end
    context "when the notes are the same" do
      it "should return 0" do
        comparison = (Note.new(name: "G") <=> Note.new(name: "G"))
        expect(comparison).to eq(0)
      end
    end
  end
  
  describe "#==" do
    it "should return true if two notes are the same" do
      expect(Note.new).to eq Note.new
      expect(Note.new(name: "G")).to eq Note.new(name: "G")
      expect(Note.new(name: "G", octave_change: 1)).to eq Note.new(name: "G") + 12
    end
    it "should return false if two notes are different" do
      expect(Note.new).not_to eq Note.new + 1
      expect(Note.new(name: "G")).not_to eq Note.new(name: "A")
      expect(Note.new(name: "G", octave_change: 1)).not_to eq Note.new(name: "A") + 12
    end
  end
  
end
