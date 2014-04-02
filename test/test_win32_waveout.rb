##########################################################################
# test_win32_waveout.rb
#
# Test suite for the win32-sound waveOut library.
#
##########################################################################
require 'test-unit'
require '../lib/juicy'
include Win32

class TC_Win32_WavOut < Test::Unit::TestCase
  
  def test_play_freq
    assert_respond_to(Sound, :play_freq)
    assert_nothing_raised{ Sound.play_freq }
    assert_nothing_raised{ Sound.play_freq(220) }
    assert_nothing_raised{ Sound.play_freq(660, 500) }
    assert_nothing_raised{ Sound.play_freq(550, 200, 0.5) }
  end
  
  def test_play_freq_expected_errors
    assert_raises(ArgumentError){ Sound.play_freq(-1) }
    assert_raises(ArgumentError){ Sound.play_freq(440, -1) }
    assert_raises(ArgumentError){ Sound.play_freq(32768) }
    assert_raises(ArgumentError){ Sound.play_freq(500, 5001, 2) }
    assert_raises(ArgumentError){ Sound.play_freq(440, 500, 0.5, 7) }
    assert_raises(ArgumentError){ Sound.play_freq("440") }
  end
  
end
