# API Testing Guide - CGV Movie Database

## 🚀 Khởi động server

```bash
cd BE
node server.js
```

Server sẽ chạy tại: `http://localhost:3000`

---

## 📋 Danh sách API Endpoints

### 1. **Health Check**
Kiểm tra server có hoạt động không

**GET** `/health`

```bash
curl http://localhost:3000/health
```

---

### 2. **Tìm Suất Chiếu** (TimSuatChieu)
Tìm kiếm suất chiếu với các tham số tùy chọn

**GET** `/tim-suat-chieu`

**Query Parameters** (tất cả optional):
- `ngayChieu`: DATE (yyyy-mm-dd)
- `gio`: TIME (HH:MM)
- `tenRap`: NVARCHAR(100)
- `tuaDe`: NVARCHAR(50)

**Ví dụ:**
```bash
# Tìm tất cả suất chiếu
curl http://localhost:3000/tim-suat-chieu

# Tìm theo ngày
curl "http://localhost:3000/tim-suat-chieu?ngayChieu=2024-12-25"

# Tìm theo nhiều điều kiện
curl "http://localhost:3000/tim-suat-chieu?ngayChieu=2024-12-25&gio=18:00&tenRap=CGV%20Vincom"
```

---

### 3. **Liệt Kê Tài Khoản Chi Tiêu Cao** (LietKeTaiKhoanTieuNhieu)
Liệt kê tài khoản có tổng chi tiêu lũy kế cao

**GET** `/tai-khoan-tieu-nhieu`

**Query Parameters**:
- `tongChiTieu`: DECIMAL(18,2) - optional (null = lấy tất cả)

**Ví dụ:**
```bash
# Lấy tất cả tài khoản
curl http://localhost:3000/tai-khoan-tieu-nhieu

# Lấy tài khoản chi tiêu >= 1,000,000 VNĐ
curl "http://localhost:3000/tai-khoan-tieu-nhieu?tongChiTieu=1000000"
```

---

### 4. **Thống Kê Doanh Thu Vé Của Rạp** (ThongKeDoanhThuVeCuaRap)
Thống kê doanh thu vé theo rạp trong khoảng thời gian

**GET** `/thong-ke-doanh-thu`

**Query Parameters** (required):
- `ngayBatDau`: DATE (yyyy-mm-dd)
- `ngayKetThuc`: DATE (yyyy-mm-dd)

**Response**: JSON array
```json
[
  {
    "MaRap": "RAP01",
    "TenRap": "CGV Vincom Center",
    "TinhThanh": "TP.HCM",
    "DoanhThu": 125000000.00
  }
]
```

**Ví dụ:**
```bash
curl "http://localhost:3000/thong-ke-doanh-thu?ngayBatDau=2024-01-01&ngayKetThuc=2024-12-31"
```

---

### 5. **Top 5 Phim Doanh Thu Cao Nhất** (Top5PhimDoanhThuCaoNhat)
Top 5 phim có doanh thu cao nhất trong khoảng thời gian

**GET** `/top-5-phim`

**Query Parameters** (required):
- `ngayBatDau`: DATE (yyyy-mm-dd)
- `ngayKetThuc`: DATE (yyyy-mm-dd)

**Response**: JSON array
```json
[
  {
    "XepHang": 1,
    "MaPhim": "PHIM000001",
    "TuaDe": "Avatar 2",
    "DoanhThu": 500000000.00
  }
]
```

**Ví dụ:**
```bash
curl "http://localhost:3000/top-5-phim?ngayBatDau=2024-01-01&ngayKetThuc=2024-12-31"
```

---

### 6. **Thêm Suất Chiếu Mới** (sp_Insert_SuatChieu)
Thêm một suất chiếu mới vào hệ thống

**POST** `/them-suat-chieu`

**Content-Type**: `application/json`

**Body Parameters** (all required):
```json
{
  "maSuatChieu": "SC00001",
  "maPhim": "PHIM000001",
  "maRap": "RAP01",
  "maPhongChieu": 1,
  "ngayChieu": "2024-12-25",
  "dinhDangChieu": "2D",
  "ngonNgu": "Tiếng Việt",
  "trangThai": "Mở bán",
  "hinhThucDichThuat": "PhuDe",
  "gioBatDau": "18:00:00"
}
```

**Ví dụ:**
```bash
curl -X POST http://localhost:3000/them-suat-chieu \
  -H "Content-Type: application/json" \
  -d '{
    "maSuatChieu": "SC00001",
    "maPhim": "PHIM000001",
    "maRap": "RAP01",
    "maPhongChieu": 1,
    "ngayChieu": "2024-12-25",
    "dinhDangChieu": "2D",
    "ngonNgu": "Tiếng Việt",
    "trangThai": "Mở bán",
    "hinhThucDichThuat": "PhuDe",
    "gioBatDau": "18:00:00"
  }'
```

---

### 7. **Cập Nhật Suất Chiếu** (Update_ThongTinSuatChieu)
Cập nhật giờ bắt đầu và/hoặc phòng chiếu của suất chiếu

**PUT** `/cap-nhat-suat-chieu`

**Content-Type**: `application/json`

**Body Parameters**:
- `maSuatChieu`: CHAR(7) - required
- `maPhim`: CHAR(10) - required
- `maRap`: CHAR(5) - required
- `gioBatDauMoi`: TIME - optional
- `maPhongMoi`: TINYINT - optional

