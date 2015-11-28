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
    return self if currency == self.currency
    
    if has_currency_reference?(currency)
      new_amount = self.amount * self.class.currencies_rates[currency]
    else
      new_amount = self.amount / self.class.currencies_rates[self.currency]
   end
    
    self.class.new(new_amount, currency)
  end
  
  def self.conversion_rates(base_rate, currencies_rates)
    self.base_rate        = base_rate
    self.currencies_rates = currencies_rates
  end

  private
  def has_currency_reference?(currency)
    self.class.currencies_rates.include?(currency)
  end
end
