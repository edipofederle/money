class Money
  module Arithmetic
    
    def +(other_money)
      operation("+", other_money)
    end

    def -(other_money)
      operation("-", other_money)
    end

    def /(value)
      if value.is_a?(Numeric)
        self.class.new(self.amount / value, self.currency)
      else
        raise ArgumentError, "Can't divide #{self.class.name} by a #{value.class.name}"
      end
    end

    def *(value)
      if value.is_a?(Numeric)
        self.class.new(self.amount * value, self.currency)
      else
        raise ArgumentError, "Can't multiply #{self.class.name} by #{value.class.name}"
      end
    end

    def ==(other_money)
      comparation("==", other_money)
    end

    def >(other_money)
      comparation(">", other_money)
    end

    def <(other_money)
      comparation("<", other_money)
    end

    def comparation(fn, other_money)
      if other_money.currency.eql?(self.currency)
        self.amount.send(fn.to_sym, other_money.amount)
      else
        self.amount.send(fn.to_sym, other_money.convert_to(self.currency).amount)
      end
    end

    def operation(fn, other_money)
      raise_unexpected_type(fn, other_money) unless other_money.is_a?(Money)
      return self if other_money.eql?(0)
      
      if other_money.currency.eql?(self.currency)
        new_amount = self.amount.send(fn.to_sym, other_money.amount)
        new_money  = self.class.new(new_amount, currency)
      else
        new_currency = self.currency
        new_amount   = self.amount.send(fn.to_sym,
                                        other_money.convert_to(new_currency).amount)
        new_money    = self.class.new(new_amount, new_currency)
      end
    end

    private
    def raise_unexpected_type(fn, other_money)
      msg = "Can't perform #{fn} operation. Expected a #{self.class.name} but receive #{other_money.class.name}"
      raise TypeError, msg  unless other_money.is_a?(Money)
    end
  end
end
