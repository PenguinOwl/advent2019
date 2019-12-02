#! /usr/bin/crystal

def fuel(int)
  result = (int / 3).floor.to_i - 2
  if result <= 0
    return int
  else
    return int + (fuel result)
  end
end

data = File.read("input.txt")
sum = 0
data.each_line do |e|
  sum += fuel(e.to_i) - e.to_i
end

puts sum
