#Дочерний класс "Задача". Разновидность базового класса "Запись"
require 'date' # подключаем класс Date для работы с датами
class Task < Post

  def initialize
    super # вызываем конструктор родителя
    @due_date = Time.now
  end

  def read_from_console
    #метод будет спрашивать 2 строки: описание задачи и дедлайн
  end

  def to_strings
    # Массив из 3-х строк: делайн задачи, описание и дата задачи
  end

end



