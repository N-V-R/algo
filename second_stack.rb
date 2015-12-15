class Stack
  def initialize(*values)
    @arr = Array(*values)
  end

  def push(*values)
    @arr.push(*values)
  end

  def pop
    @arr.pop
  end

  def top
    @arr.last
  end

  def length
    @arr.length
  end

  def inspect
    @arr
  end
end

arr = (1..7).to_a
p st = Stack.new(arr)
p st.push(8, 9, 10)
p st.pop
p st.top
p st.length
