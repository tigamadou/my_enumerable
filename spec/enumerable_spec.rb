# frozen_string_literal: true

require_relative './../main.rb'
RSpec.describe Enumerable do
  describe '#my_select' do
    it 'Returns [3,6,9] containing all elements of enum for which the given block returns a true value.' do
      expect([1, 2, 3, 4, 5, 6, 7, 8, 9, 10].my_select { |i| (i % 3).zero? }).to eql([3, 6, 9])
    end

    it 'Returns [2, 4] containing all even elements of enum' do
      expect([1, 2, 3, 4, 5].my_select(&:even?)).to eql([2, 4])
    end
    it 'Returns [:foo] an array containing all symbols of enum for which the given block returns a true value.' do
      expect(%i[foo bar].my_select { |x| x == :foo }).to eql([:foo])
    end
  end

  describe '#my_all' do
    it 'returns true if all the elements match the block.' do
      expect(%w[ant bear cat].my_all? { |word| word.length >= 3 }).to eql(true)
    end

    it 'returns false if the block  returns false or nil.' do
      expect(%w[ant bear cat].my_all? { |word| word.length >= 4 }).to eql(false)
    end
    it 'return false if no match for the regular expression.' do
      expect(%w[ant bear cat].my_all?(/t/)).to eql(false)
    end

    it 'returns true if the block match the pattern.' do
      expect([1, 2i, 3.14].my_all?(Numeric)).to eql(true)
    end
    it 'returns false if at least one of the collection element is false or nil' do
      expect([nil, true, 99].my_all?).to eql(false)
    end

    it 'returns true if the block never returns false or nil' do
      expect([].my_all?).to eql(true)
    end
  end

  describe '#my_any?' do
    it 'return true if at least one of the collection members match the block given .' do
      expect(%w[ant bear cat].my_any? { |word| word.length >= 3 }).to eql(true)
    end

    it 'return false if none of the collection members match the regex' do
      expect(%w[ant bear cat].my_any?(/d/)).to eql(false)
    end
    it 'return true if at least one of the collection members match the pattern Integer.' do
      expect([nil, true, 99].my_any?(Integer)).to eql(true)
    end
    it 'return true if at least one of the collection members is not false or nil.' do
      expect([nil, true, 99].my_any?).to eql(true)
    end

    it 'return false if none of the collection members is not false or nil.' do
      expect([].any?).to eql(false)
    end
  end

  describe '#my_count' do
    ary = [1, 2, 4, 2]
    it 'Returns the number of items' do
      expect(ary.my_count).to eql(4)
    end
    it 'Returns the number of items that are equal to the argument' do
      expect(ary.my_count(2)).to eql(2)
    end
    it 'Returns the number of items yielding a true value for the block given' do
      expect(ary.my_count(&:even?)).to eql(3)
    end
  end

  describe '#my_map' do
    it 'Returns a new array with the results of running block once for every element' do
      expect([1, 2, 3, 4].my_map { |i| i * i }).to eql([1, 4, 9, 16])
    end
    it 'Returns a new array with the results of running block once for every element' do
      expect([1, 2, 3, 4].my_map { 'cat' }).to eql(%w[cat cat cat cat])
    end
  end

  describe '#my_inject' do
    it 'return 45 after it combines all elements when a symbol is specified ' do
      expect([5, 6, 7, 8, 9, 10].my_inject(:+)).to eql(45)
    end
    it 'return 45 after it combines all elements with initial and symbol are  specified' do
      expect([5, 6, 7, 8, 9, 10].my_inject { |sum, n| sum + n }).to eql(45)
    end
    it 'return 151200 after it multiply all elements when initial and symbol are specified' do
      expect([5, 6, 7, 8, 9, 10].my_inject(1, :*)).to eql(151_200)
    end
    it 'return 151200 after it multiply all elements with initial  specified and block is given' do
      expect([5, 6, 7, 8, 9, 10].my_inject(1) { |product, n| product * n }).to eql(151_200)
    end
    it 'return sheep as the longuest word with a block given' do
      expect(%w[cat sheep bear].my_inject { |memo, word| memo.length > word.length ? memo : word }).to eql('sheep')
    end
  end
end
