erDiagram
    DV_KHACH {
        string MaDV PK
        string TenDV
        string DiaChi
        string DienThai
    }

    NGUOI_DAT {
        string MaSoND PK
        string HoTenND
        string MaDV FK
    }

    NGUOI_NHAN {
        string MaSoNN PK
        string HoTenNN
        string MaDV FK
    }

    HANG {
        string MaHang PK
        string TenHang
        string DvTinh
        string MoTaHang
    }

    NGUOI_GIAO {
        string MaSoNG PK
        string HoTenNG
    }

    NOI_GIAO {
        string MaSoDDG PK
        string TenNoiGiao
    }

    DAT_HANG {
        string SoDH
        date NgayDat
        int SoLuong
    }

    GIAO_HANG {
        string SoPG
        date NgayGiao
        int SoLuong
        double DonGia
    }

    DV_KHACH ||--o{ NGUOI_DAT : "Thuoc 1"
    DV_KHACH ||--o{ NGUOI_NHAN : "Thuoc 2"
    NGUOI_DAT ||--o{ DAT_HANG : "Thuc hien"
    HANG ||--o{ DAT_HANG : "Duoc dat"
    NGUOI_GIAO ||--o{ GIAO_HANG : "Phu trách"
    NGUOI_NHAN ||--o{ GIAO_HANG : "Nhan hang"
    NOI_GIAO ||--o{ GIAO_HANG : "Giao tai"
    HANG ||--o{ GIAO_HANG : "Duoc giao"
