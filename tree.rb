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

  def find(input, tree_node = root, depth = 0, need_depth = false)
    if tree_node.nil?
    elsif input.is_a?(Integer)
      find(Node.new(input), tree_node, depth, need_depth)
    elsif !input.is_a?(Node)
      raise "Invalid find input"
    elsif input < tree_node
      find(input, tree_node.left, depth + 1, need_depth)
    elsif input > tree_node
      find(input, tree_node.right, depth + 1, need_depth)
    elsif !need_depth
      tree_node
    else
      depth
    end
  end

  def level_order_rec(queue = [root], return_arr = [], &block)
    if queue.empty?
      return return_arr
    end
    queue.push(queue.first.left) unless queue.first.left.nil?
    queue.push(queue.first.right) unless queue.first.right.nil?
    if block
      block.call(queue.shift)
    else
      return_arr.push(queue.shift.value)
    end
    level_order_rec(queue, return_arr, &block)
  end

  def level_order_iter(&block)
    return_arr = []
    queue = [root]
    queue.each do |node|
      if block
        block.call(node)
      else
        return_arr.push(node.value)
      end
      queue.push(node.left) unless node.left.nil?
      queue.push(node.right) unless node.right.nil?
    end
    return_arr
  end

  def inorder(start_node = root, return_arr = [], &block)
    return if start_node.nil?
    inorder(start_node.left, return_arr, &block)
    if block
      block.call(start_node)
    else
      return_arr.push(start_node.value)
    end
    inorder(start_node.right, return_arr, &block)
    return_arr
  end

  def preorder(start_node = root, return_arr = [], &block)
    return if start_node.nil?
    if block
      block.call(start_node)
    else
      return_arr.push(start_node.value)
    end
    preorder(start_node.left, return_arr, &block)
    preorder(start_node.right, return_arr, &block)
    return_arr
  end

  def postorder(start_node = root, return_arr = [], &block)
    return if start_node.nil?
    postorder(start_node.left, return_arr, &block)
    postorder(start_node.right, return_arr, &block)
    if block
      block.call(start_node)
    else
      return_arr.push(start_node.value)
    end
    return_arr
  end

  def height(value)
    start_node = find(value)
    return if start_node.nil?
    height_hash = {start_node.value => 0}
    preorder(start_node) do |node|
      unless node.left.nil?
        height_hash[node.left.value] = height_hash[node.value] + 1
      end
      unless node.right.nil?
        height_hash[node.right.value] = height_hash[node.value] + 1
      end
    end
    height_hash.values.max
  end

  def depth(value)
    find(value, root, 0, true)
  end

  def balanced?
    is_balanced = true
    level_order_rec do |node|
      next if node.nil?
      next if node.is_leaf?
      if node.has_one_child?
        if height(node.value) == 1
          next
        else
          is_balanced = false
          break
        end
      elsif (height(node.left.value) - height(node.right.value)).abs <= 1
        next
      else
        is_balanced = false
        break
      end
    end
    is_balanced
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
