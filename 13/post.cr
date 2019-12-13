#! /usr/bin/crystal
require "../intcode"

data = File.read("input.txt")

program = data.strip.split(",").map { |e| e.to_i64 }
program[0] = 2i64
intcode = Intcode.new(program)
intcode.run

enum Tile
  EMPTY
  WALL
  BLOCK
  PADDLE
  BALL
end

grid = {} of Tuple(Int32, Int32) => Tile
score = 0
last = 0
joy = 0

loop do
  Fiber.yield
  break if intcode.exited

  output1 = intcode.output_channel.receive.to_i32
  output2 = intcode.output_channel.receive.to_i32
  output3 = intcode.output_channel.receive.to_i32
  if output1 == -1 && output2 == 0
    score = output3
  end
  grid[{output1, output2}] = Tile.new(output3)

  joy = 0

  if grid.select { |e, t| t == Tile::BALL }.size > 0 && grid.select { |e, t| t == Tile::PADDLE }.size > 0
    ball = grid.select { |e, t| t == Tile::BALL }.first_key
    ball_x = ball[0].as(Int32)
    ball_y = ball[1].as(Int32)

    paddle = grid.select { |e, t| t == Tile::PADDLE }.first_key
    paddle_x = paddle[0].as(Int32)
    paddle_y = paddle[1].as(Int32)

    if ball_x > paddle_x
      joy = 1
    elsif ball_x < paddle_x
      joy = -1
    end
  end

  Fiber.yield
  intcode.input_channel.send(joy.to_i64) if intcode.waiting
end

puts score
