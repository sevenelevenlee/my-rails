# 使用difene_method动态定义方法
class Computer
  def initialize(com_id, data)
    @id = com_id
    @data = data
    # 内省的方式缩减代码
    data.methods.grep(/^get_(.*)_info$/) { Computer.define_component($1)}
  end

  def self.define_component(name)
    define_method(name) do
      info = @data.send("get_#{name}_info", @id)
      price = @data.send("get_#{name}_price", @id)
      result = "#{name.to_s.capitalize}: #{info} ($#{price})"
      return "* #{result}" if price >= 100
      result
    end 
  end

  define_component :mouse
  define_component :cpu
  define_component :keyboard
end

# binding对象，获取上下文的环境
def foo
  bar = 'baz'
  return binding
end

eval('p bar', foo)
