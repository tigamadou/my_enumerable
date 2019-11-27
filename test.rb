# frozen_string_literal: true

require './main.rb'

class EnumTest
  include Enumerable
  def initialize
    @results = {}
  end

  def run_all(det = nil)
    test_my_select
    test_my_all
    test_my_any
    test_my_none
    test_my_count
    test_my_map
    test_my_inject
    r = nil
    if det
      r = @results
    else
      @results.all? do |_x, array|
        r = if array[:result]
              true
            else
              false
            end
      end
    end

    r
  end

  def check_test(name, result, requirements)
    r = true
    success = []
    fails = ''
    if result.length == requirements.length
      (0...requirements.length).each do |i|
        r = false unless result[i] == requirements[i]
        if result[i] == requirements[i]
          success << i
        else
          fails += "Test #{i + 1} - "
        end
      end
    end
    test = {}

    test[:result] = r
    test[:success] = 'Tests Succeeded' if r
    test[:fail] = "Tests Failed : #{fails.upcase}" unless r
    test[:ratio] = "#{success.length}/#{result.length}"
    @results[name.to_s] = test
    @results
  end

  def test_my_select
    rs = []
    rq = []
    rs << [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].my_select { |i| (i % 3).zero? }
    rq << [3, 6, 9]
    rs << [1, 2, 3, 4, 5].my_select(&:even?)
    rq << [2, 4]
    rs << %i[foo bar].my_select { |x| x == :foo }
    rq << [:foo]
    check_test('my_select', rs, rq)
  end

  def test_my_all
    rs = []
    rq = []
    rs << %w[ant bear cat].my_all? { |word| word.length >= 3 }
    rq << true
    rs << %w[ant bear cat].my_all? { |word| word.length >= 4 }
    rq << false
    rs << %w[ant bear cat].my_all?(/t/)
    rq << false
    rs << [1, 2i, 3.14].my_all?(Numeric)
    rq << true
    rs << [nil, true, 99].my_all?
    rq << false
    rs << [].my_all?
    rq << true
    check_test('my_all', rs, rq)
  end

  def test_my_any
    rs = []
    rq = []
    rs << %w[ant bear cat].my_any? { |word| word.length >= 3 }
    rq << true
    rs << %w[ant bear cat].my_any? { |word| word.length >= 4 }
    rq << true
    rs << %w[ant bear cat].my_any?(/d/)
    rq << false
    rs << [nil, true, 99].my_any?(Integer)
    rq << true
    rs << [nil, true, 99].my_any?
    rq << true
    rs << [].any?
    rq << false
    check_test('my_any', rs, rq)
  end

  def test_my_none
    rs = []
    rq = []
    rs << %w[ant bear cat].my_none? { |word| word.length == 5 } #=> true
    rq << true
    rs << %w[ant bear cat].my_none? { |word| word.length >= 4 } #=> false
    rq << false
    rs << %w[ant bear cat].my_none?(/d/) #=> true
    rq << true
    rs << [1, 3.14, 42].my_none?(Float) #=> false
    rq << false
    rs << [].my_none? #=> true
    rq << true
    rs << [nil].my_none? #=> true
    rq << true
    rs << [nil, false].my_none? #=> true
    rq << true
    rs << [nil, false, true].my_none? #=> false
    rq << false
    check_test('my_none', rs, rq)
  end

  def test_my_count
    rs = []
    rq = []
    ary = [1, 2, 4, 2]
    rs << ary.my_count #=> 4
    rq << 4
    rs << ary.my_count(2) #=> 2
    rq << 2
    rs << ary.my_count(&:even?) #=> 3
    rq << 3
    check_test('my_count', rs, rq)
  end

  def test_my_map
    rs = []
    rq = []
    rs << [1, 2, 3, 4].my_map { |i| i * i } #=> [1, 4, 9, 16]
    rq << [1, 4, 9, 16]
    rs << [1, 2, 3, 4].my_map { 'cat' } #=> ["cat", "cat", "cat", "cat"]
    rq << %w[cat cat cat cat]
    check_test('my_map', rs, rq)
  end

  def test_my_inject
    rs = []
    rq = []
    rs << [5, 6, 7, 8, 9, 10].my_inject(:+) #=> 45
    rq << 45
    rs << [5, 6, 7, 8, 9, 10].my_inject { |sum, n| sum + n } #=> 45
    rq << 45
    rs << [5, 6, 7, 8, 9, 10].my_inject(1, :*) #=> 151200
    rq << 151_200
    rs << [5, 6, 7, 8, 9, 10].my_inject(1) { |product, n| product * n } #=> 151200
    rq << 151_200
    rs << %w[cat sheep bear].my_inject do |memo, word|
      memo.length > word.length ? memo : word
    end
    rq << 'sheep'
    check_test('my_inject', rs, rq)
  end
end

test = EnumTest.new

p test.testAll
