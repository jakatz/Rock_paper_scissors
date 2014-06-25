require_relative 'spec_helper.rb'

describe 'Create_player' do
  let(:player) {RPS::Player.new(1, 'Gideon', '1234', 5, 9)} #id, name, wins, games_played
  describe '#run' do
    it 'returns an error if the user exists' do
      result = RPS::Create_player.run(username:'Gideon', password: '1255')
      expect(result.success?).to be_false
    end
    it 'returns a player if no error exists' do
      result = RPS::Create_player.run(username:'jon', password: '1255')
      expect( result.success? ).to be_true
      expect( result.player.name ).to eq( 'jon' )
    end
  end
end
