#Дочерний класс "Заметка", разновидность базового класса "Запись"
class Memo < Post

  #отдельный конструктор писать не будем ибо он в точности совпадает с родительским

  def read_from_console
    #Он будет спрашивать ввод содержимого Заметки
    puts "Все что вы введете до \"end\" попадет в заметку"

    @text = []
    line = ''

    while line != "end"
      line = STDIN.gets.chomp.encode("utf-8")
      @text << line
    end

    @text.pop
  end

  def to_strings
    #Метод to_strings у каждого класса должен вернуть представление содержимого данного объекта класса в вивде массива
    # строк, готовых для записи в файл
    time_string = "Создано: #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")} \n\r \n\r"

    return @text.unshift(time_string)

  end

end
