require_relative '../lib/juicy.rb'
include Juicy

describe Pitch do

  context "a new default pitch" do
    it "should have a frequency of 440" do
      pitch = Pitch.new
      expect(pitch.frequency).to eq(440)
    end
    it "should have 100% confidence in its frequency" do
      pitch = Pitch.new
      expect(pitch.confidence).to eq(100)
    end
  end

end
