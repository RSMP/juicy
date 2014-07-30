
module Juicy

  class Measure
  
    def initialize(time_signature)
      @beats_per_measure = time_signature[0]
      @beat_type = Rational(1,time_signature[1])
    end
    
  end
  
end
