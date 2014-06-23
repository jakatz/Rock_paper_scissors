require_relative 'spec_helper.rb'

describe Game do
  let(:test){ RPS::Game.new(0, 1, 2, nil)}

  it "exists" do
    expect(RPS::Game).to be_a(Class)
  end

  describe '#initialize' do
    it "is initialized with an id, two players, and a default winner status of nil" do
      expect(test.id).to eq(0)
      expect(test.player1).to eq(1)
      expect(test.player2).to eq(2)
      expect(test.winner).to eq(nil)
    end
  end

  describe '#mark_winner' do
    it "sets the winner to a player's ID" do
      test.mark_winner(1)
      expect(test.winner).to eq(1)
    end
  end
end
