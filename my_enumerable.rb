# frozen_string_literal: true

module Enumerable
  def my_each
    return to_enum unless block_given?
    for i in 0...self.length do
        yield self[i] 
    end
    self
  end
  

  def my_each_with_index
    return to_enum unless block_given?

    (0...length).each { |i| yield self[i], i }
    self
  end

  def my_select
    return to_enum unless block_given?
    r = []
    self.my_each { |x| r << x if yield x }
    r
  end

  def my_all?(pattern = nil)
    r = true
    if block_given?
      my_each { |x| r = false unless yield x }
    elsif pattern
      my_each { |x| r = false unless pattern === x }
    else
      my_each { |x| r = false unless x }
    end
    r
  end

  def my_any?(pattern=nil)
    r=false
    if block_given?
        my_each {|x| r=true if yield x}
    elsif pattern
        my_each { |x| r = true if pattern === x }
    else
    my_each { |x| r = true if  x}
    end
    r
  end

  def my_none?(pattern=nil)
    r = true
    if block_given?
        my_each { |x| r = false if yield x}
    elsif pattern
        my_each { |x| r = false if x === pattern}
    else
        my_each { |x| r = false if  x }
    end    
    r
  end

  def my_count(number = nil)
    count = 0
    if !block_given? && number.nil?
      count = length
    elsif !block_given? && !number.nil?
      my_each do |x|
        count += 1 if x == number
      end
    else

      my_each do |x|
        count += 1 if yield(x)
      end
    end
    count
  end

  def my_map
    return to_enum unless block_given?
    r = []
    my_each do |x|
      r << yield(x)
    end
    r
  end

  def my_inject(*params)
    # if (initial, sym)
    if init && symb && symb.is_a?(Symbol)
      my_each do |x|
        init = init.method(symb).call(x)
      end
    # if (symb)
    elsif init && init.is_a?(Symbol) && symb.nil?
      memo, *elements = self
      elements.my_each do |x|
        memo = memo.method(init).call(x)
      end
      memo
    end
    init
  end
end

#p %w{ant bear cat}.my_none?(/d/)                        #=> true