// Định nghĩa URL cố định bên ngoài hàm
const baseURL = 'http://localhost:3000/call-function?';
let currentData = []; // Biến toàn cục để lưu dữ liệu hiện tại
let currentData2=[];
/**
 * Function to render a table with sorting functionality.
 * 
 * @param {Array.<Object>} data The data to be rendered in the table.
 * @returns {String} The rendered table as a string of HTML.
 */
function renderTableWithSorting(data) {
  if (!Array.isArray(data) || data.length === 0) {
    // If the input data is invalid, return an empty string.
    return '';
  }

  const columns = Object.keys(data[0]);
  // The columns are the keys of the first object in the data array.

  let thead = '<thead><tr>';
  // Begin constructing the <thead> element of the table.
  for (const col of columns) {
    // For each column, add a <th> element with two children: the column name,
    // and a button with an onclick event that will sort the table by that
    // column when clicked.
    thead += `<th>
                ${col}<br>
                <button onclick="sortByColumn('${col}')">🔼🔽</button>
              </th>`;
  }
  thead += '</tr></thead>';
  // Finish constructing the <thead> element.

  let tbody = '<tbody>';
  // Begin constructing the <tbody> element of the table.
  for (const row of data) {
    // For each row of data, add a <tr> element with a <td> element for each
    // column in the row.
    tbody += '<tr>';
    for (const col of columns) {
      tbody += `<td>${row[col]}</td>`;
    }
    tbody += '</tr>';
  }
  tbody += '</tbody>';
  // Finish constructing the <tbody> element.

  return `<table border="1">${thead}${tbody}</table>`;
  // Return the rendered table as a string of HTML.
}
let sortState = {};  // Ghi nhớ trạng thái sắp xếp tăng/giảm

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

  // Gọi lại đúng hàm có nút
  const tableHtml = renderTableWithEditAndSortButton(currentData);
  document.getElementById('output').innerHTML = '<h3>Kết quả:</h3>' + getTable(tableHtml);
}


function call(proc, params) {
  const paramsStr = JSON.stringify(params);
  const url = `${baseURL}proc=${proc}&params=${paramsStr}&func=False`;

  fetch(url)
    .then(response => response.json())
    .then(result => {
      let output = document.getElementById('output');
      // ✅ Backend mới trả về { success: true, data: [...] }
      const data = result.data || result;
      if (result.error || !result.success) {
        output.textContent = 'Lỗi: ' + (result.error || 'Không có dữ liệu');
        return;
      }

      if (!Array.isArray(data) || data.length === 0) {
        output.textContent = 'Không có dữ liệu.';
        return;
      }
      currentData = data; // Lưu dữ liệu để xử lý edit
      let tableHtml = '';

      if (proc === 'TimSuatChieu') {
        tableHtml  = renderTableWithEditAndSortButton(data);; // ✅ Gọi đúng dữ liệu
      } else {
        tableHtml = renderTableWithSorting(data); // 👈 Hàm khác hiển thị không có nút
      }

      output.innerHTML = '<h3>Kết quả:</h3>' + getTable(tableHtml);
    })
    .catch(error => {
      console.error('Lỗi:', error);
      document.getElementById('output').textContent = 'Đã xảy ra lỗi khi gọi API!';
    });
}

// ✅ Hàm tạo bảng bình thường (không có nút)
function renderTableNormally(data) {
  let table = '<table border="1" cellpadding="5" cellspacing="0"><thead><tr>';
  Object.keys(data[0]).forEach(key => {
    table += `<th>${key}</th>`;
  });
  table += '</tr></thead><tbody>';
  data.forEach(row => {
    table += '<tr>';
    Object.values(row).forEach(value => {
      table += `<td>${value}</td>`;
    });
    table += '</tr>';
  });
  table += '</tbody></table>';
  return table;
}

function renderTableWithEditAndSortButton(data) {
  currentData = data;
  const columns = Object.keys(data[0]);

  let table = '<table border="1" cellpadding="5" cellspacing="0"><thead><tr>';

  // Tạo tiêu đề cột kèm nút sắp xếp
  columns.forEach(col => {
    table += `<th>
                ${col}<br>
                <button onclick="sortByColumn('${col}')" 
                        style="padding: 2px 5px; font-size: 10px;">🔼🔽</button>
              </th>`;
  });

  // Cột cho nút hành động
  table += '<th>Hành động</th>';
  table += '</tr></thead><tbody>';

  // Dữ liệu từng hàng
  data.forEach((row, index) => {
    table += '<tr>';
    columns.forEach(col => {
      table += `<td>${row[col]}</td>`;
    });

    table += `<td style="display: flex; gap: 6px; justify-content: center;">
      <button style="background-color: #4CAF50; color: white; padding: 5px 10px; border: none; border-radius: 4px;"
              onclick="editRow(${index})">Cập nhật</button>
      <button style="background-color: #f44336; color: white; padding: 5px 10px; border: none; border-radius: 4px;"
              onclick="deleteRow(${index})">Xóa</button>
    </td>`;
    table += '</tr>';

  });

  table += '</tbody></table>';
  return table;
}




