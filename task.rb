#Дочерний класс "Задача". Разновидность базового класса "Запись"
require 'date' # подключаем класс Date для работы с датами
class Task < Post

  def initialize
    super # вызываем конструктор родителя
    @due_date = Time.now
  end

  def read_from_console
    #метод будет спрашивать 2 строки: описание задачи и дедлайн
    puts "Что нужно сделать?"
    @text = STDIN.gets.chomp.encode("utf-8")

    puts "Укажите к какому числу нужно сделать задачу? Формат ДД.ММ.ГГГГ, например 10.01.2021"
    user_input = STDIN.gets.chomp.encode("utf-8")
    @due_date = Date.parse(user_input)
  end

  def to_strings
    #Метод to_strings у каждого класса должен вернуть представление содержимого данного объекта класса в вивде массива
    # строк, готовых для записи в файл
    # Массив из 3-х строк: делайн задачи, описание и дата задачи
    time_string = "Создано: #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")} \n\r \n\r"

    deadline = "Крайни срок: #{@due_date}"

    return [deadline, @text, time_string]
  end

end



