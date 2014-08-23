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
end