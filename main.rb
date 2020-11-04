IMG_WIDTH = 1000
IMG_HEIGHT = 1000

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
    # result = []
    # if color == :even
    #     # Subdivide red triangle
    #     P = A + (B - A) / goldenRatio
    #     result += [(0, C, P, B), (1, P, C, A)]
    # else
    #     # Subdivide blue triangle
    #     Q = B + (A - B) / goldenRatio
    #     R = B + (C - B) / goldenRatio
    #     result += [(1, R, C, A), (1, Q, R, B), (0, R, Q, A)]
    # return result
  end
end

triangles = []
N = 10
N.times do |i|
  b_complex = Complex.polar(1, ((2*i - 1)*Math::PI/N))
  c_complex = Complex.polar(1, ((2*i + 1)*Math::PI/N))

  b_complex, c_complex = c_complex, b_complex if i.even?

  b_point = Point.new(b_complex.real, b_complex.imaginary)
  c_point = Point.new(c_complex.real, c_complex.imaginary)

  triangles << Triangle.new(Point.new, b_point, c_point, :red)
end

def line(a, b, stroke_color)
  "<line x1=\"#{a.x}\" y1=\"#{a.y}\" x2=\"#{b.x}\" y2=\"#{b.y}\" stroke=\"#{stroke_color}\" />\n"
end

def triangle(a, b, c, fill_color)
  "<polygon points=\"#{a.x},#{a.y} #{b.x},#{b.y} #{c.x},#{c.y}\" fill=\"#{fill_color}\" />\n"
end

img = "<svg viewBox=\"0 0 #{IMG_WIDTH} #{IMG_HEIGHT}\" xmlns=\"http://www.w3.org/2000/svg\">\n"

odd_fill_color = '#FF6060'
stroke_color = '#6060FF'

triangles.each do |t|
  a = Point.transform(t.a)
  b = Point.transform(t.b)
  c = Point.transform(t.c)

  img << triangle(a, b, c, odd_fill_color)
  img << line(a, b, stroke_color)
  img << line(c, a, stroke_color)
end

img << "</svg>"
puts img