# 使用异常来处理状态码
class Account
  def withdraw(amount)
    return -1 if amount > @balance
    @balance -= amount
    return 0
  end
end

class BalanceError < StandardError
end

def withdraw
  raise BalanceError.new if amount > @balance
  @balance -= amount
end

account = Account.new
begin
  accout.withdraw
  pass
rescue BalanceError
  pass
end