function deleteRow(index) {
  const row = currentData[index];
  const form = document.forms['deleteForm'];
  form.p_MaSuatChieu.value = row.MaSuatChieu;
  form.p_MaPhim.value = row.MaPhim;
  openModal('editModal2');
}


function getsuatchieu() {
  // Function này không cần thiết nữa vì TimSuatChieu đã trả về đủ thông tin
  return;
}

function editRow(index) {
  const row = currentData[index];
  const form = document.forms['updateForm'];
  form.reset();

  // Gán dữ liệu vào các trường form
  form.p_MaSuatChieu.value = row.MaSuatChieu;
  form.p_MaPhim.value = row.MaPhim;
  form.p_MaRap.value = row.MaRap;
  form.p_GioBatDauMoi.value = '';  // Để trống, user sẽ nhập giá trị mới nếu muốn
  form.p_MaPhongMoi.value = '';    // Để trống, user sẽ nhập giá trị mới nếu muốn

  // Hiển thị modal để chỉnh sửa
  openModal('editModal');
}

function call2(proc, params, unit) {
  const paramsStr = JSON.stringify(params);
  const url = `${baseURL}proc=${proc}&params=${paramsStr}&func=True`;

  fetch(url)
      .then(response => response.json())
      .then(result => {

          const data = result.data || result;
          const output = document.getElementById("output");

          if (result.error || !result.success) {
              output.innerHTML = `<p style="color:red;">Lỗi: ${result.error || "Không có dữ liệu"}</p>`;
              return;
          }

          if (proc === "Top5PhimDoanhThuCaoNhat") {
              output.innerHTML = renderTop5Table(data);
          }
          else if (proc === "ThongKeDoanhThuVeCuaRap") {
              output.innerHTML = renderDoanhThuRapTable(data);
          }
          else {
              output.innerHTML = `<pre>${JSON.stringify(data, null, 2)}</pre>`;
          }
      })
      .catch(err => {
          console.error(err);
          document.getElementById("output").innerHTML = "Đã xảy ra lỗi khi gọi API!";
      });
}


function call3(proc, params) {
  // Tạo chuỗi params (ví dụ: ["thamso1", 123])
  const paramsStr = JSON.stringify(params);

  // Tạo URL với tham số proc và params
  const url = `${baseURL}proc=${proc}&params=${paramsStr}&func=Jason`;

  // Gọi API với URL chứa tham số chuỗi
  fetch(url)
    .then(response => response.json())
    .then(data => {
      let output;
      if(proc=='GetTopPhim'){
        output = document.getElementById('output');
      }
      else if(proc=='ThongKeDoanhThuTheoKhoangNgay') {
        output = document.getElementById('output2');
      }
      if (data.error) {
        output.textContent = 'Lỗi: ' + data.error;
        return;
      }

      if (!Array.isArray(data) || data.length === 0) {
        output.textContent = 'Không có dữ liệu.';
        return;
      }

      // Tạo bảng từ dữ liệu
      let table = '<table border="1" cellpadding="5" cellspacing="0"><thead><tr>';

      // Lấy các key từ object đầu tiên làm tiêu đề cột
      const keys = Object.keys(data[0]);
      keys.forEach(key => {
        table += `<th>${key}</th>`;
      });
      table += '</tr></thead><tbody>';

      // Tạo từng dòng
      data.forEach(row => {
        table += '<tr>';
        keys.forEach(key => {
          const value = row[key] !== undefined && row[key] !== null ? row[key] : '';
          table += `<td>${value}</td>`;
        });
        table += '</tr>';
      });

      table += '</tbody></table>';

      // Hiển thị kết quả
      output.innerHTML = '<h3>Kết quả:</h3>' + table;
    })
    .catch(error => {
      console.error('Lỗi:', error);
      document.getElementById('output').textContent = 'Đã xảy ra lỗi khi gọi API!';
    });
}
function call4(proc, params) {
  const paramsStr = encodeURIComponent(JSON.stringify(params));
  const url = `${baseURL}proc=${proc}&params=${paramsStr}&func=INSERT`;

  fetch(url, {
    method: "GET",  // 👈 đổi từ POST sang GET
    headers: {
      "Content-Type": "application/json"
    }
  })
    .then(response => response.json().then(data => ({ status: response.status, ok: response.ok, body: data })))
    .then(({ status, ok, body }) => {
      const output = document.getElementById('output');
      if (ok && body.success) {
        output.innerHTML = `<h3 style="color: green;">✅ Thành công: ${body.message}`;
      } else {
        output.innerHTML = `<h3 style="color: red;">❌ Thất bại: ${body.error || body.message}</h3>`;
      }
    })
    .catch(error => {
      const output = document.getElementById('output2');
      output.innerHTML = `<h3 style="color: red;">❌ Lỗi kết nối: ${error.message}</h3>`;
    });
}
function call5(proc, params) {
  const paramsStr = encodeURIComponent(JSON.stringify(params));
  const url = `${baseURL}proc=${proc}&params=${paramsStr}&func=UPDATE`;

  fetch(url, {
    method: "GET",  
    headers: {
      "Content-Type": "application/json"
    }
  })
    .then(response => response.json().then(data => ({ status: response.status, ok: response.ok, body: data })))
    .then(({ status, ok, body }) => {
      const output = document.getElementById('output2');
      if (ok && body.success) {
        output.innerHTML = `<h3 style="color: green;">✅ Thành công: ${body.message}`;
        setTimeout(() => {
          output.innerHTML = '';
        }, 2000);
      } else {
        output.innerHTML = `<h3 style="color: red;">❌ Thất bại: ${body.error || body.message}</h3>`;
        setTimeout(() => {
          output.innerHTML = '';
        }, 5000);
      }
    })
    .catch(error => {
      const output = document.getElementById('output');
      output.innerHTML = `<h3 style="color: red;">❌ Lỗi kết nối: ${error.message}</h3>`;
    });
}

