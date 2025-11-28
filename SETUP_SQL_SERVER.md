# Hướng Dẫn Kết Nối SQL Server

## 📋 Yêu Cầu

- Node.js (đã cài đặt)
- SQL Server (SQLEXPRESS hoặc phiên bản khác)
- Database: BTL2_DBS

## 🔧 Cấu Hình

### 1. Cài Đặt Dependencies

Các package cần thiết đã được cài đặt:
- `mssql`: Driver kết nối SQL Server
- `dotenv`: Quản lý biến môi trường

```bash
npm install
```

### 2. Cấu Hình File .env

File `.env` đã được tạo sẵn với cấu hình mặc định. Bạn cần **chỉnh sửa** các thông tin sau cho phù hợp với SQL Server của bạn:

```env
# Thông tin từ ảnh của bạn:
DB_SERVER=LAPTOP-P0HATMA3\\SQLEXPRESS
DB_DATABASE=BTL2_DBS
DB_USER=LAPTOP-P0HATMA3\\Danh Khoaa
DB_PASSWORD=

# Cấu hình bảo mật
DB_ENCRYPT=true
DB_TRUST_CERT=true
```

#### 📝 Lưu Ý Quan Trọng:

1. **Server Name**: Sử dụng `\\` (double backslash) cho tên instance
   - Ví dụ: `LAPTOP-P0HATMA3\\SQLEXPRESS`

2. **Windows Authentication**:
   - Nếu bạn đang sử dụng Windows Authentication (như trong ảnh), để trống `DB_PASSWORD`
   - Đảm bảo `DB_USER` có định dạng: `TÊN_MÁY\\Tên_User`

3. **SQL Server Authentication**:
   - Nếu sử dụng SQL Server Authentication, điền đầy đủ username và password:
   ```env
   DB_USER=sa
   DB_PASSWORD=your_password_here
   ```

4. **Encryption**:
   - `DB_ENCRYPT=true`: Bật mã hóa kết nối (bắt buộc với Azure)
   - `DB_TRUST_CERT=true`: Tin tưởng certificate của server (đã check trong ảnh)

### 3. Kiểm Tra Database

Đảm bảo database `BTL2_DBS` đã được tạo trong SQL Server:

```sql
USE BTL2_DBS;
GO
```

### 4. Chạy Server

```bash
npm start
# hoặc
node BE/server.js
```

## ✅ Xác Nhận Kết Nối Thành Công

Khi kết nối thành công, bạn sẽ thấy:
```
✅ Kết nối SQL Server thành công
Server running on http://localhost:3000
Danh sách các hàm và thủ tục: [...]
```

## ❌ Troubleshooting

### Lỗi: "Login failed for user"
- **Nguyên nhân**: Sai username/password hoặc user không có quyền truy cập database
- **Giải pháp**:
  1. Kiểm tra lại username và password trong `.env`
  2. Đảm bảo user có quyền truy cập vào database `BTL2_DBS`
  3. Nếu dùng Windows Authentication trên máy khác Windows, cần chuyển sang SQL Server Authentication

### Lỗi: "Failed to connect to server"
- **Nguyên nhân**: Không thể kết nối đến SQL Server
- **Giải pháp**:
  1. Kiểm tra SQL Server đang chạy
  2. Kiểm tra tên server trong `.env` (phải có `\\` cho instance name)
  3. Enable TCP/IP trong SQL Server Configuration Manager
  4. Kiểm tra firewall cho phép kết nối đến port 1433

### Lỗi: "Self signed certificate"
- **Nguyên nhân**: Vấn đề với SSL certificate
- **Giải pháp**: Đặt `DB_TRUST_CERT=true` trong `.env`

## 🔄 Thay Đổi từ MySQL sang SQL Server

Dự án đã được chuyển đổi từ MySQL sang SQL Server với các thay đổi chính:

1. **Driver**: `mysql2` → `mssql`
2. **Connection**: Callback-based → Promise-based
3. **Query Syntax**: MySQL syntax → T-SQL syntax
4. **Stored Procedures**: `CALL procedure(?)` → `EXECUTE procedure @param`
5. **JSON Functions**: `JSON_TABLE` → `OPENJSON`

## 📚 Tài Liệu Tham Khảo

- [mssql Package Documentation](https://www.npmjs.com/package/mssql)
- [SQL Server Connection Strings](https://www.connectionstrings.com/sql-server/)
- [SQL Server Express Documentation](https://docs.microsoft.com/en-us/sql/sql-server/)
