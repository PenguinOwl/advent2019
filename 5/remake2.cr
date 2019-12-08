#! /usr/bin/crystal
require "../intcode"

data = File.read("input.txt")

program = data.split(",").map { |e| e.to_i }

vm = Intcode.new(program)
vm.run
vm.input_channel.send 5
puts vm.output_channel.receive
