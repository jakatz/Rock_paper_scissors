require_relative 'spec_helper.rb'

describe 'Round'  do
  let( :test ){ RPS::Round.new( 0, 1, 'r', 'p', 2 ) }
  it 'has an id' do
    expect( test.id ).to eq( 0 )
    expect( test.game_id ).to eq( 1 )
  end

  it 'has at least 1 player' do
    expect( test.player1_move ).to eq( 'r' )
  end

  it 'does not have a winner' do
    expect( test.winner ).to eq( 2 )
  end


  describe '#check_win' do
    context 'no body has won 3 rounds' do
      it 'returns nil' do

      end
    end


    context 'someone has won 3 rounds' do
      it 'returns the players id' do
      end
    end

  end

  describe '#mark_win' do
    context 'when a player has won' do
      it 'returns the winner' do
      end
    end
  end

end


