
module Juicy

  # some index of a given scale.  if scale is [2,4,5,7,9,11,12], then a scale degree of 3 is 4.
  # scale degree of 1 is 0 by definition. That is, the root of the scale is defined to be 
  # a scale degree of 1.

  class ScaleDegree
  
    attr_reader :degree
    
    def initialize(degree)
      @degree = degree
    end
    
    def to_s
      @degree
    end
    
  end
  
end
