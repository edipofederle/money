class Money
  module Arithmetic
    
  def +(money)
    operation("+", money)
  end

  def -(money)
    operation("-", money)
  end

  def /(value)
    if value.is_a? Numeric
      self.class.new(self.amount / value, self.currency)
    else
      raise ArgumentError, "Can't divide #{self.class.name} by #{value.class.name}"
    end
  end

  def *(value)
    if value.is_a? Numeric
      self.class.new(self.amount * value, self.currency)
    else
      raise ArgumentError, "Can't multiply #{self.class.name} by #{value.class.name}"
    end
  end

  def ==(money)
    comparation("==", money)
  end

  def >(money)
    comparation(">", money)
  end

  def <(money)
    comparation("<", money)
  end

  def comparation(fn, money)
    if money.currency.eql?(self.currency)
       money.amount.send(fn.to_sym, self.amount)
    else
      self.amount.send(fn.to_sym, money.convert_to(self.currency).amount)
    end
  end

  def operation(fn, money)
    return TypeError unless money.is_a?(Money)

    return self if money.eql?(0)
    
    if money.currency.eql?(self.currency)
      new_amount = @amount.send(fn.to_sym, money.amount)
      new_money  = Money.new(new_amount, currency)
    else
      new_amount = money.convert_to(self.currency).amount.send(fn.to_sym, money.amount)
      new_money  = Money.new(new_amount, currency)
    end
    
    new_money
  end
  end
end
