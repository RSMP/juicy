require 'spec_helper'

describe Juicy::Mode do
  context "::new" do
    it "should have a type of ionian" do
      expect(Juicy::Mode.new.type).to eq :ionian
    end
  end
  describe "#==" do
    context "the modes are the same" do
      it "should return true" do
        mode1 = Mode.new(type: :major)
        mode2 = Mode.new(type: :major)
        expect(mode1 == mode2).to eq true
      end
    end
    context "the modes are different" do
      it "should return false" do
        mode1 = Mode.new(type: :major)
        mode2 = Mode.new(type: :minor)
        expect(mode1 == mode2).to eq false
      end
    end
  end
  describe "#to_s" do
    it "returns its type" do
      mode = Mode.new(type: :minor)
      expect(mode.to_s).to eq "minor"
    end
    it "returns a String" do
      mode = Mode.new(type: :major)
      expect(mode.to_s.class).to eq String
    end
  end
end