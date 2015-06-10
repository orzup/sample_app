require 'minitest/autorun'
require 'exercises_4'

class Exercises4Test < Minitest::Test
  def test_shuffle
    original = "abcdefg"
    shuffled = Exercises4.string_shuffle(original)

    assert_empty original.split('') - shuffled.split('')
    assert_empty shuffled.split('') - original.split('')
  end

  def test_instance_method_shuffle
    original = "abcdefg"
    shuffled = original.shuffle

    assert_empty original.split('') - shuffled.split('')
    assert_empty shuffled.split('') - original.split('')
  end
end
