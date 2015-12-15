class BinaryTree
  Node = Struct.new(:value, :left, :right)

  def initialize(nodes_count)
    @nodes_count = nodes_count
    @root = create_nodes(@nodes_count)
  end

  def create_nodes(count)
    return if count <= 0

    left_count = count/2
    right_count = count - left_count-1

    Node.new(rand(100), create_nodes(left_count), create_nodes(right_count))
  end

  def direct_bypass(node = @root, level = 1)
    return if node.nil?

    print_node(node, level)
    direct_bypass(node.left, level+1)
    direct_bypass(node.right, level+1)
  end

  def symm_bypass(node = @root, level = 1)
    return if node.nil?

    symm_bypass(node.left, level+1)
    print_node(node, level)
    symm_bypass(node.right, level+1) 
  end

  def back_bypass(node = @root, level = 1)
    return if node.nil?

    back_bypass(node.right, level+1) 
    back_bypass(node.left, level+1)
    print_node(node, level)
  end

  private

  def print_node(node, level)
    (level-1).times { print "\t" }
    print "#{level}: #{node.value}\r\n"
  end
end

tree = BinaryTree.new(10)
puts "Direct bypass:"
tree.direct_bypass
puts "Symmetric bypass:"
tree.symm_bypass
puts "Backward bypass:"
tree.back_bypass
