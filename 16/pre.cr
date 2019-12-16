#! /usr/bin/crystal
require "../intcode"

data = File.read("input.txt")

inputs = data.strip.split("").map{|e| e.to_i}

def get_mul(mul, ind)
  base = [0, 1, 0, -1]
  ind += 1
  return base[ (ind // (mul + 1)) % 4 ]
end

100.times do
  new_inputs = inputs.map_with_index do |e, i|
    total = 0
    inputs.each_with_index do |e2, i2|
      total += e2 * get_mul(i, i2)
    end
    total.to_s[-1].to_i
  end
  inputs = new_inputs
end

puts inputs[0..7].join("")
