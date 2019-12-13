#! /usr/bin/crystal
require "../intcode"

data = File.read("input.txt")

program = data.strip.split(",").map { |e| e.to_i64 }
intcode = Intcode.new(program)
intcode.run

enum Tile
  EMPTY
  WALL
  BLOCK
  PADDLE
  BALL
end

grid = {} of Tuple(Int32, Int32) => Tile

loop do
  Fiber.yield
  break if intcode.exited
  output1 = intcode.output_channel.receive.to_i32
  output2 = intcode.output_channel.receive.to_i32
  output3 = intcode.output_channel.receive.to_i32
  grid[{output1, output2}] = Tile.new(output3)

  #   bounds = grid.keys.transpose
  #   xoffset = bounds[0].min
  #   yoffset = bounds[1].min
  #   xcap = bounds[0].max
  #   ycap = bounds[1].max
  #
  #   final = Array(Array(Tile)).new(1 + ycap - yoffset) { Array(Tile).new(1 + xcap - xoffset, Tile.new(0)) }
  #
  #   grid.each do |k, v|
  #     final[k[1] - yoffset][k[0] - xoffset] = v
  #   end
  #
  #   final.reverse.each do |line|
  #     line.each do |tile|
  #       if tile != Tile::EMPTY
  #         print "█"
  #       else
  #         print " "
  #       end
  #     end
  #     print "\n"
  #   end

end

bounds = grid.keys.transpose
xoffset = bounds[0].min
yoffset = bounds[1].min
xcap = bounds[0].max
ycap = bounds[1].max

final = Array(Array(Tile)).new(1 + ycap - yoffset) { Array(Tile).new(1 + xcap - xoffset, Tile.new(0)) }

grid.each do |k, v|
  final[k[1] - yoffset][k[0] - xoffset] = v
end

count = 0

final.reverse.each do |line|
  line.each do |tile|
    if tile == Tile::BLOCK
      count += 1
    end
  end
end

puts count
