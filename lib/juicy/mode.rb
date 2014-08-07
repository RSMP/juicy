
module Juicy

  MODES = [:ionian, :dorian, :phrygian, :lydian, :mixolydian, :aeolian, :locrian]

  class Mode
  
    attr_reader :rotate, :type
  
    def initialize(type = :ionian)
      @type = type
      @rotate = case @type
      when :major
      0
      when :minor
        -2
      else
        0
      end
    end
    
    def to_s
      "#{@type}"
    end
    
    def ==(other_mode)
      if other_mode.kind_of? Mode
        type == other_mode.type
      elsif other_mode.kind_of? Symbol
        type == other_mode
      end
    end
	
  end
  
end
