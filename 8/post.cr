#! /usr/bin/crystal

data = File.read("input.txt")

image = data.strip.split("").map { |e| e.to_i }.in_groups_of(25*6).map { |e| e.in_groups_of(25) }

hash = {} of Tuple(Int32, Int32) => Int32
image.reverse.each do |layer|
  layer.each_with_index do |e, r|
    e.each_with_index do |e2, c|
      if e2.as(Int32) < 2
        hash[{r, c}] = e2.as(Int32)
      end
    end
  end
end

puts hash

final = Array(Array(Int32)).new(6) { Array(Int32).new(25, 0) }

hash.each do |k, v|
  final[k[0]][k[1]] = v
end

final.each do |line|
  line.each do |numb|
    print numb
  end
  print "\n"
end
