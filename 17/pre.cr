#! /usr/bin/crystal
require "../intcode"

data = File.read("input.txt")

program = data.strip.split(",").map { |e| e.to_i64 }
intcode = Intcode.new(program)
intcode.run

enum Tile
  SPACE
  SCAFFOLD
  BOT
  INTERSECTION
end

# grid = {} of Tuple(Int32, Int32) => Tile
grid = { {0, 0} => Tile::SPACE }

direction = 0
x, y = 0, 0
grid_string = ""

until intcode.exited
  grid_string += intcode.output_channel.receive.chr
end

grid_string = grid_string.strip

grid_string.split("\n").each_with_index do |e, i|
  e.split("").each_with_index do |e2, i2|
    tile = case e2
           when "#"
             Tile::SCAFFOLD
           when "."
             Tile::SPACE
           else
             Tile::BOT
           end
    grid[{i2, i}] = tile
  end
end

sum = 0

grid.each do |i, e|
  if e == Tile::SCAFFOLD
    corners = 0
    [{-1, 0}, {1, 0}, {0, -1}, {0, 1}].each do |x, y|
      tile = grid[{i[0] + x, i[1] + y}]?
      corners += 1 if tile == Tile::SCAFFOLD || tile == Tile::BOT || tile == Tile::INTERSECTION
    end
    if corners >= 3
      sum += i[0] * i[1]
      grid[i] = Tile::INTERSECTION
    end
  end
end

# bounds = grid.keys.transpose
# xoffset = bounds[0].min
# yoffset = bounds[1].min
# xcap = bounds[0].max
# ycap = bounds[1].max
#
# final = Array(Array(Tile)).new(1 + ycap - yoffset) { Array(Tile).new(1 + xcap - xoffset, Tile::SPACE) }
#
# grid.each do |k, v|
#   final[k[1] - yoffset][k[0] - xoffset] = v
# end
#
# final.each do |line|
#   line.each do |tile|
#     string = case tile
#              when Tile::SPACE
#                " "
#              when Tile::BOT
#                "&"
#              when Tile::SCAFFOLD
#                "#"
#              when Tile::INTERSECTION
#                "0"
#              end
#     print string
#   end
#   print "\n"
# end

puts sum
