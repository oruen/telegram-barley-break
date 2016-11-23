require 'spec_helper'

describe Game do
  let(:position) {
    [
      1, 2, 3, 4,
      5, 6, 7, 8,
      9, 10,11,12,
      13,15,14,0
    ]
  }
  subject {Game.new(position.dup)}

  describe "#start" do
    it "should return greeting and random position" do
      response = subject.start
      expect(response[0]).to eq(Game::GREETING)
      expect(response[1]).to include(*(0..15).to_a)
    end
  end

  describe "#move" do

    it "should change fields order when move is acceptable" do
      expect(subject.move(12)[1]).to eq([
        1, 2, 3, 4,
        5, 6, 7, 8,
        9, 10,11,0,
        13,15,14,12
      ])
      expect(subject.move(11)[1]).to eq([
        1, 2, 3, 4,
        5, 6, 7, 8,
        9, 10,0, 11,
        13,15,14,12
      ])
    end

    it "should not change fields order when move is unacceptable" do
      expect(subject.move(11)[1]).to eq(position)
      expect(subject.move(15)[1]).to eq(position)
      expect(subject.move(8)[1]).to eq(position)
    end

    it "should cycle messages on wrong moves" do
      expect(subject.move(11)[0]).not_to eq(subject.move(11)[0])
    end

    context "endspiel" do
      let(:position) {[
        1, 2, 3, 4,
        5, 6, 7, 8,
        9, 10,11,12,
        13,14,0, 15
      ]}

      it "should finish game" do
        response = subject.move(15)
        expect(Game::VICTORY).to eq(response[0])
        expect(response[1]).to be_nil
      end

      it "should not progress further if the game has already ended" do
        subject.move(15)
        response = subject.move(15)
        expect(Game::VICTORY).to eq(response[0])
        expect(response[1]).to be_nil
      end
    end
  end
end
