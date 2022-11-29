require_relative "tree"
require_relative "node"

input_data = (1..15).to_a
puts "input data: #{input_data}"
puts "Creating tree class with input data (no output)"
bst = Tree.new(input_data)
puts "Building tree (no output)"
bst.build_tree
puts "pretty_print:"
bst.pretty_print
# puts "preorder:"
# p bst.preorder
puts "level_order_iter:"
p bst.level_order_iter
puts "level_order_rec:"
p bst.level_order_rec
puts "height of 4 (should be 2)"
p bst.height(4)