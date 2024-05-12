require 'ruby2d'
possible_word_list = IO.readlines('./words.txt').map(&:strip)

WIDTH = 600
HEIGHT = 480

set width: WIDTH
set height: HEIGHT
set fps_cap: 30
set background: 'gray'
set title: 'typing speeder'

def draw_bottom_panel(current_word, seconds, lives, words_typed)
  wpm = seconds.zero? ? 0 : (words_typed / (seconds / 60.0)).truncate(2)

  Rectangle.new(x: 0, y: HEIGHT - 100, width: WIDTH, height: 100, color: 'blue')
  Line.new(x1: 200, x2: 200, y1: HEIGHT - 100, y2: HEIGHT, color: 'white')
  Text.new('Press ESC to pause', x: 35, y: HEIGHT - 35, color: 'white', size: 15)

  # left top side panel
  Text.new("time: #{seconds}", x: 20, y: HEIGHT - 90, color: 'white', size: 15)
  Text.new("lives: #{lives}",  x: 120, y: HEIGHT - 90, color: 'white', size: 15)
  # left bottom side panel
  Text.new("words: #{words_typed}", x: 20, y: HEIGHT - 65, color: 'white', size: 15)
  Text.new("wpm: #{wpm}", x: 120, y: HEIGHT - 65, color: 'white', size: 15)

  # right side panel
  Text.new(current_word, x: (WIDTH - 200) / 2 + 20, y: HEIGHT - 90, color: 'white', size: 50)
end

def draw_break_view(text)
  Text.new(text, x: WIDTH / 3 - 10, y: HEIGHT / 3, size: 45, color: 'red')
end

def generate_new_word(current_words, possible_word_list)
  return Word.new(possible_word_list.sample, WIDTH - rand(50..170), rand(0..HEIGHT - 120)) if current_words.empty?

  occupied_pos = current_words.map { |word| [word.x, word.y] }
  x = 0
  y = 0

  # avoid collision between words
  loop do
    x = WIDTH - rand(50..150)
    y = rand(0..HEIGHT - 120)
    collision = false

    occupied_pos.each do |pos|
      collision = true if (pos[0] - 40..pos[0] + 40).include?(x) && (pos[1] - 25..pos[1] + 25).include?(y)
    end

    break unless collision
  end

  Word.new(possible_word_list.sample, x, y)
end

class Word
  attr_reader :x, :y, :content

  def initialize(content, x, y)
    @content = content
    @x = x
    @y = y
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
current_words = []
words_typed = 0
lives = 5
time_start = Time.new
seconds = 0
seconds_before_pause = 0

# generate couple words to start with
5.times do
  current_words << generate_new_word(current_words, possible_word_list)
end

update do
  clear

  draw_bottom_panel(current_word, seconds, lives, words_typed)

  if lives <= 0
    draw_break_view('GAME OVER')
    next
  end

  if paused
    draw_break_view('PAUSED')
    seconds_before_pause = seconds
    time_start = Time.new
    next
  end

  seconds = seconds_before_pause + (Time.new - time_start).to_i

  current_words.each(&:draw)

  # each 1/2 of second move each words to the left
  current_words.each(&:move) if (Window.frames % 15).zero?

  # check if any word reached far left edge of the screen
  current_words.each_with_index do |word, index|
    if word.x <= 0
      lives -= 1
      current_words.delete_at(index)
    end
  end

  # each 55 frames generate new word
  current_words << generate_new_word(current_words, possible_word_list) if (Window.frames % 55).zero?
end

on :key_down do |event|
  paused = !paused if event.key == 'escape'
  next if paused

  current_word += event.key if ('a'..'z').include?(event.key) && current_word.size <= 15

  current_word = current_word.chop if event.key == 'backspace'

  if event.key == 'return'
    current_words.each_with_index do |word, index|
      if word.content == current_word
        current_words.delete_at(index)
        words_typed += 1
      end
    end
    current_word = ''
  end
end

show
