CREATE DATABASE sql_session4;
USE sql_session4;

-- bảng sv
CREATE TABLE student(
	stu_id INT AUTO_INCREMENT PRIMARY KEY,
    stu_fullname VARCHAR(100) NOT NULL,
    stu_date DATE NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE

);	

-- bảng gv 
CREATE TABLE teacher(
	teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    teacher_fullname VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE

);
 
-- bảng course 
CREATE TABLE course(
	course_id INT AUTO_INCREMENT PRIMARY KEY,
	course_name VARCHAR(100) NOT NULL,
    desscription TEXT,
	num_of_lession TINYINT NOT NULL,
    teacher_id INT,
    FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id) ON DELETE CASCADE,
    UNIQUE(course_id,teacher_id)
);

-- bảng đăng ký 

CREATE TABLE enrollment(
	enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    stu_id INT NOT NULL,
	course_id INT NOT NULL,
    date_enrollment DATE DEFAULT(CURRENT_DATE()),
    FOREIGN KEY (stu_id) REFERENCES student(stu_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES course(course_id) ON DELETE CASCADE,
    UNIQUE(stu_id,course_id)
);

-- bảng kết quả
CREATE TABLE result(
	result_id INT AUTO_INCREMENT PRIMARY KEY,
    stu_id INT NOT NULL,
	course_id INT NOT NULL,
    midterm FLOAT NOT NULL CHECK(midterm >= 0 AND midterm <= 10 ),
    end_of_term FLOAT NOT NULL CHECK(end_of_term >= 0 AND end_of_term <= 10 ),
    UNIQUE(stu_id,course_id),
    FOREIGN KEY (stu_id) REFERENCES student(stu_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES course(course_id) ON DELETE CASCADE
); 


-- Nhập dữ liệu ban đầu
-- Thêm ít nhất 5 sinh viên
INSERT INTO student
VALUES	(NULL,'Nguyen Van A','2007-01-02','nva@gmail.com'),
		(NULL,'Tran Thi B','2007-01-02','ttb@gmail.com'),
		(NULL,'Le Van C','2007-01-02','lvc@gmail.com'),
        (NULL,'Kieu Thi B','2007-01-02','ktb@gmail.com'),
        (NULL,'Do Tien Nam','2007-01-02','dtn@gmail.com');
		
-- Thêm ít nhất 5 giảng viên
INSERT INTO teacher
VALUES	(NULL, 'Nguyễn Văn An ','nguyenvanan@example.com'),
		(NULL, 'Trần Thị Bích ','tranthibich.dev@example.com'),
        (NULL, 'Lê Hoàng Nam','nam.lehoang@example.com'),
        (NULL, 'Phạm Quỳnh Hương','huongpham.work@example.com'),
        (NULL, 'Vũ Đức Minh','vuducminh.contact@example.com');
        
-- Thêm ít nhất 5 khóa học
INSERT INTO course
VALUES	(NULL, 'Lập trình C/C++ nền tảng', 'Cung cấp kiến thức cơ bản về cú pháp, cấu trúc điều khiển và tư duy logic lập trình.', 24, 1),
		(NULL, 'Thiết kế Web Frontend', 'Hướng dẫn xây dựng giao diện web từ cơ bản đến nâng cao với HTML, CSS (Flexbox, Grid).', 20, 1),
        (NULL, 'JavaScript và thao tác DOM', 'Tập trung vào xử lý logic hướng đối tượng, các phương thức mảng và tạo hiệu ứng tương tác.', 18, 2),
        (NULL, 'Cơ sở dữ liệu quan hệ MySQL', 'Học cách thiết kế schema, tạo bảng, viết truy vấn SQL và quản lý khóa ngoại.', 16, 3),
        (NULL, 'Phát triển phần mềm thực chiến', 'Quy trình xây dựng các dự án quản lý thực tế trong môi trường phát triển phần mềm.', 12, 5);
		
-- Thêm dữ liệu đăng ký học cho sinh viên
INSERT INTO enrollment
VALUES	(NULL,1, 3,'2026-04-04'),
		(NULL,4, 5,'2026-05-04'),
        (NULL,2, 3,'2026-04-14'),
        (NULL,2, 1,'2026-07-10'),
        (NULL,3, 2,'2026-07-04');
		
-- Thêm dữ liệu kết quả học tập cho sinh viên
INSERT INTO result
VALUES	(NULL, 1, 1,8.9, 9.0),
		(NULL, 3, 2, 7.5, 8.0);


-- Cập nhật dữ liệu
-- Cập nhật email cho một sinh viên
UPDATE student
SET email = 'lalala@gmail.com'
WHERE stu_id = 1;

-- Cập nhật mô tả cho một khóa học
UPDATE course
SET desscription = 'zxcvbnm,masdfghjklwertyui'
WHERE course_id = 4;
		
-- Cập nhật điểm cuối kỳ cho một sinh viên
UPDATE result
SET end_of_term = 10
WHERE stu_id = 1;

--  Xóa dữ liệu
-- Xóa một lượt đăng ký học không hợp lệ
DELETE FROM result
WHERE result_id = 1;

DELETE FROM student
WHERE stu_id = 2;

-- Truy vấn dữ liệu
-- Lấy danh sách tất cả sinh viên (Student)
SELECT stu_id, stu_fullname, stu_date, email FROM student;

-- Lấy danh sách giảng viên (Teacher)
SELECT teacher_id, teacher_fullname, email FROM teacher;

-- Lấy danh sách các khóa học (Course)
SELECT course_id, course_name, desscription, num_of_lession, teacher_id FROM course;

-- Lấy thông tin các lượt đăng ký khóa học (Enrollment)
SELECT enrollment_id, stu_id, course_id, date_enrollment FROM enrollment;

-- Lấy thông tin các lần đánh giá kết quả (Score)
SELECT result_id, stu_id, course_id, midterm, end_of_term FROM result;








