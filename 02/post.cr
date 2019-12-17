#! /usr/bin/crystal

data = STDIN.gets_to_end

(0..99).to_a.each do |a|
  (0..99).to_a.each do |b|
    program = data.split(",").map { |e| e.to_i }
    pointer = 0

    program[1] = a
    program[2] = b

    loop do
      case program[pointer]
      when 99
        break
      when 1
        program[program[pointer + 3]] = program[program[pointer + 1]] + program[program[pointer + 2]]
      when 2
        program[program[pointer + 3]] = program[program[pointer + 1]] * program[program[pointer + 2]]
      end
      pointer += 4
    end

    if program[0] == 19690720
      puts 100 * a + b
    end
  end
end
