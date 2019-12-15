#! /usr/bin/crystal

def step(bodies)
  bodies.each do |e|
    (bodies - [e]).each do |o|
      if e[0] > o[0]
        e[1] += -1
      elsif e[0] < o[0]
        e[1] += 1
      end
    end
  end
  bodies.each do |e|
    e[0] += e[1]
  end
end

all = {} of Array(Array(Array(Int32))) => UInt64

(-20..20).to_a.each do |point1_x|
  all_bodies = [] of Array(Array(Int32))
  (-20..20).to_a.each do |point1_y|
    (-20..20).to_a.each do |point1_z|
      all_bodies << [[point1_x, point1_y, point1_z], [0, 0, 0]]
      (-20..20).to_a.each do |point2_x|
        (-20..20).to_a.each do |point2_y|
          (-20..20).to_a.each do |point2_z|
            all_bodies << [[point2_x, point2_y, point2_z], [0, 0, 0]]
            (-20..20).to_a.each do |point3_x|
              (-20..20).to_a.each do |point3_y|
                (-20..20).to_a.each do |point3_z|
                  all_bodies << [[point2_x, point2_y, point2_z], [0, 0, 0]]
                  (-20..20).to_a.each do |point4_x|
                    (-20..20).to_a.each do |point4_y|
                      (-20..20).to_a.each do |point4_z|
                        all_bodies << [[point2_x, point2_y, point2_z], [0, 0, 0]]

                        tally = [] of UInt64
                        0.upto 2 do |i|
                          bodies = all_bodies.map { |e| [e[0][i], e[1][i]] }
                          seen = [] of UInt64
                          count = 0u64
                          loop do
                            step bodies
                            hash = bodies.hash
                            if hash == seen[0]? # seen.includes? hash
                              break
                            else
                              seen << hash
                            end
                            count += 1u64
                          end
                          tally << count
                        end

                        all[all_bodies.clone] = tally[0].lcm(tally[1]).lcm(tally[2])

                        puts all.size
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

top = all.values.max

puts all
puts all.select { |i, e| e == top }
