require 'spec_helper'
include Juicy

describe Pitch do
  let(:default_pitch) {Pitch.new}
  
  describe "to_s" do
    it "should display the frequency" do
      expect(default_pitch.to_s).to match(/\d+\.\d+/)
    end
  end
  
  context "a new default pitch" do
    it "should have a frequency of the concert pitch" do
      concert_pitch = 440
      expect(default_pitch.frequency).to eq(concert_pitch)
    end
    it "should have 100% confidence in its frequency" do
      expect(default_pitch.confidence).to eq(100)
    end
  end

  describe "#+" do
    context "when you add 1 to a pitch" do
      it "should have a larger frequency" do
        expect((default_pitch + 1).frequency).to be > default_pitch.frequency
      end
    end
    context "when you add -1 to a pitch" do
      it "should return a pitch with a lower frequency" do
        expect((default_pitch + (-1)).frequency).to be < default_pitch.frequency
      end
    end
  end

  describe "#-" do
    context "when you subtract 1 from a pitch" do
      it "should return a pitch with a lower frequency" do
        expect((default_pitch - 1).frequency).to be < default_pitch.frequency
      end
    end
    context "when you subtract -1 from a pitch" do
      it "should return a pitch with a higher frequency" do
        expect((default_pitch - (-1)).frequency).to be > default_pitch.frequency
      end
    end
  end

  context "when two pitches are compared" do
    context "when the frequency of the first pitch is higher" do
      it "should return 1" do
        comparison = (Pitch.new(400) <=> Pitch.new(200))
        expect(comparison).to eq(1)
      end
    end
    context "when the frequency of the second pitch is higher" do
      it "should return -1" do
        comparison = (Pitch.new(200) <=> Pitch.new(400))
        expect(comparison).to eq(-1)
      end
    end
    context "when the frequencies are the same" do
      it "should return 0" do
        comparison = (Pitch.new(400) <=> Pitch.new(400))
        expect(comparison).to eq(0)
      end
    end
  end

end
