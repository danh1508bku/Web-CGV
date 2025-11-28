const express = require('express');
const router = express.Router();
const {
  callStoredProcedure,
  callStoredFunction,
  callInsertSuatChieu,
  callUpdateSuatChieu,
  callDeleteSuatChieu,
  callTimSuatChieu,
  callLietKeTaiKhoanTieuNhieu,
  callThongKeDoanhThuVeCuaRap,
  callTop5PhimDoanhThuCaoNhat
} = require('../controllers/functionController');

/**
 * Route tổng quát để gọi procedures/functions
 * Query params:
 *   - proc: tên procedure/function
 *   - params: JSON array các tham số
 *   - func: loại gọi (False=procedure, True=function, các giá trị đặc biệt khác)
 */
router.get('/call-function', async (req, res) => {
  try {
    const procName = req.query.proc;
    const params = req.query.params ? JSON.parse(req.query.params) : [];
    const func = req.query.func;

    if (!procName) {
      return res.status(400).json({
        error: 'Thiếu tham số "proc" (tên procedure/function)',
        success: false
      });
    }

    // Route theo loại function
    switch (func) {
      case 'False':
        // Gọi stored procedure thông thường
        await callStoredProcedure(procName, params, res);
        break;

      case 'True':
        // Gọi function thông thường
        await callStoredFunction(procName, params, res);
        break;

      case 'INSERT':
        // Gọi sp_Insert_SuatChieu
        await callInsertSuatChieu(params, res);
        break;

      case 'UPDATE':
        // Gọi Update_ThongTinSuatChieu
        await callUpdateSuatChieu(params, res);
        break;

      case 'DELETE':
        // Gọi Delete_SuatChieu
        await callDeleteSuatChieu(params, res);
        break;

      default:
        return res.status(400).json({
          error: 'Tham số "func" không hợp lệ. Sử dụng: False (procedure), True (function), INSERT, UPDATE, DELETE',
          success: false
        });
    }
  } catch (err) {
    console.error('❌ Lỗi trong route /call-function:', err);
    return res.status(500).json({
      error: 'Lỗi server',
      message: err.message,
      success: false
    });
  }
});

/**
 * Route: Tìm suất chiếu
 * GET /tim-suat-chieu?ngayChieu=2024-12-25&gio=18:00&tenRap=CGV&tuaDe=Avatar
 * Tất cả params đều optional
 */
router.get('/tim-suat-chieu', async (req, res) => {
  try {
    const { ngayChieu, gio, tenRap, tuaDe } = req.query;
    const params = [ngayChieu, gio, tenRap, tuaDe];

    await callTimSuatChieu(params, res);
  } catch (err) {
    console.error('❌ Lỗi trong route /tim-suat-chieu:', err);
    return res.status(500).json({
      error: 'Lỗi server',
      message: err.message,
      success: false
    });
  }
});

/**
 * Route: Liệt kê tài khoản có tổng chi tiêu cao
 * GET /tai-khoan-tieu-nhieu?tongChiTieu=1000000
 * tongChiTieu optional (null = lấy tất cả)
 */
router.get('/tai-khoan-tieu-nhieu', async (req, res) => {
  try {
    const { tongChiTieu } = req.query;
    const params = [tongChiTieu];

    await callLietKeTaiKhoanTieuNhieu(params, res);
  } catch (err) {
    console.error('❌ Lỗi trong route /tai-khoan-tieu-nhieu:', err);
    return res.status(500).json({
      error: 'Lỗi server',
      message: err.message,
      success: false
    });
  }
});

/**
 * Route: Thống kê doanh thu vé của rạp theo khoảng ngày
 * GET /thong-ke-doanh-thu?ngayBatDau=2024-01-01&ngayKetThuc=2024-12-31
 */
