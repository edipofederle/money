require 'spec_helper'

describe Money do
  
  it 'has a version number' do
    expect(Money::VERSION).to eq "0.1.0"
  end

  it 'has initial configurations' do
    Money.conversion_rates('EUR', {'USD' => 1.11, 'Bitcoind' => 0.0047})

    expect(Money.base_rate).to eq 'EUR'
  end

  it 'is a instance of Money' do
    fifity_eur = Money.new(50, 'EUR')
    
    expect(fifity_eur).to be_an_instance_of Money
  end

end
