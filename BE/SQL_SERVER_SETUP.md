# Hướng dẫn Enable TCP/IP cho SQL Server Express

## ⚠️ Vấn đề
Lỗi: `Data source name not found and no default driver specified`

## ✅ Giải pháp: Enable TCP/IP Protocol

### Bước 1: Mở SQL Server Configuration Manager

1. Nhấn `Windows + R`
2. Gõ: `SQLServerManager15.msc` (hoặc `SQLServerManager14.msc` cho SQL Server 2017)
3. Nhấn Enter

**Lưu ý:** Nếu không tìm thấy, search "SQL Server Configuration Manager" trong Start Menu

---

### Bước 2: Enable TCP/IP Protocol

1. Trong **SQL Server Configuration Manager**, mở rộng:
   ```
   SQL Server Network Configuration
   └── Protocols for SQLEXPRESS
   ```

2. **TCP/IP** hiện đang `Disabled`
   - Right-click vào **TCP/IP**
   - Chọn **Enable**

3. Xuất hiện warning "Changes will not take effect until service is restarted"
   - Click **OK**

---

### Bước 3: Cấu hình TCP/IP Port (Quan trọng!)

1. Right-click vào **TCP/IP** → Chọn **Properties**

2. Chuyển sang tab **IP Addresses**

3. Scroll xuống cuối, tìm **IPALL**:
   - **TCP Dynamic Ports**: Xóa giá trị (để trống)
   - **TCP Port**: Nhập `1433`

4. Click **OK**

---

### Bước 4: Restart SQL Server Service

1. Trong **SQL Server Configuration Manager**, mở rộng:
   ```
   SQL Server Services
   ```

2. Right-click vào **SQL Server (SQLEXPRESS)**

3. Chọn **Restart**

4. Đợi service restart hoàn tất (status = Running)

---

### Bước 5: Kiểm tra Windows Firewall (nếu cần)

Nếu vẫn không kết nối được, mở port 1433 trong Windows Firewall:

**PowerShell (Run as Administrator):**
```powershell
New-NetFirewallRule -DisplayName "SQL Server" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action Allow
```

**Hoặc thủ công:**
1. Mở **Windows Defender Firewall with Advanced Security**
2. Click **Inbound Rules** → **New Rule**
3. Chọn **Port** → Next
4. Chọn **TCP**, nhập port `1433` → Next
5. Chọn **Allow the connection** → Next
6. Check all (Domain, Private, Public) → Next
7. Đặt tên: "SQL Server" → Finish

---

### Bước 6: Enable SQL Server Browser (Optional nhưng recommended)

1. Trong **SQL Server Configuration Manager**
2. Mở **SQL Server Services**
3. Right-click **SQL Server Browser** → **Properties**
4. Tab **Service**: Đổi **Start Mode** thành **Automatic**
5. Click **OK**
6. Right-click **SQL Server Browser** → **Start**

---

## 🧪 Test Connection

Sau khi hoàn tất các bước trên, test lại server:

```bash
cd BE
node server.js
```

**Kết quả mong đợi:**
```
✅ Kết nối SQL Server thành công!
✅ Database connection pool đã sẵn sàng
✅ Danh sách các hàm và thủ tục: [...]
🚀 Server đang chạy tại http://localhost:3000
```

---

## 🔧 Nếu vẫn gặp lỗi

### Option 1: Sử dụng SQL Server Authentication

Thay đổi `BE/database/db.js`:

```javascript
const config = {
  server: 'LAPTOP-P0HATMA3\\SQLEXPRESS',
  database: 'Movie',
  user: 'sa',  // SQL Server username
  password: 'your_password',  // SQL Server password
  options: {
    encrypt: false,
    trustServerCertificate: true,
    enableArithAbort: true,
    instanceName: 'SQLEXPRESS'
  },
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000
  }
};
```

**Lưu ý:** Cần enable SQL Server Authentication trong SQL Server:
1. Mở **SQL Server Management Studio (SSMS)**
2. Right-click server → **Properties**
3. Chọn **Security**
4. Chọn **SQL Server and Windows Authentication mode**
5. Click **OK** và restart SQL Server

---

### Option 2: Sử dụng localhost thay vì tên máy

Thay đổi trong `BE/database/db.js`:

```javascript
const config = {
  server: 'localhost\\SQLEXPRESS',  // Thay vì LAPTOP-P0HATMA3\SQLEXPRESS
  // ... rest of config
};
```

---

### Option 3: Sử dụng IP + Port trực tiếp

```javascript
const config = {
  server: 'localhost',
  port: 1433,
  database: 'Movie',
  // ... rest of config
};
```

---

## 📝 Kiểm tra SQL Server có chạy không

**CMD hoặc PowerShell:**
```powershell
# Kiểm tra SQL Server Service
sc query MSSQL$SQLEXPRESS

# Hoặc
Get-Service | Where-Object {$_.Name -like "*SQL*"}
```

**Kết quả mong đợi:**
```
STATE              : 4  RUNNING
```

---

## 🎯 Troubleshooting Commands

```bash
# Test connection với sqlcmd (nếu có cài)
sqlcmd -S LAPTOP-P0HATMA3\SQLEXPRESS -E -Q "SELECT @@VERSION"

# Kiểm tra port TCP/IP đang listening
netstat -an | findstr "1433"
```

---

## 📞 Support

Nếu vẫn không được, kiểm tra:
1. SQL Server có đang chạy không?
2. TCP/IP đã enable chưa?
3. Port 1433 đã mở trong Firewall chưa?
4. Database "Movie" có tồn tại không? (check trong SSMS)

Chạy lệnh này để verify:
```bash
cd BE
node -e "require('./database/db').poolPromise.then(() => console.log('✅ OK')).catch(err => console.error('❌', err.message))"
```
