-- # Создание простых таблиц в PostgreSQL: полное руководство

-- PostgreSQL — это мощная объектно-реляционная СУБД, которая позволяет эффективно 
-- хранить и управлять структурированными данными. В этой статье мы рассмотрим основы создания таблиц в PostgreSQL.

-- ## 1. Базовый синтаксис создания таблицы

-- Самый простой способ создать таблицу:

-- sql
CREATE TABLE имя_таблицы (
    имя_столбца1 тип_данных [ограничения],
    имя_столбца2 тип_данных [ограничения],
    ...
);


-- ## 2. Примеры создания простых таблиц

-- ### 2.1 Таблица пользователей

-- sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);


/*
**Разбор:**
- `SERIAL` - автоинкрементный целочисленный идентификатор
- `VARCHAR(n)` - строка переменной длины (максимум n символов)
- `TIMESTAMP WITH TIME ZONE` - дата и время с часовым поясом
- `DEFAULT` - значение по умолчанию
- `PRIMARY KEY` - первичный ключ
- `UNIQUE` - гарантирует уникальность значений
- `NOT NULL` - запрещает NULL-значения
*/

-- ### 2.2 Таблица заказов

-- sql
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    order_date DATE NOT NULL DEFAULT CURRENT_DATE,
    total_amount DECIMAL(10,2) CHECK (total_amount >= 0),
    status VARCHAR(20) CHECK (status IN ('pending', 'completed', 'cancelled'))
);

/*
**Разбор:**
- `REFERENCES` - внешний ключ (связь с таблицей users)
- `DECIMAL(10,2)` - точные десятичные числа (10 цифр всего, 2 после запятой)
- `CHECK` - проверка значений при вставке/обновлении
*/

-- ## 3. Основные типы данных

/*
| Тип данных        | Описание                          | Пример                |
|-------------------|-----------------------------------|-----------------------|
| `INTEGER`         | Целое число                       | 42, -15               |
| `SERIAL`          | Автоинкрементное целое            | 1, 2, 3...            |
| `VARCHAR(n)`      | Строка переменной длины           | 'hello'               |
| `TEXT`            | Строка неограниченной длины       | Длинный текст...      |
| `BOOLEAN`         | Логическое значение               | TRUE, FALSE           |
| `DATE`            | Дата                              | '2023-01-15'          |
| `TIMESTAMP`       | Дата и время                      | '2023-01-15 14:30:00' |
| `DECIMAL(p,s)`    | Точные десятичные числа           | 123.45                |
| `JSON`/`JSONB`    | Данные в формате JSON             | `{"key": "value"}`    |
*/

-- ## 4. Добавление ограничений (constraints)

-- Ограничения помогают поддерживать целостность данных:

-- sql
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    category VARCHAR(50),
    in_stock INTEGER DEFAULT 0 CHECK (in_stock >= 0),
    CONSTRAINT unique_product UNIQUE (name, category)
);

/*
**Виды ограничений:**
- `PRIMARY KEY` - первичный ключ
- `FOREIGN KEY` - внешний ключ
- `UNIQUE` - уникальность значений
- `CHECK` - проверка условия
- `NOT NULL` - запрет NULL-значений
- `DEFAULT` - значение по умолчанию
*/

-- ## 5. Изменение существующих таблиц

-- ### 5.1 Добавление столбца

-- sql:
ALTER TABLE users ADD COLUMN phone VARCHAR(20);


### 5.2 Удаление столбца

-- sql
ALTER TABLE users DROP COLUMN phone;


-- ### 5.3 Изменение типа данных

-- sql
ALTER TABLE users ALTER COLUMN email TYPE TEXT;


-- ### 5.4 Добавление ограничения

-- sql
ALTER TABLE orders ADD CONSTRAINT positive_amount CHECK (total_amount >= 0);


-- ## 6. Удаление таблиц

-- sql
DROP TABLE IF EXISTS orders;

-- Опция `IF EXISTS` предотвращает ошибку, если таблица не существует.


-- ## 7. Практические советы

/*
1. **Именование**: Используйте понятные имена в snake_case (например, `user_orders`)
2. **Первичные ключи**: Всегда определяйте PRIMARY KEY
3. **Внешние ключи**: Для связей между таблицами
4. **Ограничения**: Используйте CHECK для валидации данных
5. **Миграции**: Для изменений в продакшене используйте системы миграций (Flyway, Liquibase)
*/

-- ## 8. Пример комплексной схемы

-- sql
CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2) CHECK (salary > 0),
    dept_id INTEGER REFERENCES departments(dept_id)
);

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    budget DECIMAL(12,2),
    start_date DATE,
    end_date DATE CHECK (end_date > start_date)
);

CREATE TABLE employee_projects (
    emp_id INTEGER REFERENCES employees(emp_id),
    project_id INTEGER REFERENCES projects(project_id),
    PRIMARY KEY (emp_id, project_id)
);

-- ## Заключение

-- Создание таблиц — фундаментальный навык работы с PostgreSQL.
-- Начните с простых структур, постепенно добавляя ограничения и связи между таблицами. 
-- Правильно спроектированная схема базы данных значительно упростит дальнейшую работу с информацией.