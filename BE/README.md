# CGV Movie Database - Backend API

Backend API cho hệ thống quản lý rạp chiếu phim CGV sử dụng **MS SQL Server**.

## 🎯 Tổng quan

Backend này cung cấp RESTful API để tương tác với database SQL Server, bao gồm:
- **5 Stored Procedures**: Insert, Update, Delete, TimSuatChieu, LietKeTaiKhoanTieuNhieu
- **2 Scalar Functions**: ThongKeDoanhThuVeCuaRap, Top5PhimDoanhThuCaoNhat
- **2 Triggers**: Tự động cập nhật chi tiêu lũy kế và kiểm tra độ tuổi xem phim

## 📦 Cài đặt

### Prerequisites

1. **Node.js** (v14+)
2. **MS SQL Server** (SQL Server Express or higher)
3. **SQL Server Native Client** (cho mssql/msnodesqlv8)

### Cài đặt Dependencies

```bash
cd BE
npm install
```

Dependencies chính:
- `express`: Web framework
- `cors`: CORS middleware
- `mssql/msnodesqlv8`: SQL Server driver với Windows Authentication

### Cấu hình Database

Cập nhật file `database/db.js` với thông tin SQL Server của bạn:

```javascript
const config = {
  server: 'YOUR_SERVER\\SQLEXPRESS',  // Ví dụ: 'LAPTOP-ABC\\SQLEXPRESS'
  database: 'Movie',
  driver: 'msnodesqlv8',
  options: {
    trustedConnection: true  // Windows Authentication
  }
};
```

### Import Database Schema

1. Mở SQL Server Management Studio (SSMS)
2. Kết nối đến SQL Server của bạn
3. Chạy file `FE/BTL2_DBS_HK251.sql` để tạo:
   - Database `Movie`
   - Tất cả tables, procedures, functions, triggers
   - Sample data

## 🚀 Chạy Server

```bash
node server.js
```

Server sẽ chạy tại `http://localhost:3000`

Output mong đợi:
```
✅ Kết nối SQL Server thành công!
✅ Database connection pool đã sẵn sàng
✅ Danh sách các hàm và thủ tục: [...]
📊 Tổng số: 7 procedures/functions
🚀 Server đang chạy tại http://localhost:3000
📝 API endpoints:
   - GET  /health
   - GET  /call-function
   ...
```

## 📁 Cấu trúc thư mục

```
BE/
├── database/
│   └── db.js                    # SQL Server connection configuration
├── controllers/
│   └── functionController.js    # Business logic cho procedures/functions
├── routers/
│   └── functionRouter.js        # API route definitions
├── server.js                    # Entry point
├── API_TESTING.md              # Hướng dẫn test API chi tiết
├── README.md                    # File này
└── package.json
```

## 🔧 Kiến trúc

### Database Layer (`database/db.js`)
- Tạo connection pool với MS SQL Server
- Sử dụng Windows Authentication (trustedConnection)
- Export `sql` module và `poolPromise`

### Controller Layer (`controllers/functionController.js`)
- `getFunction_Procedure_FromDatabase()`: Lấy danh sách procedures/functions
- `callStoredProcedure()`: Gọi stored procedure chung
- `callStoredFunction()`: Gọi scalar function chung
- Các functions đặc biệt:
  - `callInsertSuatChieu()`
  - `callUpdateSuatChieu()`
  - `callDeleteSuatChieu()`
  - `callTimSuatChieu()`
  - `callLietKeTaiKhoanTieuNhieu()`
  - `callThongKeDoanhThuVeCuaRap()`
  - `callTop5PhimDoanhThuCaoNhat()`

### Router Layer (`routers/functionRouter.js`)
- Định nghĩa tất cả API endpoints
- Validation tham số đầu vào
- Error handling

## 📚 API Documentation

Xem file [API_TESTING.md](./API_TESTING.md) để biết chi tiết về:
- Tất cả endpoints
- Request/Response format
- Ví dụ cURL và Postman
- Testing guide

### Quick Examples

```bash
# Health check
curl http://localhost:3000/health

# Tìm suất chiếu
curl "http://localhost:3000/tim-suat-chieu?ngayChieu=2024-12-25"

# Top 5 phim
curl "http://localhost:3000/top-5-phim?ngayBatDau=2024-01-01&ngayKetThuc=2024-12-31"

# Thêm suất chiếu
curl -X POST http://localhost:3000/them-suat-chieu \
  -H "Content-Type: application/json" \
  -d '{"maSuatChieu":"SC00001","maPhim":"PHIM000001",...}'
```

## 🗃️ Database Schema

### Stored Procedures

