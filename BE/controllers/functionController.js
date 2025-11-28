const { sql, poolPromise } = require('../database/db');

let function_Procedure_Names = [];

/**
 * Lấy danh sách tất cả stored procedures và functions từ SQL Server database
 * Cập nhật biến toàn cục function_Procedure_Names
 */
async function getFunction_Procedure_FromDatabase() {
  try {
    const pool = await poolPromise;

    // Query cho SQL Server (không phải MySQL)
    const query = `
      SELECT ROUTINE_NAME, ROUTINE_TYPE
      FROM INFORMATION_SCHEMA.ROUTINES
      WHERE ROUTINE_SCHEMA = 'dbo'
      ORDER BY ROUTINE_NAME;
    `;

    const result = await pool.request().query(query);

    // Lưu danh sách tên procedures và functions
    function_Procedure_Names = result.recordset.map(row => row.ROUTINE_NAME);

    console.log('✅ Danh sách các hàm và thủ tục:', function_Procedure_Names);
    console.log(`📊 Tổng số: ${function_Procedure_Names.length} procedures/functions`);

    return function_Procedure_Names;
  } catch (err) {
    console.error('❌ Lỗi khi truy vấn các hàm:', err);
    throw err;
  }
}

/**
 * Gọi stored procedure với tên và tham số cho trước
 * MS SQL Server sử dụng EXECUTE thay vì CALL
 *
 * @param {string} procName - Tên stored procedure
 * @param {array} params - Mảng tham số
 * @param {object} res - Express response object
 */
async function callStoredProcedure(procName, params, res) {
  try {
    // Kiểm tra procedure có tồn tại không
    if (!function_Procedure_Names.includes(procName)) {
      return res.status(400).json({
        error: `Thủ tục ${procName} không hợp lệ hoặc không được phép gọi`,
        success: false
      });
    }

    const pool = await poolPromise;
    const request = pool.request();

    // Thêm parameters vào request
    params.forEach((param, index) => {
      request.input(`param${index}`, param);
    });

    // Tạo câu lệnh EXEC với named parameters
    const paramNames = params.map((_, index) => `@param${index}`).join(', ');
    const sql = `EXEC ${procName} ${paramNames}`;

    console.log(`📞 Gọi thủ tục: ${procName} với tham số:`, params);

    const result = await request.query(sql);

    // Trả về kết quả
    res.json({
      success: true,
      data: result.recordset || result.recordsets,
      rowsAffected: result.rowsAffected
    });

  } catch (err) {
    console.error(`❌ Lỗi khi gọi thủ tục ${procName}:`, err);
    return res.status(500).json({
      error: 'Lỗi khi gọi thủ tục SQL',
      message: err.message,
      success: false
    });
  }
}

/**
 * Gọi scalar function trả về JSON string
 * Parse JSON và trả về kết quả
 *
 * @param {string} funcName - Tên function
 * @param {array} params - Mảng tham số
 * @param {object} res - Express response object
 */
async function callStoredFunction(funcName, params, res) {
  try {
    // Kiểm tra function có tồn tại không
    if (!function_Procedure_Names.includes(funcName)) {
      return res.status(400).json({
        error: `Hàm ${funcName} không hợp lệ hoặc không được phép gọi`,
        success: false
      });
    }

    const pool = await poolPromise;
    const request = pool.request();

    // Thêm parameters
    params.forEach((param, index) => {
      request.input(`param${index}`, param);
    });

    // Gọi function với SELECT
    const paramNames = params.map((_, index) => `@param${index}`).join(', ');
    const sql = `SELECT dbo.${funcName}(${paramNames}) AS Result`;

    console.log(`📞 Gọi hàm: ${funcName} với tham số:`, params);

    const result = await request.query(sql);

    if (!result.recordset || result.recordset.length === 0) {
      return res.status(404).json({
        error: 'Không có dữ liệu trả về',
        success: false
      });
    }

    const functionResult = result.recordset[0].Result;

    // Thử parse JSON nếu kết quả là JSON string
    let parsedResult;
    try {
      parsedResult = JSON.parse(functionResult);
    } catch (e) {
      // Nếu không phải JSON, trả về nguyên bản
      parsedResult = functionResult;
    }

    console.log(`✅ Kết quả từ hàm ${funcName}:`, parsedResult);

    res.json({
      success: true,
      data: parsedResult
    });

  } catch (err) {
    console.error(`❌ Lỗi khi gọi hàm ${funcName}:`, err);
    return res.status(500).json({
      error: 'Lỗi khi gọi hàm SQL',
      message: err.message,
      success: false
    });
  }
}

/**
 * Gọi procedure sp_Insert_SuatChieu
 * Thêm suất chiếu mới với 10 tham số
 */
