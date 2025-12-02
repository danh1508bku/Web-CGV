// Định nghĩa URL cố định
const baseURL = 'http://localhost:3000/call-function?';
let currentData = [];
let sortState = {};

/**
 * Render table với chức năng sắp xếp
 */
function renderTableWithSorting(data) {
  if (!Array.isArray(data) || data.length === 0) {
    return '';
  }

  const columns = Object.keys(data[0]);
  let thead = '<thead><tr>';
  
  for (const col of columns) {
    thead += `<th>
                ${col}<br>
                <button onclick="sortByColumn('${col}')" class="sort-btn">🔼🔽</button>
              </th>`;
  }
  thead += '</tr></thead>';

  let tbody = '<tbody>';
  for (const row of data) {
    tbody += '<tr>';
    for (const col of columns) {
      tbody += `<td>${row[col]}</td>`;
    }
    tbody += '</tr>';
  }
  tbody += '</tbody>';

  return `<table border="1">${thead}${tbody}</table>`;
}

/**
 * Sắp xếp theo cột
 */
function sortByColumn(column) {
  if (!currentData || currentData.length === 0) return;

  const ascending = !sortState[column];

  currentData.sort((a, b) => {
    if (typeof a[column] === 'number') {
      return ascending ? a[column] - b[column] : b[column] - a[column];
    }
    return ascending
      ? String(a[column]).localeCompare(String(b[column]))
      : String(b[column]).localeCompare(String(a[column]));
  });

  sortState[column] = ascending;

  const tableHtml = renderTableWithEditAndSortButton(currentData);
  document.getElementById('output').innerHTML = '<h3>Kết quả:</h3>' + formatTable(tableHtml);
}

/**
 * Render table với nút Edit và Delete
 */
function renderTableWithEditAndSortButton(data) {
  currentData = data;
  const columns = Object.keys(data[0]);

  let table = '<table border="1" cellpadding="5" cellspacing="0"><thead><tr>';

  columns.forEach(col => {
    table += `<th>
                ${col}<br>
                <button onclick="sortByColumn('${col}')" class="sort-btn">🔼🔽</button>
              </th>`;
  });

  table += '<th>Hành động</th>';
  table += '</tr></thead><tbody>';

  data.forEach((row, index) => {
    table += '<tr>';
    columns.forEach(col => {
      table += `<td>${row[col]}</td>`;
    });

    table += `<td style="display: flex; gap: 6px; justify-content: center;">
      <button class="btn-edit" onclick="editRow(${index})">Cập nhật</button>
      <button class="btn-delete" onclick="deleteRow(${index})">Xóa</button>
    </td>`;
    table += '</tr>';
  });

  table += '</tbody></table>';
  return table;
}

/**
 * Gọi stored procedure (SELECT)
 */
function callProcedure(proc, params) {
  const paramsStr = JSON.stringify(params);
  const url = `${baseURL}proc=${proc}&params=${paramsStr}&func=False`;

  fetch(url)
    .then(response => response.json())
    .then(result => {
      let output = document.getElementById('output');
      const data = result.data || result;
      
      if (result.error || !result.success) {
        output.innerHTML = `<p class="error">Lỗi: ${result.error || 'Không có dữ liệu'}</p>`;
        return;
      }

      if (!Array.isArray(data) || data.length === 0) {
        output.innerHTML = '<p class="info">Không có dữ liệu.</p>';
        return;
      }
      
      currentData = data;
      let tableHtml = '';

      if (proc === 'TimSuatChieu') {
        tableHtml = renderTableWithEditAndSortButton(data);
      } else {
        tableHtml = renderTableWithSorting(data);
      }

      output.innerHTML = '<h3>Kết quả:</h3>' + formatTable(tableHtml);
    })
    .catch(error => {
      console.error('Lỗi:', error);
      document.getElementById('output').innerHTML = '<p class="error">Đã xảy ra lỗi khi gọi API!</p>';
    });
}

/**
 * Gọi function (trả về JSON)
 */
