require 'spec_helper'

describe Money do

  before do
    Money.conversion_rates('EUR', {'USD' => 1.11, 'Bitcoin' => 0.0047})
  end

  let(:fifity_eur) { Money.new(50, 'EUR') }
  
  it 'has a version number' do
    expect(Money::VERSION).to eq "0.1.0"
  end

  it 'has initial configurations' do
    Money.conversion_rates('EUR', {'USD' => 1.11, 'Bitcoind' => 0.0047})

    expect(Money.base_rate).to eq 'EUR'
  end

  describe 'Money instance' do
    
    
    it 'is a instance of Money' do
      expect(fifity_eur).to be_an_instance_of Money
    end

    it 'has amount' do
      expect(fifity_eur.amount).to eq 50
    end

    it 'has currency' do
      expect(fifity_eur.currency).to eq 'EUR'
    end

    it 'inspect should be amount and currency' do
      expect(fifity_eur.inspect).to eq '50.00 EUR'
    end
  end

  describe 'Convert to a different Currency' do
    it 'to USD' do
      fifity_usd = fifity_eur.convert_to('USD')
      
      expect(fifity_usd).to be_an_instance_of Money
      expect(fifity_usd.inspect).to eq "55.50 USD"
    end

    it 'to Bitcoin' do
      fifity_bitcoin = fifity_eur.convert_to('Bitcoin')
      
      expect(fifity_bitcoin).to be_an_instance_of Money
      expect(fifity_bitcoin.inspect).to eq "0.24 Bitcoin"
    end
  end
end
