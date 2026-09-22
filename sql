USE QuanLySinhVien;

-- 1. Hiển thị tất cả các sinh viên có tên bắt đầu bằng ký tự 'h' (hoặc 'H')
SELECT * 
FROM Student 
WHERE StudentName LIKE 'h%';

-- 2. Hiển thị thông tin các lớp học có thời gian bắt đầu vào tháng 12
SELECT * 
FROM Class 
WHERE MONTH(StartDate) = 12;

-- 3. Hiển thị tất cả thông tin các môn học có số tín chỉ (Credit) trong khoảng từ 3 đến 5
SELECT * 
FROM Subject 
WHERE Credit BETWEEN 3 AND 5;

-- 4. Thay đổi mã lớp (ClassID) của sinh viên có tên 'Hung' thành 2
UPDATE Student 
SET ClassID = 2 
WHERE StudentName = 'Hung';

-- 5. Hiển thị các thông tin: StudentName, SubName, Mark.
-- Dữ liệu sắp xếp theo điểm thi (Mark) giảm dần, nếu trùng điểm sắp theo tên tăng dần.
SELECT 
    s.StudentName, 
    sub.SubName, 
    m.Mark
FROM Mark m
JOIN Student s ON m.StudentId = s.StudentId
JOIN Subject sub ON m.SubId = sub.SubId
ORDER BY m.Mark DESC, s.StudentName ASC;
