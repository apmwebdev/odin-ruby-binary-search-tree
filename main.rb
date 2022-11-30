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
# puts "deletions..."
# bst.delete(11)
# bst.delete(9)
# bst.delete(10)
# bst.pretty_print
# puts "balanced?"
# puts bst.balanced?
# puts "rebalance"
# bst.rebalance
# bst.pretty_print
