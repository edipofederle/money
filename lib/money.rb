require "money/version"

class Money

  class << self
    attr_accessor :base_rate, :currencies_rates
  end
  
  def self.conversion_rates(base_rate, currencies_rates)
    self.base_rate        = base_rate
    self.currencies_rates = currencies_rates
  end
end
