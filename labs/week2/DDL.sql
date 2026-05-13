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


