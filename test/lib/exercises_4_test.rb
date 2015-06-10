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

  def test_hash_in_hash
    person1 = {first: "John", last: "Tanaka"}
    person2 = {first: "Mary", last: "Honda"}
    person3 = {first: "Alex", last: "Yamada"}

    params = {father: person1, mother: person2, child: person3}

    assert_equal params[:father][:first], "John"
    assert_equal params[:father][:last],  "Tanaka"
    assert_equal params[:mother][:first], "Mary"
    assert_equal params[:mother][:last],  "Honda"
    assert_equal params[:child][:first],  "Alex"
    assert_equal params[:child][:last],   "Yamada"
  end

  def test_hash_merge
    hash = {"a" => 100, "b" => 200}.merge({"b" => 300})

    assert_equal hash["b"], 300
  end
end
