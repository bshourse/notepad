# это у нас будет базовый класс "Запись".
# класс будет задавать основные методы и свойства присущие всем разновидностям Записи
class Post

  def self.post_types
    #Создаем статические методы чтобы у родителя получить массив классов его детей
    [Memo, Link, Task]
  end

  def self.create(type_index)
    # Создадим еще один статический метод чтобы выбрать какую запись хочет создать пользователь(заметку, линк или задачу)
    return post_types[type_index].new
  end

  def initialize
    @text = nil
    @created_at = Time.now
  end

  def read_from_console
    #этот метод будет вызываться в программе когда нужно будет считать ввод пользователя
    # и записать его данные в нужные поля объекта
    # данный метод будет реализован классами-детьми, которые знают как именно считывать свои
    # данные из консоли
  end

  def to_strings
    #Этот метод возвращает состояние объекта в виде массива строк
    # готовых к записи в файл
    # должен быть реализован классами-детьми которые знают как именно хранить себя в файле
  end

  def save
    #Этот метод записывает текущее состояние объекта в файл
    file = File.new(file_path, "w")

    for item in to_strings do
      file.puts(item)
    end
    file.close
  end

    def file_path
      current_path = File.dirname(__FILE__ )

      file_name = @created_at.strftime("#{self.class.name}_%Y-%m-%d_%H-%M-%S.txt")

      return current_path + "/" + file_name
    end
end
