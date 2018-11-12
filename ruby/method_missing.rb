class Computer
  def initialize(id, data_source)
    @id = id
    @data_source = data_source
  end

  def method_missing(name, *args)
    super unless @data_source.respond_to?("get_#{name}_info")
    info = @data_source.send "get_#{name}_info", @id
    price = @data_source.send "get_#{name}_price", @id
    result = "#{name.to_s.capitalize}: #{info} ($#{price})"
    return "* #{result}" if price > 100
    result
  end

  def respond_to?(name)
    @data_source.respond_to?("get_#{name}_info") || super
  end
end

# yield
def my_method
    x = "Goodbye"
    yield "cruel"
end

x = "Hello"
my_method {|y| "#{x}, #{y} world" }  # => "Hello, cruel world"
