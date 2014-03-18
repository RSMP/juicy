
module Juicy

  MODES = [:ionian, :dorian, :phrygian, :lydian, :mixolydian, :aeolian, :locrian]

  class Mode
  
    attr_reader :rotate
  
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
	
  end
  
end
