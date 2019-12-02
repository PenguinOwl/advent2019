#! /usr/bin/crystal

data = File.read("input.txt")
program = data.split(",").map{|e| e.to_i}
pointer = 0

program[1] = 12
program[2] = 2

loop do
  case program[pointer]
  when 99
    puts program[0]
    break
  when 1
    program[program[pointer+3]] = program[program[pointer+1]] + program[program[pointer+2]]
  when 2
    program[program[pointer+3]] = program[program[pointer+1]] * program[program[pointer+2]]
  end
  pointer += 4
end