1. **sp_Insert_SuatChieu** (10 params)
   - Thêm suất chiếu mới với validation đầy đủ
   - Kiểm tra: NOT NULL, PRIMARY KEY, FOREIGN KEY, CHECK constraints
   - Kiểm tra logic nghiệp vụ: định dạng phòng, thời gian trùng lặp

2. **Update_ThongTinSuatChieu** (5 params)
   - Cập nhật giờ bắt đầu và/hoặc phòng chiếu
   - Kiểm tra: suất chiếu tồn tại, chưa có vé bán, không trùng lịch

3. **Delete_SuatChieu** (2 params)
   - Xóa suất chiếu
   - Kiểm tra: đã có vé bán chưa, đã qua giờ chiếu chưa

4. **TimSuatChieu** (4 params optional)
   - Tìm kiếm suất chiếu với WHERE, ORDER BY
   - Params: NgayChieu, Gio, TenRap, TuaDe

5. **LietKeTaiKhoanTieuNhieu** (1 param optional)
   - Liệt kê tài khoản có tổng chi tiêu cao
   - GROUP BY, HAVING

### Scalar Functions

1. **ThongKeDoanhThuVeCuaRap** (2 params)
   - Tham số: NgayBatDau, NgayKetThuc
   - Trả về: JSON array [{MaRap, TenRap, TinhThanh, DoanhThu}]

2. **Top5PhimDoanhThuCaoNhat** (2 params)
   - Tham số: NgayBatDau, NgayKetThuc
   - Trả về: JSON array [{XepHang, MaPhim, TuaDe, DoanhThu}]

### Triggers

1. **trg_UpdateTongChiTieuLuyKe**
   - Bảng: GiaoDich (AFTER UPDATE)
   - Tự động cập nhật TongChiTieuLuyKe khi TrangThai = "Đã thanh toán"

2. **trg_CheckTuoiXemPhim**
   - Bảng: Ve (AFTER INSERT, UPDATE)
   - Kiểm tra độ tuổi khách hàng với GioiHanDoTuoi của phim

## 🔄 Thay đổi so với MySQL

Code ban đầu được thiết kế cho MySQL, đã được chuyển đổi hoàn toàn sang MS SQL Server:

| MySQL | MS SQL Server |
|-------|---------------|
| `CALL procedure()` | `EXEC procedure` hoặc `request.execute()` |
| `JSON_TABLE()` | Parse JSON string với `JSON.parse()` |
| `db.query(callback)` | `async/await` với `request.query()` |
| Schema name: `CINEMA` | Schema name: `dbo` |
| `?` placeholders | Named parameters `@param0`, `@param1` |

## 🐛 Troubleshooting

### Lỗi kết nối SQL Server

```
❌ Lỗi kết nối: ConnectionError: Failed to connect to...
```

**Giải pháp:**
1. Kiểm tra SQL Server có đang chạy không (SQL Server Configuration Manager)
2. Kiểm tra tên server đúng không (`YOUR_PC\\SQLEXPRESS`)
3. Enable TCP/IP protocol trong SQL Server Configuration Manager
4. Restart SQL Server service

### Lỗi "Procedure không tồn tại"

```
❌ Lỗi: Could not find stored procedure 'sp_Insert_SuatChieu'
```

**Giải pháp:**
1. Chạy file `BTL2_DBS_HK251.sql` trong SSMS
2. Kiểm tra database đúng là `Movie`
3. Restart server để load lại procedures

### Lỗi JSON parse

```
❌ Unexpected token in JSON
```

**Giải pháp:**
- Kiểm tra function SQL có trả về JSON hợp lệ không
- Test function trực tiếp trong SSMS: `SELECT dbo.FunctionName(@param1, @param2)`

## 📝 Development

### Thêm endpoint mới

1. Viết function trong `controllers/functionController.js`
2. Export function
3. Import vào `routers/functionRouter.js`
4. Thêm route mới
5. Update documentation

### Testing

Sử dụng curl hoặc Postman để test:
```bash
# Test health check
curl http://localhost:3000/health

# Test với params
curl "http://localhost:3000/tim-suat-chieu?ngayChieu=2024-12-25"
```

## 🤝 Contributing

1. Fork repo
2. Tạo branch mới (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Tạo Pull Request

## 📄 License

MIT License

## 👥 Authors

- Đội ngũ phát triển CGV Movie Database System

## 📞 Support

Nếu gặp vấn đề:
1. Kiểm tra [API_TESTING.md](./API_TESTING.md)
2. Kiểm tra [Troubleshooting](#troubleshooting)
3. Tạo issue trên GitHub
