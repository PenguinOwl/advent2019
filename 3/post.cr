#! /usr/bin/crystal

data = STDIN.gets_to_end

locations = { {0, 0} => {0, 0} }

stuff = data.split("\n").map { |e| e.split(",") }
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

answer = locations.to_a.select { |v| v[1][0] < 0 }.sort { |e1, e2|
  e1[1][1] <=> e2[1][1]
}[0]

puts answer[1][1]
