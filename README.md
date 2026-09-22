erDiagram
    DV_KHACH {
        string MaDV PK
        string TenDV
        string DiaChi
        string DienThoai
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

    NGUOI_GIAO {
        string MaSoNG PK
        string HoTenNG
    }

    NOI_GIAO {
        string MaSoDDG PK
        string TenNoiGiao
    }

    HANG {
        string MaHang PK
        string TenHang
        string DvTinh
        string MoTaHang
    }

    DON_DAT_HANG {
        string SoDH PK
        date NgayDat
        string MaSoND FK
        string MaDV FK
    }

    CHI_TIET_DAT_HANG {
        string SoDH PK, FK
        string MaHang PK, FK
        int SoLuong
    }

    PHIEU_GIAO_HANG {
        string SoPG PK
        date NgayGiao
        string SoDH FK
        string MaSoNG FK
        string MaSoNN FK
        string MaSoDDG FK
    }

    CHI_TIET_GIAO_HANG {
        string SoPG PK, FK
        string MaHang PK, FK
        int SoLuong
        double DonGia
    }

    %% Mối quan hệ Đơn vị khách
    DV_KHACH ||--o{ NGUOI_DAT : "thuoc"
    DV_KHACH ||--o{ NGUOI_NHAN : "thuoc"
    DV_KHACH ||--o{ DON_DAT_HANG : "dat"

    %% Mối quan hệ Đặt hàng
    NGUOI_DAT ||--o{ DON_DAT_HANG : "lap"
    DON_DAT_HANG ||--|{ CHI_TIET_DAT_HANG : "co"
    HANG ||--o{ CHI_TIET_DAT_HANG : "duoc_dat"

    %% Mối quan hệ giữa Đơn đặt hàng và Phiếu giao hàng
    DON_DAT_HANG ||--o{ PHIEU_GIAO_HANG : "sinh_ra"

    %% Mối quan hệ Giao hàng
    NGUOI_GIAO ||--o{ PHIEU_GIAO_HANG : "giao"
    NGUOI_NHAN ||--o{ PHIEU_GIAO_HANG : "nhan"
    NOI_GIAO ||--o{ PHIEU_GIAO_HANG : "giao_tai"
    PHIEU_GIAO_HANG ||--|{ CHI_TIET_GIAO_HANG : "co"
    HANG ||--o{ CHI_TIET_GIAO_HANG : "duoc_giao"
