const sql = require('mssql/msnodesqlv8');

const config = {
  server: 'LAPTOP-P0HATMA3\\SQLEXPRESS',
  database: 'Movie',
  driver: 'msnodesqlv8',
  options: {
    trustedConnection: true,
    enableArithAbort: true,
    encrypt: false
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