function callFunction(proc, params) {
  const paramsStr = JSON.stringify(params);
  const url = `${baseURL}proc=${proc}&params=${paramsStr}&func=True`;

  fetch(url)
    .then(response => response.json())
    .then(result => {
      const data = result.data || result;
      const output = document.getElementById("output");

      if (result.error || !result.success) {
        output.innerHTML = `<p class="error">Lỗi: ${result.error || "Không có dữ liệu"}</p>`;
        return;
      }

      if (proc === "Top5PhimDoanhThuCaoNhat") {
        output.innerHTML = renderTop5Table(data);
      } else if (proc === "ThongKeDoanhThuVeCuaRap") {
        output.innerHTML = renderDoanhThuRapTable(data);
      } else {
        output.innerHTML = `<pre>${JSON.stringify(data, null, 2)}</pre>`;
      }
    })
    .catch(err => {
      console.error(err);
      document.getElementById("output").innerHTML = '<p class="error">Đã xảy ra lỗi khi gọi API!</p>';
    });
}

/**
 * INSERT
 */
function callInsert(proc, params) {
  const paramsStr = encodeURIComponent(JSON.stringify(params));
  const url = `${baseURL}proc=${proc}&params=${paramsStr}&func=INSERT`;

  fetch(url, {
    method: "GET",
    headers: { "Content-Type": "application/json" }
  })
    .then(response => response.json().then(data => ({ status: response.status, ok: response.ok, body: data })))
    .then(({ ok, body }) => {
      const output = document.getElementById('message');
      if (ok && body.success) {
        output.innerHTML = `<p class="success">✅ Thành công: ${body.message}</p>`;
        setTimeout(() => { output.innerHTML = ''; }, 3000);
      } else {
        output.innerHTML = `<p class="error">❌ Thất bại: ${body.error || body.message}</p>`;
      }
    })
    .catch(error => {
      document.getElementById('message').innerHTML = `<p class="error">❌ Lỗi kết nối: ${error.message}</p>`;
    });
}

/**
 * UPDATE
 */
function callUpdate(proc, params) {
  const paramsStr = encodeURIComponent(JSON.stringify(params));
  const url = `${baseURL}proc=${proc}&params=${paramsStr}&func=UPDATE`;

  fetch(url, {
    method: "GET",
    headers: { "Content-Type": "application/json" }
  })
    .then(response => response.json().then(data => ({ ok: response.ok, body: data })))
    .then(({ ok, body }) => {
      const output = document.getElementById('message');
      if (ok && body.success) {
        output.innerHTML = `<p class="success">✅ ${body.message}</p>`;
        setTimeout(() => { 
          output.innerHTML = '';
          closeModal('editModal');
        }, 2000);
      } else {
        output.innerHTML = `<p class="error">❌ ${body.error || body.message}</p>`;
      }
    })
    .catch(error => {
      document.getElementById('message').innerHTML = `<p class="error">❌ Lỗi: ${error.message}</p>`;
    });
}

/**
 * DELETE
 */
function callDelete(proc, params) {
  const paramsStr = encodeURIComponent(JSON.stringify(params));
  const url = `${baseURL}proc=${proc}&params=${paramsStr}&func=DELETE`;

  fetch(url, {
    method: "GET",
    headers: { "Content-Type": "application/json" }
  })
    .then(response => response.json().then(data => ({ ok: response.ok, body: data })))
    .then(({ ok, body }) => {
      const output = document.getElementById('message');
      if (ok && body.success) {
        output.innerHTML = `<p class="success">✅ ${body.message}</p>`;
        setTimeout(() => {
          output.innerHTML = '';
          closeModal('deleteModal');
        }, 2000);
      } else {
        output.innerHTML = `<p class="error">❌ ${body.error || body.message}</p>`;
      }
    })
    .catch(error => {
      document.getElementById('message').innerHTML = `<p class="error">❌ Lỗi: ${error.message}</p>`;
    });
}

/**
 * Format bảng (chuyển đổi date/time)
 */
