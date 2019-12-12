#! /usr/bin/crystal
require "../intcode"

data = File.read("input.txt")

bodies = [] of Array(Array(Int32))

data.each_line do |e|
  match = (/^<x=([-0-9]+), y=([-0-9]+), z=([-0-9]+)>$/).match(e).as(Regex::MatchData)
  bodies << [[match[1].to_i, match[2].to_i, match[3].to_i], [0, 0, 0]]
end

def step(bodies)
  bodies.each do |e|
    (bodies - [e]).each do |o|
      0.upto 2 do |i|
        if e[0][i] > o[0][i]
          e[1][i] += -1
        elsif e[0][i] < o[0][i]
          e[1][i] += 1
        end
      end
    end
  end
  bodies.each do |e|
    loc = e[0]
    vec = e[1]
    e[0] = loc.zip(vec).map { |e| e.sum }
  end
end

1000.times { step bodies }

puts bodies.map { |e| e.map { |e2| e2.map { |e3| e3.abs }.sum } }.map { |e| e[0] * e[1] }.sum
