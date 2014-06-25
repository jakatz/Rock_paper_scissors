require_relative 'spec_helper.rb'

describe 'Sign_in' do
  let( :player ) { RPS::Player.new( 1, 'Gideon', '1234', 5, 9 ) }
  describe '#run' do

    it 'returns an error message if password is wrong' do
      result = RPS.Sign_in.run( password: '1222', name: 'Gideon' )
      expect( result.success? ).to be_false
    end

    it 'returns an error message if username does not exist' do
      result = RPS.Sign_in.run( password: '1234', name: 'jon' )
      expect( result.success? ).to be_false
    end

    it 'returns an player if there is no error' do
      result = RPS.Sign_in.run( password: '1234', name: 'Gideon' )
      expect( result.success? ).to be_true
      expect( result.player.id ).to eq( 1 )
    end
  end
end
