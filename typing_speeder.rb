require 'ruby2d'

WIDTH = 600
HEIGHT = 480

set width: WIDTH
set height: HEIGHT
set background: 'gray'
set title: "typing speeder"

def draw_bottom_panel
  Rectangle.new(x: 0, y: HEIGHT - 100, width: WIDTH, height: 100, color: 'blue')
  Line.new(x1: 200, x2: 200, y1: HEIGHT - 100, y2: HEIGHT, color: 'white')
  Text.new('Press ESC to pause', x: 35, y: HEIGHT - 35, color: 'white', size: 15)
end 

def draw_pause
  Text.new('PASUED', x: 35, y: HEIGHT - 35, color: 'white', size: 15)
end

paused = false

update do
  clear

  draw_bottom_panel
  if paused
    draw_pause
    next 
  end 
end 

on :key_down do |event|
  if event.key == 'escape'
    paused = !paused
  end 
end

show
