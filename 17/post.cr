#! /usr/bin/crystal
require "../intcode"

data = File.read("input.txt")

program = data.strip.split(",").map { |e| e.to_i64 }
program[0] = 2
intcode = Intcode.new(program)

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

botx, boty = 0, 0

grid_string = grid_string.strip

grid_string.split("\n").each_with_index do |e, i|
  e.split("").each_with_index do |e2, i2|
    tile = case e2
           when "#"
             Tile::SCAFFOLD
           when "."
             Tile::SPACE
           else
             botx, boty = i2, i
             Tile::BOT
           end
    grid[{i2, i}] = tile
  end
end

intstructions = "L12L8R10R10L6L4L12L12L8R10R10L6L4L12R10L8L4R10L6L4L12L12L8R10R10R10L8L4R10L6L4L12R10L8L4R10"

a_routine = %w(L 12 L 8 R 10 R 10)
b_routine = %w(L 6 L 4 L 12)
c_routine = %w(R 10 L 8 L 4 R 10)

routines = %w(A B A B C B A C B C)

inputs = [routines, a_routine, b_routine, c_routine]
input = inputs.map!(&.flat_map { |e2| [e2, ","] }.tap(&.pop).tap(&.<<("\n"))).flatten
input << "n"
input << "\n"
ascii_input = input.flat_map do |e|
  e.chars
end

intcode.run
spawn do
  until ascii_input.empty?
    intcode.input_channel.send(ascii_input.shift.ord.to_i64)
    Fiber.yield
  end
end

string = ""

until intcode.exited
  string += intcode.output_channel.receive.chr.to_s
end

puts string
puts string[-1].ord