async function callInsertSuatChieu(params, res) {
  try {
    // Validate số lượng tham số
    if (!params || params.length !== 10) {
      return res.status(400).json({
        error: "Cần đủ 10 tham số: MaSuatChieu, MaPhim, MaRap, MaPhongChieu, NgayChieu, DinhDangChieu, NgonNgu, TrangThai, HinhThucDichThuat, GioBatDau",
        success: false
      });
    }

    // Validate không có tham số null/empty
    if (params.some(p => p === undefined || p === null || p === '')) {
      return res.status(400).json({
        error: "Tất cả tham số không được để trống",
        success: false
      });
    }

    const pool = await poolPromise;
    const request = pool.request();

    // Thêm parameters với đúng kiểu dữ liệu
    request.input('MaSuatChieu', sql.Char(7), params[0]);
    request.input('MaPhim', sql.Char(10), params[1]);
    request.input('MaRap', sql.Char(5), params[2]);
    request.input('MaPhongChieu', sql.TinyInt, params[3]);
    request.input('NgayChieu', sql.Date, params[4]);
    request.input('DinhDangChieu', sql.NVarChar(10), params[5]);
    request.input('NgonNgu', sql.NVarChar(20), params[6]);
    request.input('TrangThai', sql.NVarChar(15), params[7]);
    request.input('HinhThucDichThuat', sql.NVarChar(10), params[8]);
    request.input('GioBatDau', sql.Time, params[9]);

    console.log(`📞 Gọi sp_Insert_SuatChieu với tham số:`, params);

    const result = await request.execute('sp_Insert_SuatChieu');

    // Lấy message từ SELECT statement trong procedure
    const message = result.recordset?.[0]?.Result || "Thêm suất chiếu thành công!";

    res.status(200).json({
      message: message,
      success: true,
      data: result.recordset
    });

  } catch (err) {
    console.error(`❌ Lỗi khi thêm suất chiếu:`, err);
    return res.status(500).json({
      error: err.message,
      success: false
    });
  }
}

/**
 * Gọi procedure Update_ThongTinSuatChieu
 * Cập nhật thông tin suất chiếu (giờ và/hoặc phòng)
 */
async function callUpdateSuatChieu(params, res) {
  try {
    // Cần ít nhất 3 tham số: MaSuatChieu, MaPhim, MaRap
    if (!params || params.length < 3) {
      return res.status(400).json({
        error: "Cần ít nhất 3 tham số: MaSuatChieu, MaPhim, MaRap",
        success: false
      });
    }

    const [maSuatChieu, maPhim, maRap, gioBatDauMoi, maPhongMoi] = params;

    if (!maSuatChieu || !maPhim || !maRap) {
      return res.status(400).json({
        error: "MaSuatChieu, MaPhim và MaRap không được để trống",
        success: false
      });
    }

    const pool = await poolPromise;
    const request = pool.request();

    request.input('MaSuatChieu', sql.Char(7), maSuatChieu);
    request.input('MaPhim', sql.Char(10), maPhim);
    request.input('MaRap', sql.Char(5), maRap);
    request.input('GioBatDauMoi', sql.Time, gioBatDauMoi || null);
    request.input('MaPhongMoi', sql.TinyInt, maPhongMoi || null);

    console.log(`📞 Gọi Update_ThongTinSuatChieu với tham số:`, params);

    const result = await request.execute('Update_ThongTinSuatChieu');

    res.status(200).json({
      message: "Cập nhật suất chiếu thành công!",
      success: true,
      data: result.recordset
    });

  } catch (err) {
    console.error(`❌ Lỗi khi cập nhật suất chiếu:`, err);
    return res.status(500).json({
      error: err.message,
      success: false
    });
  }
}

/**
 * Gọi procedure Delete_SuatChieu
 * Xóa suất chiếu
 */
async function callDeleteSuatChieu(params, res) {
  try {
    if (!params || params.length !== 2) {
      return res.status(400).json({
        error: "Cần 2 tham số: MaSuatChieu, MaPhim",
        success: false
      });
    }

    const [maSuatChieu, maPhim] = params;

    if (!maSuatChieu || !maPhim) {
      return res.status(400).json({
        error: "MaSuatChieu và MaPhim không được để trống",
        success: false
      });
    }

    const pool = await poolPromise;
    const request = pool.request();

    request.input('MaSuatChieu', sql.Char(7), maSuatChieu);
    request.input('MaPhim', sql.Char(10), maPhim);

    console.log(`📞 Gọi Delete_SuatChieu với tham số:`, params);

    const result = await request.execute('Delete_SuatChieu');

    res.status(200).json({
      message: "Xóa suất chiếu thành công!",
      success: true
    });

  } catch (err) {
    console.error(`❌ Lỗi khi xóa suất chiếu:`, err);
    return res.status(500).json({
      error: err.message,
      success: false
    });
  }
}

/**
 * Gọi procedure TimSuatChieu
 * Tìm kiếm suất chiếu với các tham số tùy chọn
 */
