SET NAMES 'utf8mb4';
CREATE DATABASE Cinema;
USE Cinema;
CREATE TABLE KhachHang (
	ID_KhachHang			CHAR(11)			PRIMARY KEY,
    HoTen					VARCHAR(30)			NOT NULL,
    LoaiKhachHang			CHAR(6)				NOT NULL CHECK (LoaiKhachHang in ('Normal','Member'))
);
CREATE TABLE KhachHangThanhVien(
	ID_KhachHang			CHAR(11)			PRIMARY KEY,
	MaCodeTaiKhoan 			CHAR(12)			UNIQUE,  
    ThoiGianCapNhatDiem		DATETIME			NOT NULL
);
CREATE TABLE TaiKhoan(
	MaCodeTaiKhoan 			CHAR(12)			PRIMARY KEY, 
    Email					VARCHAR(50)			NOT NULL,
    NgaySinh				DATE				NOT NULL,
	SoDienThoai				CHAR(10)			NOT NULL,
    GioiTinh				CHAR				NOT NULL CHECK(GioiTinh IN ('M','F')),
    TenDangNhap				VARCHAR(50)			NOT NULL,
    
    CHECK (SoDienThoai REGEXP '^(03|05|07|08|09)[0-9]{8}$'),
    CHECK (Email REGEXP '^[a-zA-Z0-9._%+-]+@gmail\\.com$')
);
CREATE TABLE GiaoDich(
	ID_GiaoDich				CHAR(9)				PRIMARY KEY,
    LoaiGiaoDich			VARCHAR(7)			NOT NULL CHECK (LoaiGiaoDich in ('Online','Offline')),
    ThoiDiemGiaoDich		DATETIME			NOT NULL,
    HinhThuc				VARCHAR(30)			NOT NULL,
    ID_KhachHangThanhVien 	CHAR(11)			,
    SoDiemDuocCong			SMALLINT UNSIGNED	NOT NULL,
    ID_KhachHang			CHAR(11)			NOT NULL 
);
CREATE TABLE GiaoDichOffline(
	ID_GiaoDich				CHAR(9)				PRIMARY KEY,
    MaRap					CHAR(5)				NOT NULL,
    QuaySo					TINYINT UNSIGNED	NOT NULL 
);
CREATE TABLE NhanSu(
	MaCodeTaiKhoan 			CHAR(12)			UNIQUE, 
	ID_NhanSu				CHAR(7)				PRIMARY KEY,
    DiaChi					VARCHAR(50)			NOT NULL,
    HoTen					VARCHAR(30)			NOT NULL,
    CCCD					CHAR(12)			NOT NULL UNIQUE    
);
CREATE TABLE CaTruc(
	NgayTruc				DATE				,
    BuoiTruc				VARCHAR(5)			CHECK (BuoiTruc IN ('Sang','Chieu','Toi')),
    PRIMARY KEY(NgayTruc,BuoiTruc)
);
CREATE TABLE RapChieuPhim(
	MaRap					CHAR(5)				PRIMARY KEY,
    TenRap					VARCHAR(30)			NOT NULL,
    SoLuongPhongChieu		TINYINT UNSIGNED	NOT NULL,
    DiaChi					VARCHAR(50)			NOT NULL,
    GioMoCua				TIME				NOT NULL,
    GioDongCua				TIME				NOT NULL,
    ID_NhanVienQuanLy 		CHAR(9)				NOT NULL,
    TenTinhThanh 			VARCHAR(25)			NOT NULL
);
CREATE TABLE PhongChieu(
	MaRap					CHAR(5)				,
	PhongSo					TINYINT	UNSIGNED	,
	SoGhe					TINYINT UNSIGNED	NOT NULL,
    TinhTrang				VARCHAR(10)			NOT NULL,
    LoaiPhong 				VARCHAR(4) 			NOT NULL CHECK (LoaiPhong in ('IMAX','4D','3D','2D')),
    
	PRIMARY KEY(MaRap,PhongSo)
);
CREATE TABLE Ve(
	ID_Ve					INT UNSIGNED 		AUTO_INCREMENT PRIMARY KEY,
	ID_GiaoDich				CHAR(9)				NOT NULL,  
	MaRap					CHAR(5)				NOT NULL,  
	PhongSo					TINYINT UNSIGNED	NOT NULL,  
	GheSo					CHAR(3)				NOT NULL,  
	ID_SuatChieu			TINYINT UNSIGNED	NOT NULL,		   
	ID_LoaiVe				TINYINT UNSIGNED	NOT NULL		 		   
);
CREATE TABLE SuatChieu (
    ID_SuatChieu       TINYINT UNSIGNED    AUTO_INCREMENT PRIMARY KEY,
    DinhDangPhim       CHAR(9)             NOT NULL CHECK (DinhDangPhim in ('IMAX','4D','3D','2D')),
    NgonNgu            VARCHAR(25)         NOT NULL CHECK (NgonNgu in ('Vietsub','Thuyết minh')),
    NgayBatDau         DATE                NOT NULL,    
    ThoiGianBatDau     TIME                NOT NULL,    
    ThoiGianKetThuc    TIME                NOT NULL,    
    MaRap              CHAR(5)             NOT NULL,     
    PhongSo           TINYINT UNSIGNED     NOT NULL,     
    ID_Phim            CHAR(10)            NOT NULL
);
CREATE TABLE Phim(
	ID_Phim					CHAR(10)			PRIMARY KEY,
    NamSanXuat				YEAR				NOT NULL,
    DaoDien					VARCHAR(30)			NOT NULL,
    ThoiLuong				TIME				NOT NULL,
    MoTa					TEXT				,
	DoTuoi					TINYINT UNSIGNED	NOT NULL,
    TheLoai					VARCHAR(25)			NOT NULL,
    TuaDe					VARCHAR(30)			NOT NULL,
    QuocGiaSanXuat			VARCHAR(30)			NOT NULL
);
CREATE TABLE DanhGia(
	ID_Phim					CHAR(10)			,
	ID_KhachHang			CHAR(11)			,
	DiemDanhGia				TINYINT UNSIGNED	NOT NULL,
    NoiDungDanhGia			TEXT				,
    ThoiGianDanhGia			DATETIME			NOT NULL,
	PRIMARY KEY(ID_Phim,ID_KhachHang),
    CHECK (DiemDanhGia >= 0 and DiemDanhGia <= 10)
);
CREATE TABLE Voucher (
    Voucher_ID 				TINYINT UNSIGNED 	PRIMARY KEY,
    Ngay_phat_hanh 			DATE 				NOT NULL,
    So_luong_gioi_han 		TINYINT UNSIGNED ,
    Ngay_het_han 			DATE 				NOT NULL,
    Loai_giam 				CHAR 				NOT NULL CHECK(Loai_giam IN ('%','-')), 
    Gia_giam 				INT	UNSIGNED 		NOT NULL,
    So_lan_quy_doi_nguoi 	TINYINT UNSIGNED 	NOT NULL
);
CREATE TABLE Voucher_theo_dip (
    Voucher_ID 				TINYINT UNSIGNED 	PRIMARY KEY,
    Loai_su_kien 			VARCHAR(30) 		NOT NULL
);
CREATE TABLE Voucher_theo_diem (
    Voucher_ID 				TINYINT UNSIGNED 	PRIMARY KEY,
    So_diem_quy_doi 		SMALLINT UNSIGNED	NOT NULL
);
CREATE TABLE Quy_doi (
    Voucher_ID 				TINYINT UNSIGNED,
    ID_Khach_hang 			CHAR(11),
    Ngay 					DATE 				NOT NULL,
    Gio  					TIME 				NOT NULL,
    PRIMARY KEY (Voucher_ID,ID_Khach_hang)
);
CREATE TABLE Ap_dung  (
	ID_giao_dich 			CHAR(9),
    Voucher_ID 				TINYINT UNSIGNED,
    PRIMARY KEY (ID_giao_dich,Voucher_ID)
);
CREATE TABLE Mua_kem (
    Combo_ID 				TINYINT UNSIGNED  	,
    So_luong 				TINYINT UNSIGNED	NOT NULL,
    ID_giao_dich 			CHAR(9), 
    PRIMARY KEY (Combo_ID, ID_giao_dich)
);
CREATE TABLE Do_an_thuc_uong  (
    Combo_ID 				TINYINT UNSIGNED  	PRIMARY KEY, 
    Ten 					VARCHAR(50) 		NOT NULL,
    Gia 					INT UNSIGNED 		NOT NULL
);
CREATE TABLE Nhan_vien (
    ID_nhan_vien 			CHAR(7) 			PRIMARY KEY,
    Vai_tro					VARCHAR(30) 		NOT NULL,
    ID_nhan_vien_quan_ly 	CHAR(7) 			NOT NULL
);
CREATE TABLE Nguoi_quan_ly(
	ID_nguoi_quan_ly 		CHAR(7) 			PRIMARY KEY,
    Thong_tin_chuc_vu 		VARCHAR(100) 		NOT NULL,
    Ngay_quan_ly 			DATE				NOT NULL,
    ID_quan_ly_cap_cao 		CHAR(7) 
);
CREATE TABLE Phan_cong (
    ID_nhan_vien 			CHAR(7),
    Ngay_truc 				DATE,
    Buoi_truc 				VARCHAR(6),
    PRIMARY KEY (ID_nhan_vien, Ngay_truc, Buoi_truc)
);
CREATE TABLE Quay_giao_dich (
    Ma_rap 					CHAR(5) ,
    Quay_so 				TINYINT UNSIGNED,
    PRIMARY KEY (Ma_rap, Quay_so)
);
CREATE TABLE Lam_viec_tai (
    Ma_rap  				CHAR(5),
    Quay_so 				TINYINT UNSIGNED,
    ID_nhan_vien 			CHAR(7),
    PRIMARY KEY (Ma_rap, Quay_so,ID_nhan_vien)
);
CREATE TABLE Ghe_ngoi (
    Ma_rap 					CHAR(5),
    Phong_so 				TINYINT UNSIGNED	, 
    Ghe_so 					CHAR(3),
    Loai_ghe 				VARCHAR(10)			NOT NULL CHECK (Loai_ghe in ('Normal','Vip','Sweetbox')),
    PRIMARY KEY (Ma_rap , Phong_so, Ghe_so)
);
CREATE TABLE Bang_gia_ve (
    ID_loai_ve 				TINYINT UNSIGNED 	PRIMARY KEY,
    Loai_phong 				VARCHAR(4)			NOT NULL CHECK (Loai_phong in ('IMAX','4D','3D','2D')),
    Loai_ghe 				VARCHAR(10)			NOT NULL CHECK (Loai_ghe in ('Normal','Vip','Sweetbox')),
    GiaVe 					INT UNSIGNED 		NOT NULL
);
CREATE TABLE Phim_DV (
    ID_phim 				CHAR(10),
    Dien_vien 				VARCHAR(50),
    PRIMARY KEY (ID_phim , Dien_vien)
);
-------------------------------------- ADD FOREIGN KEY ---------------------------------------------------
ALTER TABLE KhachHangThanhVien
ADD CONSTRAINT ID_KhachHangFK FOREIGN KEY (ID_KhachHang) REFERENCES KhachHang(ID_KhachHang),
ADD CONSTRAINT MaCodeTaiKhoanFK FOREIGN KEY (MaCodeTaiKhoan) REFERENCES TaiKhoan(MaCodeTaiKhoan); 

ALTER TABLE DanhGia
ADD CONSTRAINT ID_KhachHangFK3 FOREIGN KEY (ID_KhachHang) REFERENCES KhachHangThanhVien(ID_KhachHang),
ADD CONSTRAINT ID_PhimFK FOREIGN KEY (ID_Phim) REFERENCES Phim(ID_Phim);

ALTER TABLE GiaoDich
ADD CONSTRAINT ID_KhachHangThanhVienFK FOREIGN KEY (ID_KhachHangThanhVien) REFERENCES khachhangthanhvien(ID_KhachHang),
ADD CONSTRAINT ID_KhachHangFK2 FOREIGN KEY (ID_KhachHang) REFERENCES KhachHang(ID_KhachHang);

ALTER TABLE GiaoDichOffline
ADD CONSTRAINT ID_GiaoDichFK FOREIGN KEY (ID_GiaoDich) REFERENCES GiaoDich(ID_GiaoDich),
ADD CONSTRAINT QGDFK FOREIGN KEY(MaRap,QuaySo) REFERENCES quay_giao_dich(Ma_rap,Quay_so);

ALTER TABLE NhanSu
ADD CONSTRAINT MaCodeTaiKhoanFK2 FOREIGN KEY (MaCodeTaiKhoan) REFERENCES TaiKhoan(MaCodeTaiKhoan);

ALTER TABLE RapChieuPhim
ADD CONSTRAINT ID_NhanVienQuanLyFK FOREIGN KEY (ID_NhanVienQuanLy) REFERENCES Nguoi_quan_ly(ID_nguoi_quan_ly);

ALTER TABLE PhongChieu
ADD CONSTRAINT MaRapFK FOREIGN KEY (MaRap) REFERENCES RapChieuPhim(MaRap);

ALTER TABLE SuatChieu
ADD CONSTRAINT PhongChieuFK FOREIGN KEY(MaRap,PhongSo) REFERENCES PhongChieu(MaRap,PhongSo);

ALTER TABLE Ve
ADD CONSTRAINT ID_GiaoDichFK2 FOREIGN KEY (ID_GiaoDich) REFERENCES GiaoDich(ID_GiaoDich),
ADD CONSTRAINT ChoNgoiFK FOREIGN KEY(MaRap,PhongSo,GheSo) REFERENCES Ghe_ngoi(Ma_rap,Phong_so,Ghe_so),
ADD CONSTRAINT ID_SuatChieuFK FOREIGN KEY (ID_SuatChieu) REFERENCES SuatChieu(ID_SuatChieu),
ADD CONSTRAINT ID_LoaiVeFK FOREIGN KEY (ID_LoaiVe) REFERENCES Bang_gia_ve(ID_loai_ve);

ALTER TABLE Voucher_theo_dip
ADD CONSTRAINT Voucher_IDFK FOREIGN KEY (Voucher_ID) REFERENCES Voucher(Voucher_ID);

ALTER TABLE Voucher_theo_diem
ADD CONSTRAINT Voucher_IDFK2 FOREIGN KEY (Voucher_ID) REFERENCES Voucher(Voucher_ID);

ALTER TABLE Quy_doi
ADD CONSTRAINT Voucher_IDFK3 FOREIGN KEY (Voucher_ID) REFERENCES Voucher_theo_diem(Voucher_ID),
ADD CONSTRAINT ID_Khach_hangFK4 FOREIGN KEY (ID_Khach_hang) REFERENCES KhachHangThanhVien(ID_KhachHang);

ALTER TABLE Ap_dung
ADD CONSTRAINT ID_giao_dichFK3 FOREIGN KEY (ID_giao_dich) REFERENCES GiaoDich(ID_GiaoDich),
ADD CONSTRAINT Voucher_IDFK4 FOREIGN KEY (Voucher_ID) REFERENCES Voucher(Voucher_ID);

ALTER TABLE Mua_kem
ADD CONSTRAINT ID_giao_dichFK4 FOREIGN KEY (ID_giao_dich) REFERENCES GiaoDich(ID_GiaoDich),
ADD CONSTRAINT Combo_IDFK FOREIGN KEY (Combo_ID) REFERENCES Do_an_thuc_uong(Combo_ID);

ALTER TABLE Nhan_vien
ADD CONSTRAINT ID_nhan_vien_quan_lyFK FOREIGN KEY (ID_nhan_vien_quan_ly) REFERENCES Nguoi_quan_ly(ID_nguoi_quan_ly),
ADD CONSTRAINT ID_nhan_vienFK FOREIGN KEY (ID_nhan_vien) REFERENCES NhanSu(ID_NhanSu);

ALTER TABLE Nguoi_quan_ly
ADD CONSTRAINT ID_nguoi_quan_lyFK FOREIGN KEY (ID_nguoi_quan_ly) REFERENCES NhanSu(ID_NhanSu),
ADD CONSTRAINT ID_giam_docFK FOREIGN KEY (ID_quan_ly_cap_cao) REFERENCES Nguoi_quan_ly(ID_nguoi_quan_ly);

