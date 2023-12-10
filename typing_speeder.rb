require 'ruby2d'

WIDTH = 600
HEIGHT = 480

set width: WIDTH
set height: HEIGHT
set background: 'gray'
set title: "typing speeder"

def draw_bottom_panel(current_word)
  Rectangle.new(x: 0, y: HEIGHT - 100, width: WIDTH, height: 100, color: 'blue')
  Line.new(x1: 200, x2: 200, y1: HEIGHT - 100, y2: HEIGHT, color: 'white')
  Text.new('Press ESC to pause', x: 35, y: HEIGHT - 35, color: 'white', size: 15)

  Text.new(current_word, x: (WIDTH - 200) / 2 + 20 , y: HEIGHT - 90, color: 'white', size: 50)
end 

def draw_pause
  Text.new('PAUSED', x: WIDTH / 3, y: HEIGHT / 3, size: 45, color: 'red')
end

paused = false
current_word = ''

update do
  clear

  draw_bottom_panel(current_word)
  if paused
    draw_pause
    next 
  end 
end 

on :key_down do |event|
  paused = !paused if event.key == 'escape'

  if ('a'..'z').to_a.include?(event.key)
    current_word += event.key.upcase unless current_word.size > 15
  end 

  if event.key == 'backspace'
    current_word = current_word.chop
  end 

  if event.key == 'return'
    current_word = ''
  end 
end

show
