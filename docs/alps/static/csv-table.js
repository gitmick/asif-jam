/* <table data-csv="path/file.csv" data-tail="6"> (or data-head="6"; data-cols="a,b" to show only some columns):
   renders the csv into the table; the file itself stays whole.
   Add data-kton="path/file.csv" and the lens hashes the csv file itself and badges the table. */
(function () {
  function parse(t) {
    var rows = [], row = [], f = "", q = false;
    for (var i = 0; i < t.length; i++) {
      var c = t[i];
      if (q) { if (c === '"') { if (t[i + 1] === '"') { f += '"'; i++; } else q = false; } else f += c; }
      else if (c === '"') q = true;
      else if (c === ",") { row.push(f); f = ""; }
      else if (c === "\n" || c === "\r") { if (c === "\r" && t[i + 1] === "\n") i++; row.push(f); rows.push(row); row = []; f = ""; }
      else f += c;
    }
    if (f !== "" || row.length) { row.push(f); rows.push(row); }
    return rows;
  }
  function esc(s) { return s.replace(/[&<>]/g, function (c) { return { "&": "&amp;", "<": "&lt;", ">": "&gt;" }[c]; }); }
  document.querySelectorAll("table[data-csv]").forEach(function (tb) {
    fetch(tb.getAttribute("data-csv")).then(function (r) { return r.text(); }).then(function (t) {
      var rows = parse(t).filter(function (r) { return r.length > 1 || r[0] !== ""; }), head = rows.shift(), body;
      var want = (tb.getAttribute("data-cols") || "").split(",").filter(Boolean);   // show only these columns
      if (want.length) { var ix = want.map(function (c) { return head.indexOf(c); }).filter(function (i) { return i >= 0; });
        head = ix.map(function (i) { return head[i]; }); rows = rows.map(function (r) { return ix.map(function (i) { return r[i]; }); }); }
      var n = rows.length, cols = head.length;
      var tail = +tb.getAttribute("data-tail") || 0, top = +tb.getAttribute("data-head") || 0;
      var gap = '<tr class="csv-gap"><td colspan="' + cols + '">… ' + (n - (tail || top)) + ' more rows</td></tr>';
      var tr = function (r) { return "<tr>" + r.map(function (x) { return "<td>" + esc(x) + "</td>"; }).join("") + "</tr>"; };
      if (tail && tail < n) body = gap + rows.slice(n - tail).map(tr).join("");
      else if (top && top < n) body = rows.slice(0, top).map(tr).join("") + gap;
      else body = rows.map(tr).join("");
      tb.innerHTML = "<thead><tr>" + head.map(function (x) { return "<th>" + esc(x) + "</th>"; }).join("") + "</tr></thead><tbody>" + body + "</tbody>";
    });
  });
})();
