require 'benchmark'

class Hash
  def sort_by_func(func, is_value = false)
    if is_value
      arr_sorted = func.call(self.values)
      Hash[sort_by { |_, value| arr_sorted.index(value) }]
    else
      arr_sorted = func.call(self.keys)
      Hash[sort_by { |key, _| arr_sorted.index(key) }]
    end
  end

  def sort_by_func_bm(func, is_value = false)
    10_000.times do
      sort_by_func(func, is_value)
    end
  end
end

def bubblesort(arr)
  last_index = arr.length-1
  last_index.times do |i|
    (last_index - i).times do |j|
      if arr[j] > arr[j+1]
        arr[j], arr[j+1] = arr[j+1], arr[j]
      end
    end
  end

  arr
end

def mergesort(arr)
  def merge(left_sorted, right_sorted)
    res = []
    l = 0
    r = 0

    loop do
      break if r >= right_sorted.length and l >= left_sorted.length

      if r >= right_sorted.length or (l < left_sorted.length and left_sorted[l] < right_sorted[r])
        res << left_sorted[l]
        l += 1
      else
        res << right_sorted[r]
        r += 1
      end
    end

    return res
  end

  def iter(arr_sliced)
    return arr_sliced if arr_sliced.length <= 1

    mid = arr_sliced.length/2 - 1
    left_sorted = iter(arr_sliced[0..mid])
    right_sorted = iter(arr_sliced[mid+1..-1])
    return merge(left_sorted, right_sorted)
  end

  iter(arr)
end

def quicksort(arr)
  return arr if arr.length <= 1

  pivot_index = arr.length/2
  pivot_value = arr[pivot_index]
  arr.delete_at(pivot_index)
  lesser = []
  greater = []

  arr.each { |e| e <= pivot_value ? lesser << e : greater << e }

  quicksort(lesser) + [pivot_value] + quicksort(greater)
end

hash = {a: "1", c: "7", b: "5", d: "3"}
Benchmark.bm do |b|
  b.report("Bubble sort by keys  ") { hash.sort_by_func_bm(method(:bubblesort)) }
  b.report("Bubble sort by values") { hash.sort_by_func_bm(method(:bubblesort), true) }
  b.report("Merge sort by keys   ") { hash.sort_by_func_bm(method(:mergesort)) }
  b.report("Merge sort by values ") { hash.sort_by_func_bm(method(:mergesort), true) }
  b.report("Quick sort by keys   ") { hash.sort_by_func_bm(method(:quicksort)) }
  b.report("Quick sort by values ") { hash.sort_by_func_bm(method(:quicksort), true) }
end
