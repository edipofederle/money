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
      expect(fifity_usd.inspect).to eq '55.50 USD'
    end

    it 'to Bitcoin' do
      fifity_bitcoin = fifity_eur.convert_to('Bitcoin')
      
      expect(fifity_bitcoin).to be_an_instance_of Money
      expect(fifity_bitcoin.inspect).to eq '0.24 Bitcoin'
    end

    it 'from USD to EUR' do
      fifty_eur_in_usd = fifity_eur.convert_to('USD')
      expect(fifty_eur_in_usd.convert_to('EUR').inspect).to eq '50.00 EUR'
    end

    it 'from EUR to USD' do
      expect(fifity_eur.convert_to('USD').inspect).to eq '55.50 USD'
    end

    it 'from EUR to Bitcoin' do
       expect(fifity_eur.convert_to('Bitcoin').inspect).to eq '0.24 Bitcoin'
    end
  end

  describe 'Arithmetics' do
    context 'addition' do
      it 'with same currency' do
        ten_eur = Money.new(10, 'EUR')
        total = ten_eur + fifity_eur

        expect(total.inspect).to eq '60.00 EUR'
      end

      it 'with different currency' do
        fifity_usd = fifity_eur.convert_to('USD')
        total = fifity_usd + fifity_eur

        expect(total.inspect).to eq '105.50 USD'
      end

      it 'with same currency and number' do
        total = fifity_eur + 10
        expect(total.inspect).to eq '60.00 EUR'
      end
    end

    context 'subtraction' do
      it 'with same currency' do
        ten_eur = Money.new(10, 'EUR')
        total = fifity_eur - ten_eur

        expect(total.inspect).to eq '40.00 EUR'
      end

      it 'with different currency' do
        fifity_usd = fifity_eur.convert_to('USD')
        total = fifity_usd - fifity_eur

        expect(total.inspect).to eq '5.50 USD'
      end

      it 'with same currency and number' do
        total = fifity_eur - 5.5
        expect(total.inspect).to eq '44.50 EUR'
      end
    end

    context 'division' do
      it 'with same currency' do
        ten_eur = Money.new(10, 'EUR')
        total = fifity_eur / ten_eur

        expect(total.inspect).to eq '5.00 EUR'
      end

      it 'with different currency' do
        fifity_usd = fifity_eur.convert_to('USD')
        total = fifity_usd / fifity_eur

        expect(total.inspect).to eq '1.11 USD'
      end

      it 'with same currency and number' do
        total = fifity_eur / 2
        expect(total.inspect).to eq '25.00 EUR'
      end
    end

    context 'multiply' do
      it 'with same currency' do
        ten_eur = Money.new(10, 'EUR')
        total = fifity_eur * ten_eur
        
        expect(total.inspect).to eq '500.00 EUR'
      end

      it 'with different currency' do
        fifity_usd = fifity_eur.convert_to('USD')
        total = fifity_usd * fifity_eur

        expect(total.inspect).to eq '2775.00 USD'
      end

      it 'with same currency and number' do
        total = fifity_eur * 3
        expect(total.inspect).to eq '150.00 EUR'
      end
    end
  end

  describe 'Comparisons' do
    context 'equality' do
       it 'with same currency and amount should be equals' do
        twenty_dollars = Money.new(20, 'USD')
        expect(twenty_dollars == Money.new(20, 'USD')).to eq true
      end

     it 'with different currency should be equals' do
       fifty_eur_in_usd = fifity_eur.convert_to('USD')
       expect(fifty_eur_in_usd == fifity_eur).to eq true
     end

     it 'equals' do
       twenty_dollars = Money.new(20, 'USD')
       expect(twenty_dollars == Money.new(20, 'USD')).to eq true
     end

     it 'equals 2' do
       twenty_dollars = Money.new(20, 'USD')
       expect(Money.new(20, 'USD') == twenty_dollars).to eq true
     end
    end
    
  end
end















