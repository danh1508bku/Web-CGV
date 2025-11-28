const sql = require('mssql');

// Thử config 1: Sử dụng localhost + port (đơn giản nhất)
const config = {
  server: 'localhost',
  port: 1433,
  database: 'Movie',
  options: {
    encrypt: false,
    trustServerCertificate: true,
    enableArithAbort: true
  },
  authentication: {
    type: 'default'
  },
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000
  },
  connectionTimeout: 30000,
  requestTimeout: 30000
};

// Nếu config trên không work, uncomment config 2 bên dưới và comment config 1
/*
// Config 2: Sử dụng tên máy + instance
const config = {
  server: 'LAPTOP-P0HATMA3\\SQLEXPRESS',
  database: 'Movie',
  options: {
    encrypt: false,
    trustServerCertificate: true,
    enableArithAbort: true,
    instanceName: 'SQLEXPRESS'
  },
  authentication: {
    type: 'default'
  },
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000
  },
  connectionTimeout: 30000,
  requestTimeout: 30000
};
*/

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