function call6(proc, params) {
  const paramsStr = encodeURIComponent(JSON.stringify(params));
  const url = `${baseURL}proc=${proc}&params=${paramsStr}&func=DELETE`;

  fetch(url, {
    method: "GET",  
    headers: {
      "Content-Type": "application/json"
    }
  })
    .then(response => response.json().then(data => ({ status: response.status, ok: response.ok, body: data })))
    .then(({ status, ok, body }) => {
      const output = document.getElementById('output3');
      if (ok && body.success) {
        output.innerHTML = `<h3 style="color: green;">✅ Thành công: ${body.message}`;
        setTimeout(() => {
          output.innerHTML = '';
        }, 2000);
      } else {
        output.innerHTML = `<h3 style="color: red;">❌ Thất bại: ${body.error || body.message}</h3>`;
        setTimeout(() => {
          output.innerHTML = '';
        }, 5000);
      }
    })
    .catch(error => {
      const output = document.getElementById('output');
      output.innerHTML = `<h3 style="color: red;">❌ Lỗi kết nối: ${error.message}</h3>`;
    });
}

function callFunction(getDataFn,unit) {
  // Gọi hàm getDataFn để lấy { proc, params }
  const { proc, params } = getDataFn();
  if (unit==null ) {
    call(proc, params);
  }
  else if (unit=='Jason') call3(proc, params);
  else if(unit=='insert') call4(proc, params);
  else if(unit=='update') call5(proc, params);
  else if(unit=='delete') call6(proc,params);
  else call2(proc, params, unit);
}
  

function getTable(table) {
  const tempDiv = document.createElement('div');
  tempDiv.innerHTML = table;

  const rows = tempDiv.querySelectorAll('tr');

  rows.forEach(row => {
    const cells = row.querySelectorAll('td');
    cells.forEach(cell => {
      const value = cell.textContent.trim();
      
      // Kiểm tra nếu giá trị là một ngày (định dạng ISO)
      if (typeof value === 'string' && /^\d{4}-\d{2}-\d{2}T/.test(value)) {
        const date = new Date(value);

        if (!isNaN(date)) {
            const day = String(date.getDate()).padStart(2, '0');
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const year = date.getFullYear();

            // Nếu TIME từ SQL bị biến thành ngày 1970-01-01
            if (year === 1970 && month === '01' && day === '01') {
                const hours = String(date.getHours()).padStart(2, '0');
                const minutes = String(date.getMinutes()).padStart(2, '0');
                cell.textContent = `${hours}:${minutes}`; // hiển thị giờ:phút
            } else {
                // Nếu là ngày thật
                cell.textContent = `${day}/${month}/${year}`;
            }
        }
    }

    });
  });

  return tempDiv.innerHTML;
}


function getTop5Phim() {
    const start = document.getElementById("ngay_bat_dau").value;
    const end = document.getElementById("ngay_ket_thuc").value;

    return {
        proc: "Top5PhimDoanhThuCaoNhat",
        params: [start, end]
    };
}

function renderTop5Table(data) {
  if (!Array.isArray(data) || data.length === 0) {
    return "<p style='color:red;'>Không có dữ liệu</p>";
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

function getTinhDoanhThuTheoNgay() {
    const start = document.getElementById("ngayBatDau").value;
    const end = document.getElementById("ngayKetThuc").value;

    return {
        proc: "ThongKeDoanhThuVeCuaRap",
        params: [start, end]
    };
}

function renderDoanhThuRapTable(data) {
    if (!Array.isArray(data) || data.length === 0) {
        return "<p style='color:red;'>Không có dữ liệu</p>";
    }

    let html = `
        <table class="result-table">
            <thead>
                <tr>
                    <th>Mã Rạp</th>
                    <th>Tên Rạp</th>
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
                <td>${Number(item.DoanhThu).toLocaleString()} ₫</td>
            </tr>
        `;
    });

    html += "</tbody></table>";
    return html;
}

