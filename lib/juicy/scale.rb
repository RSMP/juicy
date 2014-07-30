
module Juicy

  SCALE_TYPES = {
	  chromatic: [1,1,1,1,1,1,1,1,1,1,1,1],
	  whole_note: [2,2,2,2,2,2],
	  octotonic: [2,1,2,1,2,1,2,1],
	  pentatonic: [2,2,3,2,3],
	  diatonic: [2,2,1,2,2,2,1]
  }  
  #            0  1  2  3  4  5  6  7  8  9 10 11 12
  #            |- |- |- |- |- |- |- |- |- |- |- |- |
  #           do di re ri mi fa fi so si la li ti do
  # chromatic  |- |- |- |- |- |- |- |- |- |- |- |- |
  #           do    re    mi fa    so    la    ti do
  # diatonic   |-  - |-  - |- |-  - |-  - |-  - |- |
  #           do    re    mi       so    la       do
  # pentatonic |-  - |-  - |-  -  - |-  - |-  -  - |
  #           do    re    mi    fi    si    li    do
  # whole note |-  - |-  - |-  - |-  - |-  - |-  - |
  #           do    re ri    fa fi    si la    ti do
  # octotonic  |-  - |- |-  - |- |-  - |- |-  - |- |
  #

    class Scale
    include Enumerable

    def initialize(type = :major, root = Note.new)
      case type
      when :major
      @type = :diatonic
      when :minor
      @type = :diatonic
      else
      @type = type
      end
      @mode = Mode.new(type)
      @root = root
      generate_notes
    
    end
    
    def to_s
      "scale type: #{@type}, mode: #{@mode}, root: #{@root}"
    end
    
    def[](element)
      
    end
    
    def play
    
    end
    
    def mode=(type)
      @mode = Mode.new(type)
      generate_notes
    end
    
    def root=(root)
      @root = root
      generate_notes
    end
    
    #def each
    #  yield SCALE_TYPES[@type]
    #end
    
    def each
      (SCALE_TYPES[@type].size+1).times do
        yield @notes.next.name
      end
    end
    
    def each_note
      (SCALE_TYPES[@type].size+1).times do
        yield @notes.next
      end
    end
    
    def interval_between(note1, note2)
      half_steps = 0
      direction = (note1 <=> note2)
      if direction == 0
      elsif direction == -1
        note = note1.dup
        until (note <=> note2) == 0
          note += 1
          half_steps += 1
        end
      elsif direction == 1
        note = note1.dup
        until (note <=> note2) == 0
          note -= 1
          half_steps -= 1
        end
      end
      half_steps
    end
    
    private
    
    def generate_notes
      @notes = []
      @notes << @root
      SCALE_TYPES[@type].rotate(@mode.rotate).each do |step|
        @notes << @notes[-1]+step
      end
      @notes = @notes.cycle
    end
    
  end
  
end
