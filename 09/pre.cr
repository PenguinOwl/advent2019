#! /usr/bin/crystal
require "../intcode"

data = File.read("input.txt")

program = data.split(",").map { |e| e.to_i64 }

intcode = Intcode.new(program)
intcode.run
intcode.input_channel.send(1)
packet = intcode.output_channel.receive
puts packet
