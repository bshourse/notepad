require_relative 'post'
require_relative 'task'
require_relative 'link'
require_relative 'memo'

puts "Привет, я блокнот, новой версии. Записываю новые записи в базу SQlite!"
puts "Что хотите написать в блокнот?"

choices = Post.post_types.keys # Сохраним в отдельную переменную все варианты постов которые у нас есть. А они лежат в статическом методе post_types класа Post

choice = -1 # придумаем переменную, которая будет заведомо не верная. Которая не будет являться индексом массива

until choice >= 0 && choice < choices.size #пока юзер не выбрал правильно выводим ему массив возможных типов постов

  choices.each_with_index do |type, index|
    puts "\t #{index}. #{type}"
  end

  choice = STDIN.gets.chomp.to_i
end

# и далее с помощью статического метода create класса Post, мы можем создавать объект типа Post.
# и какой именно будет дочерний класс определиться параметром choice
#
# выбор сделан, создаем запись с помощью стат. метода класса Post

entry = Post.create(choices[choice])

# Просим пользователя ввести пост (каким бы он ни был
entry.read_from_console

rowid = entry.save_to_db # метод описанный в родителе наследуются детьми

entry.save # тут также метод описанный в родителе наследуется детьми

puts "Запись сохранена в БД, id = #{rowid}"
