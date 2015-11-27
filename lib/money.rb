require "money/version"

class Money

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
    new_amount = @amount * Money.currencies_rates[currency]
    
    Money.new(new_amount, currency)
  end

  def +(money)
    if money.currency == self.currency
      new_amount = @amount + money.amount
      return Money.new(new_amount, currency)
    else
      new_amount = money.convert_to(self.currency).amount + money.amount
      return Money.new(new_amount, currency)
    end
  end
  
  
  
  # Configure the currency rates with respect to a base currency (here EUR):
  def self.conversion_rates(base_rate, currencies_rates)
      self.base_rate        = base_rate
      self.currencies_rates = currencies_rates
  end
end
