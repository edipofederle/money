require "money/version"

class Money

  attr_reader :amount, :currency
  
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

  class << self
    attr_accessor :base_rate, :currencies_rates
  end

  # Configure the currency rates with respect to a base currency (here EUR):
  def self.conversion_rates(base_rate, currencies_rates)
    self.base_rate        = base_rate
    self.currencies_rates = currencies_rates
  end
end
