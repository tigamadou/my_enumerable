module Enumerable
    def my_each
        if block_given?
            for i in 0...self.length do
                yield(self[i])
            end
        end
        self
    end

    def my_each_with_index
        if block_given?
            for i in 0...self.length do
                yield(self[i],i)
                
            end
        end
        self
    end

    
end

[1,2,3,4].my_each do |x|
    puts x ** 2
end