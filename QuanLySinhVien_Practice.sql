-- =============================================================================
-- BÀI TẬP: LUYỆN TẬP CÁC HÀM THÔNG DỤNG TRONG SQL
-- CSDL: QuanLySinhVien
-- =============================================================================

USE QuanLySinhVien;

-- -----------------------------------------------------------------------------
-- YÊU CẦU 1: Hiển thị tất cả thông tin môn học (Subject) có credit lớn nhất
-- Giải pháp: Dùng Subquery với MAX(Credit) để lấy tất cả môn có tín chỉ cao nhất (tránh bỏ sót khi trùng credit)
-- -----------------------------------------------------------------------------
SELECT * 
FROM Subject 
WHERE Credit = (SELECT MAX(Credit) FROM Subject);

-- -----------------------------------------------------------------------------
-- YÊU CẦU 2: Hiển thị thông tin môn học có điểm thi lớn nhất
-- Giải pháp: JOIN bảng Subject với Mark và lọc điểm bằng subquery MAX(Mark)
-- -----------------------------------------------------------------------------
SELECT 
    sub.SubId,
    sub.SubName,
    sub.Credit,
    sub.Status,
    m.Mark
FROM Subject sub
JOIN Mark m ON sub.SubId = m.SubId
WHERE m.Mark = (SELECT MAX(Mark) FROM Mark);

-- -----------------------------------------------------------------------------
-- YÊU CẦU 3: Hiển thị thông tin sinh viên và điểm trung bình của mỗi sinh viên,
-- xếp hạng theo thứ tự điểm giảm dần
-- Giải pháp: Sử dụng LEFT JOIN + GROUP BY + ORDER BY AVG(...) DESC
-- -----------------------------------------------------------------------------
SELECT 
    s.StudentId,
    s.StudentName,
    s.Address,
    s.Phone,
    s.Status,
    s.ClassId,
    AVG(m.Mark) AS AverageMark
FROM Student s
LEFT JOIN Mark m ON s.StudentId = m.StudentId
GROUP BY 
    s.StudentId, 
    s.StudentName, 
    s.Address, 
    s.Phone, 
    s.Status, 
    s.ClassId
ORDER BY AverageMark DESC;
