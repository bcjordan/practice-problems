# encoding: utf-8

# Alternatively could use Struct.new(), would just need to be careful
# using .equals? (identity) instead of == (struct value equivalency)
class Node
  attr_accessor :parent, :left, :right

  def initialize
    @left = nil
    @right = nil
    @parent = nil
  end

  [:left, :right].each do |direction|
    define_method "#{direction}=" do |value_node|
      instance_variable_set("@#{direction}", value_node)
      value_node.parent = self
    end
  end
end

# Utility methods for tree traversal
class Traversal
  def self.next_inorder(node)
    return node.right unless node.parent

    return get_leftmost_child(node.right) if node.right

    node == node.parent.left ? node.parent : nil
  end

  private

  def get_leftmost_child(node)
    curr = node.right
    curr = curr.left while curr.left
    curr
  end
end

require 'test/unit'

# Test Traversal utility methods
class TestTraversalUtils < Test::Unit::TestCase
  def setup
    #   B
    #  / \
    # A   C

    @a = Node.new
    @b = Node.new
    @c = Node.new

    @b.left = @a
    @b.right = @c
  end

  def test_next_is_parent
    assert_equal @b, Traversal.next_inorder(@a)
  end

  def test_next_is_right_child
    assert_equal @c, Traversal.next_inorder(@b)
  end

  def test_end_of_traversal
    assert_equal nil, Traversal.next_inorder(@c)
  end
end
