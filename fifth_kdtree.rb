require 'benchmark'

class KDTree
  Node = Struct.new(:item, :axis, :left, :right)

  def initialize(points)
    throw ArgumentError unless points.is_a?(Array)

    @root = build(points)
  end

  def find(query)
    prepare_query(query)
    find_by_query(query)
  end

  private

  def build(points, depth = 0)
    return if points.empty?

    @dimensions ||= points[0].length
    axis = depth % @dimensions
    return Node.new(points[0], axis) if points.length == 1

    points.sort_by! { |point| point[axis] }
    median = points.length/2
    left = build(points[0...median], depth+1)
    right = build(points[median+1..-1], depth+1)
    Node.new(points[median], axis, left, right)
  end

  def prepare_query(query)
    throw ArgumentError unless query.is_a?(Array)

    query.each_with_index { |range, i| query[i] = range..range if range.is_a?(Integer) }
  end

  def find_by_query(query, node = @root, points = [])
    axis = node.axis
    median = node.item[axis]
    range = query[axis]

    points << node.item if match?(query, node)
    find_by_query(query, node.left, points) if node.left && (range.nil? || median >= range.begin)
    find_by_query(query, node.right, points) if node.right && (range.nil? || median <= range.end)
    points
  end

  def match?(query, node)
    @dimensions.times.all? do |axis|
      range = query[axis]
      range.nil? || range === node.item[axis]
    end
  end
end

class PeopleGenerator
  Person = Struct.new(:age, :salary, :height, :weight)
  Rand = Random.new
  AGE_RANGE = 0..100
  SALARY_RANGE = 0..1000000.0
  HEIGHT_RANGE = 0..200
  WEIGHT_RANGE = 0..200
  N = 10_000_000

  class << self
    def generate_array
      arr = Array.new(N)

      N.times do |i|
        person = generate_person
        arr[i] = [person.age, person.salary, person.height, person.weight]
      end

      arr
    end

    private

    def generate_person
      Person.new(
        Rand.rand(AGE_RANGE),
        Rand.rand(SALARY_RANGE),
        Rand.rand(HEIGHT_RANGE),
        Rand.rand(WEIGHT_RANGE)
      )
    end
  end
end

puts "Generating 10M objects... (It takes about 30 sec)"
arr = PeopleGenerator.generate_array
puts "Building k-d tree... (It takes about 3 min)"
tree = KDTree.new(arr)

def bench(b, query, tree)
  b.report("Query: #{query}") { @points = tree.find(query) }
  puts "Found #{@points.length} matches. First 4:"
  @points.length.times { |i| break if i >= 4; p @points[i] }
  puts ""
end

puts "\r\nRange search (nil = any):"
Benchmark.bm do |b|
  query = [nil, nil, nil, nil];
  bench(b, query, tree)
  query = [50..100, 100000..700000, nil, 10];
  bench(b, query, tree)
  query = [nil, 100000..700000, nil, nil];
  bench(b, query, tree)
  query = [0..50, 0...100000, 10..40, 0..20];
  bench(b, query, tree)
end
