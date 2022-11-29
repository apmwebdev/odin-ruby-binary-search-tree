class Node
  include Comparable
  attr_accessor :value, :left, :right

  def initialize(value)
    @value = value
  end

  def <=>(other)
    value <=> other.value
  end

  def is_leaf?
    left.nil? && right.nil?
  end

  def has_one_child?
    (left.nil? && !right.nil?) || (!left.nil? && right.nil?)
  end

  def to_s
    value.to_s
  end
end
