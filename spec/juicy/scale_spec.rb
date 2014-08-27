require 'spec_helper'
include Juicy

describe Scale do
  let(:note) {double}
  before do
    allow(note).to receive(:+).with(anything()) {note}
    allow(note).to receive(:play)
  end
  let(:scale) {Scale.new(mode: :major, root: note)}
  it "should have a root of the note passed" do
    expect(scale.root).to eq note
  end
  it "should have a mode of :major" do
    expect(scale.mode).to eq :major
  end
  it "should have solfege" do
    expect(scale.do).to eq note
    expect(scale.re).to eq note
    expect(scale.mi).to eq note
    expect(scale.fa).to eq note
    expect(scale.so).to eq note
    expect(scale.la).to eq note
    expect(scale.ti).to eq note
  end
  it "should play" do
    expect {scale.play}.not_to raise_error
  end
end