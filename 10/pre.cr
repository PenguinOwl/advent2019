#! /usr/bin/crystal
require "../intcode"

data = File.read("input.txt")

def run(data)
array = data.split("\n").map { |e| e.split("") }
astriods = [] of Tuple(Int32, Int32)
counts = {} of Tuple(Int32, Int32) => Int32

array.each_with_index do |e, r|
  e.each_with_index do |e2, c|
    astriods << {c, r} if e2 == "#"
  end
end

astriods.each do |i|
  others = astriods.dup
  others.delete i
  angles = Set(Tuple(Int32, Int32)).new
  others.each do |i2|
    x = i2[0] - i[0]
    y = i2[1] - i[1]
    gcd = x.gcd y
    angles << {x//gcd, y//gcd}
  end
  counts[i] = angles.size
end

return counts.max_by { |i, e| e }
end

puts run(data)
