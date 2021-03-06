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

  # вызываем родительский метод ключевым словом super и к хэшу, который он вернул
  # присоединяем прицепом специфичные для этого класса поля методом Hash#merge
  def to_db_hash
    return super.merge(
        {
            'text' => @text.join('\n\r') #массив строк делаем одной большой строкой, разделенной символами перевода строки
        }
    )
  end

  def load_data(data_hash)
    super(data_hash) # сперва дергаем родительский метод для общих полей
    # теперь прописываем свое специфичное поле
    @text = data_hash['text'].split('\n')
  end

end
