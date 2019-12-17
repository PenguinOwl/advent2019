#! /usr/bin/crystal

data = File.read("input.txt")

class Body
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
        indirects << direct
      end
      return indirects
    else
      return [] of self
    end
  end

  def direct
    return @@bodies[@orbit]?
  end
end

Body.new("", "COM")

data.lines.each do |line|
  command = line.split(")")
  Body.new(command[0], command[1])
end

Body.bodies
model = Body.bodies
directs = model.size - 1
indirects = 0
model.each do |e, v|
  indirects += v.indirects.size
end
puts directs + indirects