router.get('/thong-ke-doanh-thu', async (req, res) => {
  try {
    const { ngayBatDau, ngayKetThuc } = req.query;

    if (!ngayBatDau || !ngayKetThuc) {
      return res.status(400).json({
        error: 'Cần cung cấp ngayBatDau và ngayKetThuc',
        success: false
      });
    }

    const params = [ngayBatDau, ngayKetThuc];
    await callThongKeDoanhThuVeCuaRap(params, res);
  } catch (err) {
    console.error('❌ Lỗi trong route /thong-ke-doanh-thu:', err);
    return res.status(500).json({
      error: 'Lỗi server',
      message: err.message,
      success: false
    });
  }
});

/**
 * Route: Top 5 phim có doanh thu cao nhất
 * GET /top-5-phim?ngayBatDau=2024-01-01&ngayKetThuc=2024-12-31
 */
router.get('/top-5-phim', async (req, res) => {
  try {
    const { ngayBatDau, ngayKetThuc } = req.query;

    if (!ngayBatDau || !ngayKetThuc) {
      return res.status(400).json({
        error: 'Cần cung cấp ngayBatDau và ngayKetThuc',
        success: false
      });
    }

    const params = [ngayBatDau, ngayKetThuc];
    await callTop5PhimDoanhThuCaoNhat(params, res);
  } catch (err) {
    console.error('❌ Lỗi trong route /top-5-phim:', err);
    return res.status(500).json({
      error: 'Lỗi server',
      message: err.message,
      success: false
    });
  }
});

/**
 * Route: Thêm suất chiếu mới
 * POST /them-suat-chieu
 * Body: {
 *   maSuatChieu, maPhim, maRap, maPhongChieu, ngayChieu,
 *   dinhDangChieu, ngonNgu, trangThai, hinhThucDichThuat, gioBatDau
 * }
 */
router.post('/them-suat-chieu', express.json(), async (req, res) => {
  try {
    const {
      maSuatChieu, maPhim, maRap, maPhongChieu, ngayChieu,
      dinhDangChieu, ngonNgu, trangThai, hinhThucDichThuat, gioBatDau
    } = req.body;

    const params = [
      maSuatChieu, maPhim, maRap, maPhongChieu, ngayChieu,
      dinhDangChieu, ngonNgu, trangThai, hinhThucDichThuat, gioBatDau
    ];

    await callInsertSuatChieu(params, res);
  } catch (err) {
    console.error('❌ Lỗi trong route /them-suat-chieu:', err);
    return res.status(500).json({
      error: 'Lỗi server',
      message: err.message,
      success: false
    });
  }
});

/**
 * Route: Cập nhật suất chiếu
 * PUT /cap-nhat-suat-chieu
 * Body: {
 *   maSuatChieu, maPhim, maRap, gioBatDauMoi?, maPhongMoi?
 * }
 */
router.put('/cap-nhat-suat-chieu', express.json(), async (req, res) => {
  try {
    const { maSuatChieu, maPhim, maRap, gioBatDauMoi, maPhongMoi } = req.body;

    const params = [maSuatChieu, maPhim, maRap, gioBatDauMoi, maPhongMoi];

    await callUpdateSuatChieu(params, res);
  } catch (err) {
    console.error('❌ Lỗi trong route /cap-nhat-suat-chieu:', err);
    return res.status(500).json({
      error: 'Lỗi server',
      message: err.message,
      success: false
    });
  }
});

/**
 * Route: Xóa suất chiếu
 * DELETE /xoa-suat-chieu
 * Body: { maSuatChieu, maPhim }
 */
router.delete('/xoa-suat-chieu', express.json(), async (req, res) => {
  try {
    const { maSuatChieu, maPhim } = req.body;

    const params = [maSuatChieu, maPhim];

    await callDeleteSuatChieu(params, res);
  } catch (err) {
    console.error('❌ Lỗi trong route /xoa-suat-chieu:', err);
    return res.status(500).json({
      error: 'Lỗi server',
      message: err.message,
      success: false
    });
  }
});

/**
 * Route: Health check
 */
router.get('/health', (req, res) => {
  res.json({
    status: 'OK',
    message: 'API đang hoạt động',
    timestamp: new Date().toISOString()
  });
});

module.exports = router;
