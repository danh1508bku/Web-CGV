const sql = require('mssql/msnodesqlv8');

const config = {
  server: 'LAPTOP-P0HATMA3\\SQLEXPRESS',
  database: 'Movie',   // hoặc tên DB bạn muốn
  driver: 'msnodesqlv8',
  options: {
    trustedConnection: true
  }
};

sql.connect(config)
  .then(() => {
    console.log("✅ Kết nối SQL Server thành công!");
  })
  .catch(err => {
    console.error("❌ Lỗi kết nối:", err);
  });
