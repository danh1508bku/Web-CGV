const db = require('../database/db');

let function_Procedure_Names = [];

/**
 * Retrieves the names of all stored functions and procedures from the 'CINEMA' schema in the database.
 * The function updates the global variable 'function_Procedure_Names' with the names of these routines.
 * Logs an error message if the query fails.
 */

function getFunction_Procedure_FromDatabase() {
  // Define the SQL query to select the names and types of all routines (functions and procedures)
  // from the 'CINEMA' schema in the database.
  // This query targets the 'information_schema.routines' table, which holds metadata about
  // stored routines in the database.
  const query = `
    SELECT ROUTINE_NAME, ROUTINE_TYPE
    FROM information_schema.routines
    WHERE ROUTINE_SCHEMA = 'CINEMA';`;

  // Execute the SQL query using the database connection object 'db'.
  // The 'query' method takes the SQL query and a callback function that handles the query result.
  db.query(query, (err, results) => {
    // If an error occurs during the query execution, log the error message to the console
    // and return early to exit the function.
    if (err) {
      console.error('Lỗi khi truy vấn các hàm:', err);
      return;
    }

    // Map over the results array to extract the 'ROUTINE_NAME' from each row.
    // Update the global variable 'function_Procedure_Names' with the names of these routines.
    function_Procedure_Names = results.map(row => row.ROUTINE_NAME);

    // Log the list of function and procedure names to the console for debugging purposes.
    console.log('Danh sách các hàm và thủ tục:', function_Procedure_Names);
  });
}

/**
 * Calls a stored procedure with the given name and parameters.
 *
 * First, it checks if the procedure exists and is allowed to be called by checking
 * if the procedure name is in the list of allowed function and procedure names.
 * If the procedure does not exist or is not allowed to be called, it returns a 400 error.
 *
 * Then, it constructs the SQL query that calls the stored procedure with the given
 * parameters. The parameters are passed as an array of values, and the query is
 * constructed by replacing the parameter placeholders with the actual values.
 *
 * The query is then executed using the 'db.query' method, which takes the SQL query
 * and a callback function that handles the query result. If an error occurs during
 * the query execution, the error message is logged to the console and a 500 error
 * is returned with the error message.
 *
 * Otherwise, the result of the query is returned as a JSON response.
 *
 * @param {string} procName name of the stored procedure to call
 * @param {array} params parameters to pass to the stored procedure
 * @param {object} res Express.js response object
 */
function callStoredProcedure(procName, params, res) {
  // Check if the procedure exists and is allowed to be called
  if (!function_Procedure_Names.includes(procName)) {
    return res.status(400).json({
      error: `Thủ tục ${procName} không hợp lệ hoặc không được phép gọi`,
    });
  }

  // Construct the SQL query that calls the stored procedure with the given parameters
  const placeholders = params.map(() => '?').join(', ');
  const sql = `CALL ${procName}(${placeholders})`;

  console.log(`Gọi thủ tục: ${procName} với tham số:`, params);

  // Execute the query
  db.query(sql, params, (err, results) => {
    if (err) {
      // If there's an error, log it and return a 500 error
      console.error(`Lỗi khi gọi thủ tục ${procName}:`, err);
      return res.status(500).json({
        error: 'Lỗi khi gọi thủ tục SQL',
        message: err.message,
      });
    }

    // Return the result of the query as a JSON response
    res.json(results[0]);
  });
}

/**
 * Calls a stored function with the given name and parameters.
 *
 * If the function does not exist or is not allowed to be called, returns a 400 error.
 * If the query fails, returns a 500 error with the error message.
 * Otherwise, returns the result of the query, which is expected to be a single value.
 *
 * @param {string} procName name of the stored function to call
 * @param {array} params parameters to pass to the stored function
 * @param {object} res Express.js response object
 */
