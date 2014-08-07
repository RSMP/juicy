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
end
