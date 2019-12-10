#! /usr/bin/crystal

data = File.read("input.txt")

array = data.split("\n").map { |e| e.split("") }
astriods = [] of Tuple(Int32, Int32)
counts = {} of Tuple(Int32, Int32) => Int32

array.each_with_index do |e, r|
  e.each_with_index do |e2, c|
    astriods << {c, r} if e2 == "#"
  end
end

i = {22, 19}
others = astriods.dup
others.delete i
angles = {} of Tuple(Int32, Int32) => Array(Tuple(Int32, Int32))
others.each do |i2|
  x = i2[0] - i[0]
  y = i2[1] - i[1]
  gcd = x.gcd y
  unless angles[{x//gcd, y//gcd}]?
    angles[{x//gcd, y//gcd}] = [] of Tuple(Int32, Int32)
  end
  angles[{x//gcd, y//gcd}] << i2
end

polar = angles.map do |i, e|
  trig = Math.atan2(i[1], i[0])
  # if i[0] == 0
  #   trig = (i[1] > 0) ? (Math::PI / 2) : (3 * Math::PI / 2)
  # end
  trig += (Math::PI / 2)
  trig %= Math::PI * 2
  {trig, e}
end

mapb = polar.to_a.sort_by { |e| e[0] }
map = mapb.clone

pointer = 0
count = 0

until map.empty?
  pointer %= map.size
  map[pointer][1].pop
  if count == 199
    puts mapb.select { |e| e[0] == map[pointer][0] }
    exit
  else
    count += 1
  end
  if map[pointer][1].empty?
    map.delete_at(pointer)
  else
    pointer += 1
  end
end
