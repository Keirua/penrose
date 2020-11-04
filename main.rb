require 'chunky_png'

img_width = 1000
img_height = 1000

background = background = ChunkyPNG::Color::WHITE

img = ChunkyPNG::Image.new(img_width + 1, img_height + 1, background)

# img.polygon(points, color, color)
# img.line(west_x, base_y, mid_x, apex_y, wall)


img.save "penrose.png"