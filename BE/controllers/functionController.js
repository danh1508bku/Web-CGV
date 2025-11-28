const { sql, poolPromise } = require('../database/db');

let function_Procedure_Names = [];

/**
 * Retrieves the names of all stored functions and procedures from the database.
 * Updates the global variable 'function_Procedure_Names' with the names of these routines.
 */
async function getFunction_Procedure_FromDatabase() {
  try {
    const pool = await poolPromise;

    // Query for SQL Server to get stored procedures and functions
    const query = `
      SELECT ROUTINE_NAME, ROUTINE_TYPE
      FROM INFORMATION_SCHEMA.ROUTINES
      WHERE ROUTINE_CATALOG = DB_NAME()
      AND ROUTINE_TYPE IN ('PROCEDURE', 'FUNCTION')`;

    const result = await pool.request().query(query);

    // Map the results to get routine names
    function_Procedure_Names = result.recordset.map(row => row.ROUTINE_NAME);

    console.log('Danh sách các hàm và thủ tục:', function_Procedure_Names);
  } catch (err) {
    console.error('Lỗi khi truy vấn các hàm:', err);
  }
}

/**
 * Calls a stored procedure with the given name and parameters.
 */
async function callStoredProcedure(procName, params, res) {
  // Check if the procedure exists and is allowed to be called
  if (!function_Procedure_Names.includes(procName)) {
    return res.status(400).json({
      error: `Thủ tục ${procName} không hợp lệ hoặc không được phép gọi`,
    });
  }

  console.log(`Gọi thủ tục: ${procName} với tham số:`, params);

  try {
    const pool = await poolPromise;
    const request = pool.request();

    // Add parameters to the request
    params.forEach((param, index) => {
      request.input(`param${index}`, param);
    });

    // Execute stored procedure
    const result = await request.execute(procName);

    // Return the first recordset
    res.json(result.recordset || result.recordsets[0] || []);
  } catch (err) {
    console.error(`Lỗi khi gọi thủ tục ${procName}:`, err);
    return res.status(500).json({
      error: 'Lỗi khi gọi thủ tục SQL',
      message: err.message,
    });
  }
}

/**
 * Calls a stored function with the given name and parameters.
 */
async function callStoredFunction(procName, params, res) {
  // Check if the function exists and is allowed to be called
  if (!function_Procedure_Names.includes(procName)) {
    return res.status(400).json({
      error: `Hàm ${procName} không hợp lệ hoặc không được phép gọi`
    });
  }

  console.log(`Gọi hàm: ${procName} với tham số:`, params);

  try {
    const pool = await poolPromise;
    const request = pool.request();

    // Add parameters to the request
    params.forEach((param, index) => {
      request.input(`param${index}`, param);
    });

    // For scalar functions in SQL Server, we use SELECT
    const paramPlaceholders = params.map((_, i) => `@param${i}`).join(', ');
    const query = `SELECT dbo.${procName}(${paramPlaceholders}) AS result`;

    const result = await request.query(query);

    console.log(`Kết quả từ hàm ${procName}:`, result.recordset);
    res.json(result.recordset);
  } catch (err) {
    console.error(`Lỗi khi gọi hàm ${procName}:`, err);
    return res.status(500).json({
      error: 'Lỗi khi gọi hàm SQL',
      message: err.message
    });
  }
}

/**
 * Calls a stored function that returns JSON data
 */
async function callStoredFunctionJason(funcName, params, res) {
  if (!function_Procedure_Names.includes(funcName)) {
    return res.status(400).json({
      error: `Hàm ${funcName} không hợp lệ hoặc không được phép gọi`
    });
  }

  try {
    const pool = await poolPromise;
    const request = pool.request();

    // Add parameters to the request
    params.forEach((param, index) => {
      request.input(`param${index}`, param);
    });

    let query;

    // SQL Server uses different syntax for JSON
    if (funcName === 'GetTopPhim') {
      // Execute function and parse JSON result
      const paramPlaceholders = params.map((_, i) => `@param${i}`).join(', ');
      query = `
        SELECT * FROM OPENJSON(dbo.${funcName}(${paramPlaceholders}))
        WITH (
          TuaDe NVARCHAR(30) '$.TuaDe',
          DoanhThu INT '$.DoanhThu'
        )`;
    } else if (funcName === 'ThongKeDoanhThuTheoKhoangNgay') {
      const paramPlaceholders = params.map((_, i) => `@param${i}`).join(', ');
      query = `
        SELECT * FROM OPENJSON(dbo.${funcName}(${paramPlaceholders}))
        WITH (
          TenRap NVARCHAR(30) '$.TenRap',
          TinhThanh NVARCHAR(25) '$.TinhThanh',
          DiaChi NVARCHAR(50) '$.DiaChi',
          DoanhThu INT '$.DoanhThu'
        )`;
    } else {
      return res.status(400).json({
        error: `Hàm ${funcName} không được hỗ trợ`
      });
    }

    const result = await request.query(query);

    if (!result.recordset || result.recordset.length === 0) {
      return res.status(404).json({ error: 'Không có dữ liệu trả về' });
    }

    console.log(`Kết quả từ hàm ${funcName}:`, result.recordset);
    res.json(result.recordset);
  } catch (err) {
    console.error(`Lỗi khi gọi hàm ${funcName}:`, err);
    return res.status(500).json({
      error: 'Lỗi khi gọi hàm SQL',
      message: err.message
    });
  }
}

