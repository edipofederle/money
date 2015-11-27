require 'spec_helper'

describe Money do
  
  it 'has a version number' do
    expect(Money::VERSION).to eq "0.1.0"
  end

  it 'has initial configurations' do
    Money.conversion_rates('EUR', {'USD' => 1.11, 'Bitcoind' => 0.0047})

    expect(Money.base_rate).to eq 'EUR'
  end

  describe 'Money instance' do
    let(:fifity_eur) { Money.new(50, 'EUR') }
    
    it 'is a instance of Money' do
      expect(fifity_eur).to be_an_instance_of Money
    end

    it 'has amount' do
      expect(fifity_eur.amount).to eq 50
    end

    it 'has currency' do
      expect(fifity_eur.currency).to eq 'EUR'
    end
  end

end
