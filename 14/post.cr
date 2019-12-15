#! /usr/bin/crystal
require "../intcode"

data = File.read("input.txt")

class Pool
  property recipes
  property contents
  property ore

  def initialize
    @recipes = {} of Tuple(String, UInt64) => Array(Tuple(String, UInt64))
    @contents = {} of String => UInt64
    @ore = 0u64
  end

  def clone
    p = Pool.new
    p.recipes = @recipes.clone
    p.contents = @contents.clone
    p.ore = @ore.clone
    return p
  end

  def clear
    @recipes.each do |e, v|
      @contents[e[0]] = 0u64
    end
  end

  def create(string, count)
    recipe = @recipes.select { |e, v| e[0] == string }.to_a.first
    @contents[string] = 0u64 unless @contents[string]?
    needed = recipe[1].clone.map { |e| {e[0], e[1] * count} }
    until needed.empty?
      item = needed.pop
      if item[0] == "ORE"
        @ore += item[1]
      else
        if @contents[item[0]] >= item[1]
          @contents[item[0]] -= item[1]
          next
        elsif @contents[item[0]] > 0u64
          item = {item[0], item[1] - @contents[item[0]]}
          @contents[item[0]] = 0u64
        end

        itemrecipe = @recipes.select { |e, v| e[0] == item[0] }.to_a.first
        multi = item[1] // itemrecipe[0][1] + 1u64
        @contents[item[0]] += itemrecipe[0][1] * multi - item[1]
        itemrecipe[1].each { |e| needed << {e[0], e[1] * multi} }
      end
    end
  end
end

def quantize(string)
  data = string.split(" ")
  return {data[1], data[0].to_u64}
end

base = Pool.new

data.each_line do |e|
  sides = e.split(" => ")
  result = quantize(sides[1])
  ingredients = sides[0].split(", ").map { |e| quantize(e) }
  base.recipes[result] = ingredients
end

found = (0u64..9999999u64).to_a.bsearch { |e|
  pool = base.clone
  pool.clear
  pool.create("FUEL", e)
  pool.ore >= 1000000000000u64
}

puts found.as(UInt64) - 1u64
