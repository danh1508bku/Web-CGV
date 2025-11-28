const sql = require('mssql');

const config = {
  server: 'LAPTOP-P0HATMA3\\SQLEXPRESS',
  database: 'Movie',
  options: {
    encrypt: false,  // Tắt encryption cho local dev
    trustServerCertificate: true,  // Trust self-signed certificate
    enableArithAbort: true,
    instanceName: 'SQLEXPRESS'  // Chỉ định instance name
  },
  authentication: {
    type: 'default',  // Windows Authentication
    options: {
      userName: '',  // Để trống cho Windows Auth
      password: ''
    }
  },
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000
  }
};

// Tạo connection pool
let poolPromise = sql.connect(config)
  .then(pool => {
    console.log("✅ Kết nối SQL Server thành công!");
    return pool;
  })
  .catch(err => {
    console.error("❌ Lỗi kết nối:", err);
    throw err;
  });

// Export sql module và poolPromise
module.exports = {
  sql,
  poolPromise
};
