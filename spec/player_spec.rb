require_relative 'spec_helper.rb'

describe 'Player Class' do
  let(:player) {RPS::Player.new(1, 'Gideon', 'gewulf', '1234', 5, 9)} #id, name, wins, games_played
  describe '#initialize' do
    it 'initializes values in player class' do
      expect(player.id).to eq(1)
      expect(player.name).to eq('Gideon')
      expect(player.win_count).to eq(5)
      expect(player.games_played).to eq(9)
    end
    it 'creates instance of player class' do
      expect(player).to be_a(RPS::Player)
    end
  end
end
