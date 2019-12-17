#! /usr/bin/crystal

data = File.read("input.txt")

image = data.strip.split("").map { |e| e.to_i }.in_groups_of(25*6).map { |e| e.in_groups_of(25) }

lowest = -1
beat = Int32::MAX
image.each_with_index do |e, i|
  if e.flatten.count(0) < beat
    beat = e.flatten.count(0)
    lowest = i
  end
end

best = image[lowest].flatten

puts best.count(1) * best.count(2)