/**
 * Calls a stored procedure to insert a new showtime
 */
async function callinsertShowtime(procName, params, res) {
  // Check if the parameters are valid
  if (!params || params.length !== 7) {
    console.error(`❌ Lỗi khi thực thi thủ tục ${procName}: Số lượng tham số không đủ`);
    return res.status(400).json({
      error: "Missing or invalid input data",
      success: false,
    });
  }

  // Check if any of the parameters are empty or null
  if (params.some(p => p === undefined || p === null || p === '')) {
    console.error(`❌ Lỗi khi thực thi thủ tục ${procName}: Tham số không được phép trống`);
    return res.status(400).json({
      error: "Missing or invalid input data",
      success: false,
    });
  }

  try {
    const pool = await poolPromise;
    const request = pool.request();

    // Add parameters with proper names
    request.input('movie_format', params[0]);
    request.input('language', params[1]);
    request.input('date', params[2]);
    request.input('start_time', params[3]);
    request.input('cinema_id', params[4]);
    request.input('room_number', params[5]);
    request.input('movie_id', params[6]);

    const result = await request.execute(procName);

    // Get the message from the stored procedure
    const message = result.recordset?.[0]?.message ||
                   result.recordset?.[0]?.ThongBao ||
                   "Thêm suất chiếu thành công!";

    res.status(200).json({
      message: message,
      result: result.recordset,
      success: true,
    });
  } catch (err) {
    console.error(`❌ Lỗi khi thực thi thủ tục ${procName}:`, err);
    return res.status(500).json({
      error: err.message,
      success: false,
    });
  }
}

/**
 * Calls the stored procedure that updates a showtime
 */
async function callupdateShowtime(procName, params, res) {
  const [
    showtime_id,
    movie_format,
    language,
    date,
    start_time,
    cinema_id,
    room_number,
    movie_id
  ] = params;

  // Check if the showtime_id parameter is valid
  if (showtime_id === undefined || showtime_id === null) {
    return res.status(400).json({
      error: "showtime_id is required",
      success: false,
    });
  }

  try {
    const pool = await poolPromise;
    const request = pool.request();

    // Add parameters
    request.input('showtime_id', showtime_id);
    request.input('movie_format', movie_format);
    request.input('language', language);
    request.input('date', date);
    request.input('start_time', start_time);
    request.input('cinema_id', cinema_id);
    request.input('room_number', room_number);
    request.input('movie_id', movie_id);

    const result = await request.execute(procName);

    // Get the message from the stored procedure
    const message = result.recordset?.[0]?.message ||
                   result.recordset?.[0]?.ThongBao ||
                   "Cập nhật suất chiếu thành công!";

    res.status(200).json({
      message: message,
      result: result.recordset,
      success: true,
    });
  } catch (err) {
    console.error(`❌ Lỗi khi thực thi thủ tục ${procName}:`, err);
    return res.status(500).json({
      error: err.message,
      success: false,
    });
  }
}

/**
 * Calls the stored procedure that deletes a showtime
 */
async function calldeleteShowtime(procName, params, res) {
  const [showtime_id] = params;

  // Check if the showtime_id parameter is valid
  if (showtime_id === undefined || showtime_id === null || isNaN(showtime_id)) {
    return res.status(400).json({
      error: "showtime_id is required and must be a number",
      success: false,
    });
  }

  try {
    const pool = await poolPromise;
    const request = pool.request();

    request.input('showtime_id', showtime_id);

    const result = await request.execute(procName);

    // Get the message from the stored procedure
    const message = result.recordset?.[0]?.message ||
                   result.recordset?.[0]?.ThongBao;

    // Check if the message indicates success
    if (message === "Xóa suất chiếu thành công!") {
      return res.status(200).json({
        message: message,
        result: result.recordset,
        success: true,
      });
    } else {
      return res.status(404).json({
        error: message || "Không tìm thấy suất chiếu để xóa",
        success: false,
      });
    }
  } catch (err) {
    console.error(`❌ Lỗi khi thực thi thủ tục ${procName}:`, err);
    return res.status(500).json({
      error: err.message,
      success: false,
    });
  }
}

module.exports = {
  getFunction_Procedure_FromDatabase,
  callStoredProcedure,
  callStoredFunction,
  callStoredFunctionJason,
  callinsertShowtime,
  callupdateShowtime,
  calldeleteShowtime
};
