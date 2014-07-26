
require_relative 'win32-mmlib_structs'

module Win32

  class Sound
    
    # Plays a frequency for a specified duration at a given volume.
    # Defaults are 440Hz, 1 second, full volume.
    # Result is a single channel, 44100Hz sampled, 16 bit sine wave.
    # If multiple instances are plays in simultaneous threads, 
    # they will be started and played at the same time
    #
    # ex.: threads = []
    #      [440, 660].each do |freq|
    #        threads << Thread.new { Win32::Sound.play_freq(freq) }
    #      end
    #      threads.each { |th| th.join }
    #
    # the first frequency in this array (440) will wait until the
    # thread for 660 finished calculating its PCM array and they
    # will both start streaming at the same time.
    #
    def self.play_freq(frequency = 440, duration = 1000, volume = 1, pause_execution = false)
    
      if frequency > HIGH_FREQUENCY || frequency < LOW_FREQUENCY
        raise ArgumentError, 'invalid frequency'
      end
      
      if duration < 0 || duration > 5000
        raise ArgumentError, 'invalid duration'
      end
    
      stream(pause_execution) { |wfx|
        data = generate_pcm_integer_array_for_freq(frequency, duration, volume)
        data_buffer = FFI::MemoryPointer.new(:int, data.size)
        data_buffer.write_array_of_int data
        buffer_length = wfx[:nAvgBytesPerSec]*duration/1000
        hdr = WAVEHDR.new(data_buffer, buffer_length)
        hdr[:lpData] = data_buffer
        hdr[:dwBufferLength] = buffer_length
        hdr[:dwFlags] = 0
        hdr[:dwLoops] = 1
        hdr
      }
      
    end
  
    private
    
    # Sets up a ready-made waveOut stream to push a PCM integer array to.
    # It expects a block to be associated with the method call to which
    # it will yield an instance of WAVEFORMATEX that the block uses
    # to prepare a WAVEHDR to return to the function.
    # The WAVEHDR can contain either a self-made PCM integer array
    # or an array from a wav file or some other audio file converted
    # to PCM.
    # 
    # This function will take the entire PCM array and create one
    # giant buffer, so it is not intended for audio streams larger
    # than 5 seconds.
    #
    # In order to play larger audio files, you will have to use the waveOut
    # functions and structs to set up a double buffer to incrementally
    # push PCM data to.
    #
    def self.stream(pause_execution)
    
      hWaveOut = HWAVEOUT.new
      wfx = WAVEFORMATEX.new

      wfx[:wFormatTag] = WAVE_FORMAT_PCM
      wfx[:nChannels] = 1
      wfx[:nSamplesPerSec] = 44100
      wfx[:wBitsPerSample] = 16
      wfx[:cbSize] = 0
      wfx[:nBlockAlign] = (wfx[:wBitsPerSample] >> 3) * wfx[:nChannels]
      wfx[:nAvgBytesPerSec] = wfx[:nBlockAlign] * wfx[:nSamplesPerSec]
      
      if ((error_code = waveOutOpen(hWaveOut.pointer, WAVE_MAPPER, wfx.pointer, 0, 0, 0)) != 0)
        raise SystemCallError.new('waveOutOpen', FFI.errno)
      end
      
      header = yield(wfx)
      
      if ((error_code = waveOutPrepareHeader(hWaveOut[:i], header.pointer, header.size)) != 0)
        raise SystemCallError.new('waveOutPrepareHeader', FFI.errno)
      end
      
      if pause_execution
        Thread.stop
        Thread.current[:sleep_time] ||= 0
        sleep Thread.current[:sleep_time]
      end
      Thread.pass
      
      if (waveOutWrite(hWaveOut[:i], header.pointer, header.size) != 0)
        raise SystemCallError.new('waveOutWrite', FFI.errno)
      end
      
      while (waveOutUnprepareHeader(hWaveOut[:i], header.pointer, header.size) == 33)
        sleep 0.1
      end
      
      if ((error_code = waveOutClose(hWaveOut[:i])) != 0)
        raise SystemCallError.new('waveOutClose', FFI.errno)
      end
      
      self
    end
    
    # Generates an array of PCM integers to play a particular frequency
    # It also ramps up and down the volume in the first and last
    # 200 milliseconds to prevent audio clicking.
    # 
    def self.generate_pcm_integer_array_for_freq(freq, duration, volume)
    
      data = []
      ramp = 200.0
      samples = (44100/2*duration/1000.0).floor
      
      samples.times do |sample|
      
        angle = (2.0*Math::PI*freq) * sample/samples * duration/1000
        factor = Math.sin(angle)
        x = 32768.0*factor*volume
        
        if sample < ramp
          x *= sample/ramp
        end
        if samples - sample < ramp
          x *= (samples - sample)/ramp
        end
        
        data << x.floor
      end
      
      data
      
    end
    
  end
  
end