ALTER TABLE Phan_cong
ADD CONSTRAINT ID_nhan_vienFK2 FOREIGN KEY (ID_nhan_vien) REFERENCES Nhan_vien(ID_nhan_vien),
ADD CONSTRAINT Ca_trucFK FOREIGN KEY (Ngay_truc, Buoi_truc) REFERENCES CaTruc(NgayTruc, BuoiTruc);

ALTER TABLE Quay_giao_dich
ADD CONSTRAINT Ma_rapFK FOREIGN KEY (Ma_rap) REFERENCES RapChieuPhim(MaRap);

ALTER TABLE Lam_viec_tai
ADD CONSTRAINT Ma_rapFK2 FOREIGN KEY (Ma_rap, Quay_so) REFERENCES Quay_giao_dich(Ma_rap, Quay_so),
ADD CONSTRAINT ID_nhan_vienFK3 FOREIGN KEY (ID_nhan_vien) REFERENCES Nhan_vien(ID_nhan_vien);

ALTER TABLE Ghe_ngoi
ADD CONSTRAINT Ma_rapFK3 FOREIGN KEY (Ma_rap, Phong_so) REFERENCES PhongChieu(MaRap, PhongSo);

ALTER TABLE Phim_DV
ADD CONSTRAINT ID_phimFK2 FOREIGN KEY (ID_phim) REFERENCES Phim(ID_Phim);

-- ---------------------- LỆNH KIỂM TRA CÁC KHÓA NGOẠI TRONG SCHEMA -------------------------
SELECT 
    TABLE_NAME,
    CONSTRAINT_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE 
    CONSTRAINT_SCHEMA = 'Cinema'
    AND REFERENCED_TABLE_NAME IS NOT NULL;
-- -------------------------------------- LỆNH TẠO TRIGGER -----------------------------------------
-- Thay đổi bảng --- 
-- Thêm column điểm tích luỹ
ALTER TABLE KhachHangThanhVien
ADD COLUMN DiemTichLuy INT UNSIGNED NOT NULL DEFAULT 0
AFTER MaCodeTaiKhoan;

-- Thêm column TongThanhToan
ALTER TABLE GiaoDich 
ADD COLUMN TongThanhToan INT UNSIGNED NOT NULL DEFAULT 0
AFTER ID_KhachHangThanhVien;

-- Thêm column TongGoc
ALTER TABLE GiaoDich 
ADD COLUMN TongGoc INT UNSIGNED NOT NULL DEFAULT 0
AFTER ID_KhachHangThanhVien;

-- Số điểm được cộng = 0
ALTER TABLE GiaoDich
MODIFY COLUMN SoDiemDuocCong INT UNSIGNED NOT NULL DEFAULT 0;
    
-- Trigger 1: Tính tổng số tiền thanh toán của giao dịch
-- Trigger 1.1: Cộng tiền vé 
DELIMITER $$

CREATE TRIGGER TinhTienVe
AFTER INSERT ON Ve
FOR EACH ROW
BEGIN
    DECLARE v_giave INT DEFAULT 0;

    SELECT bg.GiaVe INTO v_giave
    FROM Bang_gia_ve bg
    WHERE bg.ID_loai_ve = NEW.ID_LoaiVe;

    UPDATE GiaoDich
    SET TongGoc = TongGoc + v_giave,
		TongThanhToan = TongThanhToan + v_giave
    WHERE ID_GiaoDich = NEW.ID_GiaoDich;
END$$

DELIMITER ;    

-- Trigger 1.2: Cộng tiền đồ ăn
DELIMITER $$

CREATE TRIGGER TinhTienDoAn
AFTER INSERT ON Mua_kem
FOR EACH ROW
BEGIN
    DECLARE v_gia_combo INT DEFAULT 0;

    SELECT da.Gia INTO v_gia_combo
    FROM Do_an_thuc_uong da
    WHERE da.Combo_ID = NEW.Combo_ID;

    UPDATE GiaoDich
    SET TongGoc = TongGoc + (v_gia_combo * NEW.So_luong),
		TongThanhToan = TongThanhToan + (v_gia_combo * NEW.So_luong)
    WHERE ID_GiaoDich = NEW.ID_giao_dich;
END$$

DELIMITER ;
   
-- Trigger 1.3: Chỉ được tối đa 1 voucher -, 1 voucher % và không thể áp dụng nếu số lượng = 0 hoặc hết hạn
DELIMITER $$

