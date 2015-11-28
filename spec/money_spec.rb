require 'spec_helper'

describe Money do

  before do
    Money.conversion_rates('EUR', {'USD' => 1.11, 'Bitcoin' => 0.0047})
  end

  let(:fifty_eur) { Money.new(50, 'EUR') }
  
  it 'has a version number' do
    expect(Money::VERSION).to eq "0.1.0"
  end

  it 'has initial configurations' do
    Money.conversion_rates('EUR', {'USD' => 1.11, 'Bitcoin' => 0.0047})

    expect(Money.base_rate).to eq 'EUR'
  end

  describe 'Money instance' do
    it 'is a instance of Money' do
      expect(fifty_eur).to be_an_instance_of Money
    end

    it 'has amount' do
      expect(fifty_eur.amount).to eq 50
    end

    it 'has currency' do
      expect(fifty_eur.currency).to eq 'EUR'
    end

    it 'inspect should be amount and currency' do
      expect(fifty_eur.inspect).to eq '50.00 EUR'
    end
  end

  describe 'Convert to a different Currency' do
    it 'to USD' do
      fifty_usd  = fifty_eur.convert_to('USD')
      
      expect(fifty_usd).to be_an_instance_of Money
      expect(fifty_usd.inspect).to eq '55.50 USD'
    end

    it 'from bitcoin to euro 1' do
      one_btx = Money.new(1, 'Bitcoin')
      expect(one_btx.convert_to('EUR').inspect).to eq '212.77 EUR'
    end
    
    it 'from bitcoin to euro 2' do
      two_btx = Money.new(2, 'Bitcoin')
      expect(two_btx.convert_to('EUR').inspect).to eq '425.53 EUR'
    end

    it 'from USD to EUR' do
      ten_usd = Money.new(10, 'USD')
      
      expect(ten_usd.convert_to('EUR').inspect).to eq '9.01 EUR'
    end

    it 'from EUR to USD' do
      expect(fifty_eur.convert_to('USD').inspect).to eq '55.50 USD'
    end

    it 'from EUR to Bitcoin' do
       expect(fifty_eur.convert_to('Bitcoin').inspect).to eq '0.24 Bitcoin'
    end

    
    it 'same currency 1' do
      ten_usd = Money.new(10, 'USD')
      expect(ten_usd.convert_to('USD').inspect).to eq '10.00 USD'
    end

    it 'same currency 2' do
      ten_eur = Money.new(10, 'EUR')
      expect(ten_eur.convert_to('EUR').inspect).to eq '10.00 EUR'
    end
  end

  describe 'Arithmetics' do
    context 'addition' do
      it 'with same currency' do
        ten_eur = Money.new(10, 'EUR')
        total = ten_eur + fifty_eur

        expect(total.inspect).to eq '60.00 EUR'
      end

      it 'with different currency' do
        ten_eur = Money.new(10, 'EUR')
        ten_usd = Money.new(10, 'USD')
        
        total = ten_eur + ten_usd

        expect(total.inspect).to eq '19.01 EUR'
      end

      it 'raise exception when not money object' do
        expect { fifty_eur + 10 }.to raise_error(TypeError)
      end

      it 'with different currency 2' do
        fifty_eur = Money.new(50, 'EUR')
        twenty_dollars = Money.new(20, 'USD')
        expect((fifty_eur + twenty_dollars).inspect).to eq '68.02 EUR'
      end

      it 'with different currency 3' do
#        five_our = Money.new(5, 'EUR')
 #       one_bitcoin = Money.new(1, 'Bitcoin')
  #      expect((five_our + one_bitcoin).inspect).to eq '68.02 EUR'
      end

      it 'with different currency and dollars first' do
        fifty_eur = Money.new(50, 'EUR')
        twenty_dollars = Money.new(20, 'USD')


        expect((twenty_dollars + fifty_eur).inspect).to eq "75.50 USD"
      end


    end

    context 'subtraction' do
      it 'with same currency' do
        ten_eur = Money.new(10, 'EUR')
        total = fifty_eur - ten_eur

        expect(total.inspect).to eq '40.00 EUR'
      end

      it 'with different currency' do
        ten_eur = Money.new(10, 'EUR')
        fifty_usd = Money.new(50, 'USD')

        total = fifty_usd - ten_eur
        expect(total.inspect).to eq '38.90 USD'
      end

      it 'raise exception when not money object' do
        expect { fifty_eur - 10 }.to raise_error(TypeError)
      end
    end

    context 'division' do
      it 'with same currency and number' do
        total = fifty_eur / 2
        
        expect(total.inspect).to eq '25.00 EUR'
      end

      it 'raise a error if not a number' do
        expect { fifty_eur / "2" }.to raise_error(ArgumentError)
      end
    end

    context 'multiply' do
      it 'with same currency and number' do
        total = fifty_eur * 3
        
        expect(total.inspect).to eq '150.00 EUR'
      end

      it 'raise a error if not a number' do
        expect { fifty_eur * "2" }.to raise_error(ArgumentError)
      end
    end
  end

  describe 'Comparisons' do
    context 'equality' do
      it 'with same currency and amount' do
        twenty_dollars = Money.new(20, 'USD')
        
        expect(twenty_dollars == Money.new(20, 'USD')).to eq true
      end

     it 'with different currency should be equals' do
       fifty_eur_in_usd = fifty_eur.convert_to('USD')
       
       expect(fifty_eur_in_usd == fifty_eur).to eq true
     end

     it 'with same currency and different amount' do
       twenty_dollars = Money.new(20, 'USD')
       
       expect(twenty_dollars == Money.new(20, 'USD')).to eq true
     end

     it 'equals 2' do
       twenty_dollars = Money.new(20, 'USD')
       
       expect(Money.new(20, 'USD') == twenty_dollars).to eq true
     end
    end

    context 'greater that' do
      it 'euro should be greater that dollars' do
        twenty_dollars = Money.new(20, 'USD')
        
        expect(fifty_eur > twenty_dollars).to eq true
      end

      it 'dollars should not be greater that euro' do
        twenty_dollars = Money.new(20, 'USD')
        
        expect(twenty_dollars > fifty_eur).to eq false
      end

      it 'dollar should be greater that euro' do
        twenty_dollars = Money.new(20, 'USD')
        two_euros = Money.new(2, 'EUR')
        
        expect(twenty_dollars > two_euros).to eq true
      end

      it 'dollar should be greater taht euro 2' do
        twenty_dollars = Money.new(20, 'USD')
        expect(twenty_dollars > Money.new(5, 'USD')).to eq true
      end
    end

    context 'less that' do
      it 'euro should be less that dollars' do
        twenty_dollars = Money.new(20, 'USD')
        two_euros      = Money.new(2, 'EUR')
        
        expect(two_euros < twenty_dollars).to eq true
      end

      it 'euro should be less that dollars' do
        twenty_dollars = Money.new(5, 'USD')
        two_euros      = Money.new(20, 'EUR')
        
        expect(two_euros < twenty_dollars).to eq false
      end
    end
  end
end