async function callTimSuatChieu(params, res) {
  try {
    const [ngayChieu, gio, tenRap, tuaDe] = params || [];

    const pool = await poolPromise;
    const request = pool.request();

    // Tất cả params đều optional
    request.input('NgayChieu', sql.Date, ngayChieu || null);
    request.input('Gio', sql.Time, gio || null);
    request.input('TenRap', sql.NVarChar(100), tenRap || null);
    request.input('TuaDe', sql.NVarChar(50), tuaDe || null);

    console.log(`📞 Gọi TimSuatChieu với tham số:`, params);

    const result = await request.execute('TimSuatChieu');

    res.json({
      success: true,
      data: result.recordset,
      count: result.recordset.length
    });

  } catch (err) {
    console.error(`❌ Lỗi khi tìm suất chiếu:`, err);
    return res.status(500).json({
      error: err.message,
      success: false
    });
  }
}

/**
 * Gọi procedure LietKeTaiKhoanTieuNhieu
 * Liệt kê tài khoản có tổng chi tiêu cao
 */
async function callLietKeTaiKhoanTieuNhieu(params, res) {
  try {
    const [tongChiTieu] = params || [];

    const pool = await poolPromise;
    const request = pool.request();

    // Param optional
    request.input('TongChiTieu', sql.Decimal(18, 2), tongChiTieu || null);

    console.log(`📞 Gọi LietKeTaiKhoanTieuNhieu với tham số:`, params);

    const result = await request.execute('LietKeTaiKhoanTieuNhieu');

    res.json({
      success: true,
      data: result.recordset,
      count: result.recordset.length
    });

  } catch (err) {
    console.error(`❌ Lỗi khi liệt kê tài khoản:`, err);
    return res.status(500).json({
      error: err.message,
      success: false
    });
  }
}

/**
 * Gọi function ThongKeDoanhThuVeCuaRap
 * Trả về JSON array chứa doanh thu vé của các rạp
 */
async function callThongKeDoanhThuVeCuaRap(params, res) {
  try {
    if (!params || params.length !== 2) {
      return res.status(400).json({
        error: "Cần 2 tham số: NgayBatDau, NgayKetThuc",
        success: false
      });
    }

    const [ngayBatDau, ngayKetThuc] = params;

    const pool = await poolPromise;
    const request = pool.request();

    request.input('NgayBatDau', sql.Date, ngayBatDau);
    request.input('NgayKetThuc', sql.Date, ngayKetThuc);

    console.log(`📞 Gọi ThongKeDoanhThuVeCuaRap với tham số:`, params);

    const result = await request.query(`
      SELECT dbo.ThongKeDoanhThuVeCuaRap(@NgayBatDau, @NgayKetThuc) AS JsonResult
    `);

    const jsonString = result.recordset[0].JsonResult;

    // Parse JSON string
    let data;
    try {
      data = JSON.parse(jsonString);
    } catch (e) {
      // Nếu có lỗi trong function (ví dụ: "Lỗi: Ngày không được để trống!")
      return res.status(400).json({
        error: jsonString,
        success: false
      });
    }

    res.json({
      success: true,
      data: data,
      count: data.length
    });

  } catch (err) {
    console.error(`❌ Lỗi khi thống kê doanh thu:`, err);
    return res.status(500).json({
      error: err.message,
      success: false
    });
  }
}

/**
 * Gọi function Top5PhimDoanhThuCaoNhat
 * Trả về JSON array chứa top 5 phim có doanh thu cao nhất
 */
async function callTop5PhimDoanhThuCaoNhat(params, res) {
  try {
    if (!params || params.length !== 2) {
      return res.status(400).json({
        error: "Cần 2 tham số: NgayBatDau, NgayKetThuc",
        success: false
      });
    }

    const [ngayBatDau, ngayKetThuc] = params;

    const pool = await poolPromise;
    const request = pool.request();

    request.input('NgayBatDau', sql.Date, ngayBatDau);
    request.input('NgayKetThuc', sql.Date, ngayKetThuc);

    console.log(`📞 Gọi Top5PhimDoanhThuCaoNhat với tham số:`, params);

    const result = await request.query(`
      SELECT dbo.Top5PhimDoanhThuCaoNhat(@NgayBatDau, @NgayKetThuc) AS JsonResult
    `);

    const jsonString = result.recordset[0].JsonResult;

    // Parse JSON string
    let data;
    try {
      data = JSON.parse(jsonString);
    } catch (e) {
      // Nếu có lỗi trong function
      return res.status(400).json({
        error: jsonString,
        success: false
      });
    }

    res.json({
      success: true,
      data: data,
      count: data.length
    });

  } catch (err) {
    console.error(`❌ Lỗi khi lấy top phim:`, err);
    return res.status(500).json({
      error: err.message,
      success: false
    });
  }
}

module.exports = {
  getFunction_Procedure_FromDatabase,
  callStoredProcedure,
  callStoredFunction,

  // Procedures đặc biệt
  callInsertSuatChieu,
  callUpdateSuatChieu,
  callDeleteSuatChieu,
  callTimSuatChieu,
  callLietKeTaiKhoanTieuNhieu,

  // Functions trả về JSON
  callThongKeDoanhThuVeCuaRap,
  callTop5PhimDoanhThuCaoNhat
};
