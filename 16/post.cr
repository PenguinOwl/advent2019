#! /usr/bin/crystal

data = File.read("input.txt")

inputs = data.strip.split("").map{|e| e.to_i}

offset = inputs[0..6].join("").to_i

inputs *= 10000

100.times do
  partial = inputs[offset..-1].sum
  (offset...inputs.size).to_a.each do |e|
    numb = partial
    partial -= inputs[e]
    inputs[e] = numb.abs % 10
  end
end

puts inputs[offset..offset+7].join("")
