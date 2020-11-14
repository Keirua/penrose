IMG_WIDTH = 1000
IMG_HEIGHT = 1000

if ARGV.count < 3
  depth = 5
  nb_triangles = 10
  start_color = :red
else
  depth = ARGV[0].to_i
  nb_triangles = ARGV[1].to_i
  start_color = ARGV[2].to_sym
end

GOLDEN_RATIO = (1 + Math.sqrt(5)) / 2.0

class Point
  attr_accessor :x, :y

  def initialize(x = 0, y = 0)
    @x = x
    @y = y
  end

  def self.transform(p)
    Point.new((IMG_WIDTH/2 + p.x * 0.8 * IMG_WIDTH/2).to_i, (IMG_HEIGHT/2 + p.y * 0.8 * IMG_HEIGHT/2).to_i)
  end

  def self.lerp(a, b, alpha)
    Point.new(a.x + (b.x - a.x)*alpha, a.y + (b.y - a.y)*alpha)
  end
end

class Triangle
  attr_accessor :a, :b, :c
  attr_accessor :color

  def initialize(a, b, c, color)
    @a = a
    @b = b
    @c = c
    @color = color
  end

  def subdivide()
    result = []
    if color == :red
      p = Point.lerp(a, b, 1/GOLDEN_RATIO)
      result << [Triangle.new(c, p, b, :red), Triangle.new(p, c, a, :blue)]
    else
      q = Point.lerp(b, a, 1/GOLDEN_RATIO)
      r = Point.lerp(b, c, 1/GOLDEN_RATIO)
      result << [Triangle.new(r, c, a, :blue), Triangle.new(q, r, b, :blue), Triangle.new(r, q, a, :red)]
    end
    return result
  end
end

initial_triangles = []
nb_triangles.times do |i|
  b_complex = Complex.polar(1, ((2*i - 1)*Math::PI/10))
  c_complex = Complex.polar(1, ((2*i + 1)*Math::PI/10))

  b_complex, c_complex = c_complex, b_complex if i.even?

  b_point = Point.new(b_complex.real, b_complex.imaginary)
  c_point = Point.new(c_complex.real, c_complex.imaginary)

  initial_triangles << Triangle.new(Point.new, b_point, c_point, start_color)
end

triangles = initial_triangles

(depth-1).times do
  triangles = triangles.map { |t| t.subdivide }.flatten
end

def line(a, b, stroke_color)
  "<line x1=\"#{a.x}\" y1=\"#{a.y}\" x2=\"#{b.x}\" y2=\"#{b.y}\" stroke=\"#{stroke_color}\" />\n"
end

def triangle(a, b, c, fill_color)
  "<polygon points=\"#{a.x},#{a.y} #{b.x},#{b.y} #{c.x},#{c.y}\" fill=\"#{fill_color}\" />\n"
end

red_fill_color = '#FF6060'
blue_fill_color = '#6060FF'
stroke_color = '#404040'
img = "<svg viewBox=\"0 0 #{IMG_WIDTH} #{IMG_HEIGHT}\" xmlns=\"http://www.w3.org/2000/svg\">\n"

triangles.each do |t|
  a = Point.transform(t.a)
  b = Point.transform(t.b)
  c = Point.transform(t.c)

  img << triangle(a, b, c, t.color == :red ? red_fill_color : blue_fill_color)
  img << line(a, b, stroke_color)
  img << line(c, a, stroke_color)
end

img << "</svg>"
puts img