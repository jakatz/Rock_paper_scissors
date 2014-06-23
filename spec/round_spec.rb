require_relative 'spec_helper.rb'

describe 'Round'  do
  let( :test ){ RPS::Round.new( 0, 1, 2, nil ) }
  it 'has an id' do
    expect( test.id ).to eq( 0 )
  end

  it 'has at least 1 player' do
    expect( test.player_1).to eq( 1 )
  end

  it 'does not have a winner' do
    expect( test.winner).to eq( nil )
  end

end
