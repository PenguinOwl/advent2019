#! /usr/bin/crystal
require "../intcode"

data = STDIN.gets_to_end

program = data.split(",").map { |e| e.to_i }
pointer = 0

program[1] = 12
program[2] = 2

puts Intcode::Parser.new.text(program.join(","))[0]
