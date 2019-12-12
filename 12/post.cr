#! /usr/bin/crystal
require "../intcode"

data = File.read("input.txt")

all_bodies = [] of Array(Array(Int32))

data.each_line do |e|
  match = (/^<x=([-0-9]+), y=([-0-9]+), z=([-0-9]+)>$/).match(e).as(Regex::MatchData)
  all_bodies << [[match[1].to_i, match[2].to_i, match[3].to_i], [0, 0, 0]]
end

def step(bodies)
  bodies.each do |e|
    (bodies - [e]).each do |o|
      if e[0] > o[0]
        e[1] += -1
      elsif e[0] < o[0]
        e[1] += 1
      end
    end
  end
  bodies.each do |e|
    e[0] += e[1]
  end
end

tally = [] of UInt64
0.upto 2 do |i|
  bodies = all_bodies.map { |e| [e[0][i], e[1][i]] }
  seen = [] of UInt64
  count = 0u64
  loop do
    step bodies
    hash = bodies.hash
    if hash == seen[0]?
      break
    else
      seen << hash
    end
    count += 1u64
  end
  puts i
  tally << count
end

puts tally[0].lcm(tally[1]).lcm(tally[2])
