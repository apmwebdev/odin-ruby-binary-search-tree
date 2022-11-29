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
puts "level_order_iter:"
p bst.level_order_iter
puts "level_order_rec:"
p bst.level_order_rec
puts "find 1"
p bst.find(1)
# puts "delete leaf"
# bst.delete(13)
# puts "delete 1-child child"
# bst.delete(14)
# puts "pretty_print again:"
# bst.pretty_print
# puts "delete 2-child child"
# bst.delete(12)
# puts "pretty_print again:"
# bst.pretty_print