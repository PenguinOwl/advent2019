#! /usr/bin/crystal

macro check(x)
  case mode(modes, {{x}}); 
  when 1
    @pointer+{{x}}
  when 2
    while nil == @program[@program[@pointer+{{x}}]+@relative_pos]?
      @program << 0
    end
    @program[@pointer+{{x}}]+@relative_pos
  else
    while nil == @program[@program[@pointer+{{x}}]]?
      @program << 0
    end
    @program[@pointer+{{x}}]
  end
end

macro resolve(x)
  case mode(modes, {{x}}); 
  when 1
    while nil == @program[@pointer+{{x}}]?
      @program << 0
    end
    @program[@pointer+{{x}}]
  when 2
    while nil == @program[@program[@pointer+{{x}}]+@relative_pos]?
      @program << 0
    end
    @program[@program[@pointer+{{x}}]+@relative_pos]
  else
    while nil == @program[@program[@pointer+{{x}}]]?
      @program << 0
    end
    @program[@program[@pointer+{{x}}]]
  end
end

class Intcode
  property pointer
  property input_channel
  property output_channel
  property last_out
  property exited
  property waiting
  property relative_pos
  property program : Array(Int64)

  def initialize(program : Array(Int64))
    @pointer = 0_i64
    @program = program.dup
    @input_channel = Channel(Int64).new
    @output_channel = Channel(Int64).new
    @last_out = 0_i64
    @exited = false
    @waiting = false
    @relative_pos = 0_i64
  end

  def run
    spawn do
      loop do
        break if step
      end
    end
  end

  def step
    instruction = @program[@pointer].to_s.rjust(2, '0')
    opcode = instruction[-2..-1].to_i
    modes = instruction[0..-2].reverse.split("").map { |e| e.to_i }
    case opcode
    when 99
      @exited = true
      return true
    when 1
      resolve(3)
      @program[check(3)] = resolve(1) + resolve(2)
      @pointer += 4
    when 2
      resolve(3)
      @program[check(3)] = resolve(1) * resolve(2)
      @pointer += 4
    when 3
      @waiting = true
      @program[check(1)] = @input_channel.receive.to_i64
      @waiting = false
      @pointer += 2
    when 4
      @last_out = resolve(1)
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
      p3 = check(3)
      @program[p3] = (p1 < p2) ? 1_i64 : 0_i64
      @pointer += 4
    when 8
      p1 = resolve(1)
      p2 = resolve(2)
      p3 = check(3)
      @program[p3] = (p1 == p2) ? 1_i64 : 0_i64
      @pointer += 4
    when 9
      p1 = resolve(1)
      @relative_pos += p1
      @pointer += 2
    else
      puts "stuck on #{@pointer} with instruction #{instruction}"
    end
    return false
  end

  def mode(modes, loc)
    if modenum = modes[loc]?
      return modenum
    else
      return 0
    end
  end
end
