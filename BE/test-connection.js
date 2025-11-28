// Test connection đơn giản
const sql = require('mssql');

console.log('🔍 Đang test kết nối SQL Server...\n');

// Test với localhost:1433
const config1 = {
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
  connectionTimeout: 10000
};

// Test với named instance
const config2 = {
  server: 'localhost\\SQLEXPRESS',
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
  connectionTimeout: 10000
};

async function testConnection(config, name) {
  try {
    console.log(`📡 Test ${name}...`);
    const pool = await sql.connect(config);
    console.log(`✅ ${name}: THÀNH CÔNG!`);
    await pool.close();
    return true;
  } catch (err) {
    console.log(`❌ ${name}: THẤT BẠI`);
    console.log(`   Lỗi: ${err.message}\n`);
    return false;
  }
}

async function runTests() {
  console.log('=' .repeat(60));

  const test1 = await testConnection(config1, 'Config 1 (localhost:1433)');
  const test2 = await testConnection(config2, 'Config 2 (localhost\\SQLEXPRESS)');

  console.log('=' .repeat(60));
  console.log('\n📊 KẾT QUẢ:\n');

  if (test1) {
    console.log('✅ Sử dụng Config 1 trong db.js (localhost:1433)');
    console.log('   Config đã được set sẵn trong db.js\n');
  } else if (test2) {
    console.log('✅ Sử dụng Config 2 trong db.js (localhost\\SQLEXPRESS)');
    console.log('   Cần uncomment Config 2 và comment Config 1 trong db.js\n');
  } else {
    console.log('❌ Cả 2 config đều thất bại!\n');
    console.log('🔧 HƯỚNG DẪN KHẮC PHỤC:\n');
    console.log('1. Kiểm tra SQL Server có đang chạy:');
    console.log('   PowerShell: Get-Service | Where-Object {$_.Name -like "*SQL*"}\n');
    console.log('2. Enable TCP/IP trong SQL Server Configuration Manager:');
    console.log('   - Mở: SQLServerManager15.msc');
    console.log('   - Protocols for SQLEXPRESS → TCP/IP → Enable');
    console.log('   - TCP/IP Properties → IP Addresses → IPALL');
    console.log('     + TCP Dynamic Ports: (để trống)');
    console.log('     + TCP Port: 1433');
    console.log('   - Restart SQL Server service\n');
    console.log('3. Start SQL Server Browser service:');
    console.log('   - SQL Server Configuration Manager');
    console.log('   - SQL Server Services → SQL Server Browser → Start\n');
    console.log('4. Xem hướng dẫn chi tiết: BE/SQL_SERVER_SETUP.md\n');
  }

  process.exit(test1 || test2 ? 0 : 1);
}

runTests();
