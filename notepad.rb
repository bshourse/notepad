require_relative 'post'
require_relative 'task'
require_relative 'link'
require_relative 'memo'

puts "Привет, я блокнот!"
puts "Что хотите написать в блокнот?"

choices = Post.post_types # Сохраним в отдельную переменную все варианты постов которые у нас есть. А они лежат в статическом методе post_types класа Post

choice = -1 # придумаем переменную, которая будет заведомо не верная. Которая не будет являться индексом массива

until choice >= 0 && choice < choices.size

  choices.each_with_index do |type, index|
    puts "\t #{index}. #{type}"
  end

  choice = STDIN.gets.chomp.to_i
end

# и далее с помощью статического метода create класса Post, мы можем создавать объект типа Post.
# и какой именно будет дочерний класс определиться параметром choice
#

entry = Post.create(choice)

entry.read_from_console
entry.save

puts "Ура запись сохранена!"
