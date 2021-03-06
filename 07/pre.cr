#! /usr/bin/crystal

data = File.read("input.txt")

program = data.split(",").map { |e| e.to_i }

macro resolve(x)
  (mode(modes, {{x}}) == 0 ? program[program[pointer+{{x}}]] : program[pointer+{{x}}])
end

def intcode(program : Array(Int32), inputs : Array(Int32))
  pointer = 0
  outputs = [] of Int32
  loop do
    instruction = program[pointer].to_s.rjust(2, '0')
    opcode = instruction[-2..-1].to_i
    modes = instruction[0..-2].reverse.split("").map { |e| e.to_i }
    case opcode
    when 99
      break
    when 1
      program[program[pointer + 3]] = resolve(1) + resolve(2)
      pointer += 4
    when 2
      program[program[pointer + 3]] = resolve(1) * resolve(2)
      pointer += 4
    when 3
      program[program[pointer + 1]] = inputs.delete_at(0)
      pointer += 2
    when 4
      outputs << resolve(1)
      pointer += 2
    when 5
      p1 = resolve(1)
      p2 = resolve(2)
      if p1 != 0
        pointer = p2
      else
        pointer += 3
      end
    when 6
      p1 = resolve(1)
      p2 = resolve(2)
      if p1 == 0
        pointer = p2
      else
        pointer += 3
      end
    when 7
      p1 = resolve(1)
      p2 = resolve(2)
      p3 = program[pointer + 3]
      program[p3] = (p1 < p2) ? 1 : 0
      pointer += 4
    when 8
      p1 = resolve(1)
      p2 = resolve(2)
      p3 = program[pointer + 3]
      program[p3] = (p1 == p2) ? 1 : 0
      pointer += 4
    else
      puts "stuck on #{pointer} with instruction #{instruction}"
    end
  end
  return outputs
end

def mode(modes, loc)
  if modenum = modes[loc]?
    return modenum
  else
    return 0
  end
end

runs = [0, 1, 2, 3, 4].permutations
res = [] of Int32

runs.each do |r|
  input = [0]
  r.each do |i|
    input.insert(0, i)
    input = intcode(program, input)
  end
  res << input[0]
end

puts res.max
