module Enumerable
    def my_each
        for i in 0...self.length do
            yield(self[i])            
        end
        self
    end

    
end

[1,2,3,4].my_each do |x|
    puts x ** 2
end