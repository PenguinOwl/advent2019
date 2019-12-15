#! /usr/bin/crystal
require "../intcode"

data = File.read("input.txt")

program = data.strip.split(",").map { |e| e.to_i64 }
intcode = Intcode.new(program)
intcode.run

grid = { {0, 0} => true }

direction = {0, 1}
pointer = {0, 0}
count = 0

loop do
  puts intcode.program
  count += 1
  intcode.input_channel.send(grid[pointer]? == true ? 1i64 : 0i64)
  exit if count == 5
  o1, o2 = intcode.output_channel.receive, intcode.output_channel.receive
  break if intcode.exited
  grid[pointer] = o1 == 1i64
  direction = case o2.to_i
              when 1
                case direction
                when {0, 1}
                  {1, 0}
                when {1, 0}
                  {0, -1}
                when {0, -1}
                  {-1, 0}
                else {-1, 0}
                {0, 1}
                end
              when 0
                case direction
                when {0, 1}
                  {-1, 0}
                when {1, 0}
                  {0, 1}
                when {0, -1}
                  {1, 0}
                else {-1, 0}
                {0, -1}
                end
              else
                {1, 0}
              end
  pointer = typeof(pointer).from(pointer.zip(direction).map { |e| e.sum })
end
