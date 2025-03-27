-- # **DDL, DML, DCL и другие категории SQL-команд: полный обзор**

-- SQL-команды делятся на несколько категорий в зависимости от их назначения.
-- В этой статье мы разберем основные группы команд и их применение.

-- ## **1. DDL (Data Definition Language) — Язык определения данных**

-- **Назначение**: Создание, изменение и удаление структуры объектов БД.

-- ### **Основные команды DDL**:

/*
-- | Команда       | Описание                                                                 |
-- |---------------|--------------------------------------------------------------------------|
-- | `CREATE`      | Создает новые объекты (таблицы, индексы, представления и т.д.)          |
-- | `ALTER`       | Изменяет структуру существующих объектов                                |
-- | `DROP`        | Удаляет объекты из БД                                                   |
-- | `TRUNCATE`    | Удаляет все данные из таблицы, сохраняя ее структуру                    |
-- | `RENAME`      | Переименовывает объекты                                                 |
-- | `COMMENT`     | Добавляет комментарии к объектам БД                                     |
*/

-- **Пример DDL**:
-- sql
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10,2)
);

ALTER TABLE employees ADD COLUMN department VARCHAR(50);

DROP TABLE employees;


-- ## **2. DML (Data Manipulation Language) — Язык управления данными**

-- **Назначение**: Работа с данными внутри объектов БД.

-- ### **Основные команды DML**:

/*
| Команда       | Описание                                                                 |
|---------------|--------------------------------------------------------------------------|
| `SELECT`      | Извлекает данные из таблиц                                               |
| `INSERT`      | Добавляет новые записи                                                  |
| `UPDATE`      | Изменяет существующие записи                                            |
| `DELETE`      | Удаляет записи                                                          |
| `MERGE`       | Объединяет операции INSERT, UPDATE и DELETE (UPSERT)                    |
*/

-- **Пример DML**:
-- sql
INSERT INTO employees VALUES (1, 'Иван Иванов', 50000, 'IT');

UPDATE employees SET salary = 55000 WHERE id = 1;

DELETE FROM employees WHERE id = 1;

SELECT * FROM employees WHERE department = 'IT';

-- ## **3. DCL (Data Control Language) — Язык управления доступом**

-- **Назначение**: Управление правами доступа к объектам БД.

-- ### **Основные команды DCL**:

/*
| Команда       | Описание                                                                 |
|---------------|--------------------------------------------------------------------------|
| `GRANT`       | Дает права пользователям или ролям                                       |
| `REVOKE`      | Отзывает ранее выданные права                                            |
| `DENY`        | Запрещает определенные действия (в некоторых СУБД)                       |
*/

-- **Пример DCL**:
-- sql
GRANT SELECT, INSERT ON employees TO manager;

REVOKE DELETE ON employees FROM assistant;


-- ## **4. TCL (Transaction Control Language) — Язык управления транзакциями**

-- **Назначение**: Управление транзакциями в БД.

-- ### **Основные команды TCL**:

/*
| Команда       | Описание                                                                 |
|---------------|--------------------------------------------------------------------------|
| `COMMIT`      | Подтверждает транзакцию                                                 |
| `ROLLBACK`    | Отменяет транзакцию                                                     |
| `SAVEPOINT`   | Создает точку сохранения внутри транзакции                              |
| `SET TRANSACTION` | Устанавливает характеристики текущей транзакции                      |
*/

-- **Пример TCL**:
-- sql
BEGIN TRANSACTION;
INSERT INTO accounts (user_id, amount) VALUES (1, 1000);
SAVEPOINT savepoint1;
UPDATE accounts SET amount = amount - 100 WHERE user_id = 1;
-- Если что-то пошло не так:
ROLLBACK TO savepoint1;
-- Или подтвердить все изменения:
COMMIT;


-- ## **5. DQL (Data Query Language) — Язык запросов данных**

-- **Назначение**: Извлечение данных (часто включают в DML).

-- | Команда       | Описание                                                                 |
-- |---------------|--------------------------------------------------------------------------|
-- | `SELECT`      | Единственная команда в этой категории                                   |

-- **Пример DQL**:
-- sql
SELECT name, salary FROM employees WHERE department = 'Sales' ORDER BY salary DESC;


-- ## **6. SCL (Session Control Language) — Язык управления сессиями**

-- **Назначение**: Управление параметрами сессии.

/*
| Команда       | Описание                                                                 |
|---------------|--------------------------------------------------------------------------|
| `ALTER SESSION` | Изменяет параметры текущей сессии (в Oracle и др.)                     |
| `SET`         | Устанавливает параметры сессии (в PostgreSQL, MySQL)                    |
*/

-- **Пример SCL**:
-- sql
-- PostgreSQL
SET search_path TO hr, public;

-- Oracle
ALTER SESSION SET NLS_DATE_FORMAT = 'DD.MM.YYYY';


-- ## **Сравнительная таблица категорий SQL**

/*
| Категория | Основное назначение               | Характер операций             | Примеры команд               |
|-----------|-----------------------------------|-------------------------------|------------------------------|
| DDL       | Определение структуры             | Автокоммит                    | CREATE, ALTER, DROP          |
| DML       | Манипуляция данными               | Требует явного коммита        | SELECT, INSERT, UPDATE       |
| DCL       | Управление доступом               | Автокоммит                    | GRANT, REVOKE                |
| TCL       | Управление транзакциями           | Управление транзакциями       | COMMIT, ROLLBACK             |
| DQL       | Запросы данных                    | Чтение данных                 | SELECT                       |
| SCL       | Управление сессиями               | Настройка окружения           | SET, ALTER SESSION           |
*/

/*
## **Почему важно понимать различия?**

1. **Безопасность**: DCL команды критичны для защиты данных
2. **Производительность**: DDL операции часто блокируют таблицы
3. **Целостность данных**: TCL команды обеспечивают согласованность
4. **Оптимизация**: Разные категории требуют разных подходов к настройке

## **Заключение**

Понимание категорий SQL-команд помогает:
- Лучше организовывать код
- Правильно планировать миграции
- Эффективно управлять правами доступа
- Контролировать транзакции

Все эти категории вместе образуют мощный язык для работы с реляционными базами данных,
позволяя выполнять любые операции — от создания структуры до сложных выборок и управления доступом.
*/