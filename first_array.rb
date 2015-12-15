arr = (1..9).to_a

p arr[2]
arr << 10
arr.delete_at(6)
arr[4] = 0
p arr
