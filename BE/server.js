const express = require('express');
const cors = require('cors');
const { poolPromise } = require('./database/db');
const functionRouter = require('./routers/functionRouter');
const { getFunction_Procedure_FromDatabase } = require('./controllers/functionController');

const app = express();
const port = 3000;

// Middleware
app.use(cors());
app.use(express.json()); // Parse JSON body
app.use(express.urlencoded({ extended: true })); // Parse URL-encoded body

// Routes
app.use('/', functionRouter);

// Khởi tạo server với async/await
async function startServer() {
  try {
    // Đợi kết nối database
    await poolPromise;
    console.log('✅ Database connection pool đã sẵn sàng');

    // Lấy danh sách procedures và functions
    await getFunction_Procedure_FromDatabase();

    // Khởi động server
    app.listen(port, () => {
      console.log(`🚀 Server đang chạy tại http://localhost:${port}`);
      console.log(`📝 API endpoints:`);
      console.log(`   - GET  /health`);
      console.log(`   - GET  /call-function?proc=<name>&params=[...]&func=<type>`);
      console.log(`   - GET  /tim-suat-chieu`);
      console.log(`   - GET  /tai-khoan-tieu-nhieu`);
      console.log(`   - GET  /thong-ke-doanh-thu`);
      console.log(`   - GET  /top-5-phim`);
      console.log(`   - POST /them-suat-chieu`);
      console.log(`   - PUT  /cap-nhat-suat-chieu`);
      console.log(`   - DELETE /xoa-suat-chieu`);
    });

  } catch (err) {
    console.error('❌ Lỗi khởi động server:', err);
    process.exit(1);
  }
}

// Bắt đầu server
startServer();
