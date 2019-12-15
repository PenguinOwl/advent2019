#! /usr/bin/crystal
require "../intcode"

data = File.read("input.txt")

class Pool
  macro set(x, y)
    @contents[{{x}}] = 0 unless @contents[{{x}}]?
    @contents[{{x}}] {{y.id}}
  end

  property recipes
  property contents
  property ore

  def initialize
    @recipes = {} of Tuple(String, Int32) => Array(Tuple(String, Int32))
    @contents = {} of String => Int32
    @ore = 0
  end

  def consume(string, count)
    if string == "ORE"
      @ore += count
    else
      create(string, count)
      set(string, "-= count")
    end
  end

  def create(string, count)
    recipe = @recipes.select { |e, v| e[0] == string }.to_a.first
    @contents[string] = 0 unless @contents[string]?
    until @contents[string] >= count
      recipe[1].each { |e| consume(*e) }
      @contents[recipe[0][0]] += recipe[0][1]
    end
  end
end

def quantize(string)
  data = string.split(" ")
  return {data[1], data[0].to_i}
end

pool = Pool.new

data.each_line do |e|
  sides = e.split(" => ")
  result = quantize(sides[1])
  ingredients = sides[0].split(", ").map { |e| quantize(e) }
  pool.recipes[result] = ingredients
end

pool.consume(*quantize("1 FUEL"))
puts pool.ore
