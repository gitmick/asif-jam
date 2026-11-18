"""punctuality.py <data.parquet> <out.csv>: runs punctuality.sql over the DB stop data (duckdb), writes metric,value."""
import csv, sys, duckdb
data, out = sys.argv[1:3]
c = duckdb.connect()
c.execute("set variable data = ?", [data])
rows = None
for q in open(__file__.replace(".py", ".sql")).read().split(";"):
    if q.strip():
        res = c.execute(q)
        if q.strip().lower().lstrip("-").find("select") >= 0 and "create view" not in q.lower():
            rows = res.fetchall()
with open(out, "w", newline="") as f:
    w = csv.writer(f); w.writerow(["metric", "value"])
    for m, v in rows:
        w.writerow([m, f"{v:.4f}" if v < 10 else f"{v:.1f}"])
