require 'spec_helper'

describe Juicy::Mode do
  context "::new" do
    it "should have a type of ionian" do
      expect(Juicy::Mode.new.type).to eq :ionian
    end
  end
end