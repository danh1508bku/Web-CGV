require('dotenv').config();
const sql = require('mssql');

// Cấu hình kết nối SQL Server
const config = {
  server: process.env.DB_SERVER,
  database: process.env.DB_DATABASE,
  options: {
    encrypt: process.env.DB_ENCRYPT === 'true',
    trustServerCertificate: process.env.DB_TRUST_CERT === 'true',
    enableArithAbort: true,
  },
};

// Sử dụng Windows Authentication nếu không có user/password
if (process.env.DB_USER && process.env.DB_PASSWORD) {
  config.user = process.env.DB_USER;
  config.password = process.env.DB_PASSWORD;
  config.authentication = {
    type: 'default'
  };
} else {
  // Windows Authentication (Trusted Connection)
  config.authentication = {
    type: 'ntlm',
    options: {
      domain: '',
      userName: process.env.DB_USER || '',
      password: ''
    }
  };
}

// Tạo connection pool
const poolPromise = new sql.ConnectionPool(config)
  .connect()
  .then(pool => {
    console.log('✅ Kết nối SQL Server thành công');
    return pool;
  })
  .catch(err => {
    console.error('❌ Kết nối SQL Server thất bại:', err.message);
    throw err;
  });

module.exports = {
  sql,
  poolPromise
};
