-- =============================================================================
-- BÀI TẬP: TRUY VẤN DỮ LIỆU VỚI CSDL QUẢN LÝ SINH VIÊN
-- =============================================================================

-- 1. KHỞI TẠO CƠ SỞ DỮ LIỆU
CREATE DATABASE IF NOT EXISTS QuanLySinhVien;
USE QuanLySinhVien;

-- 2. TẠO CẤU TRÚC BẢNG (DDL)
CREATE TABLE IF NOT EXISTS Class (
    ClassID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ClassName VARCHAR(60) NOT NULL,
    StartDate DATETIME NOT NULL,
    Status BIT
);

CREATE TABLE IF NOT EXISTS Student (
    StudentId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    StudentName VARCHAR(30) NOT NULL,
    Address VARCHAR(50),
    Phone VARCHAR(20),
    Status BIT,
    ClassId INT NOT NULL,
    FOREIGN KEY (ClassId) REFERENCES Class (ClassID)
);

CREATE TABLE IF NOT EXISTS Subject (
    SubId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    SubName VARCHAR(30) NOT NULL,
    Credit TINYINT NOT NULL DEFAULT 1 CHECK (Credit >= 1),
    Status BIT DEFAULT 1
);

CREATE TABLE IF NOT EXISTS Mark (
    MarkId INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    SubId INT NOT NULL,
    StudentId INT NOT NULL,
    Mark FLOAT DEFAULT 0 CHECK (Mark BETWEEN 0 AND 100),
    ExamTimes TINYINT DEFAULT 1,
    UNIQUE (SubId, StudentId),
    FOREIGN KEY (SubId) REFERENCES Subject (SubId),
    FOREIGN KEY (StudentId) REFERENCES Student (StudentId)
);

-- 3. CHÈN DỮ LIỆU MẪU (DML)
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE Mark;
TRUNCATE TABLE Student;
TRUNCATE TABLE Subject;
TRUNCATE TABLE Class;
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO Class (ClassID, ClassName, StartDate, Status)
VALUES 
    (1, 'A1', '2008-12-20', 1),
    (2, 'A2', '2008-12-22', 1),
    (3, 'B3', CURRENT_DATE, 0);

INSERT INTO Student (StudentName, Address, Phone, Status, ClassId)
VALUES 
    ('Hung', 'Ha Noi', '0912113113', 1, 1),
    ('Hoa', 'Hai phong', 1, 1),
    ('Manh', 'HCM', '0123123123', 0, 2);

INSERT INTO Subject (SubId, SubName, Credit, Status)
VALUES 
    (1, 'CF', 5, 1),
    (2, 'C', 6, 1),
    (3, 'HDJ', 5, 1),
    (4, 'RDBMS', 10, 1);

INSERT INTO Mark (SubId, StudentId, Mark, ExamTimes)
VALUES 
    (1, 1, 8, 1),
    (1, 2, 10, 2),
    (2, 1, 12, 1);

-- =============================================================================
-- 4. CÁC CÂU TRUY VẤN THEO YÊU CẦU ĐỀ BÀI
-- =============================================================================

-- Yêu cầu 1: Hiển thị tất cả các sinh viên có tên bắt đầu bằng ký tự 'h'
SELECT * 
FROM Student 
WHERE StudentName LIKE 'h%';

-- Yêu cầu 2: Hiển thị các thông tin lớp học có thời gian bắt đầu vào tháng 12
SELECT * 
FROM Class 
WHERE MONTH(StartDate) = 12;

-- Yêu cầu 3: Hiển thị tất cả thông tin các môn học có credit trong khoảng từ 3-5
SELECT * 
FROM Subject 
WHERE Credit BETWEEN 3 AND 5;

-- Yêu cầu 4: Thay đổi mã lớp (ClassID) của sinh viên có tên 'Hung' thành 2
UPDATE Student 
SET ClassID = 2 
WHERE StudentName = 'Hung';

-- Yêu cầu 5: Hiển thị các thông tin: StudentName, SubName, Mark.
-- Dữ liệu sắp xếp theo điểm thi (mark) giảm dần, nếu trùng sắp theo tên tăng dần.
SELECT 
    s.StudentName, 
    sub.SubName, 
    m.Mark
FROM Mark m
JOIN Student s ON m.StudentId = s.StudentId
JOIN Subject sub ON m.SubId = sub.SubId
ORDER BY m.Mark DESC, s.StudentName ASC;
