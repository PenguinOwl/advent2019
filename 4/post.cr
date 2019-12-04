#! /usr/bin/crystal

data = STDIN.gets_to_end

range = data.strip.split("-")
range = range[0]..range[1]

succ = [] of String

range.each do |e|
  array = e.to_s.split("")
  match = false
  temp = nil
  array.each do |e|
    if e == temp
      match = true
      break
    else
      temp = e
    end
  end
  next unless match
  puts e
  next unless array.map{|e|e.to_i} == array.map{|e|e.to_i}.sort
  next if array.tally.select{|k, v| v == 2}.empty?
  succ << e
end

puts succ.size
