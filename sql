-- 1. Sử dụng cơ sở dữ liệu QuanLySinhVien
CREATE DATABASE IF NOT EXISTS QuanLySinhVien;
USE QuanLySinhVien;

-- 2. Khởi tạo cấu trúc các bảng (nếu chưa có)
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

-- 3. Xóa dữ liệu cũ (nếu có) để tránh trùng lặp khi chạy lại script
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE Mark;
TRUNCATE TABLE Student;
TRUNCATE TABLE Subject;
TRUNCATE TABLE Class;
SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================================
-- 4. THỰC HIỆN CÁC CÂU LỆNH INSERT INTO THEO YÊU CẦU ĐỀ BÀI
-- =============================================================================

-- Thêm dữ liệu vào bảng Class
INSERT INTO Class (ClassID, ClassName, StartDate, Status)
VALUES 
    (1, 'A1', '2008-12-20', 1),
    (2, 'A2', '2008-12-22', 1),
    (3, 'B3', CURRENT_DATE, 0);

-- Thêm dữ liệu vào bảng Student
INSERT INTO Student (StudentName, Address, Phone, Status, ClassId)
VALUES ('Hung', 'Ha Noi', '0912113113', 1, 1);

INSERT INTO Student (StudentName, Address, Status, ClassId)
VALUES ('Hoa', 'Hai phong', 1, 1);

INSERT INTO Student (StudentName, Address, Phone, Status, ClassId)
VALUES ('Manh', 'HCM', '0123123123', 0, 2);

-- Thêm dữ liệu vào bảng Subject
INSERT INTO Subject (SubId, SubName, Credit, Status)
VALUES 
    (1, 'CF', 5, 1),
    (2, 'C', 6, 1),
    (3, 'HDJ', 5, 1),
    (4, 'RDBMS', 10, 1);

-- Thêm dữ liệu vào bảng Mark
INSERT INTO Mark (SubId, StudentId, Mark, ExamTimes)
VALUES 
    (1, 1, 8, 1),
    (1, 2, 10, 2),
    (2, 1, 12, 1);
