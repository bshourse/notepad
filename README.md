Эта версия программы дневник будет работать с БД SQlite, для хранения всех записей. 


Программа должна сохранять новую запись в базе при добавлении и по запросу пользователя выводить последние записи определенного типа (Memo, Link, Task)

**Проектируем БД:**

Каждая таблица в БД представляет какую-то сущность, например, содержит записи для каждого из объектов какого-то класса.

Для удобства все записи мы будем хранить в одной таблице posts. Как и у класса, поля в этой таблице играют ту же роль, это просто свойства этой сущности. Разумно назвать поля таблицы также, как и поля класса
