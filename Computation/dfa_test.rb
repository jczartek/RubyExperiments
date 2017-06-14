require 'minitest/autorun'
require_relative 'dfa'

class FARuleTest < MiniTest::Test
  def setup
    @rule = FA::FARule.new(1, 'a', 2)
  end

  def test_follow
    assert_equal 2, @rule.follow
  end

  def test_apply
    assert_equal true, @rule.applies_to?(1, 'a')
  end
end

class DFARulebookTest < MiniTest::Test
  def setup
    @rulebook1 = FA::DFARulebook.new([FA::FARule.new(1, 'a', 2), FA::FARule.new(2, 'a', 1)])
    @rulebook2 = FA::DFARulebook.new
    @rulebook2.rule 1, 'a', 2
    @rulebook2.rule 2, 'a', 1
  end

  def test_next_state
    assert_equal @rulebook1.next_state(1, 'a'), 2
    assert_equal @rulebook1.next_state(2, 'a'), 1

    assert_equal @rulebook2.next_state(1, 'a'), 2
    assert_equal @rulebook2.next_state(2, 'a'), 1
  end
end

class DFADesignTest < MiniTest::Test
  def setup
    @dfa_desing = FA::DFADesign.new(0, [0]) do
      rule 0, '0', 0
      rule 0, '1', 1
      rule 1, '1', 0
      rule 1, '0', 2
      rule 2, '0', 1
      rule 2, '1', 2
    end
  end

  def test_binary_number_divisible_by_3
    numbers_divisible_by_3 = (1..100000).find_all { |n| @dfa_desing.accepts?(n.to_s(2)) }
    assert numbers_divisible_by_3.all? { |n| (n % 3).zero? }
  end
end
