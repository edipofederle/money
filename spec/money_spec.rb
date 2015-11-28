require 'spec_helper'

describe Money do

  before do
    Money.conversion_rates('EUR', {'USD' => 1.11, 'Bitcoin' => 0.0047})
  end

  let(:fifty_euros) { Money.new(50, 'EUR') }
  
  it 'has a version number' do
    expect(Money::VERSION).to eq "0.1.0"
  end

  it 'has initial configurations' do
    Money.conversion_rates('EUR', {'USD' => 1.11, 'Bitcoin' => 0.0047})

    expect(Money.base_rate).to eq 'EUR'
  end

  describe 'Money instance' do
    it 'is a instance of Money' do
      expect(fifty_euros).to be_an_instance_of Money
    end

    it 'has amount' do
      expect(fifty_euros.amount).to eq 50
    end

    it 'has currency' do
      expect(fifty_euros.currency).to eq 'EUR'
    end

    it 'inspect should be amount and currency' do
      expect(fifty_euros.inspect).to eq '50.00 EUR'
    end
  end

  describe '#convert_to' do
    context 'with same currency' do
      context 'dollar'
      it {
        ten_dollars = Money.new(10, 'USD')
        expect(ten_dollars.convert_to('USD').inspect).to eq '10.00 USD'
      }
      
      it {
        ten_euros = Money.new(10, 'EUR')
        expect(ten_euros.convert_to('EUR').inspect).to eq '10.00 EUR'
      }

      it 'from Bitcoin to Bitcoin' do
        ten_euros = Money.new(1, 'Bitcoin')
        expect(ten_euros.convert_to('Bitcoin').inspect).to eq '1.00 Bitcoin'
      end      
    end

    context 'with differenct currency' do
      it 'from EUR to USD' do
        fifty_dollars  = fifty_euros.convert_to('USD')
        
        expect(fifty_dollars).to be_an_instance_of Money
        expect(fifty_dollars.inspect).to eq '55.50 USD'
      end

      it 'from Bitcoin to EUR' do
        one_btx = Money.new(1, 'Bitcoin')
        expect(one_btx.convert_to('EUR').inspect).to eq '212.77 EUR'
      end

      
      it 'from USD to EUR' do
        ten_usd = Money.new(10, 'USD')
        
        expect(ten_usd.convert_to('EUR').inspect).to eq '9.01 EUR'
      end

      it 'from EUR to Bitcoin' do
        expect(fifty_euros.convert_to('Bitcoin').inspect).to eq '0.24 Bitcoin'
      end
    end
  end
  
  context 'Arithmetics' do
    describe 'addition' do
      context 'with same currency' do
        it {
          ten_euros = Money.new(10, 'EUR')
          total = ten_euros + fifty_euros
          
          expect(total.inspect).to eq '60.00 EUR'
        }

        it {
          ten_dollars  = Money.new(10, 'USD')
          five_dollars = Money.new(5,  'USD')
          
          total = ten_dollars + five_dollars
          
          expect(total.inspect).to eq '15.00 USD'
        }
      end

      context 'with different currency' do
        it {
          ten_euros   = Money.new(10, 'EUR')
          ten_dollars = Money.new(10, 'USD')
          
          total = ten_euros + ten_dollars
          
          expect(total.inspect).to eq '19.01 EUR'
        }

        it {
          fifty_euros = Money.new(50, 'EUR')
          twenty_dollars = Money.new(20, 'USD')
          expect((fifty_euros + twenty_dollars).inspect).to eq '68.02 EUR'
        }

        it {
          fifty_euros = Money.new(50, 'EUR')
          twenty_dollars = Money.new(20, 'USD')
          
          expect((twenty_dollars + fifty_euros).inspect).to eq "75.50 USD"
        }
      end

      context 'invalid' do
        it { expect { fifty_euros + 10 }.to raise_error(TypeError)  }
      end
    end

    describe 'subtraction' do
      context 'with same currency' do
        it {
          ten_euros = Money.new(10, 'EUR')
          total       = fifty_euros - ten_euros
          
          expect(total.inspect).to eq '40.00 EUR'
        }
      end

      context 'with different currency' do
        it {
          ten_euros = Money.new(10, 'EUR')
          fifty_dollars = Money.new(50, 'USD')
          
          total = fifty_dollars - ten_euros
          expect(total.inspect).to eq '38.90 USD'
        }

        it {
          ten_dollars = Money.new(10, 'USD')
          five_euros  = Money.new(5, 'EUR')

          total = ten_dollars - five_euros
          expect(total.inspect).to eq '4.45 USD'
        }
      end

      context 'invalid' do
        it {  expect { fifty_euros - 10 }.to raise_error(TypeError) }
      end
    end

   describe 'division' do
      it {
        total = fifty_euros / 2
        
        expect(total.inspect).to eq '25.00 EUR'
      }

      it { expect { fifty_euros / "2" }.to raise_error(ArgumentError) }
    end

    describe 'multiply' do
      it {
        total = fifty_euros * 3
        
        expect(total.inspect).to eq '150.00 EUR'
      }

      it { expect { fifty_euros * "2" }.to raise_error(ArgumentError) }
    end
  end

  context 'Comparisons' do
    describe 'equality' do
      it {
        twenty_dollars = Money.new(20, 'USD')
        
        expect(twenty_dollars == Money.new(20, 'USD')).to be true
      }

     it {
       fifty_euros_in_dollars = fifty_euros.convert_to('USD')
       
       expect(fifty_euros_in_dollars == fifty_euros).to be  true
     }

     it {
       twenty_dollars = Money.new(20, 'USD')
       
       expect(twenty_dollars == Money.new(20, 'USD')).to eq true
     }

     it {
       twenty_dollars = Money.new(20, 'USD')
       
       expect(Money.new(20, 'USD') == twenty_dollars).to eq true
     }

     it {
       fifty_euros_in_usd = fifty_euros.convert_to('USD')
       expect(fifty_euros_in_usd == fifty_euros).to be true
     }

     it {
       twenty_dollars = Money.new(20, 'USD')
       ten_euroso = Money.new(5, 'EUR')
       
       expect(ten_euroso == twenty_dollars).to eq false
     }
    end

    describe 'greater that' do
      it {
        twenty_dollars = Money.new(20, 'USD')
        
        expect(fifty_euros > twenty_dollars).to eq true
      }

      it {
        twenty_dollars = Money.new(20, 'USD')
        
        expect(twenty_dollars > fifty_euros).to eq false
      }

      it {
        twenty_dollars = Money.new(20, 'USD')
        two_euros = Money.new(2, 'EUR')
        
        expect(twenty_dollars > two_euros).to eq true
      }

      it {
        twenty_dollars = Money.new(20, 'USD')
        expect(twenty_dollars > Money.new(5, 'USD')).to eq true
      }
    end

    describe 'less that' do
      it {
        twenty_dollars = Money.new(20, 'USD')
        two_euros      = Money.new(2, 'EUR')
        
        expect(two_euros < twenty_dollars).to eq true
      }

      it {
        twenty_dollars = Money.new(5, 'USD')
        two_euros      = Money.new(20, 'EUR')
        
        expect(two_euros < twenty_dollars).to eq false
      }
    end
  end
end















