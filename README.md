# Thực hành: Tạo CSDL Quản lý Sinh viên

## 1. Mô tả dự án
Thực hiện tạo cơ sở dữ liệu `QuanLySinhVien` và các bảng dữ liệu với đầy đủ các ràng buộc toàn vẹn (Khóa chính, Khóa ngoại, Unique, Default, Check, Auto Increment).

## 2. Sơ đồ ERD
```mermaid
erDiagram
    Class {
        int ClassID PK
        string ClassName
        datetime StartDate
        bit Status
    }

    Student {
        int StudentId PK
        string StudentName
        string Address
        string Phone
        bit Status
        int ClassId FK
    }

    Subject {
        int SubId PK
        string SubName
        tinyint Credit
        bit Status
    }

    Mark {
        int MarkId PK
        int SubId FK
        int StudentId FK
        float Mark
        tinyint ExamTimes
    }

    Class ||--o{ Student : "chua"
    Student ||--o{ Mark : "co"
    Subject ||--o{ Mark : "co"
```

## 3. Cấu trúc bảng và Ràng buộc
- **Class**: `ClassID` (PK, Auto Inc), `ClassName` (NOT NULL), `StartDate` (NOT NULL).
- **Student**: `StudentId` (PK, Auto Inc), `StudentName` (NOT NULL), `ClassId` (FK references Class).
- **Subject**: `SubId` (PK, Auto Inc), `SubName` (NOT NULL), `Credit` (DEFAULT 1, CHECK >= 1), `Status` (DEFAULT 1).
- **Mark**: `MarkId` (PK, Auto Inc), `SubId` (FK), `StudentId` (FK), `Mark` (DEFAULT 0, CHECK 0-100), `ExamTimes` (DEFAULT 1), `UNIQUE (SubId, StudentId)`.
