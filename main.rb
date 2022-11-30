require_relative "tree"
require_relative "node"

# input_data = (1..15).to_a
# puts "input data: #{input_data}"
# puts "Creating tree class with input data (no output)"
# bst = Tree.new(input_data)
# puts "Building tree (no output)"
# bst.build_tree
# puts "pretty_print:"
# bst.pretty_print

input_arr = Array.new(15) { rand(1..100) }
puts "input_arr = #{input_arr}"
tree = Tree.new(input_arr)
tree.build_tree
tree.pretty_print
puts "balanced?"
puts tree.balanced?
puts "traverse: level rec, level iter, pre, post, in"
p tree.level_order_rec
p tree.level_order_iter
p tree.preorder
p tree.postorder
p tree.inorder
puts "unbalance tree..."
tree.insert(101)
tree.insert(110)
tree.insert(120)
tree.insert(130)
puts "balanced?"
puts tree.balanced?
tree.pretty_print
puts "rebalance"
tree.rebalance
tree.pretty_print
puts "balanced?"
puts tree.balanced?
puts "traverse: level rec, level iter, pre, post, in"
p tree.level_order_rec
p tree.level_order_iter
p tree.preorder
p tree.postorder
p tree.inorder
