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

end
