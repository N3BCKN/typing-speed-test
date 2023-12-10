require 'ruby2d'
word_list = IO.readlines('./words.txt').map(&:strip)

WIDTH = 600
HEIGHT = 480

set width: WIDTH
set height: HEIGHT
set fps_cap: 30
set background: 'gray'
set title: "typing speeder"


def draw_bottom_panel(current_word, seconds, lives)
  Rectangle.new(x: 0, y: HEIGHT - 100, width: WIDTH, height: 100, color: 'blue')
  Line.new(x1: 200, x2: 200, y1: HEIGHT - 100, y2: HEIGHT, color: 'white')
  Text.new('Press ESC to pause', x: 35, y: HEIGHT - 35, color: 'white', size: 15)

  # left top side panel 
  Text.new("time: #{seconds}", x: 20, y: HEIGHT - 90, color: 'white', size: 15)
  Text.new("lives: #{lives}",  x: 60, y: HEIGHT - 90, color: 'white', size: 15)
  # left bottom side panel 
  Text.new('words:', x: 20, y: HEIGHT - 65, color: 'white', size: 15)

  # right side panel 
  Text.new(current_word, x: (WIDTH - 200) / 2 + 20 , y: HEIGHT - 90, color: 'white', size: 50)
end 

def draw_pause_view
  Text.new('PAUSED', x: WIDTH / 3, y: HEIGHT / 3, size: 45, color: 'red')
end

class Word
  attr_reader :x, :y, :content

  def initialize(content)
    @content = content
    @x = WIDTH - rand(50..150)
    @y = rand(0..HEIGHT-120)
  end
  
  def draw
    Text.new(@content, x: @x, y: @y, size: 20, color: 'blue')
  end

  def move
    @x -= 5
  end
end

paused = false
current_word = ''
words = []
lives = 0
time_start = Time.new 
seconds = 0
seconds_before_pause = 0

# generate couple words to start with 
5.times do
  words << Word.new(word_list.sample)
  words.each(&:draw)
end

update do
  clear
  
  draw_bottom_panel(current_word, seconds, lives)

  if paused
    draw_pause_view
    seconds_before_pause = seconds
    time_start = Time.new
    next 
  end 

  seconds = seconds_before_pause + (Time.new - time_start).to_i
  
  words.each(&:draw)

  # each 3 seconds generate new word 
  words << Word.new(word_list.sample) if Window.frames % 90 == 0 

  # each 2/3 of second move each words to the left 
  words.each(&:move) if Window.frames % 20 == 0 

end 

on :key_down do |event|
  paused = !paused if event.key == 'escape'
  next if paused

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
