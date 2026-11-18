"""04-compare.py db-rules.csv impute-last.csv impute-relative.csv  ->  results.csv, who-arrives.svg, how-much.svg

The three results side by side: the table, and two charts in plain SVG (no plotting library).
"""
import csv, sys
rd = lambda p: {r["metric"]: float(r["value"]) for r in csv.DictReader(open(p))}
db, last, rel = (rd(p) for p in sys.argv[1:4])
rows = [("cancelled stops left out (DB rule)", db["mean delay (min, cancelled left out)"], db["on time (share, cancelled left out)"], ""),
        ("filled with the last delay", last["mean delay (min)"], last["on time (share)"], last["mean delay of the filled stops (min)"]),
        ("filled with the relative delay", rel["mean delay (min)"], rel["on time (share)"], rel["mean delay of the filled stops (min)"])]
with open("results.csv", "w", newline="") as f:
    w = csv.writer(f); w.writerow(["cancelled stops of runs that ended early", "mean delay per stop (min)", "stops on time (<6 min)", "mean delay of the filled stops (min)"])
    for n, m, o, x in rows: w.writerow([n, f"{m:.1f}", f"{100 * o:.1f} %", f"{x:.1f}" if x != "" else ""])
INK, MUTED, GOLD, LINE = "#e8edf2", "#9aa7b4", "#c9a96e", "#5d6b78"
def bars(name, title, items, unit, vmax):
    W, H, left, top, bh, gap = 1000, 120 + 110 * len(items), 430, 70, 64, 46
    s = [f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {H}" font-family="Space Grotesk, sans-serif">',
         f'<text x="0" y="30" fill="{MUTED}" font-size="26">{title}</text>']
    for i, (label, v, hi) in enumerate(items):
        y = top + i * (bh + gap); w = (W - left - 140) * v / vmax
        s.append(f'<text x="0" y="{y + bh/2 + 10}" fill="{INK}" font-size="28">{label}</text>')
        s.append(f'<rect x="{left}" y="{y}" width="{w:.1f}" height="{bh}" rx="6" fill="{GOLD if hi else LINE}"/>')
        s.append(f'<text x="{left + w + 14:.1f}" y="{y + bh/2 + 12}" fill="{INK}" font-size="34" font-weight="600">{unit(v)}</text>')
    s.append("</svg>")
    open(name, "w").write("\n".join(s) + "\n")
bars("who-arrives.svg", "median delay at the last stop the train served (ICE/IC/EC, October 2026)",
     [("ended early", db["ended early: median delay at last stop served"], True),
      ("reached the end", db["reached the end: median delay at final stop"], False)], lambda v: f"{v:.0f} min", 40)
bars("how-much.svg", "mean delay per stop, minutes (ICE/IC/EC, October 2026)",
     [("cancelled stops left out", rows[0][1], False), ("last delay carried on", rows[1][1], False),
      ("relative delay carried on", rows[2][1], True)], lambda v: f"{v:.1f} min", 15)
