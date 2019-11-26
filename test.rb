require './my_enumerable.rb'
include Enumerable
def checkTest(result,requirements)
    r = true
    success=[]
    fails = []
    if result.length == requirements.length
        for i in 0...requirements.length
            r=false unless result[i]==requirements[i]
             if result[i]==requirements[i]
                success << i 
             else
                fails << "Test #{i+1}"           
             end
        end
    end
    puts "Tests Succeeded" if r
    puts "Tests Failed : #{fails}" if !r
    puts "Result: #{success.length}/#{result.length}"
end

def testMySelect
    rs=[]
    rq=[]
    rs << [1,2,3,4,5,6,7,8,9,10].my_select { |i|  i % 3 == 0 } 
    rq << [3, 6, 9]
    rs << [1,2,3,4,5].my_select { |num|  num.even?  }   
    rq << [2, 4]
    rs << [:foo, :bar].my_select { |x| x == :foo }
    rq << [:foo]
    
  
    checkTest(rs,rq) 
end

def testMyAll
    rs=[]
    rq= []

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

    checkTest(rs,rq) 
end

def testMyAny
    rs=[]
    rq= []

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

    checkTest(rs,rq) 
end

def testMyNone
    rs=[]
    rq=[]
    rs << %w{ant bear cat}.my_none? { |word| word.length == 5 } #=> true
    rq << true
    rs << %w{ant bear cat}.my_none? { |word| word.length >= 4 } #=> false
    rq << false
    rs << %w{ant bear cat}.my_none?(/d/)                        #=> true
    rq << true
    rs << [1, 3.14, 42].my_none?(Float)                         #=> false
    rq << false
    rs << [].my_none?                                           #=> true
    rq << true
    rs << [nil].my_none?                                        #=> true
    rq << true
    rs << [nil, false].my_none?                                 #=> true
    rq << true
    rs << [nil, false, true].my_none?                           #=> false
    rq << false
    checkTest(rs,rq)
end

def testMyCount
    rs=[]
    rq=[]
    ary = [1, 2, 4, 2]
    rs << ary.my_count               #=> 4
    rq << 4
    rs << ary.my_count(2)               #=> 2
    rq << 2
    rs << ary.my_count{ |x| x%2==0 } #=> 3
    rq << 3
    

    checkTest(rs,rq)
end

def testMyMap
    rs=[]
    rq=[]
    rs << [1,2,3,4].my_map { |i| i*i }      #=> [1, 4, 9, 16]
    rq << [1, 4, 9, 16]
    rs << [1,2,3,4].my_map { "cat"  }   #=> ["cat", "cat", "cat", "cat"]
    rq << ["cat", "cat", "cat", "cat"]
    checkTest(rs,rq)
end
def testMyInject
    rs=[]
    rq=[]
    rs << [5,6,7,8,9,10].my_inject(:+)                             #=> 45
    rq << 45
    rs << [5,6,7,8,9,10].my_inject { |sum, n| sum + n }            #=> 45
    rq << 45
    rs << [5,6,7,8,9,10].my_inject(1, :*)                          #=> 151200
    rq << 151200
    rs << [5,6,7,8,9,10].my_inject(1) { |product, n| product * n } #=> 151200
    rq << 151200
    rs << %w{ cat sheep bear }.my_inject do |memo, word|
        memo.length > word.length ? memo : word
     end
    rq << "sheep"

    checkTest(rs,rq)
end


testMyInject