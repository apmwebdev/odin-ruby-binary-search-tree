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
puts "inorder, no block:"
p bst.inorder
puts "preorder, no block:"
p bst.preorder
puts "postorder, no block:"
p bst.postorder
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