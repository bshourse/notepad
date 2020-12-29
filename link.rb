#Дочерний класс "Ссылка". Разновидность базового класса "Запись"
class Link < Post

  def initialize
    super #вызываем конструктор родителя
    @url = '' #добавляем специфического для ссылки поле(свойство)
  end

  def read_from_console
    #Этот метод будет спрашивать 2 строки: адрес ссылки и ее описание
    puts "Введите адрес ссылки:"
    @url = STDIN.gets.chomp.encode("utf-8")

    puts "Что это за ссылка?"
    @text = STDIN.gets.chomp.encode("utf-8")
  end

  def to_strings
    #Метод to_strings у каждого класса должен вернуть представление содержимого данного объекта класса в вивде массива
    # строк, готовых для записи в файл
    #Этот метод вернут массив из трех строк: адрес ссылки, описание и дату создания
    time_string = "Создано: #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")} \n\r \n\r"

    return [@url, @text, time_string]
  end

end
