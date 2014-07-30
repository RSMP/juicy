require_relative '../lib/juicy.rb'
include Juicy

describe Pitch do

  context "a new default pitch" do
    it "should have a frequency of the concert pitch" do
      concert_pitch = 440
      pitch = Pitch.new
      expect(pitch.frequency).to eq(concert_pitch)
    end
    it "should have 100% confidence in its frequency" do
      pitch = Pitch.new
      expect(pitch.confidence).to eq(100)
    end
  end
  
  describe "#+" do
    context "when you add 1 to a pitch" do
      it "should return a pitch with a higher frequency" do
        pitch = Pitch.new
        expect((pitch + 1).frequency).to be > pitch.frequency
      end
    end
    context "when you add -1 to a pitch" do
      it "should return a pitch with a lower frequency" do
        pitch = Pitch.new
        expect((pitch + (-1)).frequency).to be < pitch.frequency
      end
    end
  end
  
  describe "#-" do
    context "when you subtract 1 from a pitch" do
      it "should return a pitch with a lower frequency" do
        pitch = Pitch.new
        expect((pitch - 1).frequency).to be < pitch.frequency
      end
    end
    context "when you subtract -1 from a pitch" do
      it "should return a pitch with a higher frequency" do
        pitch = Pitch.new
        expect((pitch - (-1)).frequency).to be > pitch.frequency
      end
    end
  end

end