function callStoredFunction(procName, params, res) {
  // First, check if the function exists and is allowed to be called
  if (!function_Procedure_Names.includes(procName)) {
    return res.status(400).json({ error: `Hàm ${procName} không hợp lệ hoặc không được phép gọi` });
  }

  // Construct the SQL query that will call the stored function
  const placeholders = params.map(() => '?').join(', ');
  const sql = `SELECT ${procName}(${placeholders})`;

  console.log(`Gọi thủ tục: ${procName} với tham số:`, params);

  // Execute the query
  db.query(sql, params, (err, results) => {
    if (err) {
      // If there's an error, log it and return a 500 error
      console.error(`Lỗi khi gọi hàm ${procName}:`, err);

      return res.status(500).json({ error: 'Lỗi khi gọi hàm SQL', message: err.message });
    }

    console.log(`Kết quả từ hàm ${procName}:`, results);
    // If the query is successful, return the result
    res.json(results); 
  });
}

  /**
 * Calls a stored function that returns a JSON value and returns the result as a JSON response.
 *
 * The stored function is assumed to take the given parameters and return a JSON value.
 * The JSON value will be parsed and returned as the response body.
 *
 * If the function does not exist or is not allowed to be called, returns a 400 error.
 * If the query fails, returns a 500 error with the error message.
 *
 * @param {string} funcName name of the stored function to call
 * @param {array} params parameters to pass to the stored function
 * @param {object} res Express.js response object
 */
function callStoredFunctionJason(funcName, params, res) {
  if (!function_Procedure_Names.includes(funcName)) {
    return res.status(400).json({ error: `Hàm ${funcName} không hợp lệ hoặc không được phép gọi` });
  }

  // Construct the SQL query that will call the stored function
  const placeholders = params.map(() => '?').join(', ');
  let sql;

  // Depending on the name of the stored function, construct a different SQL query
  if (funcName === 'GetTopPhim') {
    // For GetTopPhim, the query will return a JSON array of objects with the following structure:
    //   {
    //     "TuaDe": string,
    //     "DoanhThu": number
    //   }
    sql = `SELECT * FROM JSON_TABLE(
      ${funcName}(${placeholders}),
      '$[*]' COLUMNS (
        TuaDe VARCHAR(30) PATH '$.TuaDe',
        DoanhThu INT PATH '$.DoanhThu'
      )
    ) AS result_table`;

  } else if (funcName === 'ThongKeDoanhThuTheoKhoangNgay') {
    // For ThongKeDoanhThuTheoKhoangNgay, the query will return a JSON array of objects with the following structure:
    //   {
    //     "TenRap": string,
    //     "TinhThanh": string,
    //     "DiaChi": string,
    //     "DoanhThu": number
    //   }
    sql = `SELECT * FROM JSON_TABLE(
      ${funcName}(${placeholders}),
      '$[*]' COLUMNS (
        TenRap VARCHAR(30) PATH '$.TenRap',
        TinhThanh VARCHAR(25) PATH '$.TinhThanh',
        DiaChi VARCHAR(50) PATH '$.DiaChi',
        DoanhThu INT PATH '$.DoanhThu'
      )
    ) AS DoanhThuTheoRap;`;
  } else {
    // If the stored function is not recognized, return a 400 error
    return res.status(400).json({ error: `Hàm ${funcName} không được hỗ trợ` });
  }

  // Execute the query
  db.query(sql, params, (err, results) => {
    if (err) {
      // If there's an error, log it and return a 500 error
      console.error(`Lỗi khi gọi hàm ${funcName}:`, err);
      return res.status(500).json({ error: 'Lỗi khi gọi hàm SQL', message: err.message });
    }

    if (!results || results.length === 0) {
      // If the query returns no data, return a 404 error
      return res.status(404).json({ error: 'Không có dữ liệu trả về' });
    }

    console.log(`Kết quả từ hàm ${funcName}:`, results);
    // If the query is successful, return the result
    res.json(results);
  });
}


/**
 * Calls a stored procedure to insert a new showtime with the given parameters.

 * @param {string} procName - The name of the stored procedure to call.
 * @param {array} params - The parameters for the stored procedure, expected to include:
 *   [movie_format, language, date, start_time, cinema_id, room_number, movie_id].
 * @param {object} res - The Express.js response object for sending JSON responses.
 */

