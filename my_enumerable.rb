# frozen_string_literal: true

module Enumerable
  def my_each
    if block_given?
      (0...length).each do |i|
        yield(self[i])
      end
    end
    self
  end

  def my_each_with_index
    if block_given?
      (0...length).each do |i|
        yield(self[i], i)
      end
    end
    self
  end

  def my_select
    if block_given?
      r = []
      my_each do |x|
        r << x if yield(x)
      end
      r
    end
  end

  def my_all?
    if block_given?
      my_each do |x|
        return false unless yield(x)
      end
      true
    end
  end

  def my_any?
    if block_given?
      my_each do |x|
        return true if yield(x)
      end
      false
    end
  end

  def my_none?
    if block_given?
      my_each do |x|
        return false if yield(x)
      end
      true
    end
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
end
