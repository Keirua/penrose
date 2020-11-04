IMG_WIDTH = 1000
IMG_HEIGHT = 1000

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

def line(x1, y1, x2, y2, stroke_color)
  "<line x1=\"#{x1}\" y1=\"#{y1}\" x2=\"#{x2}\" y2=\"#{y2}\" stroke=\"#{stroke_color}\" />\n"
end

img = "<svg viewBox=\"0 0 #{IMG_WIDTH} #{IMG_HEIGHT}\" xmlns=\"http://www.w3.org/2000/svg\">\n"

triangles.each do |t|
  a = Point.transform(t.a)
  b = Point.transform(t.b)
  c = Point.transform(t.c)

  img << line(a.x, a.y, b.x, b.y, 'red')
  img << line(b.x, b.y, c.x, c.y, 'green')
  img << line(c.x, c.y, a.x, a.y, 'blue')

end

img << "</svg>"
puts img