function callinsertShowtime(procName, params, res) {
  // Construct the SQL query to call the stored procedure
  const placeholders = params.map(() => '?').join(', ');
  const sql = `CALL ${procName}(${placeholders})`;

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

  // Execute the query
  db.query(sql, params, (err, rows) => {
    if (err) {
      console.error(`❌ Lỗi khi thực thi thủ tục ${procName}:`, err);
      return res.status(500).json({
        error: err.message,
        success: false,
      });
    }

    // Get the message from the stored procedure
    const message = rows?.[0]?.[0]?.message || rows?.[0]?.[0]?.ThongBao || "Thêm suất chiếu thành công!";
    res.status(200).json({
      message: message,
      result: rows,
      success: true,
    });
  });
}

/**
 * Calls the stored procedure that updates a showtime.
 *
 * @param {string} procName the name of the stored procedure
 * @param {array} params the parameters to pass to the stored procedure
 * @param {object} res the Express.js response object
 */
function callupdateShowtime(procName, params, res) {
  const placeholders = params.map(() => '?').join(', ');
  const sql = `CALL ${procName}(${placeholders})`;

  // Unpack the parameters
  const [
    showtime_id, // The ID of the showtime to update
    movie_format, // The format of the movie
    language, // The language of the movie
    date, // The date of the showtime
    start_time, // The start time of the showtime
    cinema_id, // The ID of the cinema
    room_number, // The room number
    movie_id // The ID of the movie
  ] = params;

  // Check if the showtime_id parameter is valid
  if (showtime_id === undefined || showtime_id === null) {
    // If it's not valid, return a 400 error
    return res.status(400).json({
      error: "showtime_id is required",
      success: false,
    });
  }

  // Execute the query
  db.query(sql, params, (err, rows) => {
    if (err) {
      // If there's an error, log it and return a 500 error
      console.error(`❌ Lỗi khi thực thi thủ tục ${procName}:`, err);
      return res.status(500).json({
        error: err.message,
        success: false,
      });
    }

    // Get the message from the stored procedure
    const message = rows?.[0]?.[0]?.message || rows?.[0]?.[0]?.ThongBao || "Cập nhật suất chiếu thành công!";

    // Return the result
    res.status(200).json({
      message: message,
      result: rows,
      success: true,
    });
  });
}

/**
 * Calls the stored procedure that deletes a showtime.
 *
 * @param {string} procName the name of the stored procedure
 * @param {array} params the parameters to pass to the stored procedure
 * @param {object} res the Express.js response object
 */
function calldeleteShowtime(procName, params, res) {
  // Unpack the parameters
  const [showtime_id] = params;

  // Check if the showtime_id parameter is valid
  if (showtime_id === undefined || showtime_id === null || isNaN(showtime_id)) {
    // If it's not valid, return a 400 error
    return res.status(400).json({
      // The error message
      error: "showtime_id is required and must be a number",
      // Whether the request was successful
      success: false,
    });
  }

  // Construct the SQL query to call the stored procedure
  const placeholders = params.map(() => '?').join(', ');
  const sql = `CALL ${procName}(${placeholders})`;

  // Execute the query
  db.query(sql, params, (err, rows) => {
    if (err) {
      // If there's an error, log it and return a 500 error
      console.error(`❌ Lỗi khi thực thi thủ tục ${procName}:`, err);
      return res.status(500).json({
        // The error message
        error: err.message,
        // Whether the request was successful
        success: false,
      });
    }

    // Get the message from the stored procedure
    const message = rows?.[0]?.[0]?.message || rows?.[0]?.[0]?.ThongBao;

    // Check if the message is "Xóa suất chiếu thành công!"
    if (message === "Xóa suất chiếu thành công!") {
      // If it is, return a 200 response with the message
      return res.status(200).json({
        // The message from the stored procedure
        message: message,
        // The result of the query
        result: rows,
        // Whether the request was successful
        success: true,
      });
    } else {
      // If the message is not "Xóa suất chiếu thành công!",
      // return a 404 response with the message
      return res.status(404).json({
        // The error message
        error: message || "Không tìm thấy suất chiếu để xóa",
        // Whether the request was successful
        success: false,
      });
    }
  });
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