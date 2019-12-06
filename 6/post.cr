#! /usr/bin/crystal

data = File.read("input.txt")

struct Body
  @@bodies = {} of String => Body

  def Body.bodies
    return @@bodies
  end

  property orbit : String
  property name : String

  def initialize(orbit, name)
    @orbit = orbit
    @name = name
    @@bodies[name] = self
  end

  def indirects
    unless @orbit == ""
      indirects = @@bodies[@orbit].indirects
      if direct = @@bodies[@orbit].direct
        indirects.insert 0, direct
      end
      return indirects
    else
      return [] of self
    end
  end

  def direct
    return @@bodies[@orbit]?
  end

  def orbits
    res = indirects
    if primary = direct
      res.insert 0, primary
    end
    return res
  end
end

Body.new("", "COM")

data.lines.each do |line|
  command = line.split(")")
  Body.new(command[0], command[1])
end

Body.bodies
model = Body.bodies

you_orbits = model["YOU"].orbits
san_orbits = model["SAN"].orbits

common = (you_orbits & san_orbits)[0]
transfers = 0
you_orbits.each do |orbit|
  transfers += 1
  break if orbit == common
end
san_orbits.each do |orbit|
  transfers += 1
  break if orbit == common
end
puts transfers - 2
