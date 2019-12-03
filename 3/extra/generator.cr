#! /usr/bin/crystal
require "stumpy_png"

include StumpyPNG

data = STDIN.gets_to_end

locations = { {0, 0} => {0, 0} }

stuff = data.split("\n").map{|e|e.split(",")}
line_id = 0
stuff.each do |line|
  pointer = {0, 0}
  stepcount = 0
  line.each do |element|
    letter = element[0].to_s
    direction = {0, 0}
    case letter
    when "U"
      direction = {0, 1}
    when "D"
      direction = {0, -1}
    when "L"
      direction = {-1, 0}
    when "R"
      direction = {1, 0}
    end
    steps = element[1..-1].to_i
    steps.times do
      stepcount += 1
      pointer = {pointer[0] + direction[0], pointer[1] + direction[1]}
      if id = locations[pointer]?
        if id[0] != line_id
          locations[pointer] = {-1, id[1] + stepcount}
        end
      else
        locations[pointer] = {line_id, stepcount}
      end
    end
  end
  line_id += 1
end

x_bounds = locations.to_a.sort{ |e1, e2|
  e1[0][0] <=> e2[0][0]
}

min_x = x_bounds.first[0][0] - 3
max_x = x_bounds.last[0][0] + 3

y_bounds = locations.to_a.sort{ |e1, e2|
  e1[0][1] <=> e2[0][1]
}

min_y = y_bounds.first[0][1] - 3
max_y = y_bounds.last[0][1] + 3

puts min_x, max_x, min_y, max_y

canvas = Canvas.new((min_x.abs+max_x+1), (min_y.abs+max_y+1))

progress_max = locations.size
progress = 0
bg_color = RGBA.from_rgb_n(255, 255, 255, 8)

(0..(min_x.abs+max_x)).each do |x|
  (0..(min_y.abs+max_y)).each do |y|
    canvas[x, y] = bg_color
  end
end

puts locations.size

locations.each do |k, v|
  number = v[0]
  case number
  when 1
    color = RGBA.from_rgb_n(0, 255, 0, 8)
  when 2
    color = RGBA.from_rgb_n(255, 0, 0, 8)
  when -1
    color = RGBA.from_rgb_n(0, 0, 255, 8)
  else
    color = RGBA.from_rgb_n(0, 0, 0, 8)
  end
  (-2..2).each do |a|
    (-2..2).each do |b|
      canvas[k[0] - min_x + a, k[1] - min_y + b] = color
    end
  end
  puts (progress * 100 / progress_max).round(3).to_s + "%"
  progress += 1
end

StumpyPNG.write(canvas, "visual.png")
