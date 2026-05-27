-- Create Database
-- character set utf8mb4 is used to support a wide range of characters, including emojis and special symbols.


-- collate utf8mb4_general_ci is used to ensure that the data stored in 
-- the database is sorted and compared in a case-insensitive manner, which is important for user data such as names and emails.
-- This collation also supports a wide range of characters, making it suitable for internationalization.
-- 
CREATE DATABASE IF NOT EXISTS `pgs` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Use Database
USE `pgs`;

-- ENgine InnoDB is used for its support of transactions, foreign keys, and better performance with large datasets.
-- This engine also supports foreign keys, which are used to establish relationships between tables in the database.
-- Another Engine is MyISAM, which is optimized for read-heavy operations and does not support transactions or foreign keys.


-- Create Table

drop table students;
CREATE TABLE IF NOT EXISTS `students` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `address` varchar(255) not null,
  `dob` DATETIME not null,
  `mobile` varchar(15) not null,
  `registration_number` varchar(255) not null,
  `created_at` DATETIME NOT NULL,
  `updated_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;



create table if not exists programs (
  id int not null auto_increment,
  name varchar(255) not null,
  created_at datetime not null,
  updated_at datetime not null,
  primary key (id)
);

Alter table students add column program_id int not null;
Alter table students add foreign key (program_id) references programs(id);


create table if not exists courses (
  id int not null auto_increment,
  name varchar(255) not null,
  course_code varchar(50) not null,
  created_at datetime not null,
  updated_at datetime not null,
  primary key (id)
);

create table if not exists student_courses (
  id int not null auto_increment,
  student_id int not null,
  course_id int not null,
  credits int not null,
  start_date datetime not null,
  end_date datetime not null,
  marks int not null,
  grade varchar(5) not null,
  created_at datetime not null,
  updated_at datetime not null,
  primary key (id),
  foreign key (student_id) references students(id),
  foreign key (course_id) references courses(id)
);


create table fees (
  id int not null auto_increment,
  student_id int not null,
  amount decimal(10,2) not null,
  due_date datetime not null,
  status enum('paid', 'unpaid', 'pending') not null,
  created_at datetime not null,
  updated_at datetime not null,
  primary key (id),
  foreign key (student_id) references students(id)
);


-- Create Attendance Table
create table if not exists attendance (
  id int not null auto_increment,
  student_id int not null,
  course_id int not null,
  date datetime not null,
  status enum('present', 'absent', 'late') not null,
  created_at datetime not null default current_timestamp,
  updated_at datetime not null default current_timestamp on update current_timestamp,
  primary key (id),
  foreign key (student_id) references students(id),
  foreign key (course_id) references courses(id)
);

INSERT INTO programs(name, created_at, updated_at)
 VALUES('BBA', now(), now());

INSERT INTO students(name, email, address,
 dob, mobile, registration_number, created_at, updated_at, program_id)

 VALUES('Hari Prasad', 'hari@westcliff.edu', 'New Baneshwor',
 '2026-01-01','9800000000','1234', now(), now(),  2);



insert into courses(name, course_code, created_at, updated_at)
 values('Database Systems', 'CS101', now(), now()),
 ('Python Programming', 'CS102', now(), now()),
 ('Data Structures', 'CS103', now(), now()),
 ('Algorithms', 'CS104', now(), now()),
 ('Operating Systems', 'CS105', now(), now());


insert into student_courses(student_id, course_id, credits, start_date, end_date,
 marks, grade, created_at, updated_at)
 values(1, 1, 3, '2026-01-01', '2026-06-01', 85, 'A', now(), now()),
 (1, 2, 3, '2026-01-01', '2026-06-01', 90, 'A+', now(), now()),
 (1, 3, 3, '2026-01-01', '2026-06-01', 80, 'B+', now(), now());

INSERT INTO attendance(
  student_id,
  course_id,
  date,
  status,
  created_at,
  updated_at ,
)
VALUES (1,1,now(),'attend',now(),now());





-- MYSQL Data Types

-- Numeric
  -- BIT: A bit-field type, used to store binary values (0 or 1), can be used for flags.
  -- TINYINT: Very small integer, ranges from -128 to 127 (signed) or 0 to 255 (unsigned), 1 byte.
  -- SMALLINT: Small integer, ranges from -32,768 to 32,767 (signed) or 0 to 65,535 (unsigned), 2 bytes.
  -- MEDIUMINT: Medium-sized integer, ranges from -8,388,608 to 8,388,607 (signed) or 0 to 16,777,215 (unsigned), 3 bytes.
  -- INT / INTEGER: Standard integer, ranges from -2,147,483,648 to 2,147,483,647 (signed) or 0 to 4,294,967,295 (unsigned), 4 bytes.
  -- BIGINT: Large integer, ranges from -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807 (signed) or 0 to 18,446,744,073,709,551,615 (unsigned), 8 bytes.
  -- DECIMAL / DEC / NUMERIC / FIXED: Exact fixed-point numbers, used for storing precise values such as monetary amounts, user-defined precision and scale.
  -- FLOAT: Single-precision floating-point number, approximate numeric data type, 4 bytes.
  -- DOUBLE / DOUBLE PRECISION: Double-precision floating-point number, approximate numeric data type, 8 bytes.
  -- REAL (alias, mode-dependent): Alias for DOUBLE or FLOAT, depending on SQL mode.
  -- BOOL / BOOLEAN (alias of TINYINT(1)): Used to represent Boolean values, actually stored as TINYINT(1), where 0 is false and 1 is true.
  
  
  -- Date and Time
    -- DATE: Stores date values (YYYY-MM-DD), no time part.
    -- DATETIME: Stores date and time (YYYY-MM-DD HH:MM:SS), no timezone.
    -- TIMESTAMP: Stores date and time, converted from/to UTC, affected by time zone.
    -- TIME: Stores time values (HH:MM:SS), no date part.
    -- YEAR: Stores year values in 2-digit or 4-digit format.

  -- Character and Binary Strings
    -- CHAR: Fixed-length character string, padded with spaces.
    -- VARCHAR: Variable-length character string, up to 65,535 bytes.
    -- BINARY: Fixed-length binary data, padded with zeros.
    -- VARBINARY: Variable-length binary data.
    -- TINYBLOB: Very small binary large object, up to 255 bytes.
    -- BLOB: Binary large object, up to 65,535 bytes.
    -- MEDIUMBLOB: Medium-sized binary large object, up to 16 MB.
    -- LONGBLOB: Large binary large object, up to 4 GB.
    -- TINYTEXT: Very small text string, up to 255 characters.
    -- TEXT: Text string, up to 65,535 characters.
    -- MEDIUMTEXT: Medium-sized text string, up to 16 MB.
    -- LONGTEXT: Large text string, up to 4 GB.
    -- ENUM: String object with one value chosen from a list of permitted values.
    -- SET: String object with zero or more values chosen from a list of permitted values.

    -- JSON
      -- JSON: Stores JSON-formatted data, supports validation and manipulation.


  -- Spatial
    -- GEOMETRY: Base type for all spatial data types.
    -- POINT: Stores a single point in 2D space (X, Y).
    -- LINESTRING: Stores a sequence of points forming a line.
    -- POLYGON: Stores a polygon, defined by one or more closed rings.
    -- MULTIPOINT: Stores a collection of points.
    -- MULTILINESTRING: Stores a collection of linestrings.
    -- MULTIPOLYGON: Stores a collection of polygons.
    -- GEOMETRYCOLLECTION: Stores a collection of geometry objects (points, lines, polygons).




-- Design New Database for Simple Library management system
-- Tables
-- Authors (id, name, bio, created_at, updated_at)
-- Books (id, title, author_id, published_date, isbn, created_at, updated_at)
-- Members (id, name, email, address, created_at, updated_at)
-- BookRentals (id, book_id, member_id, rental_date, return_date, created_at,
-- updated_at)



Create database `library_management` default character set utf8mb4 collate utf8mb4_general_ci;

use `library_management`;

create table if not exists authors (
  id int not null auto_increment,
  name varchar(255) not null,
  bio text,
  created_at datetime not null,
  updated_at datetime not null,
  primary key (id)
);

create table if not exists books (
  id int not null auto_increment,
  title varchar(255) not null,
  author_id int not null,
  published_date date not null,
  isbn varchar(20) not null,
  created_at datetime not null,
  updated_at datetime not null,
  primary key (id),
  foreign key (author_id) references authors(id)
);

create table if not exists members (
  id int not null auto_increment,
  name varchar(255) not null,
  email varchar(255) not null,
  address varchar(255) not null,
  created_at datetime not null,
  updated_at datetime not null,
  primary key (id)
);


create table if not exists book_rentals (
  id int not null auto_increment,
  book_id int not null,
  member_id int not null,
  rental_date datetime not null,
  return_date datetime,
  created_at datetime not null,
  updated_at datetime not null,
  primary key (id),
  foreign key (book_id) references books(id),
  foreign key (member_id) references members(id)
);

-- Alter Statements
-- For Add New Column
-- For Modify Column
-- For Drop Column
-- For Rename Column
-- For Rename Table
-- For Add Foreign Key
-- For Drop Foreign Key
-- For Add Primary Key
-- For Drop Primary Key
-- For Add Unique Key
-- For Drop Unique Key
-- For Add Index
-- For Drop Index
-- For Add Check Constraint
-- For Drop Check Constraint

ALTER TABLE books ADD COLUMN genre VARCHAR(50) NOT NULL;
ALTER TABLE books MODIFY COLUMN published_date DATETIME NOT NULL;
-- ALTER TABLE books DROP COLUMN genre;
ALTER TABLE books RENAME COLUMN published_date TO publication_date;
-- ALTER TABLE books RENAME TO library_books;
-- ALTER TABLE book_rentals ADD FOREIGN KEY (book_id) REFERENCES books(id);
-- ALTER TABLE book_rentals DROP FOREIGN KEY book_id;
-- ALTER TABLE book_rentals ADD PRIMARY KEY (id);
-- ALTER TABLE book_rentals DROP PRIMARY KEY;
ALTER TABLE members ADD UNIQUE (email);
-- ALTER TABLE members DROP INDEX email;
-- ALTER TABLE members ADD INDEX idx_name (name);
-- ALTER TABLE members DROP INDEX idx_name;
ALTER TABLE books ADD CHECK (publication_date <= CURDATE());


alter table books add column price decimal(10,2) not null;
ALTER TABLE books ADD CONSTRAINT chk_price CHECK (price > 0);

-- INSERT Data Into Database
-- INSERT DATA into Library ( ALL TABLES and At Least 3 Rows on each Table)
INSERT INTO authors (name, bio, created_at, updated_at) VALUES 
('J.K. Rowling', 'British author, best known for the Harry Potter series.', now(), now()),
('George R.R. Martin', 'American novelist and short story writer, known for A Song of Ice and Fire series.', now(), now()),
('Agatha Christie', 'English writer known for her detective novels and short stories.', now(), now());


INSERT INTO books (title, author_id, publication_date, isbn, genre, price, created_at, updated_at) VALUES 
('Harry Potter and the Sorcerer''s Stone', 1, '1997-06-26', '978-0439708180', 'Fantasy', 19.99, now(), now()),
('A Game of Thrones', 2, '1996-08-06', '978-0553103540', 'Fantasy', 22.99, now(), now());

INSERT INTO members (name, email, address, created_at, updated_at) VALUES 
('Alice Smith', 'alice.smith@example.com', '123 Main St, Anytown, USA', now(), now()),
('Bob Johnson', 'botjonson@gmail.com', '456 Elm St, Othertown, USA', now(), now()),
('Charlie Brown', 'charliebrown@gmail.com','789 Oak St, Sometown, USA', now(), now());

INSERT INTO book_rentals (book_id, member_id, rental_date, return_date, created_at, updated_at) VALUES 
(1, 1, '2024-01-01', '2024-01-15', now(), now()),
(2, 2, '2024-01-05', '2024-01-20', now(), now()),
(1, 3, '2024-01-10', NULL, now(), now());




-- Design New Database for Simple E-commerce system
-- Tables
-- Customers (id, name, email, address, created_at, updated_at)
-- Products (id, name, description, price, stock_quantity, created_at, updated_at)
-- Orders (id, customer_id, order_date, total_amount, created_at, updated_at)
-- OrderItems (id, order_id, product_id, quantity, price, created_at, updated_at)


create database `ecommerce` default character set utf8mb4 collate utf8mb4_general_ci;
use `ecommerce`;
create table if not exists customers (
  id int not null auto_increment,
  name varchar(255) not null,
  email varchar(255) not null,
  address varchar(255) not null,
  created_at datetime not null,
  updated_at datetime not null,
  primary key (id)
);

create table if not exists products (
  id int not null auto_increment,
  name varchar(255) not null,
  description text,
  price decimal(10,2) not null,
  stock_quantity int not null,
  created_at datetime not null,
  updated_at datetime not null,
  primary key (id)
);

create table if not exists orders (
  id int not null auto_increment,
  customer_id int not null,
  order_date datetime not null,
  total_amount decimal(10,2) not null, 
  created_at datetime not null,
  updated_at datetime not null,
  primary key (id),
  foreign key (customer_id) references customers(id)
);


create table if not exists order_items (
  id int not null auto_increment,
  order_id int not null,
  product_id int not null,
  quantity int not null,
  price decimal(10,2) not null,
  created_at datetime not null,
  updated_at datetime not null,
  primary key (id),
  foreign key (order_id) references orders(id),
  foreign key (product_id) references products(id)
);


INSERT INTO products (name, description, price,stock_quantity,created_at,updated_at)
VALUES ('wiwi','Noodles',20.00,100,now(),now()),
('coke','Soft Drink',10.00,200,now(),now()),
('bread','Whole Wheat Bread',15.00,150,now(),now());

INSERT INTO customers (name, email, address, created_at, updated_at) VALUES 
('John Doe', 'john.doe@example.com', '123 Main St, Anytown, USA', now(), now()),
('Jane Smith', 'jane.smith@example.com', '456 Elm St, Othertown, USA', now(), now()),
('Alice Johnson', 'alice.johnson@example.com', '789 Oak St, Sometown, USA', now(), now());

INSERT INTO orders (customer_id, order_date, total_amount, created_at, updated_at) VALUES 
(1, '2024-01-01', 50.00, now(), now()),
(2, '2024-01-05', 30.00, now(), now()),
(3, '2024-01-10', 45.00, now(), now());

INSERT INTO order_items (order_id, product_id, quantity, price, created_at, updated_at) VALUES 
(1, 1, 2, 20.00, now(), now()),
(1, 2, 1, 10.00, now(), now()),
(2, 3, 3, 15.00, now(), now()),
(3, 1, 1, 20.00, now(), now()),
(3, 3, 2, 15.00, now(), now());

update books set name = 'Harry Potter and the Philosopher''s Stone' , published_date = '1997-06-26' where id = 1;

delete from book_rentals where id = 3;


alter table customers add column dob datetime   default rand() * (now() - '1950-01-01') + '1950-01-01';