function formatTable(table) {
  const tempDiv = document.createElement('div');
  tempDiv.innerHTML = table;

  const rows = tempDiv.querySelectorAll('tr');
  rows.forEach(row => {
    const cells = row.querySelectorAll('td');
    cells.forEach(cell => {
      const value = cell.textContent.trim();

      if (typeof value === 'string') {
        // Xử lý TIME (1970-01-01Txx:xx:xx) - giữ nguyên định dạng HH:MM:SS
        if (/^1970-01-01T\d{2}:\d{2}:\d{2}/.test(value)) {
          const date = new Date(value);
          if (!isNaN(date)) {
            const hours = String(date.getUTCHours()).padStart(2, '0');
            const minutes = String(date.getUTCMinutes()).padStart(2, '0');
            const seconds = String(date.getUTCSeconds()).padStart(2, '0');
            // Hiển thị đầy đủ HH:MM:SS cho ThoiLuong
            cell.textContent = `${hours}:${minutes}:${seconds}`;
          }
        }
        // Xử lý DATE (yyyy-mm-ddT...) - chuyển sang dd/mm/yyyy
        else if (/^\d{4}-\d{2}-\d{2}T/.test(value)) {
          const date = new Date(value);
          if (!isNaN(date) && date.getFullYear() > 1970) {
            const day = String(date.getDate()).padStart(2, '0');
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const year = date.getFullYear();
            cell.textContent = `${day}/${month}/${year}`;
          }
        }
      }
    });
  });

  return tempDiv.innerHTML;
}


/**
 * Edit row
 */
function editRow(index) {
  const row = currentData[index];
  const form = document.forms['updateForm'];
  form.reset();

  form.p_MaSuatChieu.value = row.MaSuatChieu;
  form.p_MaPhim.value = row.MaPhim;
  form.p_MaRap.value = row.MaRap;
  form.p_GioBatDauMoi.value = '';
  form.p_MaPhongMoi.value = '';

  openModal('editModal');
}

/**
 * Delete row
 */
function deleteRow(index) {
  const row = currentData[index];
  const form = document.forms['deleteForm'];
  form.p_MaSuatChieu.value = row.MaSuatChieu;
  form.p_MaPhim.value = row.MaPhim;
  openModal('deleteModal');
}

/**
 * Render Top 5 phim
 */
function renderTop5Table(data) {
  if (!Array.isArray(data) || data.length === 0) {
    return "<p class='error'>Không có dữ liệu</p>";
  }

  let html = `
    <table class="result-table">
      <thead>
        <tr>
          <th>Hạng</th>
          <th>Mã Phim</th>
          <th>Tựa Đề</th>
          <th>Doanh Thu</th>
        </tr>
      </thead>
      <tbody>
  `;

  data.forEach(item => {
    html += `
      <tr>
        <td>${item.XepHang}</td>
        <td>${item.MaPhim}</td>
        <td>${item.TuaDe}</td>
        <td>${parseInt(item.DoanhThu).toLocaleString()} ₫</td>
      </tr>
    `;
  });

  html += "</tbody></table>";
  return html;
}

/**
 * Render doanh thu rạp
 */
function renderDoanhThuRapTable(data) {
  if (!Array.isArray(data) || data.length === 0) {
    return "<p class='error'>Không có dữ liệu</p>";
  }

  let html = `
    <table class="result-table">
      <thead>
        <tr>
          <th>Mã Rạp</th>
          <th>Tên Rạp</th>
          <th>Tỉnh Thành</th>
          <th>Doanh Thu</th>
        </tr>
      </thead>
      <tbody>
  `;

  data.forEach(item => {
    html += `
      <tr>
        <td>${item.MaRap}</td>
        <td>${item.TenRap}</td>
        <td>${item.TinhThanh}</td>
        <td>${Number(item.DoanhThu).toLocaleString()} ₫</td>
      </tr>
    `;
  });

  html += "</tbody></table>";
  return html;
}

/**
 * Modal helpers
 */
function openModal(modalId) {
  document.getElementById(modalId).style.display = 'block';
}

function closeModal(modalId) {
  document.getElementById(modalId).style.display = 'none';
}