```json
{
  "maSuatChieu": "SC00001",
  "maPhim": "PHIM000001",
  "maRap": "RAP01",
  "gioBatDauMoi": "19:30:00",
  "maPhongMoi": 2
}
```

**Ví dụ:**
```bash
curl -X PUT http://localhost:3000/cap-nhat-suat-chieu \
  -H "Content-Type: application/json" \
  -d '{
    "maSuatChieu": "SC00001",
    "maPhim": "PHIM000001",
    "maRap": "RAP01",
    "gioBatDauMoi": "19:30:00"
  }'
```

---

### 8. **Xóa Suất Chiếu** (Delete_SuatChieu)
Xóa một suất chiếu khỏi hệ thống

**DELETE** `/xoa-suat-chieu`

**Content-Type**: `application/json`

**Body Parameters**:
```json
{
  "maSuatChieu": "SC00001",
  "maPhim": "PHIM000001"
}
```

**Ví dụ:**
```bash
curl -X DELETE http://localhost:3000/xoa-suat-chieu \
  -H "Content-Type: application/json" \
  -d '{
    "maSuatChieu": "SC00001",
    "maPhim": "PHIM000001"
  }'
```

---

### 9. **Gọi Procedure/Function Tùy Chỉnh** (Tổng quát)
Route linh hoạt để gọi bất kỳ procedure/function nào

**GET** `/call-function`

**Query Parameters**:
- `proc`: Tên procedure/function
- `params`: JSON array các tham số (optional)
- `func`: Loại gọi
  - `False`: Stored Procedure
  - `True`: Scalar Function
  - `INSERT`: sp_Insert_SuatChieu
  - `UPDATE`: Update_ThongTinSuatChieu
  - `DELETE`: Delete_SuatChieu

**Ví dụ:**
```bash
# Gọi procedure TimSuatChieu
curl 'http://localhost:3000/call-function?proc=TimSuatChieu&params=["2024-12-25",null,null,null]&func=False'

# Gọi function Top5PhimDoanhThuCaoNhat
curl 'http://localhost:3000/call-function?proc=Top5PhimDoanhThuCaoNhat&params=["2024-01-01","2024-12-31"]&func=True'
```

---

## 📊 Triggers (Tự động chạy)

### 1. **trg_UpdateTongChiTieuLuyKe**
- **Bảng**: GiaoDich
- **Sự kiện**: AFTER UPDATE
- **Chức năng**: Tự động cập nhật `TongChiTieuLuyKe` trong bảng `TaiKhoanThanhVien` khi trạng thái giao dịch chuyển sang "Đã thanh toán"

### 2. **trg_CheckTuoiXemPhim**
- **Bảng**: Ve
- **Sự kiện**: AFTER INSERT, UPDATE
- **Chức năng**: Kiểm tra độ tuổi khách hàng có đủ để xem phim không (dựa vào `GioiHanDoTuoi` của phim)

---

## 🧪 Testing với Postman

Import collection này vào Postman để test nhanh:

```json
{
  "info": {
    "name": "CGV API Tests",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Health Check",
      "request": {
        "method": "GET",
        "header": [],
        "url": {
          "raw": "http://localhost:3000/health",
          "protocol": "http",
          "host": ["localhost"],
          "port": "3000",
          "path": ["health"]
        }
      }
    },
    {
      "name": "Tìm Suất Chiếu",
      "request": {
        "method": "GET",
        "header": [],
        "url": {
          "raw": "http://localhost:3000/tim-suat-chieu?ngayChieu=2024-12-25",
          "protocol": "http",
          "host": ["localhost"],
          "port": "3000",
          "path": ["tim-suat-chieu"],
          "query": [
            {
              "key": "ngayChieu",
              "value": "2024-12-25"
            }
          ]
        }
      }
    },
    {
      "name": "Top 5 Phim",
      "request": {
        "method": "GET",
        "header": [],
        "url": {
          "raw": "http://localhost:3000/top-5-phim?ngayBatDau=2024-01-01&ngayKetThuc=2024-12-31",
          "protocol": "http",
          "host": ["localhost"],
          "port": "3000",
          "path": ["top-5-phim"],
          "query": [
            {
              "key": "ngayBatDau",
              "value": "2024-01-01"
            },
            {
              "key": "ngayKetThuc",
              "value": "2024-12-31"
            }
          ]
        }
      }
    }
  ]
}
```

---

## ⚠️ Lưu ý quan trọng

1. **Định dạng ngày**: Sử dụng format `yyyy-mm-dd` (ví dụ: `2024-12-25`)
2. **Định dạng giờ**: Sử dụng format `HH:MM:SS` (ví dụ: `18:00:00`)
3. **Encoding URL**: Nhớ encode các ký tự đặc biệt trong URL (space = `%20`)
4. **JSON Body**: Đảm bảo `Content-Type: application/json` khi gửi POST/PUT/DELETE
5. **Error Handling**: API sẽ trả về status code và message chi tiết khi có lỗi

---

## 🔍 Response Format

Tất cả response đều có format chuẩn:

**Success:**
```json
{
  "success": true,
  "data": [...],
  "count": 10
}
```

**Error:**
```json
{
  "success": false,
  "error": "Mô tả lỗi",
  "message": "Chi tiết lỗi từ SQL Server"
}
```

---

## 📞 Support

Nếu gặp lỗi, kiểm tra:
1. SQL Server có đang chạy không?
2. Database "Movie" có tồn tại không?
3. Các stored procedures/functions đã được tạo chưa?
4. Connection string trong `db.js` có đúng không?
