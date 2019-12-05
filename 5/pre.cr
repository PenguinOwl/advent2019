#! /usr/bin/crystal

data = File.read("input.txt")

program = data.split(",").map{|e| e.to_i}
pointer = 0

loop do
  instruction = program[pointer].to_s.rjust(2, '0')
  opcode = instruction[-2..-1].to_i
  modes = instruction[0..-2].reverse.split("").map{|e| e.to_i}
  case opcode
  when 99
    break
  when 1
    program[program[pointer+3]] = (mode(modes, 1) == 0 ? program[program[pointer+1]] : program[pointer+1]) + (mode(modes, 2) == 0 ? program[program[pointer+2]] : program[pointer+2])
    pointer += 4
  when 2
    program[program[pointer+3]] = (mode(modes, 1) == 0 ? program[program[pointer+1]] : program[pointer+1]) * (mode(modes, 2) == 0 ? program[program[pointer+2]] : program[pointer+2])
    pointer += 4
  when 3
    print "Input: "
    program[program[pointer+1]] = read_line.strip.to_i
    pointer += 2
  when 4
    puts (mode(modes, 1) == 0 ? program[program[pointer+1]] : program[pointer+1])
    pointer += 2
  else
    puts "stuck on", pointer
  end
end

def mode(modes, loc)
  if modenum = modes[loc]?
    return modenum
  else
    return 0
  end
end
