#! /usr/bin/crystal
require "../intcode"

data = File.read("input.txt")

program = data.strip.split(",").map { |e| e.to_i64 }
intcode = Intcode.new(program)
intcode.run

enum Tile
  WALL
  SPACE
  OXYGEN
  BOT
end

# grid = {} of Tuple(Int32, Int32) => Tile
grid = { {0, 0} => Tile::SPACE }

direction = 0
x, y = 0, 0

loop do
  intcode.input_channel.send(direction.to_i64 + 1i64)
  Fiber.yield
  oldx = x.dup
  oldy = y.dup
  case direction
  when 0
    y += 1
  when 1
    y -= 1
  when 2
    x -= 1
  when 3
    x += 1
  end
  output = intcode.output_channel.receive.to_i32
  if Tile.new(output) == Tile::WALL
    grid[{x, y}] = Tile.new(output)
    x, y = oldx, oldy
  else
    grid[{x, y}] = Tile.new(output)
  end
  break if output == 2

  direction = rand(4)
end

bounds = grid.keys.transpose
xoffset = bounds[0].min
yoffset = bounds[1].min
xcap = bounds[0].max
ycap = bounds[1].max

final = Array(Array(Tile)).new(1 + ycap - yoffset) { Array(Tile).new(1 + xcap - xoffset, Tile.new(1)) }

grid.each do |k, v|
  final[k[1] - yoffset][k[0] - xoffset] = v
end

final[y - yoffset][x - xoffset] = Tile::BOT

final.reverse.each do |line|
  line.each do |tile|
    if tile == Tile::WALL
      print "█"
    elsif tile == Tile::BOT
      print "#"
    else
      print " "
    end
  end
  print "\n"
end

class Vertex
  property dist

  # property prev
  def initialize
    @dist = Int32::MAX
    # @prev = nil
  end

  def clone
    v = Vertex.new
    v.dist = @dist
    return v
  end
end

paths = {} of Tuple(Int32, Int32) => Vertex

grid.select { |e, v| v == Tile::SPACE || v == Tile::OXYGEN }.each do |e, v|
  paths[e] = Vertex.new
end

paths[{x, y}].dist = 0

unchecked = paths.clone
until unchecked.empty?
  node = unchecked.min_by { |e| e[1].dist }
  (0..3).to_a.each do |e|
    loc = node[0].to_a
    case e
    when 0
      loc[1] += 1
    when 1
      loc[1] -= 1
    when 2
      loc[0] -= 1
    when 3
      loc[0] += 1
    end
    if unchecked[Tuple(Int32, Int32).from(loc)]?
      place = node[1].dist + 1
      unchecked[Tuple(Int32, Int32).from(loc)].dist = place if unchecked[Tuple(Int32, Int32).from(loc)].dist > place
    end
  end
  paths[node[0]] = node[1]
  unchecked.delete_if { |e, v| e == node[0] }
end

puts paths.values.map { |e| e.dist }.max
