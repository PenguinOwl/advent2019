#! /usr/bin/crystal
require "../intcode"

data = File.read("input.txt")

program = data.strip.split(",").map{|e| e.to_i64}
intcode = Intcode.new(program)
intcode.run

grid = { {0, 0} => true }

direction = {0, 1}
pointer = {0, 0}

loop do
  intcode.input_channel.send( grid[pointer]? == true ? 1i64 : 0i64 )
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
  pointer = typeof(pointer).from(pointer.zip(direction).map{|e| e.sum})
end

bounds = grid.keys.transpose
xoffset = bounds[0].min
yoffset = bounds[1].min
xcap = bounds[0].max
ycap = bounds[1].max

final = Array(Array(Bool)).new(1 + ycap - yoffset) { Array(Bool).new(1 + xcap - xoffset, false) }

grid.each do |k, v|
  final[k[1] - yoffset][k[0] - xoffset] = v
end

final.reverse.each do |line|
  line.each do |numb|
    if numb
      print "█"
    else
      print " "
    end
  end
  print "\n"
end
