-- # Создание и использование схем в PostgreSQL

-- ## Введение в схемы PostgreSQL

-- Схемы в PostgreSQL представляют собой пространства имен, которые позволяют организовать объекты
-- базы данных в логические группы. Они выполняют несколько ключевых функций:

-- 1. **Логическая организация** - группировка связанных объектов
-- 2. **Изоляция** - разделение объектов между разными приложениями или пользователями
-- 3. **Безопасность** - управление доступом на уровне схем
-- 4. **Управление** - упрощение администрирования больших баз данных

-- ## Создание схем

-- ### Базовый синтаксис

-- sql
CREATE SCHEMA schema_name
    [AUTHORIZATION owner_name]
    [schema_element [...]];


-- ### Примеры создания

-- 1. Простая схема:
-- sql
CREATE SCHEMA hr;


-- 2. Схема с указанием владельца:
-- sql
CREATE SCHEMA accounting AUTHORIZATION accountant;


-- 3. Схема с одновременным созданием объектов:
-- sql
CREATE SCHEMA inventory
    CREATE TABLE products (
        product_id SERIAL PRIMARY KEY,
        name VARCHAR(100) NOT NULL
    )
    CREATE VIEW active_products AS
        SELECT * FROM inventory.products
        WHERE is_active = true;


-- ## Управление схемами

-- ### Просмотр существующих схем

-- sql
SELECT schema_name 
FROM information_schema.schemata;


-- ### Изменение схем

-- 1. Переименование:
-- sql
ALTER SCHEMA hr RENAME TO human_resources;


-- 2. Изменение владельца:
-- sql
ALTER SCHEMA finance OWNER TO new_finance_manager;


-- ### Удаление схем

-- sql
DROP SCHEMA IF EXISTS temp_schema CASCADE;

-- Опция `CASCADE` автоматически удаляет все объекты в схеме.

-- ## Практическое применение схем

-- ### 1. Организация по функциональности

-- sql
CREATE SCHEMA hr;
CREATE SCHEMA finance;
CREATE SCHEMA logistics;


--### 2. Мультитенантная архитектура

-- sql
-- Для каждого клиента отдельная схема
CREATE SCHEMA client_a;
CREATE SCHEMA client_b;

-- Общие справочники в основной схеме
CREATE SCHEMA shared;


-- ### 3. Управление версиями

-- sql
CREATE SCHEMA v1;
CREATE SCHEMA v2;
-- Можно переключаться между версиями


-- ## Настройка поиска (search_path)

-- PostgreSQL использует параметр `search_path` для определения порядка поиска объектов:

-- sql
-- Установка для текущей сессии
SET search_path TO hr, public;

-- Установка по умолчанию для пользователя
ALTER ROLE app_user SET search_path = hr, public;


-- ## Управление доступом

-- ### Предоставление прав

-- sql
GRANT USAGE ON SCHEMA hr TO hr_manager;
GRANT SELECT ON ALL TABLES IN SCHEMA hr TO hr_analyst;


-- ### Отзыв прав

-- sql
REVOKE CREATE ON SCHEMA finance FROM junior_accountant;


-- ## Продвинутые техники

-- ### 1. Перенос объектов между схемами

-- sql
ALTER TABLE public.employees SET SCHEMA hr;


-- ### 2. Шаблоны схем

-- sql
-- Создание шаблона
CREATE SCHEMA template_schema
    CREATE TABLE common_settings (
        param_name VARCHAR(100) PRIMARY KEY,
        param_value TEXT
    );

-- Использование шаблона
CREATE SCHEMA new_department;
CREATE TABLE new_department.common_settings 
    (LIKE template_schema.common_settings INCLUDING ALL);


--### 3. Временные схемы для тестирования

-- sql
CREATE SCHEMA test_schema;
-- Выполнение тестов...
DROP SCHEMA test_schema CASCADE;


/*
## Лучшие практики

1. **Именование схем**:
   - Используйте понятные, описательные имена
   - Придерживайтесь единого стиля (snake_case или camelCase)
   - Избегайте зарезервированных имен (pg_*, information_schema)

2. **Организация**:
   - Группируйте связанные объекты вместе
   - Разделяйте данные приложений и системные объекты
   - Используйте public только для общедоступных объектов

3. **Безопасность**:
   - Ограничивайте права доступа к схемам
   - Не давайте лишних привилегий
   - Используйте отдельные схемы для разных ролей

4. **Производительность**:
   - Оптимизируйте search_path
   - Избегайте избыточного количества схем
   - Учитывайте влияние на планировщик запросов

## Заключение

Схемы PostgreSQL - мощный инструмент для:

- Логической организации сложных баз данных
- Реализации мультитенантных архитектур
- Управления доступом с высокой гранулярностью
- Упрощения миграций и обновлений

Правильное использование схем значительно улучшает:
- Структуру базы данных
- Безопасность
- Удобство администрирования
- Масштабируемость приложений

Начните с простой структуры и расширяйте ее по мере роста вашей системы, используя схемы для логического разделения компонентов.
*/