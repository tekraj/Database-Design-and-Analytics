# Database Systems Assignment: PostgreSQL Schema Design and Data Manipulation
## Part 1: Database and Schema Creation

### Task 1.1: Create the Database
Connect to your PostgreSQL server and create a new database named `university_db`.

```sql
CREATE DATABASE university_db;

```

### Task 1.2: Create Relational Schemas

Create the following three related tables ensuring appropriate data types, primary keys, and foreign key relationships:

1. **`courses`**: Stores information about available university courses.
2. **`students`**: Stores student profiles.
3. **`marks`**: A junction/bridge table recording the performance of students in specific courses.

```sql
-- 1. Create Courses Table
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_code VARCHAR(10) UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL CHECK (credits > 0)
);

-- 2. Create Students Table
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    enrollment_date DATE DEFAULT CURRENT_DATE
);

-- 3. Create Marks Table
CREATE TABLE marks (
    mark_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES students(student_id) ON DELETE CASCADE,
    course_id INT REFERENCES courses(course_id) ON DELETE CASCADE,
    score NUMERIC(5, 2) NOT NULL CHECK (score >= 0 AND score <= 100),
    semester VARCHAR(10) NOT NULL,
    exam_date DATE NOT NULL,
    CONSTRAINT unique_student_course_semester UNIQUE (student_id, course_id, semester)
);

```

---

## Part 2: Data Insertion

### Task 2.1: Populate Course Data

Insert at least 4 sample courses into the `courses` table.

```sql
INSERT INTO courses (course_code, course_name, credits) VALUES
('CS101', 'Introduction to Computer Science', 4),
('MATH201', 'Calculus II', 3),
('CS202', 'Data Structures and Algorithms', 4),
('ENG102', 'Advanced Technical Writing', 2);

```

### Task 2.2: Populate Student Data

Insert at least 4 sample students into the `students` table.

```sql
INSERT INTO students (first_name, last_name, email, enrollment_date) VALUES
('Alice', 'Smith', 'alice.smith@university.edu', '2025-09-01'),
('Bob', 'Johnson', 'bob.johnson@university.edu', '2025-09-01'),
('Charlie', 'Brown', 'charlie.brown@university.edu', '2026-01-15'),
('Diana', 'Prince', 'diana.prince@university.edu', '2026-01-15');

```

### Task 2.3: Populate Marks Data

Assign scores/marks to the students for the courses they have taken.

```sql
INSERT INTO marks (student_id, course_id, score, semester, exam_date) VALUES
(1, 1, 88.50, 'Fall 2025', '2025-12-15'),
(1, 2, 92.00, 'Fall 2025', '2025-12-18'),
(2, 1, 74.00, 'Fall 2025', '2025-12-15'),
(2, 4, 85.00, 'Fall 2025', '2025-12-20'),
(3, 3, 95.50, 'Spring 2026', '2026-05-10'),
(4, 1, 91.00, 'Spring 2026', '2026-05-12'),
(4, 3, 89.00, 'Spring 2026', '2026-05-10');

```

---

## Part 3: Verification Queries (Optional Lab Exercises)

To verify your database state, run the following query to fetch a comprehensive report linking students, their enrolled courses, and their performance:

```sql
SELECT 
    s.student_id, 
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    c.course_code,
    c.course_name,
    m.score,
    m.semester
FROM marks m
JOIN students s ON m.student_id = s.student_id
JOIN courses c ON m.course_id = c.course_id
ORDER BY s.student_id, m.semester;

```