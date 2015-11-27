require "money/version"

class Money

  def initialize(value, currency)
    @value    = value
    @currency = currency
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
