# frozen_string_literal: true

module Enumerable
  def my_each
    return to_enum unless block_given?

    (0...length).each do |i|
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
    my_each { |x| r << x if yield x }
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

  def my_any?(pattern = nil)
    r = false
    if block_given?
      my_each { |x| r = true if yield x }
    elsif pattern
      my_each { |x| r = true if pattern === x }
    else
      my_each { |x| r = true if x }
    end
    r
  end

  def my_none?(pat = nil)
    if block_given?
      my_each { |x| return false if yield(x) }
    elsif !pat.nil?
      if pat.is_a?(Class)
        my_each { |x| return false if x.is_a?(pat) }
      elsif pat.is_a?(Regexp)
        my_each { |x| return false if pat.match(x.to_s) }
      else
        my_each { |x| return false if x == pat }
      end
    else
      my_each do |x|
        return false if x
      end
    end
    true
  end

  def my_count(number = nil)
    count = 0
    if block_given?
      my_each { |x| count += 1 if yield(x) }

    elsif number
      my_each { |x| count += 1 if x == number }
    else
      count = length
    end
    count
  end

  def my_map
    return to_enum unless block_given?

    r = []
    my_each { |x| r << yield(x) } if proc.nil?
    my_each { |x| r << proc.call(x) } unless proc.nil?
    r
  end

  def my_inject(*args)
    result, sym = inj_param(*args)
    arr = result ? to_a : to_a[1..-1]
    result ||= to_a[0]
    if block_given?
      arr.my_each { |x| result = yield(result, x) }
    elsif sym
      arr.my_each { |x| result = result.public_send(sym, x) }
    end
    result
  end

  def inj_param(*args)
    result, sym = nil
    args.my_each do |arg|
      result = arg if arg.is_a? Numeric
      sym = arg unless arg.is_a? Numeric
    end
    [result, sym]
  end
end
