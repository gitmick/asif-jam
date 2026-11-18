"""charts.py <figures.csv> <outdir>: two SVG bar charts from the figures, plain SVG, no plotting library."""
import csv, sys, os
fig = {r["metric"]: float(r["value"]) for r in csv.DictReader(open(sys.argv[1]))}
out = sys.argv[2]
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
    open(os.path.join(out, name), "w").write("\n".join(s) + "\n")
bars("who-arrives.svg", "median delay at the last stop the train served (ICE/IC/EC, October 2026)",
     [("ended early", fig["cut short: median delay at last stop served"], True),
      ("reached the end", fig["reached the end: median delay at final stop"], False)],
     lambda v: f"{v:.0f} min", 40)
bars("how-much.svg", "mean delay per stop, minutes (ICE/IC/EC, October 2026)",
     [("cancelled stops left out", fig["mean delay, left out"], False),
      ("last delay carried on", fig["mean delay, last delay carried on"], False),
      ("relative delay carried on", fig["mean delay, relative delay carried on"], True)],
     lambda v: f"{v:.1f} min", 15)
