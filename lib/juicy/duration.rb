module Juicy

  class Duration
  
    def initialize(duration)
      @duration = parse_duration(duration)
      
    end
  
    private
    
    def parse_duration(duration)
      return "quarter"
    end
  
  end
  
end
