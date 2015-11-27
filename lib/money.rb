require "money/version"
require "money/arithmetic"

class Money
  include Money::Arithmetic
  
  attr_reader :amount, :currency

  class << self
    attr_accessor :base_rate, :currencies_rates
  end
  
  def initialize(amount, currency)
    @amount   = amount
    @currency = currency
  end
    
  def inspect
    "#{'%.2f' % @amount} #{@currency}"
  end
  
  def to_s
    inspect
  end
  
  def convert_to(currency)
    if  Money.currencies_rates[currency]
      new_amount = @amount * self.class.currencies_rates[currency]
    else
      new_amount = @amount / self.class.currencies_rates[self.currency]
    end
    
    Money.new(new_amount, currency)
  end
  
  # Configure the currency rates with respect to a base currency (here EUR):
  def self.conversion_rates(base_rate, currencies_rates)
      self.base_rate        = base_rate
      self.currencies_rates = currencies_rates
  end
end
