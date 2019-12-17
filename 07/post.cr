#! /usr/bin/crystal

data = File.read("input.txt")

program = data.split(",").map { |e| e.to_i }

macro resolve(x)
  (mode(modes, {{x}}) == 0 ? @program[@program[@pointer+{{x}}]] : @program[@pointer+{{x}}])
end

class Intcode
  property pointer
  property outputs
  property inputs
  property input_channel
  property output_channel
  property last_out
  property exited

  @program : Array(Int32)

  def initialize(program : Array(Int32))
    @pointer = 0
    @program = program.dup
    @input_channel = Channel(Int32).new
    @output_channel = Channel(Int32).new
    @last_out = 0
    @exited = false
  end

  def run
    spawn do
      loop do
        instruction = @program[@pointer].to_s.rjust(2, '0')
        opcode = instruction[-2..-1].to_i
        modes = instruction[0..-2].reverse.split("").map { |e| e.to_i }
        case opcode
        when 99
          @exited = true
          break
        when 1
          @program[@program[@pointer + 3]] = resolve(1) + resolve(2)
          @pointer += 4
        when 2
          @program[@program[@pointer + 3]] = resolve(1) * resolve(2)
          @pointer += 4
        when 3
          # puts "Waiting on #{@input_channel} for #{@output_channel}"
          @program[@program[@pointer + 1]] = @input_channel.receive
          @pointer += 2
        when 4
          @last_out = resolve(1)
          # puts "Passed #{@last_out}"
          @output_channel.send(resolve(1))
          @pointer += 2
        when 5
          p1 = resolve(1)
          p2 = resolve(2)
          if p1 != 0
            @pointer = p2
          else
            @pointer += 3
          end
        when 6
          p1 = resolve(1)
          p2 = resolve(2)
          if p1 == 0
            @pointer = p2
          else
            @pointer += 3
          end
        when 7
          p1 = resolve(1)
          p2 = resolve(2)
          p3 = @program[@pointer + 3]
          @program[p3] = (p1 < p2) ? 1 : 0
          @pointer += 4
        when 8
          p1 = resolve(1)
          p2 = resolve(2)
          p3 = @program[@pointer + 3]
          @program[p3] = (p1 == p2) ? 1 : 0
          @pointer += 4
        else
          puts "stuck on #{@pointer} with instruction #{instruction}"
        end
      end
    end
  end

  def mode(modes, loc)
    if modenum = modes[loc]?
      return modenum
    else
      return 0
    end
  end
end

runs = (5..9).to_a.permutations
res = [] of Int32

runs.each do |r|
  # puts "Trying #{r}"
  amps = [] of Intcode
  r.each do |i|
    amps << Intcode.new(program)
  end
  amps.each_with_index do |e, i|
    e.input_channel = amps[i - 1].output_channel
    spawn do
      e.input_channel.send(r[i])
    end
  end
  amps.each do |e|
    e.run
  end
  Fiber.yield
  amps[0].input_channel.send 0
  until amps.map { |e| e.exited }.includes?(true)
    Fiber.yield
  end
  res << amps.last.last_out
end

puts res.max
