class Tree
  attr_accessor :input_data, :root

  def initialize(input_data)
    @input_data = format_input_data(input_data)
  end

  def build_tree
    @root = build_tree_recursively(0, input_data.length - 1)
  end

  def pretty_print(node = @root, prefix = "", is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? "│   " : "    "}", false) if node.right
    puts "#{prefix}#{is_left ? "└── " : "┌── "}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? "    " : "│   "}", true) if node.left
  end

  def insert(value)
    raise "Invalid insert" unless value.is_a?(Integer)
    new_node = Node.new(value)
    insert_recursively(new_node)
  end

  def delete(value)
    raise "Invalid deletion" unless value.is_a?(Integer)
    node = Node.new(value)
    if node == root
      if root.is_leaf?
        @root = nil
      elsif root.has_one_child?
        @root = root.left.nil? ? root.right : root.left
      else
        delete_saturated_node(root)
      end
      return
    end

    parent_node = find_parent_of(node)
    if parent_node.nil?
      puts "Can't delete \"#{value}.\" Value not present in tree"
      return
    end

    node_to_delete = (node == parent_node.left) ? parent_node.left : parent_node.right
    if node_to_delete.is_leaf?
      delete_leaf_node(node_to_delete, parent_node)
    elsif node_to_delete.has_one_child?
      delete_unsaturated_node(node_to_delete, parent_node)
    else
      delete_saturated_node(node_to_delete, parent_node)
    end
  end

  def find
    # accepts a value and returns the node with the given value.
  end

  def level_order_rec(queue = [root], return_arr = [])
    if queue.empty?
      return return_arr
    end
    queue.push(queue.first.left) unless queue.first.left.nil?
    queue.push(queue.first.right) unless queue.first.right.nil?
    if block_given?
      return_arr.push(yield(queue.shift))
    else
      return_arr.push(queue.shift.value)
    end
    level_order_rec(queue, return_arr)
  end

  def level_order_iter
    return_arr = []
    queue = [root]
    queue.each do |node|
      if block_given?
        return_arr.push(yield(node))
      else
        return_arr.push(node.value)
      end
      queue.push(node.left) unless node.left.nil?
      queue.push(node.right) unless node.right.nil?
    end
    return_arr
  end

  def inorder(start_node = root, return_arr = [])
    return if start_node.nil?
    inorder(start_node.left, return_arr)
    if block_given?
      return_arr.push(yield(start_node))
    else
      return_arr.push(start_node.value)
    end
    inorder(start_node.right, return_arr)
    return_arr
  end

  def preorder(start_node = root, return_arr = [])
    return if start_node.nil?
    if block_given?
      return_arr.push(yield(start_node))
    else
      return_arr.push(start_node.value)
    end
    preorder(start_node.left, return_arr)
    preorder(start_node.right, return_arr)
    return_arr
  end

  def postorder(start_node = root, return_arr = [])
    return if start_node.nil?
    postorder(start_node.left, return_arr)
    postorder(start_node.right, return_arr)
    if block_given?
      return_arr.push(yield(start_node))
    else
      return_arr.push(start_node.value)
    end
    return_arr
  end

  def height(node)
    # accepts a node and returns its height. Height is defined as the number of
    # edges in longest path from a given node to a leaf node.
  end

  def depth(node)
    # accepts a node and returns its depth. Depth is defined as the number of
    # edges in path from a given node to the tree’s root node.
  end

  def balanced?
    # checks if the tree is balanced. A balanced tree is one where the
    # difference between heights of left subtree and right subtree of every node
    # is not more than 1.
  end

  def rebalance
    # rebalances an unbalanced tree. Tip: You’ll want to use a traversal method
    # to provide a new array to the #build_tree method.
  end

  private

  def format_input_data(input)
    raise "Empty input" if input.nil? || input.empty?
    raise "Invalid input data" unless input.is_a?(Array)
    input.uniq.sort
  end

  def build_tree_recursively(start_i, end_i)
    return if start_i > end_i
    mid = (start_i + end_i) / 2
    root = Node.new(input_data[mid])
    root.left = build_tree_recursively(start_i, mid - 1)
    root.right = build_tree_recursively(mid + 1, end_i)
    root
  end

  def insert_recursively(node, tree_node = root)
    if node < tree_node
      if tree_node.left.nil?
        tree_node.left = node
      else
        insert_recursively(node, tree_node.left)
      end
    elsif node > tree_node
      if tree_node.right.nil?
        tree_node.right = node
      else
        insert_recursively(node, tree_node.right)
      end
    else
      puts "Can't insert. Value already exists in tree"
    end
  end

  def find_parent_of(node, tree_node = root)
    if node < tree_node
      if tree_node.left.nil?
        nil
      elsif node == tree_node.left
        tree_node
      else
        find_parent_of(node, tree_node.left)
      end
    elsif node > tree_node
      if tree_node.right.nil?
        nil
      elsif node == tree_node.right
        tree_node
      else
        find_parent_of(node, tree_node.right)
      end
    end
  end

  def delete_leaf_node(node_to_delete, parent_node)
    if node_to_delete == parent_node.left
      parent_node.left = nil
    else
      parent_node.right = nil
    end
  end

  def delete_unsaturated_node(node_to_delete, parent_node)
    grandchild_node = node_to_delete.left.nil? ?
                        node_to_delete.right :
                        node_to_delete.left
    if node_to_delete == parent_node.left
      parent_node.left = grandchild_node
    else
      parent_node.right = grandchild_node
    end
  end

  def delete_saturated_node(node_to_delete, parent_node = nil)
    puts "node_to_delete = #{node_to_delete}, parent_node = #{parent_node}"
    next_lowest = find_lowest(node_to_delete.right)
    replacement = next_lowest[:node]
    unless next_lowest[:parent_node].nil?
      next_lowest[:parent_node].left = replacement.right
    end
    replacement.left = node_to_delete.left
    replacement.right = (node_to_delete.right == replacement) ?
                          nil :
                          node_to_delete.right
    if parent_node.nil?
      @root = replacement
      return
    end
    if node_to_delete == parent_node.left
      parent_node.left = replacement
    else
      parent_node.right = replacement
    end
  end

  def find_lowest(start_node, parent_node = nil)
    puts "find lowest. start_node = #{start_node}, parent_node = #{parent_node}"
    return_hash = {node: start_node, parent_node:}
    if start_node.left.nil?
      return_hash
    else
      find_lowest(start_node.left, start_node)
    end
  end
end