CREATE TRIGGER KiemTraVoucherHopLe
BEFORE INSERT ON Ap_dung
FOR EACH ROW
BEGIN
    DECLARE v_loai VARCHAR(2);
    DECLARE v_so_luong INT;
	DECLARE v_thoi_diem_giao_dich DATETIME;
    DECLARE v_ngay_het_han DATE;
    
    -- Lấy loại và số lượng voucher
    SELECT Loai_giam, So_luong_gioi_han, Ngay_het_han INTO v_loai, v_so_luong, v_ngay_het_han
    FROM Voucher 
    WHERE Voucher_ID = NEW.Voucher_ID;

	SELECT ThoiDiemGiaoDich INTO v_thoi_diem_giao_dich	
    FROM GiaoDich 
    WHERE ID_GiaoDich = NEW.ID_giao_dich;

	-- Kiểm tra hạn sử dụng
    IF DATE(v_thoi_diem_giao_dich) > v_ngay_het_han THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Voucher đã hết hạn.';
    END IF;
    
    -- Kiểm tra số lượng còn lại
    IF v_so_luong <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Voucher đã hết lượt sử dụng.';
    END IF;

    -- Kiểm tra nếu đã có voucher cùng loại cho giao dịch này
    IF v_loai = '%' THEN
        IF EXISTS (
            SELECT 1
            FROM Ap_dung ad
            JOIN Voucher v ON ad.Voucher_ID = v.Voucher_ID
            WHERE ad.ID_giao_dich = NEW.ID_giao_dich AND v.Loai_giam = '%'
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Chỉ được áp dụng tối đa 1 voucher giảm phần trăm.';
        END IF;
    ELSEIF v_loai = '-' THEN
        IF EXISTS (
            SELECT 1
            FROM Ap_dung ad
            JOIN Voucher v ON ad.Voucher_ID = v.Voucher_ID
            WHERE ad.ID_giao_dich = NEW.ID_giao_dich AND v.Loai_giam = '-'
        ) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Chỉ được áp dụng tối đa 1 voucher trừ tiền mặt.';
        END IF;
    END IF;
    
	-- Trừ số lượng giới hạn đi 1
    UPDATE Voucher
    SET So_luong_gioi_han = So_luong_gioi_han - 1
    WHERE Voucher_ID = NEW.Voucher_ID;
END$$

DELIMITER ;

-- Trigger 1.4: Cập nhật tiền sau voucher
DELIMITER $$

CREATE TRIGGER CapNhatTongTienSauVoucher
AFTER INSERT ON Ap_dung
FOR EACH ROW
BEGIN
    DECLARE v_tong INT;
    DECLARE v_giam_phantram DECIMAL(5,2) DEFAULT 1.0;
    DECLARE v_tru_tien INT DEFAULT 0;

    -- Lấy tổng hiện tại
    SELECT TongGoc INTO v_tong
    FROM GiaoDich
    WHERE ID_GiaoDich = NEW.ID_giao_dich;

    -- 1. Tìm giảm %
    SELECT (100 - v.Gia_giam) / 100.0 INTO v_giam_phantram
    FROM Ap_dung ad JOIN Voucher v ON ad.Voucher_ID = v.Voucher_ID
    WHERE ad.ID_giao_dich = NEW.ID_giao_dich AND v.Loai_giam = '%'
    LIMIT 1;
    
	-- 2. Tìm trừ tiền mặt
	SELECT v.Gia_giam INTO v_tru_tien
    FROM Ap_dung ad JOIN Voucher v ON ad.Voucher_ID = v.Voucher_ID
    WHERE ad.ID_giao_dich = NEW.ID_giao_dich AND v.Loai_giam = '-'
    LIMIT 1;
    
    -- Áp dụng %
    SET v_tong = v_tong * v_giam_phantram;

    -- Áp dụng -
    SET v_tong = v_tong - v_tru_tien;

    -- Không âm
    IF v_tong < 0 THEN
        SET v_tong = 0;
    END IF;

    -- Cập nhật
    UPDATE GiaoDich
    SET TongThanhToan = v_tong
    WHERE ID_GiaoDich = NEW.ID_giao_dich;
END$$

DELIMITER ;

-- Trigger 2: Cập nhật điểm tích luỹ của khách hàng thành viên
-- Trigger 2.1: Khi có giao dịch thành công
DELIMITER $$

CREATE TRIGGER cong_diem_tichluy
BEFORE UPDATE ON GiaoDich
FOR EACH ROW
BEGIN
    IF NEW.ID_KhachHangThanhVien IS NOT NULL AND NEW.TongGoc IS NOT NULL THEN
        IF NEW.TongGoc > OLD.TongGoc THEN
            SET NEW.SoDiemDuocCong = FLOOR(NEW.TongGoc / 1000);
        END IF;
    END IF;
END$$

DELIMITER ;

-- -- Update điểm cho khách hàng thành viên
DELIMITER $$

CREATE TRIGGER update_diem_tichluy
AFTER UPDATE ON GiaoDich
FOR EACH ROW
BEGIN
	DECLARE so_diem_cong INT;
    IF NEW.ID_KhachHangThanhVien IS NOT NULL
       AND NEW.TongGoc > OLD.TongGoc THEN
       
		SET so_diem_cong = FLOOR((NEW.TongGoc - OLD.TongGoc) / 1000);
        
        UPDATE KhachHangThanhVien
        SET DiemTichLuy = DiemTichLuy + so_diem_cong,
            ThoiGianCapNhatDiem = NEW.ThoiDiemGiaoDich
        WHERE ID_KhachHang = NEW.ID_KhachHangThanhVien;
    END IF;
END$$

DELIMITER ;

-- Trigger 2.2: Khi đổi voucher
DELIMITER $$

CREATE TRIGGER tru_diem_tichluy
AFTER INSERT ON Quy_doi
FOR EACH ROW
BEGIN
    DECLARE id_khach CHAR(11);
    DECLARE diem_quy_doi INT UNSIGNED;
    DECLARE diem_hien_tai INT UNSIGNED;

    -- ID khách hàng lấy từ NEW
    SET id_khach = NEW.ID_Khach_hang;

    -- Lấy điểm cần để đổi voucher từ Voucher_theo_diem
    SELECT So_diem_quy_doi INTO diem_quy_doi
    FROM Voucher_theo_diem
    WHERE Voucher_ID = NEW.Voucher_ID;

    -- Lấy điểm hiện tại của khách hàng
    SELECT DiemTichLuy INTO diem_hien_tai
    FROM KhachHangThanhVien
    WHERE ID_KhachHang = id_khach;

    -- Nếu không đủ điểm thì báo lỗi
    IF diem_hien_tai < diem_quy_doi THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không đủ điểm để quy đổi voucher.';
    END IF;

    -- Nếu đủ thì cập nhật trừ điểm và thời gian
    UPDATE KhachHangThanhVien
    SET 
        DiemTichLuy = DiemTichLuy - diem_quy_doi,
        ThoiGianCapNhatDiem = TIMESTAMP(NEW.Ngay,NEW.Gio)
    WHERE ID_KhachHang = id_khach;
END$$

DELIMITER ;

-- --------------------------------------------ADD DỮ LIỆU ------------------------------------------------
-- ------------- KHÁCH HÀNG ----------------
INSERT INTO KhachHang (ID_KhachHang, HoTen, LoaiKhachHang) VALUES
-- Khách hàng thường (Normal) - ID bắt đầu bằng '0'
('05900100001', 'Nguyễn Thị Mai', 'Normal'),
('05900100002', 'Trần Văn Nam', 'Normal'),
('05900200001', 'Lê Thị Hoa', 'Normal'),
('05900200002', 'Phạm Đức Anh', 'Normal'),
('05900300006', 'Đỗ Thị Thu', 'Normal'),
('05900300007', 'Ngô Văn Hải', 'Normal'),
('05900400008', 'Dương Thị Lan', 'Normal'),
('05900400009', 'Võ Minh Đức', 'Normal'),
('05900500010', 'Lý Văn Tài', 'Normal'),
('05900500001', 'Trịnh Văn Cường', 'Normal'),
('02900100002', 'Mai Thị Thuỷ', 'Normal'),
('02900100003', 'Huỳnh Đức Long', 'Normal'),
('02900200004', 'Bành Thị Ngọc', 'Normal'),
('02900200005', 'Đồng Văn Tùng', 'Normal'),
('02900300001', 'Nguyễn Thị Bảo An', 'Normal'),
('02900300002', 'Trần Văn Công', 'Normal'),
('02900400003', 'Lê Thị Diễm', 'Normal'),
('02900400004', 'Phạm Văn Đạt', 'Normal'),
('02900500005', 'Hoàng Thị Hương', 'Normal'),
('02900600006', 'Vũ Văn Khôi', 'Normal'),
('02900600007', 'Đặng Thị Lan', 'Normal'),
('06500100008', 'Bùi Văn Mạnh', 'Normal'),
('06500100009', 'Đỗ Thị Ngân', 'Normal'),
('06500200010', 'Hồ Văn Phúc', 'Normal'),
('06500200011', 'Ngô Thị Quỳnh', 'Normal'),
('06500300012', 'Dương Văn Sang', 'Normal'),
('06500300013', 'Đào Thị Trang', 'Normal'),
('01500100014', 'Võ Văn Tú', 'Normal'),
('01500100015', 'Lý Thị Uyên', 'Normal'),
('01500200016', 'Chu Văn Vinh', 'Normal'),
('01500200017', 'Phan Thị Xuân', 'Normal'),
('07200100018', 'Vương Văn Yên', 'Normal'),
('07200200019', 'Trịnh Thị Ái', 'Normal'),
('07200100020', 'Lưu Văn Bình', 'Normal'),
('07200200021', 'Triệu Thị Chi', 'Normal'),
('07200300022', 'Đàm Văn Dũng', 'Normal'),
('07200300023', 'Cát Thị Hà', 'Normal'),
('04600100024', 'Kha Văn Hào', 'Normal'),
('04300300025', 'Lạc Thị Kim', 'Normal'),
-- Khách hàng thành viên (Member) - ID bắt đầu bằng '1' 
('15900100001', 'Vũ Minh Tuấn', 'Member'),
('15900100002', 'Bùi Ngọc Linh', 'Member'),
('15900200001', 'Đặng Văn Khôi', 'Member'),
('15900200002', 'Hoàng Thị Nga', 'Member'),
('15900300006', 'Trương Thị Hương', 'Member'),
('15900300007', 'Phan Văn Hoàng', 'Member'),
('15900400008', 'Chu Thị Ngọc', 'Member'),
('15900400009', 'Lâm Văn Phong', 'Member'),
('15900500010', 'Hồ Thị Minh', 'Member'),
('15900500001', 'Trần Hải Dương', 'Member'),
('12900100002', 'Lê Ngọc Anh', 'Member'),
('12900100003', 'Nguyễn Minh Hằng', 'Member'),
('12900200004', 'Phạm Anh Tuấn', 'Member'),
('12900200005', 'Đinh Thị Thảo', 'Member'),
('12900300001', 'Tống Thị Hạnh', 'Member'),
('12900300002', 'Thi Văn Đạt', 'Member'),
('12900400003', 'Âu Dương Phương', 'Member'),
('12900400004', 'Hứa Văn Khánh', 'Member'),
('12900500005', 'Diệp Thị Minh', 'Member'),
('12900600006', 'Cao Văn Long', 'Member'),
('12900600007', 'Tiêu Thị Mai', 'Member'),
('16500100008', 'Mã Văn Nam', 'Member'),
('16500100009', 'Củng Thị Nga', 'Member'),
('16500200010', 'Vi Văn Phát', 'Member'),
('16500200001', 'Tư Mã Thị Quyên', 'Member'),
('16500300002', 'Khổng Văn Sơn', 'Member'),
('16500300003', 'Hoa Thị Thảo', 'Member'),
('11500100004', 'Cấn Văn Trung', 'Member'),
('11500100005', 'Trang Thị Vân', 'Member'),
('11500200006', 'Liễu Văn An', 'Member'),
('17200100007', 'Quách Thị Bích', 'Member'),
('17200100008', 'Đổng Văn Chiến', 'Member'),
('17200200009', 'Tạ Thị Dung', 'Member'),
('17200200010', 'Bành Văn Đức', 'Member'),
('17200300011', 'Chu Thị Hạnh', 'Member'),
('17200300012', 'Phù Văn Huy', 'Member'),
('14600100013', 'Trương Thị Kiều', 'Member'),
('14600100014', 'Uông Văn Lộc', 'Member'),
('14600300015', 'Văn Thị My', 'Member'),
('14600300016', 'Xa Văn Nghĩa', 'Member'),
('14600300017', 'Yên Thị Oanh', 'Member'),
('15900200018', 'Trịnh Văn Phong', 'Member'),
('15900300019', 'Lâm Thị Quy', 'Member'),
('15900600020', 'Hứa Văn Sỹ', 'Member');

-- ------------- PHIM ----------------
INSERT INTO Phim VALUES
('MOV2023001', 2023, 'Greta Gerwig',        '01:54:00', 'Một câu chuyện về búp bê Barbie.', 13, 'Hài hước',      'Barbie',              'Mỹ'),
('MOV2023002', 2023, 'Christopher Nolan',  '03:00:00', 'Cuộc đời J. Robert Oppenheimer.', 18, 'Lịch sử',        'Oppenheimer',         'Mỹ'),
('MOV2023003', 2023, 'Louis Leterrier',    '02:21:00', 'Phần 10 của loạt phim Fast & Furious.', 13, 'Hành động',  'Fast X',              'Mỹ'),
('MOV2023004', 2023, 'James Cameron',      '02:12:00', 'Phần tiếp theo của Avatar.',       13, 'Khoa học viễn tưởng', 'Avatar: Way of Water', 'Mỹ'),
('MOV2023005', 2023, 'Pham Thien An',      '01:57:00', 'Hành trình của một chàng trai trẻ ở Sài Gòn.', 16, 'Tâm lý', 'Bên trong vỏ kén vàng', 'Việt Nam'),
('MOV2023006', 2023, 'Takashi Yamazaki',   '02:04:00', 'Godzilla tàn phá Nhật Bản.',       16, 'Hành động',     'Godzilla Minus One',  'Nhật Bản'),
('MOV2023007', 2023, 'Adele Lim',          '01:35:00', 'Cuộc hành trình dở khóc dở cười của 4 người phụ nữ.', 18, 'Hài hước', 'Joy Ride', 'Mỹ'),
('MOV2023008', 2023, 'Lee Isaac Chung',    '01:49:00', 'Thảm họa tuyết cuốn tại núi Alps.', 13, 'Thảm họa',     'Just One Day',        'Hàn Quốc'),
('MOV2023009', 2023, 'Peter Sohn',         '01:41:00', 'Thế giới nơi các nguyên tố sống động.', 6, 'Hoạt hình', 'Elemental',           'Mỹ'),
('MOV2023010', 2023, 'Hayao Miyazaki',     '02:04:00', 'Cuộc phiêu lưu kỳ ảo của một cậu bé.', 13, 'Hoạt hình', 'The Boy and the Heron', 'Nhật Bản'),
('MOV2024001', 2024, 'Denis Villeneuve',   '02:46:00', 'Phần hai của cuộc chiến trên hành tinh Arrakis.', 13, 'Khoa học viễn tưởng', 'Dune: Part Two', 'Mỹ'),
('MOV2024002', 2024, 'George Miller',      '02:28:00', 'Câu chuyện nguồn gốc của Furiosa.', 16, 'Hành động',    'Furiosa',             'Úc'),
('MOV2024003', 2024, 'Michael Sarnoski',   '01:42:00', 'Tiền truyện của A Quiet Place.',    13, 'Kinh dị',       'A Quiet Place: Day One', 'Mỹ'),
('MOV2024004', 2024, 'Trấn Thành',         '02:10:00', 'Tiếp tục hành trình gia đình từ phim trước.', 13, 'Tâm lý', 'Mai',               'Việt Nam'),
('MOV2024005', 2024, 'Matthew Vaughn',     '02:19:00', 'Gián điệp và nhà văn hợp tác chống lại thế giới ngầm.', 16, 'Hành động', 'Argylle', 'Anh');

-- --------- TÀi KHOẢN  ---------
INSERT INTO TaiKhoan VALUES
-- Nhân sự -------
('MC1234567890', 'nguyenvana1@gmail.com', '1990-05-12', '0901234567', 'M', 'nguyenvana1'),
('MC0987654321', 'tranthib2@gmail.com', '1992-03-20', '0932345678', 'F', 'tranthib2'),
('MC1112223334', 'levanc3@gmail.com', '1988-12-01', '0913456789', 'M', 'levanc3'),
('MC5556667778', 'phamthid4@gmail.com', '1995-09-30', '0904567890', 'F', 'phamthid4'),
('MC7778889990', 'vovane5@gmail.com', '1987-07-15', '0935678901', 'M', 'vovane5'),
('MC8889990001', 'nguyenthif6@gmail.com', '1991-11-22', '0906789012', 'F', 'nguyenthif6'),
('MC9990001112', 'buivang7@gmail.com', '1989-10-10', '0917890123', 'M', 'buivang7'),
('MC0001112223', 'dangthih8@gmail.com', '1993-01-05', '0938901234', 'F', 'dangthih8'),
('MC2223334445', 'nguyenvani9@gmail.com', '1996-08-18', '0909012345', 'M', 'nguyenvani9'),
('MC3334445556', 'trinhthij10@gmail.com', '1986-06-25', '0910123456', 'F', 'trinhthij10'),
('MC4445556667', 'hoangvank11@gmail.com', '1994-04-14', '0931234567', 'M', 'hoangvank11'),
('MC5556667779', 'lythil12@gmail.com', '1997-02-08', '0902345678', 'F', 'lythil12'),
('MC6667778881', 'dangvanm13@gmail.com', '1990-10-20', '0913456789', 'M', 'dangvanm13'),
('MC7778889992', 'nguyenthin14@gmail.com', '1985-07-11', '0934567890', 'F', 'nguyenthin14'),
('MC8889990003', 'tranvano15@gmail.com', '1992-09-09', '0905678901', 'M', 'tranvano15'),
('MC9012837465', 'nguyenthip.dev@gmail.com', '1992-01-10', '0901122334', 'F', 'nguyenthip.dev'),
('MC8347293847', 'tranthiq.ketoan@gmail.com', '1993-05-18', '0932233445', 'F', 'tranthiq.ketoan'),
('MC7839201837', 'buithiv.hanoi@gmail.com', '1991-06-27', '0983344556', 'F', 'buithiv.hanoi'),
('MC6938472619', 'dangthiw.kt@gmail.com', '1989-09-03', '0914455667', 'F', 'dangthiw.kt'),
('MC9384710283', 'hoangthiz.89@gmail.com', '1990-11-15', '0965566778', 'F', 'hoangthiz.89'),
('MC3928475610', 'lythiaa.dn@gmail.com', '1992-08-19', '0976677889', 'F', 'lythiaa.dn'),
('MC7182937465', 'nguyenthicc.ct@gmail.com', '1993-04-04', '0397788990', 'F', 'nguyenthicc.ct'),
('MC6109283741', 'tranthidd.kt@gmail.com', '1994-12-21', '0388899001', 'F', 'tranthidd.kt'),
('MC4019283746', 'nguyenthiee.ct@gmail.com', '1990-10-08', '0379900112', 'F', 'nguyenthiee.ct'),
('MC4839201837', 'phamthigg.hp@gmail.com', '1988-03-14', '0360011223', 'F', 'phamthigg.hp'),
('MC5940283746', 'vothihh.hp@gmail.com', '1991-07-29', '0351122334', 'F', 'vothihh.hp'),
('MC6829301745', 'buithiii.hp@gmail.com', '1995-09-30', '0342233445', 'F', 'buithiii.hp'),
('MC7412039485', 'phamvanjj.hue@gmail.com', '1989-05-05', '0933344556', 'M', 'phamvanjj.hue'),
('MC8592039482', 'lethikk.hue@gmail.com', '1992-06-15', '0944455667', 'F', 'lethikk.hue'),
('MC9837401923', 'nguyenvanll.hue@gmail.com', '1990-08-23', '0955566778', 'M', 'nguyenvanll.hue'),
('MC3029481745', 'dangvanmm.vt@gmail.com', '1991-02-11', '0366677889', 'M', 'dangvanmm.vt'),
('MC5678291039', 'tranthinn.vt@gmail.com', '1987-12-12', '0377788990', 'F', 'tranthinn.vt'),
('MC6783920193', 'vovanoo.vt@gmail.com', '1993-11-01', '0388899001', 'M', 'vovanoo.vt'),
('MC0000000000', 'nguyenduythinh@gmail.com', '1890-10-01', '0358241996', 'M', 'nguyenduythinh.dev'),
('MC1293847563', 'pp.nguyen@gmail.com', '1990-04-15', '0912345678', 'M', 'pp.nguyen'),
('MC8372610948', 'qq.le@gmail.com', '1992-08-22', '0923456789', 'F', 'qq.le'),
('MC5637281947', 'rr.tran@gmail.com', '1989-12-05', '0934567890', 'M', 'rr.tran'),
-- Khách hàng ----
('TK2000000001', 'tuanvu@gmail.com', '1980-05-15', '0912345678', 'M', 'tuanvu805'),
('TK2000000002', 'linhbui@gmail.com', '1982-08-22', '0923456789', 'F', 'linhbui82'),
('TK2000000003', 'khoidang@gmail.com', '1984-11-03', '0934567890', 'M', 'khoidang8422'),
('TK2000000004', 'ngahoang@gmail.com', '1986-04-18', '0945678901', 'F', 'ngahoang'),
('TK2000000005', 'huongtruong@gmail.com', '1988-09-25', '0956789012', 'F', 'huongtruong889'),
('TK2000000006', 'hoangphan@gmail.com', '1990-07-12', '0967890123', 'M', 'hoangphan90'),
('TK2000000007', 'ngocchu@gmail.com', '1992-12-30', '0978901234', 'F', 'ngocchu92'),
('TK2000000008', 'phonglam@gmail.com', '1994-02-14', '0989012345', 'M', 'phonglam94'),
('TK2000000009', 'minhho@gmail.com', '1996-06-08', '0990123456', 'F', 'minhho96'),
('TK2000000010', 'duongtran@gmail.com', '1998-10-22', '0911234567', 'M', 'duongtran8'),
('TK2000000011', 'anhle@gmail.com', '2000-03-17', '0912345678', 'F', 'anhle00'),
('TK2000000012', 'hangnguyen@gmail.com', '2002-08-09', '0923456789', 'F', 'hangnguyen'),
('TK2000000013', 'tuanpham@gmail.com', '2004-01-25', '0934567890', 'M', 'tuanpham04'),
('TK2000000014', 'thaodinh@gmail.com', '2006-05-19', '0945678901', 'F', 'thaodinh6'),
('TK2000000015', 'hanhtong@gmail.com', '1981-09-14', '0956789012', 'F', 'hanhtong81'),
('TK2000000016', 'datthi@gmail.com', '1983-12-03', '0967890123', 'M', 'datthi83'),
('TK2000000017', 'phuongau@gmail.com', '1985-04-28', '0978901234', 'F', 'phuongau85'),
('TK2000000018', 'khanhhua@gmail.com', '1987-07-15', '0989012345', 'M', 'khanhhua87'),
('TK2000000019', 'minhdiep@gmail.com', '1989-10-31', '0990123456', 'F', 'minhdiep89'),
('TK2000000020', 'longcao@gmail.com', '1991-02-22', '0911234567', 'M', 'longcao91'),
('TK2000000021', 'maitieu@gmail.com', '1993-06-18', '0912345678', 'F', 'maitieu930608'),
('TK2000000022', 'namma@gmail.com', '1995-11-27', '0923456789', 'M', 'namma95'),
('TK2000000023', 'ngacung@gmail.com', '1997-03-09', '0934567890', 'F', 'ngacung'),
('TK2000000024', 'phatvi@gmail.com', '1999-08-14', '0945678901', 'M', 'phatvi99'),
('TK2000000025', 'quyentuma@gmail.com', '2001-01-07', '0956789012', 'F', 'quyentuma1'),
('TK2000000026', 'sonkhong@gmail.com', '2003-04-23', '0967890123', 'M', 'sonkhong03'),
('TK2000000027', 'thaohoa@gmail.com', '2005-07-30', '0978901234', 'F', 'thaohoa05'),
('TK2000000028', 'trungcan@gmail.com', '1980-10-12', '0989012345', 'M', 'trungcan80'),
('TK2000000029', 'vantrang@gmail.com', '1982-12-05', '0990123456', 'F', 'vantrang82'),
('TK2000000030', 'anlieu@gmail.com', '1984-05-28', '0911234567', 'M', 'anlieu84'),
('TK2000000031', 'bichquach@gmail.com', '1986-09-16', '0912345678', 'F', 'bichquach86'),
('TK2000000032', 'chiendong@gmail.com', '1988-02-19', '0923456789', 'M', 'chiendong'),
('TK2000000033', 'dungta@gmail.com', '1990-11-24', '0934567890', 'F', 'dungta90'),
('TK2000000034', 'ducbanh@gmail.com', '1992-06-11', '0945678901', 'M', 'ducbanh2'),
('TK2000000035', 'hanhchu@gmail.com', '1994-04-03', '0956789012', 'F', 'hanhchu94'),
('TK2000000036', 'huyphu@gmail.com', '1996-08-27', '0967890123', 'M', 'huyphu96'),
('TK2000000037', 'kieutruong@gmail.com', '1998-01-14', '0978901234', 'F', 'kieutruong8'),
('TK2000000038', 'locuong@gmail.com', '2000-07-08', '0989012345', 'M', 'locuong00'),
('TK2000000039', 'myvan@gmail.com', '2002-12-21', '0990123456', 'F', 'myvan02'),
('TK2000000040', 'nghiaxa@gmail.com', '2004-11-11', '0911234567', 'M', 'nghiaxa04'),
('TK2000000041', 'oanhyen@gmail.com', '1981-03-15', '0922345678', 'F', 'oanhyen81'),
('TK2000000042', 'phongtrinh@gmail.com', '1983-07-22', '0933456789', 'M', 'phongtrinh8322'),
('TK2000000043', 'quylam@gmail.com', '1985-09-30', '0944567890', 'F', 'quylam'),
('TK2000000044', 'syhua@gmail.com', '1987-12-18', '0955678901', 'M', 'syhua87');
-- -------------- VOUCHER -------------
INSERT INTO Voucher(Voucher_ID, Ngay_phat_hanh, So_luong_gioi_han, Ngay_het_han, Loai_giam, Gia_giam, So_lan_quy_doi_nguoi) VALUES
-- Voucher theo dịp (ID 1-15)
(1, '2025-01-01', 100, '2025-02-15', '%', 10, 1),  -- Tết Nguyên Đán
(2, '2025-02-10', 200, '2025-02-14', '-', 50000, 1),  -- Valentine
(3, '2025-08-30', 50, '2025-09-05', '%', 20, 1),  -- Quốc Khánh 2/9
(4, '2025-10-10', 150, '2025-10-15', '-', 30000, 1),  -- Ngày Phụ nữ Việt Nam
(5, '2025-04-25', 80, '2025-05-01', '%', 15, 1),  -- Ngày Quốc tế Lao động
(6, '2025-05-28', 120, '2025-06-01', '%', 12, 1),  -- Ngày Quốc tế Thiếu nhi
(7, '2025-08-15', 90, '2025-08-30', '-', 45000, 1),  -- Back to school
(8, '2025-09-10', 200, '2025-09-15', '%', 25, 1),  -- Tết Trung thu
(9, '2025-12-20', 60, '2025-12-31', '-', 55000, 1),  -- Xuân yêu thương
(10, '2025-12-01', 150, '2025-12-25', '%', 18, 1),  -- Lễ Giáng sinh
(11, '2025-12-28', 80, '2026-01-02', '-', 35000, 1),  -- Tết Dương lịch
(12, '2025-10-20', 100, '2025-10-31', '%', 10, 1),  -- Halloween
(13, '2025-06-01', 70, '2025-06-30', '-', 60000, 1),  -- Chào đón mùa hè
(14, '2025-03-01', 180, '2025-03-08', '%', 22, 1),  -- Ngày Phụ nữ Quốc tế
(15, '2025-04-25', 50, '2025-04-30', '-', 40000, 1),  -- Ngày Giải phóng Miền Nam
(31, '2025-04-25', 50, '2025-04-30', '%', 15, 1),  -- Ngày Giải phóng Miền Nam

-- Voucher đổi từ điểm (ID 16-30)
(16, '2025-03-10', 130, '2025-07-25', '%', 15, 3),
(17, '2025-03-12', 90, '2025-07-31', '-', 65000, 2),
(18, '2025-03-15', 110, '2025-07-30', '%', 20, 3),
(19, '2025-03-20', 75, '2025-07-31', '-', 50000, 2),
(20, '2025-03-25', 160, '2025-07-31', '%', 30, 3),
(21, '2025-03-28', 85, '2025-07-31', '-', 70000, 2),
(22, '2025-03-30', 140, '2025-07-31', '%', 17, 3),
(23, '2025-03-31', 65, '2025-07-31', '-', 55000, 2),
(24, '2025-03-10', 95, '2025-07-31', '%', 24, 3),
(25, '2025-03-15', 55, '2025-07-31', '-', 80000, 2),
(26, '2025-03-20', 120, '2025-07-31', '%', 18, 3),
(27, '2025-03-25', 70, '2025-07-31', '-', 75000, 2),
(28, '2025-03-30', 100, '2025-07-31', '%', 22, 3),
(29, '2025-03-31', 60, '2025-07-31', '-', 60000, 2),
(30, '2025-03-31', 140, '2025-07-31', '%', 25, 3);


-- --------------- NHÂN SỰ -----------
INSERT INTO nhansu (MaCodeTaiKhoan, ID_NhanSu, DiaChi, HoTen, CCCD) VALUES
('MC0000000000', '0000000', '95 Quang Trung, Hoàn Kiếm, Hà Nội', 'Nguyen Duy Thinh', '404199937845'),
('MC9990001112', '1500107', '12 Lý Thường Kiệt, Hồng Bàng, Hải Phòng', 'Bui Van G', '667788990011'),
('MC4839201837', '1500133', '30 Nguyễn Đức Cảnh, Hồng Bàng, Hải Phòng', 'Pham Thi GG', '333435363738'),
('MC5940283746', '1500134', '50 Lạch Tray, Ngô Quyền, Hải Phòng', 'Vo Thi HH', '343536373839'),
('MC6829301745', '1500135', '12 Phan Đăng Lưu, Kiến An, Hải Phòng', 'Bui Thi II', '353637383940'),
('MC5556667778', '2900104', '9 Nguyễn Du, Hai Bà Trưng, Hà Nội', 'Pham Thi D', '334455667788'),
('MC8889990001', '2900106', '81 Nguyễn Văn Cừ, Long Biên, Hà Nội', 'Nguyen Thi F', '556677889900'),
('MC5637281947', '2900107', '72 Trần Khát Chân, Hai Bà Trưng, Hà Nội', 'Tran Van RR', '474849505152'),
('MC7839201837', '2900122', '22 Quang Trung, Hoàn Kiếm, Hà Nội', 'Bui Thi V', '222324252627'),
('MC1112223334', '2900203', '67 Hai Bà Trưng, Hoàn Kiếm, Hà Nội', 'Le Van C', '223344556677'),
('MC1293847563', '2900204', '91 Tràng Tiền, Hoàn Kiếm, Hà Nội', 'Nguyen Van PP', '454647484950'),
('MC8372610948', '2900205', '18 Lò Đúc, Hai Bà Trưng, Hà Nội', 'Le Thi QQ', '464748495051'),
('MC6938472619', '2900223', '75 Nguyễn Lương Bằng, Đống Đa, Hà Nội', 'Dang Thi W', '232425262728'),
('MC3928475610', '4300100', '51 Nguyễn Văn Linh, Liên Chiểu, Đà Nẵng', 'Ly Thi AA', '272829303132'),
('MC7778889990', '4300105', '56 Trần Hưng Đạo, Hải Châu, Đà Nẵng', 'Vo Van E', '445566778899'),
('MC0001112223', '4300108', '34 Nguyễn Tri Phương, Thanh Khê, Đà Nẵng', 'Dang Thi H', '778899001122'),
('MC9384710283', '4300199', '110 Hoàng Diệu, Thanh Khê, Đà Nẵng', 'Hoang Thi Z', '262728293031'),
('MC1234567890', '5900101', '123 Lê Lợi, Q1, TP.HCM', 'Nguyen Van A', '001122334455'),
('MC8889990003', '5900115', '45 Phan Đăng Lưu, Bình Thạnh, TP.HCM', 'Tran Van O', '151617181920'),
('MC9012837465', '5900116', '15 Nguyễn Thị Minh Khai, Q1, TP.HCM', 'Nguyen Thi P', '161718192021'),
('MC8347293847', '5900117', '34 Nguyễn Trãi, Q5, TP.HCM', 'Tran Thi Q', '171819202122'),
('MC0987654321', '5900202', '45 Pasteur, Q3, TP.HCM', 'Tran Thi B', '112233445566'),
('MC3334445556', '5900210', '22 Lê Thánh Tôn, Q1, TP.HCM', 'Trinh Thi J', '990011223344'),
('MC6667778881', '5900213', '88 Lê Văn Sỹ, Q3, TP.HCM', 'Dang Van M', '131415161718'),
('MC7778889992', '5900214', '123 Cộng Hòa, Tân Bình, TP.HCM', 'Nguyen Thi N', '141516171819'),
('MC2223334445', '6500109', '78 Cách Mạng Tháng 8, Ninh Kiều, Cần Thơ', 'Nguyen Van I', '889900112233'),
('MC7182937465', '6500129', '25 Hòa Bình, Ninh Kiều, Cần Thơ', 'Nguyen Thi CC', '293031323334'),
('MC6109283741', '6500130', '70 Võ Văn Tần, Cái Răng, Cần Thơ', 'Tran Thi DD', '303132333435'),
('MC4019283746', '6500131', '55 Nguyễn Văn Cừ, Ninh Kiều, Cần Thơ', 'Nguyen Thi EE', '313233343536'),
('MC5556667779', '7200112', '10 Võ Thị Sáu, TP. Vũng Tàu', 'Ly Thi L', '121314151617'),
('MC3029481745', '7200139', '45 Lê Hồng Phong, TP. Vũng Tàu', 'Dang Van MM', '394041424344'),
('MC5678291039', '7200140', '88 Trần Phú, TP. Vũng Tàu', 'Tran Thi NN', '404142434445'),
('MC6783920193', '7200141', '12 Nguyễn An Ninh, TP. Vũng Tàu', 'Vo Van OO', '414243444546'),
('MC4445556667', '7500111', '99 Nguyễn Đình Chiểu, TP. Huế', 'Hoang Van K', '101112131415'),
('MC7412039485', '7500136', '25 Hùng Vương, TP. Huế', 'Pham Van JJ', '363738394041'),
('MC8592039482', '7500137', '67 Bà Triệu, TP. Huế', 'Le Thi KK', '373839404142'),
('MC9837401923', '7500138', '19 Nguyễn Huệ, TP. Huế', 'Nguyen Van LL', '383940414243');

-- ------------ DIỄN VIÊN ----------------------
INSERT INTO Phim_DV VALUES
('MOV2023001', 'Margot Robbie'),
('MOV2023001', 'Ryan Gosling'),
('MOV2023001', 'America Ferrera'),

('MOV2023002', 'Cillian Murphy'),
('MOV2023002', 'Emily Blunt'),
('MOV2023002', 'Robert Downey Jr.'),

('MOV2023003', 'Vin Diesel'),
('MOV2023003', 'Jason Momoa'),
('MOV2023003', 'Michelle Rodriguez'),

('MOV2023004', 'Sam Worthington'),
('MOV2023004', 'Zoe Saldana'),
('MOV2023004', 'Sigourney Weaver'),

('MOV2023005', 'Lê Phong Vũ'),
('MOV2023005', 'Nguyễn Thịnh'),
('MOV2023005', 'Nguyễn Thị Trúc Quỳnh'),

('MOV2023006', 'Ryunosuke Kamiki'),
('MOV2023006', 'Minami Hamabe'),
('MOV2023006', 'Yuki Yamada'),

('MOV2023007', 'Ashley Park'),
('MOV2023007', 'Sherry Cola'),
('MOV2023007', 'Stephanie Hsu'),

('MOV2023008', 'Kim Nam-gil'),
('MOV2023008', 'Han Hyo-joo'),
('MOV2023008', 'Lee Sung-kyung'),

('MOV2023009', 'Leah Lewis'),
('MOV2023009', 'Mamoudou Athie'),
('MOV2023009', 'Ronnie del Carmen'),

('MOV2023010', 'Soma Santoki'),
('MOV2023010', 'Masaki Suda'),
('MOV2023010', 'Aimyon'),

('MOV2024001', 'Timothée Chalamet'),
('MOV2024001', 'Zendaya'),
('MOV2024001', 'Austin Butler'),

('MOV2024002', 'Anya Taylor-Joy'),
('MOV2024002', 'Chris Hemsworth'),
('MOV2024002', 'Tom Burke'),

('MOV2024003', 'Lupita Nyong\'o'),
('MOV2024003', 'Joseph Quinn'),
('MOV2024003', 'Alex Wolff'),

('MOV2024004', 'Trấn Thành'),
('MOV2024004', 'Phương Anh Đào'),
('MOV2024004', 'Tuấn Trần'),

('MOV2024005', 'Henry Cavill'),
('MOV2024005', 'Bryce Dallas Howard'),
('MOV2024005', 'Sam Rockwell');

-- ---------- NHÂN VIÊN QUẢN LÝ ------------
INSERT INTO Nguoi_quan_ly
VALUES
('0000000', 'Giám đốc', '2018-11-20', NULL),
('1500135', 'Quản lý khu vực', '2020-01-01', '0000000'),
('2900223', 'Quản lý khu vực', '2019-11-25', '0000000'),
('4300105', 'Quản lý khu vực', '2021-11-25', '0000000'),
('5900214', 'Quản lý khu vực', '2021-11-20', '0000000'),
('6500131', 'Quản lý khu vực', '2021-11-11', '0000000'),
('7200112', 'Quản lý khu vực', '2023-07-11', '0000000'),
('7500138', 'Quản lý khu vực', '2021-07-11', '0000000'),

('1500107', 'Quản lý rạp', '2020-04-30', '1500135'),
('2900122', 'Quản lý rạp', '2021-05-25', '2900223'),
('2900205', 'Quản lý rạp', '2020-02-25', '2900223'),
('4300199', 'Quản lý rạp', '2022-07-26', '4300105'),
('5900116', 'Quản lý rạp', '2022-09-07', '5900214'),
('5900213', 'Quản lý rạp', '2021-05-08', '5900214'),
('6500129', 'Quản lý rạp', '2021-06-08', '6500131'),
('7200140', 'Quản lý rạp', '2023-05-02', '7200112'),
('7500137', 'Quản lý rạp', '2022-12-12', '7500138');

-- ------------- RẠP CHIẾU PHIM ------------
INSERT INTO RapChieuPhim VALUES
('59001', 'CGV Aeon Tân Phú', 10, '30 Bờ Bao Tân Thắng, Tân Phú', '08:00:00', '23:00:00', '5900116', 'TP.HCM'),
('59002', 'CGV Nguyễn Du', 5, '116 Nguyễn Du, Q.1', '08:00:00', '23:00:00', '5900213', 'TP.HCM'),
('29001', 'CGV Vincom Bà Triệu', 9, '191 Bà Triệu, Hai Bà Trưng', '08:00:00', '23:00:00', '2900122', 'Hà Nội'),
('29002', 'Beta Mỹ Đình', 5, '34 Phạm Hùng, Nam Từ Liêm', '08:00:00', '23:00:00', '2900205', 'Hà Nội'),
('65001', 'CGV Vincom Hùng Vương', 6, '209 30 Tháng 4, Ninh Kiều', '08:00:00', '23:00:00', '6500129', 'Cần Thơ'),
('15001', 'CGV Aeon Mall Lê Chân', 7, '10 Võ Nguyên Giáp, Lê Chân', '08:00:00', '23:00:00', '1500107', 'Hải Phòng'),
('72001', 'Lotte Cinema Vũng Tàu', 6, '3 Tháng 2', '08:00:00', '23:00:00', '7200140', 'Vũng Tàu'),
('43001', 'CGV Đà Nẵng', 6, '310 Điện Biên Phủ, Thanh Khê', '08:00:00', '23:00:00', '4300199', 'Đà Nẵng'),
('75001', 'CGV Huế', 4, '25 Hai Bà Trưng', '08:00:00', '23:00:00', '7500137', 'Huế');

-- ------------- PHÒNG CHIẾU ------------
INSERT INTO PhongChieu VALUES
('59001', 1, 120, 'Hoạt động', '2D'),
('59001', 2, 90, 'Hoạt động', '3D'),
('59001', 3, 100, 'Bảo trì', '2D'), 
('59001', 4, 80, 'Hoạt động', '4D'),
('59001', 5, 150, 'Hoạt động', 'IMAX'),
('59001', 6, 100, 'Hoạt động', '3D'),
('59001', 7, 110, 'Hoạt động', '2D'),
('59001', 8, 130, 'Hoạt động', 'IMAX'),
('59001', 9, 120, 'Hoạt động', '2D'),
('59001', 10, 90, 'Hoạt động', '4D'),
('59002', 1, 80, 'Hoạt động', '2D'),
('59002', 2, 90, 'Trống', '3D'), 
('59002', 3, 70, 'Hoạt động', '2D'),
('59002', 4, 100, 'Hoạt động', '4D'),
('59002', 5, 95, 'Hoạt động', '2D'),
('29001', 1, 100, 'Hoạt động', '2D'),
('29001', 2, 110, 'Hoạt động', 'IMAX'),
('29001', 3, 85, 'Hoạt động', '3D'),
('29001', 4, 120, 'Hoạt động', '2D'),
('29001', 5, 90, 'Hoạt động', '4D'),
('29002', 6, 105, 'Hoạt động', '2D'),
('29002', 7, 100, 'Hoạt động', '3D'),
('29002', 8, 115, 'Hoạt động', 'IMAX'),
('29002', 9, 95, 'Hoạt động', '2D'),
('65001', 1, 85, 'Hoạt động', '3D'),
('65001', 2, 100, 'Hoạt động', '2D'),
('65001', 3, 110, 'Hoạt động', 'IMAX'),
('65001', 4, 95, 'Hoạt động', '4D'),
('65001', 5, 120, 'Hoạt động', '2D'),
('65001', 6, 100, 'Hoạt động', '3D'),
('15001', 1, 120, 'Hoạt động', '2D'),
('15001', 2, 95, 'Hoạt động', '4D'),
('15001', 3, 100, 'Hoạt động', '3D'),
('15001', 4, 105, 'Hoạt động', '2D'),
('15001', 5, 110, 'Hoạt động', 'IMAX'),
('15001', 6, 90, 'Hoạt động', '2D'),
('15001', 7, 85, 'Hoạt động', '4D'),
('72001', 1, 110, 'Hoạt động', '2D'),
('72001', 2, 100, 'Hoạt động', 'IMAX'),
('72001', 3, 95, 'Hoạt động', '4D'),
('72001', 4, 120, 'Hoạt động', '2D'),
('72001', 5, 105, 'Hoạt động', '3D'),
('72001', 6, 90, 'Hoạt động', '2D');

-- -------------- QUẦY GIAO DỊCH ------------
INSERT INTO quay_giao_dich(Ma_rap,Quay_so) VALUES
('15001', 1),
('15001', 2),
('29001', 1),
('29001', 2),
('29002', 1),
('29002', 2),
('29002', 3),
('29002', 4),
('43001', 1),
('43001', 2),
('59001', 1),
('59001', 2),
('59001', 3),
('59002', 1),
('59002', 2),
('59002', 3),
('65001', 1),
('65001', 2),
('72001', 1),
('72001', 2),
('75001', 1),
('75001', 2);

-- -------------- VOUCHER THEO ĐIỂM -------------
INSERT INTO Voucher_theo_diem VALUES
(16, 350),
(17, 300),
(18, 750),
(19, 250),
(20, 550),
(21, 450),
(22, 650),
(23, 500),
(24, 700),
(25, 380),
(26, 400),
(27, 420),
(28, 680),
(29, 480),
(30, 720);
-------------- VOUCHER THEO DỊP ---------------
INSERT INTO Voucher_theo_dip (Voucher_ID, Loai_su_kien) VALUES
(1, 'Tết Nguyên Đán'),
(2, 'Valentine'),
(3, 'Quốc Khánh 2/9'),
(4, 'Ngày Phụ nữ Việt Nam'),
(5, 'Ngày Quốc tế Lao động'),
(6, 'Ngày Quốc tế Thiếu nhi'),
(7, 'Back to school'),
(8, 'Tết Trung thu'),
(9, 'Xuân yêu thương'),
(10, 'Lễ Giáng sinh'),
(11, 'Tết Dương lịch'),
(12, 'Halloween'),
(13, 'Chào đón mùa hè'),
(14, 'Ngày Phụ nữ Quốc tế'),
(15, 'Ngày Giải phóng Miền Nam'),
(31, 'Ngày Giải phóng Miền Nam');

-- -------------------- GHẾ NGỒI ---------------
INSERT INTO Ghe_ngoi (Ma_rap, Phong_so, Ghe_so, Loai_ghe) VALUES
('59001', 1, 'H07', 'Normal'),
('59001', 1, 'F05', 'Normal'),
('59001', 1, 'D05', 'Vip'),
('59001', 1, 'E08', 'Normal'),
('59001', 1, 'G01', 'Sweetbox'),
('59001', 1, 'B11', 'Sweetbox'),
('59001', 1, 'A12', 'Sweetbox'),
('59001', 2, 'A11', 'Vip'),
('59001', 2, 'G11', 'Normal'),
('59001', 2, 'D12', 'Vip'),
('59001', 2, 'H01', 'Sweetbox'),
('59001', 2, 'F01', 'Sweetbox'),
('59001', 2, 'B02', 'Sweetbox'),
('59001', 2, 'E12', 'Normal'),
('59001', 3, 'E12', 'Vip'),
('59001', 3, 'G02', 'Normal'),
('59001', 3, 'F05', 'Normal'),
('59001', 3, 'H02', 'Vip'),
('59001', 3, 'D04', 'Normal'),
('59001', 3, 'B11', 'Sweetbox'),
('59001', 3, 'C07', 'Normal'),
('59002', 1, 'E06', 'Normal'),
('59002', 1, 'F01', 'Normal'),
('59002', 1, 'A07', 'Normal'),
('59002', 1, 'B01', 'Vip'),
('59002', 1, 'C12', 'Vip'),
('59002', 1, 'G04', 'Normal'),
('59002', 1, 'H04', 'Normal'),
('59002', 2, 'H10', 'Normal'),
('59002', 2, 'G01', 'Vip'),
('59002', 2, 'C09', 'Sweetbox'),
('59002', 2, 'A01', 'Vip'),
('59002', 2, 'D02', 'Normal'),
('59002', 2, 'F01', 'Vip'),
('59002', 2, 'E10', 'Sweetbox'),
('59002', 3, 'F11', 'Sweetbox'),
('59002', 3, 'G07', 'Normal'),
('59002', 3, 'A08', 'Sweetbox'),
('59002', 3, 'C02', 'Normal'),
('59002', 3, 'H07', 'Normal'),
('59002', 3, 'D06', 'Sweetbox'),
('59002', 3, 'E10', 'Normal'),
('29001', 1, 'C04', 'Sweetbox'),
('29001', 1, 'H12', 'Sweetbox'),
('29001', 1, 'G09', 'Normal'),
('29001', 1, 'F07', 'Sweetbox'),
('29001', 1, 'B02', 'Vip'),
('29001', 1, 'E09', 'Normal'),
('29001', 1, 'D08', 'Normal'),
('29001', 2, 'H12', 'Normal'),
('29001', 2, 'A09', 'Sweetbox'),
('29001', 2, 'B01', 'Sweetbox'),
('29001', 2, 'C10', 'Normal'),
('29001', 2, 'D05', 'Vip'),
('29001', 2, 'E01', 'Normal'),
('29001', 2, 'F08', 'Normal'),
('29001', 3, 'B05', 'Normal'),
('29001', 3, 'C12', 'Vip'),
('29001', 3, 'A08', 'Normal'),
('29002', 6, 'D12', 'Normal'),
('29002', 7, 'F07', 'Normal'),
('29002', 8, 'H07', 'Vip'),
('29002', 8, 'E05', 'Normal'),
('65001', 1, 'D11', 'Vip'),
('65001', 1, 'H04', 'Sweetbox'),
('65001', 1, 'F12', 'Vip'),
('65001', 1, 'B04', 'Sweetbox'),
('65001', 1, 'A05', 'Normal'),
('65001', 1, 'C11', 'Normal'),
('65001', 1, 'E12', 'Normal'),
('65001', 2, 'G10', 'Sweetbox'),
('65001', 2, 'C01', 'Vip'),
('65001', 2, 'F06', 'Normal'),
('65001', 2, 'E11', 'Sweetbox'),
('65001', 2, 'A08', 'Normal'),
('65001', 2, 'B04', 'Normal'),
('65001', 2, 'D07', 'Sweetbox'),
('65001', 3, 'H03', 'Sweetbox'),
('65001', 3, 'D01', 'Vip'),
('65001', 3, 'F03', 'Vip'),
('65001', 3, 'C08', 'Normal'),
('65001', 3, 'B10', 'Normal'),
('65001', 3, 'G05', 'Vip'),
('65001', 3, 'A04', 'Normal'),
('15001', 1, 'H03', 'Vip'),
('15001', 1, 'D06', 'Sweetbox'),
('15001', 1, 'G08', 'Sweetbox'),
('15001', 1, 'F06', 'Sweetbox'),
('15001', 1, 'C06', 'Normal'),
('15001', 1, 'E07', 'Vip'),
('15001', 1, 'A08', 'Sweetbox'),
('15001', 2, 'H11', 'Normal'),
('15001', 2, 'F08', 'Normal'),
('15001', 2, 'C01', 'Vip'),
('15001', 2, 'G10', 'Sweetbox'),
('15001', 2, 'A02', 'Vip'),
('15001', 2, 'E02', 'Sweetbox'),
('15001', 2, 'D01', 'Sweetbox'),
('15001', 3, 'G05', 'Vip'),
('15001', 3, 'F04', 'Vip'),
('15001', 3, 'E04', 'Vip'),
('15001', 3, 'H04', 'Vip'),
('15001', 3, 'C06', 'Normal'),
('15001', 3, 'A03', 'Vip'),
('15001', 3, 'B08', 'Vip'),
('72001', 1, 'A08', 'Sweetbox'),
('72001', 1, 'B10', 'Vip'),
('72001', 1, 'H10', 'Normal'),
('72001', 1, 'G04', 'Sweetbox'),
('72001', 1, 'F04', 'Sweetbox'),
('72001', 1, 'E12', 'Sweetbox'),
('72001', 1, 'C12', 'Sweetbox'),
('72001', 2, 'H04', 'Vip'),
('72001', 2, 'F08', 'Vip'),
('72001', 2, 'C03', 'Normal'),
('72001', 2, 'D09', 'Sweetbox'),
('72001', 2, 'B03', 'Vip'),
('72001', 2, 'A03', 'Normal'),
('72001', 2, 'E05', 'Vip'),
('72001', 3, 'E03', 'Vip'),
('72001', 3, 'B08', 'Sweetbox'),
('72001', 3, 'H01', 'Normal'),
('72001', 3, 'C06', 'Vip'),
('72001', 3, 'D04', 'Sweetbox'),
('72001', 3, 'G05', 'Normal'),
('72001', 3, 'A04', 'Vip'),

('15001',2,'C02','Vip'),
('15001',2,'C03','Vip'),
('15001',2,'C04','Vip'),
('15001',2,'C05','Vip'),
('15001',2,'C06','Vip'),

('15001',3,'C01','Normal'),
('15001',3,'C02','Normal'),
('15001',3,'C03','Normal'),
('15001',3,'C04','Normal'),

('59001',2,'E01','Normal'),
('59001',2,'E02','Normal'),
('59001',2,'E03','Normal'),
('59001',2,'E04','Normal'),
('59001',2,'E05','Normal'),
('59001',2,'E06','Normal'),
('59001',2,'E07','Normal'),
('59001',2,'E08','Normal'),
('59001',2,'E09','Normal'),

('59001',2,'F02','Sweetbox'),
('59001',2,'F03','Sweetbox'),

('59001',4,'B01','Vip'),
('59001',4,'B02','Vip'),
('59001',4,'B03','Vip'),

('29001',3,'C01','Vip'),
('29001',3,'C02','Vip'),
('29001',3,'C03','Vip'),

('72001',4,'F01','Sweetbox'),
('72001',4,'F02','Sweetbox')
;

-- -------------- SUẤT CHIẾU --------------------
INSERT INTO SuatChieu (DinhDangPhim, NgonNgu, NgayBatDau, ThoiGianBatDau, ThoiGianKetThuc, MaRap, PhongSo, ID_Phim)   VALUES
( '2D', 'Vietsub', '2025-04-19', '13:00:00', '14:54:00', '59001', 1, 'MOV2023001'),
( 'IMAX', 'Thuyết minh', '2025-04-19', '15:00:00', '18:00:00', '59001', 5, 'MOV2023002'),
( '3D', 'Vietsub', '2025-04-19', '18:30:00', '20:51:00', '29001', 3, 'MOV2023003'),
('2D', 'Thuyết minh', '2025-04-19', '21:00:00', '23:12:00', '15001', 4, 'MOV2023004'),
( '2D', 'Vietsub', '2025-04-20', '10:00:00', '11:57:00', '15001', 2, 'MOV2023005'),
( '3D', 'Vietsub', '2025-04-20', '12:30:00', '14:34:00', '15001', 3, 'MOV2023006'),
( '2D', 'Vietsub', '2025-04-20', '15:00:00', '16:35:00', '15001', 6, 'MOV2023007'),
( '4D', 'Thuyết minh', '2025-04-20', '17:00:00', '18:49:00', '15001', 2, 'MOV2023008'),
( '2D', 'Vietsub', '2025-04-20', '19:00:00', '20:41:00', '65001', 1, 'MOV2023009'),
( '2D', 'Thuyết minh', '2025-04-20', '21:00:00', '23:04:00', '72001', 6, 'MOV2023010'),
( '2D', 'Vietsub', '2025-04-22', '13:20:00', '15:11:00', '72001', 1, 'MOV2023004'),
( 'IMAX', 'Vietsub', '2025-04-21', '10:00:00', '12:07:00', '29001', 2, 'MOV2024001'),
( '3D', 'Thuyết minh', '2025-04-20', '18:00:00', '19:49:00', '59001', 2, 'MOV2023001'),
( '4D', 'Vietsub', '2025-04-21', '16:00:00', '18:15:00', '15001', 7, 'MOV2024003'),
( '2D', 'Vietsub', '2025-04-20', '14:00:00', '15:57:00', '59002', 3, 'MOV2023005'),
( 'IMAX', 'Thuyết minh', '2025-04-23', '12:30:00', '14:49:00', '29002', 8, 'MOV2024002'),
( '3D', 'Vietsub', '2025-04-20', '09:00:00', '11:21:00', '15001', 2, 'MOV2023006'),
( '2D', 'Vietsub', '2025-04-25', '13:45:00', '15:34:00', '59001', 4, 'MOV2023007'),
( 'IMAX', 'Vietsub', '2025-04-27', '17:30:00', '19:38:00', '15001', 5, 'MOV2023004'),
('2D', 'Thuyết minh', '2025-04-28', '08:45:00', '10:42:00', '72001', 4, 'MOV2023005'),
( '4D', 'Vietsub', '2025-04-29', '16:30:00', '18:45:00', '65001', 5, 'MOV2024004');

-- -------------------- KHÁCH HÀNG THÀNH VIÊN --------------
INSERT INTO KhachHangThanhVien(ID_KhachHang,MaCodeTaiKhoan,ThoiGianCapNhatDiem) VALUES
('15900100001', 'TK2000000001', '2024-07-01 09:27:51'),
('15900100002', 'TK2000000002', '2024-09-11 17:59:35'),
('15900200001', 'TK2000000003', '2024-12-17 10:23:44'),
('15900200002', 'TK2000000004', '2024-11-06 15:12:58'),
('15900300006', 'TK2000000005', '2024-06-03 08:04:25'),
('15900300007', 'TK2000000006', '2024-12-09 12:34:17'),
('15900400008', 'TK2000000007', '2024-05-27 14:50:49'),
('15900400009', 'TK2000000008', '2024-08-22 10:21:13'),
('15900500010', 'TK2000000009', '2024-07-15 19:45:01'),
('15900500001', 'TK2000000010', '2025-01-31 06:13:45'),
('12900100002', 'TK2000000011', '2024-04-23 17:27:38'),
('12900100003', 'TK2000000012', '2024-08-06 08:55:42'),
('12900200004', 'TK2000000013', '2024-10-13 11:20:37'),
('12900200005', 'TK2000000014', '2024-07-27 16:38:26'),
('12900300001', 'TK2000000015', '2024-09-03 20:01:49'),
('12900300002', 'TK2000000016', '2024-11-20 14:11:06'),
('12900400003', 'TK2000000017', '2024-06-19 09:12:33'),
('12900400004', 'TK2000000018', '2025-02-25 18:44:57'),
('12900500005', 'TK2000000019', '2024-12-02 07:01:14'),
('12900600006', 'TK2000000020', '2024-10-28 13:50:11'),
('12900600007', 'TK2000000021', '2024-08-10 22:23:00'),
('16500100008', 'TK2000000022', '2024-05-03 11:02:37'),
('16500100009', 'TK2000000023', '2024-06-27 09:31:52'),
('16500200010', 'TK2000000024', '2024-09-19 14:44:30'),
('16500200001', 'TK2000000025', '2024-11-29 08:47:15'),
('16500300002', 'TK2000000026', '2024-07-09 20:10:41'),
('16500300003', 'TK2000000027', '2025-03-12 15:25:18'),
('11500100004', 'TK2000000028', '2024-10-01 13:07:22'),
('11500100005', 'TK2000000029', '2025-01-18 17:32:46'),
('11500200006', 'TK2000000030', '2024-05-14 06:56:03'),
('17200100007', 'TK2000000031', '2024-06-01 07:41:50'),
('17200100008', 'TK2000000032', '2024-08-15 21:19:34'),
('17200200009', 'TK2000000033', '2025-02-05 19:28:25'),
('17200200010', 'TK2000000034', '2024-09-24 12:10:59'),
('17200300011', 'TK2000000035', '2024-04-30 10:36:07'),
('17200300012', 'TK2000000036', '2024-12-25 08:18:12'),
('14600100013', 'TK2000000037', '2024-11-13 14:02:26'),
('14600100014', 'TK2000000038', '2024-07-20 16:15:33'),
('14600300015', 'TK2000000039', '2024-05-09 22:42:41'),
('14600300016', 'TK2000000040', '2025-01-08 07:39:08'),
('14600300017', 'TK2000000041', '2024-06-14 18:29:55'),
('15900200018', 'TK2000000042', '2024-10-19 15:58:44'),
('15900300019', 'TK2000000043', '2024-08-31 09:03:20'),
('15900600020', 'TK2000000044', '2025-03-03 12:56:17');

-- --------------------- GIAO DỊCH --------------------
INSERT INTO GiaoDich(ID_GiaoDich,LoaiGiaoDich,ThoiDiemGiaoDich,HinhThuc,ID_KhachHangThanhVien,SoDiemDuocCong,ID_KhachHang) VALUES
-- Khách hàng thường offline
('GD0000001', 'Offline', '2025-04-16 10:42:12', 'VNPay', NULL, 0, '05900100001'),
('GD0000002', 'Offline', '2025-04-17 15:38:44', 'VISA', NULL, 0, '01500200016'),
('GD0000003', 'Offline', '2025-04-20 09:17:30', 'ATM', NULL, 0, '02900500005'),
('GD0000004', 'Offline', '2025-04-15 08:22:05', 'Shopeepay', NULL, 0, '01500100015'),
('GD0000005', 'Offline', '2025-04-23 18:31:55', 'ZaloPay', NULL, 0, '02900300001'),
('GD0000006', 'Offline', '2025-04-25 11:06:06', 'ATM', NULL, 0, '05900200001'),
('GD0000007', 'Offline', '2025-04-19 13:59:07', 'Shopeepay', NULL, 0, '06500300012'),

-- Khách hàng thành viên offline (so diem duoc cong = so diem ve + so diem combo do an, 1000 => 1 diem)
('GD0000008', 'Offline', '2025-04-19 20:56:52', 'ATM', '15900100001', 190, '15900100001'), -- Vé: 2 * 95000, Combo: không
('GD0000009', 'Offline', '2025-04-23 17:34:23', 'Shopeepay', '16500300003', 359, '16500300003'), -- Vé: 2 * 95000, Combo: 169000 5
('GD0000010', 'Offline', '2025-04-20 16:58:25', 'ZaloPay', '14600300017', 449, '14600300017'), -- Vé: 3 * 100000, Combo: 149000 4

-- Khách hàng thành viên online
('GD0000011', 'Online', '2025-04-17 20:01:34', 'ATM', '12900200004', 287, '12900200004'), -- Vé: 2 * 100000, Combo: 87000 1
('GD0000012', 'Online', '2025-04-16 08:38:42', 'VNPay', '17200200010', 240, '17200200010'), -- Vé: 3 * 80000, Combo: không 
('GD0000013', 'Online', '2025-04-18 07:32:11', 'VISA', '15900200001', 339, '15900200001'), -- Vé: 2 * 95000, Combo: 149000 4
('GD0000014', 'Online', '2025-04-25 11:57:37', 'ATM', '12900100002', 264, '12900100002'), -- Vé: 1 * 95000, Combo: 169000 5
('GD0000015', 'Online', '2025-04-15 09:17:40', 'Momo', '14600300016', 190, '14600300016'); -- Vé: 2 * 95000, Combo: không

-- -------------- Đánh giá -------------
INSERT INTO DanhGia VALUES('MOV2023003','14600100013',9,
'Vừa xem xong Fast & Furious 10 và thật sự phải nói là quá đã luôn! Phim đúng chất Fast & Furious: cháy nổ, rượt đuổi, 
đánh đấm đều được đẩy lên một tầm cao mới. Jason Momoa vào vai phản diện thực sự là điểm sáng, diễn xuất vừa điên loạn 
vừa lôi cuốn – làm cho mạch phim hấp dẫn từ đầu đến cuối.
Dù đã là phần 10 rồi nhưng phim vẫn giữ được chất riêng về tình cảm gia đình, tình anh em – điều làm mình gắn bó với 
series này suốt nhiều năm qua. Các phân cảnh hành động có phần phi thực tế nhưng lại rất giải trí và mãn nhãn. 
Một số chỗ nội dung hơi nhanh, chưa được sâu, nhưng nhìn chung vẫn rất cuốn.','2025-05-24 19:05:37'),
('MOV2023005','15900100001',7,
'Mình vừa xem xong phim này và cảm thấy đây là một bộ phim nhẹ nhàng, gần gũi và khá chân thực.
 Điểm cộng lớn nhất là bối cảnh Sài Gòn được khắc họa rất đời thường, quen thuộc,diễn xuất tự nhiên, 
 âm nhạc nhẹ nhàng cũng góp phần tạo cảm xúc.Tuy nhiên, phần kịch bản đôi lúc còn hơi rời rạc, thiếu cao trào, 
 khiến mạch phim chưa thật sự bùng nổ.
 Một vài chi tiết tâm lý nhân vật chưa được khai thác sâu khiến câu chuyện đôi lúc bị trôi qua khá nhanh.
 Đây là một bộ phim đáng xem nếu bạn yêu thích những câu chuyện trưởng thành và muốn thấy một lát cắt nhẹ nhàng 
 nhưng thật về cuộc sống ở Sài Gòn.','2025-06-04 09:28:18'),
('MOV2023008','15900300007',5,
'Phim có ý tưởng hấp dẫn, lấy bối cảnh hiểm trở nơi núi tuyết, kết hợp yếu tố sinh tồn và tâm lý con người khi 
đối mặt với thảm họa thiên nhiên.
Tuy nhiên nội dung lại khá thiếu chiều sâu. Nhịp phim chậm, nhiều đoạn thoại lan man và thiếu điểm nhấn. 
Các nhân vật không được khai thác kỹ, nên khi họ gặp nguy hiểm hay xung đột thì người xem sẽ khó mà đồng cảm được.
Xem để giải trí thì cũng tạm ổn, nhưng nếu kỳ vọng một trải nghiệm kịch tính và đậm chất sinh tồn thì có thể sẽ hơi thất vọng.','2025-06-07 15:35:11'),
('MOV2024001','16500200010',10,
'Vừa xem xong phần hai và mình có cảm giác như hoàn toàn bị cuốn vào thế giới rộng lớn, 
sâu sắc và mãn nhãn của phim. Mọi thứ từ hình ảnh, âm thanh, đến nội dung đều được nâng lên một tầm cao mới so với phần đầu.
Phim không chỉ mở rộng quy mô chiến tranh mà còn đào sâu vào nội tâm nhân vật, đặc biệt là Paul Atreides. 
Cách phim khai thác số phận, niềm tin, quyền lực và sự hi sinh rất chặt chẽ và ấn tượng. Visual thì miễn bàn luôn,
từng khung hình đều đẹp như tranh, kết hợp với nhạc nền hoành tráng khiến cảm xúc như dâng trào liên tục.
Mình đánh giá phim này 10 điểm không có nhưng luôn.','2025-07-14 17:07:17'),
('MOV2024003','17200200009',7,
'Tôi cảm thấy đây là một phần phim khá ổn, dù chưa thật sự xuất sắc như kỳ vọng. Phim làm tốt vai trò giải thích 
nguồn gốc của thế giới câm lặng, đặc biệt là những phút đầu tiên khi thảm họa bắt đầu.Không khí kinh dị được giữ vững, 
âm thanh tiếp tục là vũ khí lợi hại tạo nên cảm giác hồi hộp. Diễn xuất cũng tròn vai, đặc biệt là ở những cảnh không lời thoại, 
cảm xúc vẫn được truyền tải rất rõ. Nhưng phần nội dung về sau hơi chững lại, thiếu cao trào và chưa đào sâu nhiều về nguồn gốc
sinh vật như bản thân tôi mong đợi. Có vài chi tiết được triển khai khá nhanh, khiến cảm xúc chưa kịp đẩy lên đã chuyển cảnh.
Nhìn chung tôi nghĩ đây là một phần tiền truyện đáng xem, nhưng vẫn còn thiếu một chút bùng nổ để thật sự ghi dấu ấn. ','2025-05-12 17:55:44'),
('MOV2023009','17200300011',6,
'Cảm nhận chung là phim khá dễ thương, hình ảnh rực rỡ, sáng tạo nhưng nội dung lại chưa đủ sức nặng để thật sự gây ấn tượng
Điểm cộng lớn nhất là phần hình ảnh của thế giới các nguyên tố được xây dựng độc đáo, màu sắc tươi sáng, nhân vật thiết kế 
sinh động và đáng yêu. kịch bản khá an toàn và dễ đoán. Tình tiết phát triển theo lối mòn, một số đoạn cảm xúc được đẩy lên 
nhưng chưa đủ sâu với lại nhân vật tuy đáng yêu nhưng còn thiếu chiều sâu, nên khó để đọng lại lâu sau khi xem','2025-06-17 10:25:54'),
('MOV2024004','11500200006',4,
'Vừa xem xong phần tiếp theo của hành trình gia đình trong phim trước và thật sự khá thất vọng. 
Phim cố gắng tiếp nối câu chuyện, nhưng lại thiếu chiều sâu và cảm xúc từng khiến phần đầu trở nên đặc biệt.
Cốt truyện rời rạc, nhiều tình tiết gượng ép như chỉ để lấp đầy thời lượng. Nhịp phim chậm, thiếu cao trào, 
trong khi các nhân vật thì không có nhiều phát triển mới, hầu hết chỉ lặp lại mô-típ cũ. 
Những khoảnh khắc cảm động cũng không đủ sức nặng để chạm đến người xem như trước.
Nếu bạn là fan trung thành thì có thể xem để theo dõi tiếp hành trình, còn nếu mong đợi một phần phim sâu sắc và 
mới mẻ thì mình nghĩ là không nên xem đâu.','2025-06-27 11:15:58'),
('MOV2023007','12900200004',8,
'Thật sự rất bất ngờ vì phim vừa hài hước, vừa chạm đến nhiều cảm xúc sâu sắc. Nội dung xoay quanh chuyến đi "trời ơi đất hỡi" 
của bốn người phụ nữ với cá tính khác nhau, mang đến nhiều tình huống cười ra nước mắt nhưng cũng đầy những khoảnh khắc 
lắng đọng về tình bạn, tình cảm gia đình và sự trưởng thành.Cá nhân mình thấy đây là phim giải trí có chiều sâu, 
vừa cười sảng khoái vừa thấy được nhiều điều đáng suy ngẫm. Rất đáng để rủ hội bạn thân đi xem cùng đấy.','2025-06-18 12:46:29'),
('MOV2024005','14600300015',3,
'Ý tưởng ban đầu của phim này nghe có vẻ mới lạ nhưng cách triển khai lại quá hời hợt và thiếu thuyết phục.
Kịch bản thì khá rối rắm, chuyển cảnh và nhịp phim thiếu mạch lạc, khiến người xem dễ bị lạc nhịp. Các tình tiết hành động thì 
cũ kỹ, còn yếu tố trinh thám lại không đủ sắc sảo để tạo sự hấp dẫn. Cặp đôi chính tuy có cố gắng tạo chemistry, nhưng diễn xuất 
gượng và thiếu tự nhiên. Chỉ nên xem nếu các bạn thật sự tò mò về ý tưởng "gián điệp + nhà văn", còn nếu đang tìm một 
phim hành động chất lượng tốt thì nên cân nhắc kỹ trước khi xem đấy.','2025-05-07 13:05:57'),
('MOV2023006','16500100009',5,
'Phim mang lại những pha tàn phá hoành tráng đúng chất Godzilla, với kỹ xảo được đầu tư mạnh tay, đặc biệt là cảnh 
thành phố chìm trong hỗn loạn nhìn rất mãn nhãn. Âm thanh cũng là một điểm cộng lớn, tạo cảm giác áp lực và hoang mang 
đúng với không khí thảm họa. Điểm trừ của phim là các quyết định trong phim đôi khi thiếu logic, và phần kịch bản thì đi 
theo hướng khá an toàn, không mang lại bất ngờ hay cảm xúc bùng nổ. Tui nghĩ nếu xem để giải trí, thưởng thức kỹ xảo thì
phim này cũng ổn, còn nếu ai có yêu cầu cao hơn thì nên tìm bộ khác để trải nghiệm nhé.','2025-05-25 14:45:18');

-- -------------- ĐỒ ĂN THỨC UỐNG ------
INSERT INTO Do_an_thuc_uong VALUES
(1,'My Combo',87000),
(2,'Gudetama Combo',179000),
(3,'Golden Combo',179000),
(4,'Krystal Combo',149000),
(5,'Aladdin Combo',169000),
(6,'Avenge Combo',199000),
(7,'How to train your dragon Combo',179000);

-- ----------- MUA KÈM -----------------
INSERT INTO Mua_kem(Combo_ID, So_luong, ID_giao_dich) VALUES

(6, 1, 'GD0000002'),
(5, 1, 'GD0000003'),
(1, 1, 'GD0000004'),
(6, 1, 'GD0000005'),
(1, 1, 'GD0000006'),
(6, 1, 'GD0000007'),

(5, 1, 'GD0000009'),
(4, 1, 'GD0000010'),
(1, 1, 'GD0000011'),
(4, 1, 'GD0000013'),
(5, 1, 'GD0000014');


-- -------- NHÂN VIÊN --------
INSERT INTO Nhan_vien(ID_nhan_vien,Vai_tro,ID_nhan_vien_quan_ly) VALUES
('1500133', 'Nhân viên', '1500107'),
('1500134', 'Nhân viên', '1500107'),

('2900104', 'Nhân viên', '2900122'),
('2900106', 'Thu ngân', '2900122'),
('2900107', 'Nhân viên', '2900122'),

('2900203', 'Nhân viên', '2900205'),
('2900204', 'Thu ngân', '2900205'),

('4300100', 'Nhân viên', '4300199'),
('4300108', 'Nhân viên', '4300199'),

('5900101', 'Thu ngân', '5900116'),
('5900115', 'Thu ngân', '5900116'),
('5900117', 'Nhân viên', '5900116'),

('5900202', 'Nhân viên', '5900213'),
('5900210', 'Nhân viên', '5900213'),

('6500109', 'Thu ngân', '6500129'),
('6500130', 'Nhân viên', '6500129'),

('7200139', 'Nhân viên', '7200140'),
('7200141', 'Thu ngân', '7200140'),

('7500111', 'Thu ngân', '7500137'),
('7500136', 'Nhân viên', '7500137');


INSERT INTO GiaoDichOffline(ID_GiaoDich, MaRap, QuaySo) VALUES
('GD0000001', '59001', 2),
('GD0000002', '29002', 1),
('GD0000003', '15001', 2),
('GD0000004', '59002', 1),
('GD0000005', '65001', 1),
('GD0000006', '29002', 3),
('GD0000007', '75001', 2),
('GD0000008', '29001', 1),
('GD0000009', '59001', 1),
('GD0000010', '29002', 4);



-- ----------------- LÀM VIỆC TẠI --------------
INSERT INTO lam_viec_tai VALUES
('29001', 1, '2900106'),
('29001', 2, '2900107'),
('29002', 1, '2900203'),
('29002', 3, '2900203'),
('29002', 2, '2900204'),
('43001', 1, '4300100'),
('43001', 2, '4300108'),
('59001', 1, '5900101'),
('59001', 2, '5900115'),
('59001', 3, '5900117'),
('59002', 1, '5900202'),
('59002', 2, '5900210'),
('59002', 3, '5900210'),
('65001', 1, '6500109'),
('65001', 2, '6500130'),
('72001', 1, '7200139'),
('72001', 2, '7200141'),
('75001', 1, '7500111'),
('75001', 2, '7500136');

-- ------------ CA TRỰC ---------------------
INSERT INTO CaTruc (NgayTruc, BuoiTruc) VALUES
('2025-04-19', 'Sang'), ('2025-04-19', 'Chieu'), ('2025-04-19', 'Toi'),
('2025-04-20', 'Sang'), ('2025-04-20', 'Chieu'), ('2025-04-20', 'Toi'),
('2025-04-21', 'Sang'), ('2025-04-21', 'Chieu'), ('2025-04-21', 'Toi'),
('2025-04-22', 'Sang'), ('2025-04-22', 'Chieu'), ('2025-04-22', 'Toi'),
('2025-04-23', 'Sang'), ('2025-04-23', 'Chieu'), ('2025-04-23', 'Toi'),
('2025-04-24', 'Sang'), ('2025-04-24', 'Chieu'), ('2025-04-24', 'Toi'),
('2025-04-25', 'Sang'), ('2025-04-25', 'Chieu'), ('2025-04-25', 'Toi'),
('2025-04-26', 'Sang'), ('2025-04-26', 'Chieu'), ('2025-04-26', 'Toi'),
('2025-04-27', 'Sang'), ('2025-04-27', 'Chieu'), ('2025-04-27', 'Toi'),
('2025-04-28', 'Sang'), ('2025-04-28', 'Chieu'), ('2025-04-28', 'Toi'),
('2025-04-29', 'Sang'), ('2025-04-29', 'Chieu'), ('2025-04-29', 'Toi'),

('2025-05-01', 'Sang'), ('2025-05-01', 'Toi'),
('2025-05-02', 'Chieu'),
('2025-05-03', 'Sang'),
('2025-05-04', 'Toi'),
('2025-05-05', 'Chieu'),
('2025-05-06', 'Sang'),
('2025-05-07', 'Toi'),
('2025-05-08', 'Sang'),
('2025-05-09', 'Chieu'),
('2025-05-10', 'Toi'),
('2025-05-11', 'Sang'),
('2025-05-12', 'Chieu'),
('2025-05-13', 'Toi'),
('2025-05-14', 'Sang'),
('2025-05-15', 'Chieu'),
('2025-05-16', 'Toi'),
('2025-05-17', 'Sang'),
('2025-05-18', 'Chieu'),
('2025-05-19', 'Toi');


-- ----------- PHÂN CÔNG -----------
INSERT INTO phan_cong (ID_nhan_vien, Ngay_truc, Buoi_truc) VALUES
('1500133', '2025-04-19', 'Sang'),
('2900104', '2025-04-19', 'Chieu'),
('4300100', '2025-04-19', 'Toi'),

-- Ngày 2025-04-20
('2900203', '2025-04-20', 'Sang'),
('5900115', '2025-04-20', 'Chieu'),
('6500130', '2025-04-20', 'Toi'),

-- Ngày 2025-04-21
('1500134', '2025-04-21', 'Sang'),
('2900107', '2025-04-21', 'Chieu'),
('7200141', '2025-04-21', 'Toi'),

-- Ngày 2025-04-22
('2900106', '2025-04-22', 'Sang'),
('5900202', '2025-04-22', 'Chieu'),
('7500111', '2025-04-22', 'Toi'),

-- Ngày 2025-04-23
('5900117', '2025-04-23', 'Sang'),
('4300108', '2025-04-23', 'Chieu'),
('2900204', '2025-04-23', 'Toi'),

-- Ngày 2025-04-24
('5900210', '2025-04-24', 'Sang'),
('6500109', '2025-04-24', 'Chieu'),
('7200139', '2025-04-24', 'Toi'),

-- Ngày 2025-04-25
('7500136', '2025-04-25', 'Sang'),
('1500133', '2025-04-25', 'Chieu'),
('2900104', '2025-04-25', 'Toi'),

-- Ngày 2025-04-26
('4300100', '2025-04-26', 'Sang'),
('2900203', '2025-04-26', 'Chieu'),
('5900115', '2025-04-26', 'Toi'),

-- Ngày 2025-04-27
('6500130', '2025-04-27', 'Sang'),
('1500134', '2025-04-27', 'Chieu'),
('2900107', '2025-04-27', 'Toi'),

-- Ngày 2025-04-28
('7200141', '2025-04-28', 'Sang'),
('2900106', '2025-04-28', 'Chieu'),
('5900202', '2025-04-28', 'Toi'),

-- Ngày 2025-04-29
('7500111', '2025-04-29', 'Sang'),
('5900117', '2025-04-29', 'Chieu'),
('4300108', '2025-04-29', 'Toi'),


('2900106', '2025-05-01', 'Sang'),
('2900107', '2025-05-01', 'Toi'),

('2900203', '2025-05-02', 'Chieu'),
('2900204', '2025-05-03', 'Sang'),

('4300100', '2025-05-04', 'Toi'),
('4300108', '2025-05-05', 'Chieu'),

('5900101', '2025-05-06', 'Sang'),
('5900115', '2025-05-07', 'Toi'),
('5900117', '2025-05-08', 'Sang'),

('5900202', '2025-05-09', 'Chieu'),
('5900210', '2025-05-10', 'Toi'),

('6500109', '2025-05-11', 'Sang'),
('6500130', '2025-05-12', 'Chieu'),

('7200139', '2025-05-13', 'Toi'),
('7200141', '2025-05-14', 'Sang'),

('7500111', '2025-05-15', 'Chieu'),
('7500136', '2025-05-16', 'Toi'),

('2900106', '2025-05-17', 'Sang'),
('2900107', '2025-05-19', 'Toi'),

('2900203', '2025-05-18', 'Chieu');

-- ------------ BẢNG GIÁ VÉ --------------------
INSERT INTO Bang_gia_ve  VALUES
(1, '2D', 'Normal', 75000),
(2, '2D', 'Vip', 80000),
(3, '2D', 'Sweetbox', 100000),
(4, '3D', 'Normal', 95000),
(5, '3D', 'Vip', 100000),
(6, '3D', 'Sweetbox', 120000),
(7, '4D', 'Normal', 180000),
(8, '4D', 'Vip', 185000),
(9, '4D', 'Sweetbox', 205000),
(10, 'IMAX', 'Normal', 180000),
(11, 'IMAX', 'Vip', 185000),
(12, 'IMAX', 'Sweetbox', 205000);
-- -------------- VÉ -------------------
INSERT INTO Ve(ID_GiaoDich, MaRap, PhongSo, GheSo, ID_SuatChieu, ID_LoaiVe)   VALUES
( 'GD0000001', '15001', 1, 'A08', 1, 12),
( 'GD0000001', '15001', 1, 'C06', 1, 1),
( 'GD0000001', '15001', 1, 'D06', 1, 5),
( 'GD0000001', '15001', 1, 'E07', 1, 7),
( 'GD0000001', '15001', 1, 'F06', 1, 2),
( 'GD0000001', '15001', 1, 'G08', 1, 3),
( 'GD0000001', '15001', 1, 'H03', 1, 7),
( 'GD0000002', '15001', 2, 'A02', 2, 8),
( 'GD0000002', '15001', 2, 'C01', 2, 7),
( 'GD0000002', '15001', 2, 'D01', 2, 9),
( 'GD0000002', '15001', 2, 'E02', 2, 10),
( 'GD0000002', '15001', 2, 'F08', 2, 11),
( 'GD0000002', '15001', 2, 'G10', 2, 12),
( 'GD0000002', '15001', 2, 'H11', 2, 1),
( 'GD0000003', '15001', 3, 'A03', 3, 5),
( 'GD0000003', '15001', 3, 'B08', 3, 4),
('GD0000003', '15001', 3, 'C06', 3, 5),
('GD0000003', '15001', 3, 'E04', 3, 7),
( 'GD0000003', '15001', 3, 'F04', 3, 7),
('GD0000003', '15001', 3, 'G05', 3, 10),
( 'GD0000003', '15001', 3, 'H04', 3, 11),
( 'GD0000004', '29001', 1, 'B02', 1, 3),
( 'GD0000004', '29001', 1, 'C04', 1, 12),
( 'GD0000004', '29001', 1, 'D08', 1, 2),
( 'GD0000004', '29001', 1, 'E09', 1, 2),
( 'GD0000004', '29001', 1, 'F07', 1, 6),
( 'GD0000004', '29001', 1, 'G09', 1, 1),
( 'GD0000004', '29001', 1, 'H12', 1, 12),
( 'GD0000005', '29001', 2, 'A09', 2, 6),
( 'GD0000005', '29001', 2, 'B01', 2, 12),
( 'GD0000005', '29001', 2, 'C10', 2, 1),

('GD0000006','15001',2,'C01',5,8),
('GD0000006','15001',2,'C02',5,8),
('GD0000006','15001',2,'C03',5,8),
('GD0000006','15001',2,'C04',5,8),
('GD0000006','15001',2,'C05',5,8),
('GD0000006','15001',2,'C06',5,8),

('GD0000007','59001',2,'E01',13,4),
('GD0000007','59001',2,'E02',13,4),
('GD0000007','59001',2,'E03',13,4),
('GD0000007','59001',2,'E04',13,4),

('GD0000007','59001',2,'F02',13,6),
('GD0000007','59001',2,'F03',13,6),

('GD0000008','15001',3,'C01',6,4),
('GD0000008','15001',3,'C02',6,4),

('GD0000009','15001',3,'C03',6,4),
('GD0000009','15001',3,'C04',6,4),

('GD0000010','29001',3,'C01',3,5),
('GD0000010','29001',3,'C02',3,5),
('GD0000010','29001',3,'C03',3,5),

('GD0000011','72001',4,'F01',20,3),
('GD0000011','72001',4,'F02',20,3),

('GD0000012','59001',4,'B01',18,2),
('GD0000012','59001',4,'B02',18,2),
('GD0000012','59001',4,'B03',18,2),

('GD0000013','59001',2,'E05',13,4),
('GD0000013','59001',2,'E06',13,4),

('GD0000014','59001',2,'E07',13,4),

('GD0000015','59001',2,'E08',13,4),
('GD0000015','59001',2,'E09',13,4);
;

-- ----------- ÁP DỤNG --------------
INSERT INTO Ap_dung(ID_giao_dich, Voucher_ID) VALUES
('GD0000010', 15),
('GD0000010', 31),

('GD0000013', 15),
('GD0000013', 31),

('GD0000014', 15),

('GD0000015', 15);

-- ----------- QUY ĐỔI --------------
INSERT INTO Quy_doi(Voucher_ID,ID_Khach_hang,Ngay,Gio) VALUES
(26,'14600300017','2025-04-20','13:57:00'), -- -400
(16,'16500300003','2025-04-21','09:32:18'), -- -350
(17,'15900200001','2025-04-22','17:22:10'), -- -300
(19,'12900200004','2025-04-28','14:02:09'); -- -250

-- --------------------------------- PROCEDURES FOR INSERT, UPDATE, DELETE - THINH,VIET ANH -----------------------------------------
DELIMITER //
CREATE PROCEDURE insert_showtime(
    IN movie_format VARCHAR(30),
    IN language_in VARCHAR(30),
    IN date_in DATE,
    IN start_time TIME,
    IN cinema_id CHAR(5),
    IN room_number INT,
    IN movie_id CHAR(10) 
)
BEGIN
    DECLARE movie_duration TIME;
    DECLARE end_time TIME;
    DECLARE remaining_time_in_day INT;
    DECLARE movie_duration_in_minutes INT;
    
    -- Kiểm tra movie_id có tồn tại
    IF NOT EXISTS (
        SELECT 1 FROM cinema.phim WHERE ID_phim = movie_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Không tìm thấy bộ phim với movie_id này.';
    END IF;

    -- Kiểm tra cinema_id có tồn tại
    IF NOT EXISTS (
        SELECT 1 FROM  cinema.rapchieuphim WHERE MaRap = cinema_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Không tìm thấy rạp chiếu với tên rạp này.';
    END IF;

    -- Kiểm tra cinema_id + room_number có tồn tại
    IF NOT EXISTS (
        SELECT 1 FROM  cinema.phongchieu
        WHERE MaRap = cinema_id AND PhongSo = room_number
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Không tìm thấy phòng chiếu với cinema_id và room_number này.';
    END IF;

    -- Kiểm tra giá trị đầu vào
    IF TRIM(movie_format) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Định dạng phim không được để trống.';
    END IF;

    IF TRIM(language_in) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Định dạng ngôn ngữ không được để trống.';
    END IF;

    IF date_in IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Ngày chiếu không được để trống.';
    END IF;

    IF start_time IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Thời gian bắt đầu không được để trống.';
    END IF;

    IF room_number <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Số phòng không hợp lệ.';
    END IF;

    -- Lấy thời lượng phim
    SELECT ThoiLuong INTO movie_duration
    FROM  cinema.phim
    WHERE ID_Phim = movie_id;

    -- Tính thời gian còn lại trong ngày
	SET remaining_time_in_day = TIMESTAMPDIFF(
    MINUTE,
    STR_TO_DATE(CONCAT(date_in, ' ', start_time), '%Y-%m-%d %H:%i:%s'),
    STR_TO_DATE(CONCAT(date_in, ' 23:59:59'), '%Y-%m-%d %H:%i:%s')
	);

	-- Chuyển duration từ TIME sang phút
	SET movie_duration_in_minutes = TIME_TO_SEC(movie_duration) / 60;

    -- Kiểm tra nếu phim chiếu lố qua ngày hôm sau
    IF movie_duration_in_minutes > remaining_time_in_day THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Suất chiếu phim không được để lố thời gian qua ngày hôm sau.';
    END IF;

    -- Tính thời gian kết thúc
    SET end_time = ADDTIME(start_time, SEC_TO_TIME(movie_duration_in_minutes * 60));

    -- Kiểm tra trùng suất chiếu
    IF EXISTS (
        SELECT 1
        FROM  cinema.suatchieu
        WHERE MaRap = cinema_id
          AND PhongSo = room_number
          AND NgayBatDau = date_in
          AND (
              (start_time >= ThoiGianBatDau AND start_time < ThoiGianKetThuc)
              OR (end_time > ThoiGianBatDau AND end_time <= ThoiGianKetThuc)
              OR (start_time <= ThoiGianBatDau AND end_time >= ThoiGianKetThuc)
              OR (start_time >= ThoiGianBatDau AND end_time <= ThoiGianKetThuc)
          )
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Suất chiếu bị chồng chéo với suất chiếu khác.';
    END IF;

    -- Thêm suất chiếu mới
    INSERT INTO  cinema.suatchieu (
        DinhDangPhim, NgonNgu, NgayBatDau,
       ThoiGianBatDau, ThoiGianKetThuc, MaRap, PhongSo, ID_Phim
    )
    VALUES (
        movie_format, language_in, date_in,
        start_time, end_time, cinema_id, room_number, movie_id
    );
     SELECT 'Thêm suất chiếu thành công' AS ThongBao;
END;
//
DELIMITER ;

-- THÀNH CÔNG -- 
CALL insert_showtime(
    '2D',              -- movie_format
    'Vietsub',      -- language_in
    '2025-05-02',      -- date_in
    '18:00:00',        -- start_time
    '59001',             -- cinema_id
    2,                 -- room_number
    'MOV2023002'          -- movie_id (Avengers)
);
-- Chồng chéo suất chiếu --
-- CALL insert_showtime(
--     '2D',              -- movie_format
--     'Vietsub',      -- language_in
--     '2025-05-02',      -- date_in
--     '19:00:00',        -- start_time
--     '59001',             -- cinema_id
--     2,                 -- room_number
--     'MOV2023006'          -- movie_id (Avengers)
-- );
-- Suất chiếu vượt qua ngày mới --
-- CALL insert_showtime(
--     '2D',              -- movie_format
--     'Vietsub',      -- language_in
--     '2025-05-02',      -- date_in
--     '23:00:00',        -- start_time
--     '59001',             -- cinema_id
--     2,                 -- room_number
--     'MOV2023006'          -- movie_id (Avengers)
-- );
-- -------------------- UPDATE SUAT CHIEU  ---------------------------------
DELIMITER $$

CREATE PROCEDURE update_suatchieu (
    IN p_ID_SuatChieu TINYINT UNSIGNED,
    IN p_DinhDangPhim CHAR(9),
    IN p_NgonNgu VARCHAR(25),
    IN p_NgayBatDau DATE,
    IN p_ThoiGianBatDau TIME,
    IN p_MaRap CHAR(5),
    IN p_PhongSo TINYINT UNSIGNED,
    IN p_ID_Phim CHAR(10)
)
BEGIN
	DECLARE v_Exists INT DEFAULT 0;
    DECLARE v_ThoiLuong TIME;
    DECLARE v_ThoiLuong_in_minutes INT;
    DECLARE v_ThoiGianKetThuc TIME;
    DECLARE v_TrungLich INT;
    DECLARE remaining_time_in_day INT;
	DECLARE v_count INT;
    
    SELECT COUNT(*) INTO v_count
    FROM SuatChieu
    WHERE ID_SuatChieu = IFNULL(p_ID_SuatChieu, ID_SuatChieu)
      AND DinhDangPhim = IFNULL(p_DinhDangPhim, DinhDangPhim)
      AND NgonNgu = IFNULL(p_NgonNgu, NgonNgu)
      AND NgayBatDau = IFNULL(p_NgayBatDau, NgayBatDau)
      AND ThoiGianBatDau = IFNULL(p_ThoiGianBatDau, ThoiGianBatDau)
      AND MaRap = IFNULL(p_MaRap, MaRap)
      AND PhongSo = IFNULL(p_PhongSo, PhongSo)
      AND ID_Phim = IFNULL(p_ID_Phim, ID_Phim);
      
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Dữ liệu vẫn chưa bị thay đổi.';
	END IF;
    -- 1. Kiểm tra ID_SuatChieu tồn tại
    SELECT COUNT(*) INTO v_Exists FROM SuatChieu WHERE ID_SuatChieu = p_ID_SuatChieu;
    IF v_Exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Không tìm thấy suất chiếu với ID_SuatChieu này.';
    END IF;

    -- 2. Kiểm tra liên kết ID_Phim
    IF p_ID_Phim IS NOT NULL THEN
        SELECT COUNT(*) INTO v_Exists FROM Phim WHERE ID_Phim = p_ID_Phim;
        IF v_Exists = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Không tìm thấy bộ phim với ID_Phim này.';
        END IF;
    ELSE
        SELECT ID_Phim INTO p_ID_Phim FROM SuatChieu WHERE ID_SuatChieu = p_ID_SuatChieu;
    END IF;

    -- 3. Kiểm tra liên kết MaRap
    IF p_MaRap IS NOT NULL THEN
        SELECT COUNT(*) INTO v_Exists FROM RapChieuPhim WHERE MaRap = p_MaRap;
        IF v_Exists = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Không tìm thấy rạp chiếu với mã rạp này.';
        END IF;
	ELSE
		SELECT MaRap INTO p_MaRap FROM SuatChieu WHERE ID_SuatChieu = p_ID_SuatChieu;
    END IF;

    -- 4. Kiểm tra PhongSo hợp lệ trong rạp
    IF p_PhongSo IS NOT NULL THEN
        SELECT COUNT(*) INTO v_Exists FROM PhongChieu
        WHERE MaRap = p_MaRap AND PhongSo = p_PhongSo;
        IF v_Exists = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Phòng chiếu không tồn tại trong rạp được chọn.';
        END IF;
	ELSE
		SELECT PhongSo INTO p_PhongSo FROM SuatChieu WHERE ID_SuatChieu = p_ID_SuatChieu;
    END IF;

    -- 5. Kiểm tra định dạng phim và ngôn ngữ
    IF p_DinhDangPhim IS NOT NULL AND LENGTH(TRIM(p_DinhDangPhim)) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Định dạng phim không được để trống.';
    END IF;

    IF p_NgonNgu IS NOT NULL AND LENGTH(TRIM(p_NgonNgu)) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Ngôn ngữ không được để trống.';
    END IF;

    -- 6. Tính thời gian kết thúc
    IF p_NgayBatDau IS NULL THEN
        SELECT NgayBatDau INTO p_NgayBatDau FROM SuatChieu WHERE ID_SuatChieu = p_ID_SuatChieu;
    END IF;
    
    IF p_ThoiGianBatDau IS NULL THEN
        SELECT ThoiGianBatDau INTO p_ThoiGianBatDau FROM SuatChieu WHERE ID_SuatChieu = p_ID_SuatChieu;
    END IF;

	SET remaining_time_in_day = TIMESTAMPDIFF(
    MINUTE,
    STR_TO_DATE(CONCAT(p_NgayBatDau, ' ', p_ThoiGianBatDau), '%Y-%m-%d %H:%i:%s'),
    STR_TO_DATE(CONCAT(p_NgayBatDau, ' 23:59:59'), '%Y-%m-%d %H:%i:%s')
	);
    
    SELECT ThoiLuong INTO v_ThoiLuong FROM Phim WHERE ID_Phim = p_ID_Phim;
    SET v_ThoiLuong_in_minutes = TIME_TO_SEC(v_ThoiLuong) / 60;
	SET v_ThoiGianKetThuc = ADDTIME(p_ThoiGianBatDau, v_ThoiLuong);
    IF v_ThoiLuong_in_minutes > remaining_time_in_day THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Thời gian kết thúc vượt quá nửa đêm.';
    END IF;

    -- 7. Kiểm tra trùng suất chiếu
    SELECT COUNT(*) INTO v_TrungLich
    FROM SuatChieu SC
    JOIN Phim P ON SC.ID_Phim = P.ID_Phim
    WHERE SC.MaRap = p_MaRap
        AND SC.PhongSo = p_PhongSo
        AND SC.NgayBatDau = p_NgayBatDau
        AND SC.ID_SuatChieu <> p_ID_SuatChieu
        AND (
            -- Thời gian chiếu mới giao với bất kỳ suất hiện tại
            (p_ThoiGianBatDau BETWEEN SC.ThoiGianBatDau AND ADDTIME(SC.ThoiGianBatDau, P.ThoiLuong)) OR
            (v_ThoiGianKetThuc BETWEEN SC.ThoiGianBatDau AND ADDTIME(SC.ThoiGianBatDau, P.ThoiLuong)) OR
            (p_ThoiGianBatDau <= SC.ThoiGianBatDau AND v_ThoiGianKetThuc >= ADDTIME(SC.ThoiGianBatDau, P.ThoiLuong))
        );

    IF v_TrungLich > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Suất chiếu bị trùng thời gian với suất khác trong cùng phòng.';
    END IF;

    -- 8. Thực hiện cập nhật
    UPDATE SuatChieu SET
        DinhDangPhim = IFNULL(p_DinhDangPhim, DinhDangPhim),
        NgonNgu = IFNULL(p_NgonNgu, NgonNgu),
        NgayBatDau = IFNULL(p_NgayBatDau, NgayBatDau),
        ThoiGianBatDau = IFNULL(p_ThoiGianBatDau, ThoiGianBatDau),
        ThoiGianKetThuc = v_ThoiGianKetThuc,
        MaRap = IFNULL(p_MaRap, MaRap),
        PhongSo = IFNULL(p_PhongSo, PhongSo),
        ID_Phim = IFNULL(p_ID_Phim, ID_Phim)
    WHERE ID_SuatChieu = p_ID_SuatChieu;

    SELECT 'Cập nhật suất chiếu thành công!' AS ThongBao;

END$$

DELIMITER ;

-- ------------------- DELETE SUAT CHIEU ---------------------------------
DELIMITER $$

CREATE PROCEDURE delete_suatchieu(IN p_ID_SuatChieu TINYINT UNSIGNED)
BEGIN
    DECLARE v_count INT;

    -- Kiểm tra suất chiếu có tồn tại không
    SELECT COUNT(*) INTO v_count
    FROM SuatChieu
    WHERE ID_SuatChieu = p_ID_SuatChieu;

    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Không tìm thấy suất chiếu với ID_SuatChieu này.';
    END IF;

    -- Kiểm tra có vé nào đã được đặt không
    SELECT COUNT(*) INTO v_count
    FROM Ve
    WHERE ID_SuatChieu = p_ID_SuatChieu;

    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi: Không thể xóa suất chiếu vì có vé đã được đặt.';
    END IF;

    -- Thực hiện xóa suất chiếu
    DELETE FROM SuatChieu
    WHERE ID_SuatChieu = p_ID_SuatChieu;

    -- Kiểm tra lại để xác nhận đã xóa thành công
    SELECT 'Xóa suất chiếu thành công!' AS ThongBao;
END$$

DELIMITER ;
-- -------------------------PROCEDURE - PHUC -----------------------------------
DELIMITER $$
CREATE PROCEDURE TimSuatChieu(
    IN p_Ngay DATE,
    IN p_Gio TIME,
    IN p_TenRap VARCHAR(30),
    IN p_TheLoai VARCHAR(25),
    IN p_TuaDe VARCHAR(30)
)
BEGIN
    SELECT 
        SC.ID_SuatChieu,
        SC.DinhDangPhim,
        SC.NgonNgu,
        SC.NgayBatDau,
        SC.ThoiGianBatDau,
        P.ThoiLuong,
        R.TenRap,
        SC.PhongSo,
        P.TuaDe AS TenPhim,
        P.TheLoai
    FROM 
        SuatChieu SC
        JOIN Phim P ON SC.ID_Phim = P.ID_Phim
        JOIN RapChieuPhim R ON SC.MaRap = R.MaRap
    WHERE 
        (p_Ngay IS NULL OR SC.NgayBatDau = p_Ngay)
        AND (p_Gio IS NULL OR SC.ThoiGianBatDau <= p_Gio  AND SC.ThoiGianBatDau +P.ThoiLuong >= p_gio)
        AND (p_TenRap IS NULL OR p_TenRap = '' OR R.TenRap = p_TenRap)
        AND (p_TheLoai IS NULL OR p_TheLoai = '' OR P.TheLoai = p_TheLoai)
        AND (p_TuaDe IS NULL OR p_TuaDe = '' OR P.TuaDe = p_TuaDe)
    ORDER BY 
        SC.ID_SuatChieu ASC;
END$$

DELIMITER ;

DELIMITER //

CREATE PROCEDURE LietKeKhachHangTheoDiem(
    IN SoDiemQuyDinh INT,
    IN ThoiGianBatDau DATETIME,
    IN ThoiGianKetThuc DATETIME
)
BEGIN
    SELECT 
        KH.ID_KhachHang, 
        KH.HoTen,
        SUM(GD.SoDiemDuocCong) AS TongDiem
    FROM 
        KhachHang KH
        JOIN GiaoDich GD ON KH.ID_KhachHang = GD.ID_KhachHang
        JOIN KhachHangThanhVien KHTV ON KH.ID_KhachHang = KHTV.ID_KhachHang
    WHERE 
        (ThoiGianBatDau IS NULL OR GD.ThoiDiemGiaoDich >= ThoiGianBatDau)
        AND (ThoiGianKetThuc IS NULL OR GD.ThoiDiemGiaoDich <= ThoiGianKetThuc)
    GROUP BY 
        KH.ID_KhachHang
    HAVING 
        SoDiemQuyDinh IS NULL OR SUM(GD.SoDiemDuocCong) >= SoDiemQuyDinh
    ORDER BY 
        SUM(GD.SoDiemDuocCong) DESC;
END //

DELIMITER ;

-- CALL LietKeKhachHangTheoDiem(700, NULL,NULL);
-- ------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE get_all_showtimes()
BEGIN
    SELECT 
        s.ID_SuatChieu as showtime_id,
        s.DinhDangPhim as movie_format,
        s.NgonNgu as language,
        s.NgayBatDau as NgayBatDau,
        s.ThoiGianBatDau as ThoiGianBatDau,
        SEC_TO_TIME(
            TIME_TO_SEC(s.ThoiGianBatDau) + 
            (TIME_TO_SEC(p.ThoiLuong))
        ) as ThoiGianKetThuc,
        s.MaRap as cinema_id,
        r.TenRap as cinema_name,
        s.PhongSo as room_number,
        s.ID_Phim as movie_id,
        p.TuaDe as movie_name,
        p.ThoiLuong as movie_duration
    FROM 
        suatchieu s, rapchieuphim r, phim p
    WHERE 
        s.MaRap = r.MaRap AND s.ID_phim = p.ID_phim
    ORDER BY 
        s.NgayBatDau DESC, 
        s.ThoiGianBatDau ASC;
END //
DELIMITER ;
-- ---------------- FUNCTION - THIEN ---------------------
-- Thống kê doanh thu các rạp trong khoảng ngày nào đó
-- Input : ngay_bat_dau, ngay_ket_thuc
-- Output : tên rạp, tỉnh thành , địa chỉ, doanh thu drop function ThongKeDoanhThuTheoKhoangNgay
DELIMITER $$

CREATE FUNCTION ThongKeDoanhThuTheoKhoangNgay(ngay_bat_dau DATE, ngay_ket_thuc DATE)
RETURNS JSON
DETERMINISTIC
BEGIN
    DECLARE done TINYINT DEFAULT 0;
    
    DECLARE var_ten_rap VARCHAR(30);
    DECLARE var_tinh VARCHAR(25);
    DECLARE var_dia_chi VARCHAR(50);
    DECLARE var_doanh_thu INT;

    DECLARE var_result JSON DEFAULT JSON_ARRAY();

    DECLARE cur CURSOR FOR
        SELECT TenRap, TenTinhThanh, DiaChi, SUM(TongThanhToan) AS TongDoanhThu
        FROM 
			(SELECT gd.ID_GiaoDich,NgayBatDau,TenRap,DiaChi,TenTinhThanh,TongThanhToan 
			FROM giaodich gd
				JOIN ve v ON gd.ID_GiaoDich = v.ID_GiaoDich
				JOIN suatchieu sc ON v.ID_SuatChieu = sc.ID_SuatChieu
				JOIN rapchieuphim rc ON rc.MaRap = v.MaRap
			WHERE NgayBatDau BETWEEN ngay_bat_dau AND ngay_ket_thuc
			GROUP BY gd.ID_GiaoDich,NgayBatDau,TenRap,DiaChi,TenTinhThanh) AS TEMP			
            
		GROUP BY TenRap, TenTinhThanh, DiaChi;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

	IF ngay_bat_dau IS NULL THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ngày bắt đầu không được để trống';
	END IF;
    
	IF ngay_ket_thuc IS NULL THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ngày kết thúc không được để trống';
	END IF;
    
	IF ngay_ket_thuc < ngay_bat_dau THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu';
    END IF;
    
    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO var_ten_rap, var_tinh, var_dia_chi, var_doanh_thu;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SET var_result = JSON_ARRAY_APPEND(
            var_result, '$',
            JSON_OBJECT(
                'TenRap', var_ten_rap,
                'TinhThanh', var_tinh,
                'DiaChi', var_dia_chi,
                'DoanhThu', var_doanh_thu
            )
        );
    END LOOP;

    CLOSE cur;

    RETURN var_result;
END$$

DELIMITER ;


SELECT *
FROM JSON_TABLE(
    ThongKeDoanhThuTheoKhoangNgay('2025-04-19','2025-04-27'),
    '$[*]' COLUMNS (
        TenRap VARCHAR(30) PATH '$.TenRap',
        TinhThanh VARCHAR(25) PATH '$.TinhThanh',
        DiaChi VARCHAR(50) PATH '$.DiaChi',
        DoanhThu INT PATH '$.DoanhThu'
    )
) AS DoanhThuTheoRap;

-- ----------------------------------------------------
-- Lấy top 3 phim có doanh thu cao nhất trong ngay chieu
DELIMITER $$

CREATE FUNCTION GetTopPhim(ngay_chieu DATE)
RETURNS JSON
DETERMINISTIC
BEGIN	
    DECLARE done INT DEFAULT FALSE;
    DECLARE var_ID_Phim CHAR(10);
    DECLARE var_TuaDe VARCHAR(30);
    DECLARE var_DoanhThu INT;
    DECLARE var_json JSON DEFAULT JSON_ARRAY();
    
    DECLARE cur CURSOR FOR
        SELECT p.ID_Phim, p.TuaDe, SUM(bgv.GiaVe) AS DoanhThu
        FROM Ve v 	JOIN SuatChieu sc ON v.ID_SuatChieu = sc.ID_SuatChieu
					JOIN Phim p ON sc.ID_Phim = p.ID_Phim
					JOIN Bang_gia_ve bgv ON v.ID_LoaiVe = bgv.ID_loai_ve
        WHERE DATE(sc.NgayBatDau) = ngay_chieu
        GROUP BY p.ID_Phim, p.TuaDe
        ORDER BY DoanhThu DESC;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	IF ngay_chieu IS NULL THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ngày không được để trống.';
	END IF;

    IF ngay_chieu > CURDATE() THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ngày không được lớn hơn ngày hiện tại.';
    END IF;
    
    SET @rank := 0;
    SET @prev := NULL;
    SET @count := 0;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO var_ID_Phim, var_TuaDe, var_DoanhThu;
        IF done THEN
            LEAVE read_loop;
        END IF;

        IF var_DoanhThu != @prev THEN
            SET @rank := @rank + 1;
            SET @prev := var_DoanhThu;
        END IF;

        IF @rank <= 3 THEN
            SET var_json = JSON_ARRAY_APPEND(var_json, '$', JSON_OBJECT('TuaDe', var_TuaDe, 'DoanhThu', var_DoanhThu));
        ELSE
            LEAVE read_loop;
        END IF;
        
    END LOOP;

    CLOSE cur;

    RETURN var_json;
END$$

DELIMITER ;

SELECT *
FROM JSON_TABLE(
    GetTopPhim('2025-04-19'),
    '$[*]' 
    COLUMNS (
        TuaDe VARCHAR(30) PATH '$.TuaDe',
        DoanhThu INT PATH '$.DoanhThu'
	)
) AS TopPhim;
