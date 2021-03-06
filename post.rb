# это у нас будет базовый класс "Запись".
# класс будет задавать основные методы и свойства присущие всем разновидностям Записи
# БД: подключим библиотеку sqlite
require 'sqlite3'

class Post

  # Статическое поле класса или class variable
  # аналогично статическим методам принадлежит всему классу в целом
  # и доступно незвисимо от созданных объектов

  @@SQLITE_DB_FILE = 'notepad.sqlite'

  # Теперь нам нужно будет читать объекты из базы данных
  # поэтому удобнее всегда иметь под рукой связь между классом и его именем в виде строки

  def self.post_types
    #Создаем статические методы чтобы у родителя получить массив классов его детей
    {'Memo' => Memo, 'Link' => Link, 'Task' => Task}
  end

  # Параметром теперь является строковое имя нужного класса
  def self.create(type)
    # Создадим еще один статический метод чтобы выбрать какую запись хочет создать пользователь(заметку, линк или задачу)
    return post_types[type].new
  end

  def initialize
    @text = nil # массив строк - пока пустой
    @created_at = Time.now # дата создания записи
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

  # Метод to_db_hash возвращает хэш вида {'имя_столбца' => 'значение'}
  # для сохранения в базу данных новой записи
  def to_db_hash
    # дочерние классы сами знают свое представление, но общие для всех классов поля
    # можно заполнить уже сейчас в базовом классе!
    {
        # self — ключевое слово, указывает на 'этот объект',
        # то есть конкретный экземпляр класса, где выполняется в данный момент этот код
        'type' => self.class.name,
        'created_at' => @created_at.to_s

    }
    # todo: дочерние классы должны дополнять этот хэш массив своими полями
  end

  #Напишу метод, сохраняющий состояние объекта в базу данных
  def save_to_db
    db = SQLite3::Database.open(@@SQLITE_DB_FILE) # открываем "соединение" к базе SQLite
    db.results_as_hash = true # настройка соединения к базе, результаты из базы преобразует в руби хэши
    # запрос к базе на вставку новой записи в соответствии с хэшом, сформированным дочерним классом to_db_hash
    begin
      db.execute(
          "INSERT INTO posts (" +
              to_db_hash.keys.join(', ') + #все поля, перечисленные через запятую
              ") " +
              " VALUES ( " +
              ('?,' * to_db_hash.size).chomp(',') + # строка из заданного числа _плейсхолдеров_ ?,?,?...
              ")",
          to_db_hash.values #массив значений хэша, которые будут вставлены в запрос вместо _плейсхолдеров_
      )
    rescue SQLite3::SQLException => error
      puts "Не удалось выполнить запрос в базе: #{@@SQLITE_DB_FILE}"
      abort error.message
    end

    insert_row_id = db.last_insert_row_id #в переменную запишем id записи и потом вернем ее в этом методе
    db.close #закрываем соединение к базе

    return insert_row_id # возвращаем идентификатор записи в базе
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
    current_path = File.dirname(__FILE__)

    file_name = @created_at.strftime("#{self.class.name}_%Y-%m-%d_%H-%M-%S.txt")

    return current_path + "/" + file_name
  end

  # Метод load_data заполняет переменные эземпляра из полученного хэша
  def load_data(data_hash)
    # Общее для всех детей класса Post поведение описано в методе экземпляра
    # класса Post.
    @created_at = Time.parse(data_hash['created_at'])
    @text = data_hash['text']
    # Остальные специфичные переменные должны заполнить дочерние классы в своих
    # версиях класса load_data (вызвав текущий метод с пом. super)
  end

  def self.find_by_id(id)
    db = SQLite3::Database.open(@@SQLITE_DB_FILE) # открываем соединение к базе SQLite
    # Если в параметрах передали идентификатор записи, нам надо найти эту
    # запись по идентификатору.
    db.results_as_hash = true # настройка соединения к базе, он результаты из базы преобразует в Руби хэши
    # выполняем наш запрос, он возвращает массив результатов, в нашем случае из одного элемента

    begin
      result = db.execute("SELECT * FROM posts WHERE rowid = ?", id) # по документации метод execute должен вернуть массив
    rescue SQLite3::SQLException => error
      puts "Не удалось выполнить запрос в базе: #{@@SQLITE_DB_FILE}"
      abort error.message
    end

    result = result[0] if result.is_a? Array #вернем первый элемент массива
    db.close

    if result == nil

      abort "Такой id #{id} не найден в базе"

    else
      # Продолжаем ветку выполнения, если был передан id и результат не был пустым
      # Создаем экземпляр поста
      # Мы можем узнать тип поста из запроса что получили и положили в массив результатов result
      # у нас есть статический метод create в классе post. его мы и вызовем передав тип поста
      post = create(result['type'])


      # Теперь, когда мы создали экземпляр нужного класса, заполним его
      # содержимым, передав методу load_data хэш result.
      # каждый из детей класса Post сам знает, как ему быть с такими
      # данными.
      post.load_data(result)

      #и вернем пост

      return post

    end
  end

  def self.find_all(limit, type)
    db = SQLite3::Database.open(@@SQLITE_DB_FILE) # открываем соединение к базе SQLite
    #этот метод выполняется если id не был передан
    # если нам не передали идентификатор поста (вместо него передали nil),
    # то нам надо найти все посты указанного типа (если в метод передали
    # переменную type).

    # Но для начала скажем нашему объекту соединения, что результаты не нужно
    # преобразовывать к хэшу.
    db.results_as_hash = false

    #формируем запрос с нужными условиями
    query = "SELECT rowid, * FROM posts "

    query += "WHERE type = :type " unless type.nil? # если задан тип, надо добавить условие
    query += "ORDER by rowid DESC " # добавим сортировку

    query += "LIMIT :limit " unless limit.nil? #если задан лимит, надо добавить условие

    #подготавливаем запрос в базу
    begin
      statement = db.prepare query
    rescue SQLite3::SQLException => error
      puts "Не удалось выполнить запрос в базе: #{@@SQLITE_DB_FILE}"
      abort error.message
    end

    statement.bind_param('type', type) unless type.nil? #загружаем в запрос тип вместо плейсхолдера
    statement.bind_param('limit', limit) unless limit.nil? #загружаем лимит вместо плейсхолдера

    # Выполняем запрос и записываем его в переменную result. Там будет массив
    # с данными из базы.

    begin
      result = statement.execute!
    rescue SQLite3::SQLException => error
      puts "Не удалось выполнить запрос в базе: #{@@SQLITE_DB_FILE}"
      abort error.message
    end

    # Закрываем запрос
    statement.close
    # закрываем бд
    db.close

    return result
  end
end

