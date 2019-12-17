#! /usr/bin/crystal

data = STDIN.gets_to_end

sum = 0
data.each_line do |e|
  sum += (e.to_i / 3).floor.to_i - 2
end

puts sum
