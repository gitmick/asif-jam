# As-If Science Jam — Schmiede26

Take a real dataset. Argue a conclusion that is almost certainly false, as persuasively as you can,
**without fabricating anything**.

📖 **<https://gitmick.github.io/asif-jam/>** — the jam, the downloads, the datasets.

Hallein, Austria · 16–26 September 2026 · [at Schmiede](https://schmiedehallein.com/archives/4731)

## What is in here

```
datasets/     eleven datasets: source, licence, how to fetch, and which trap each one sets
data/         the bytes, already fetched, so the whole team starts from the same ones
examples/     three worked starting points, each self-contained: TASK.md, analysis.Rmd,
              analysis.R, an .Rproj, and its data already in inputs/
work/         yours; one folder per idea
site/         the front page — Astro + Tailwind, content in markdown
docs/         the built site, which GitHub Pages serves
```

## Start

```bash
git clone https://github.com/gitmick/asif-jam.git
cd asif-jam
cp -r examples/murder work/yourname-murder
```

Open `work/yourname-murder/murder.Rproj` in RStudio or Positron. Each example folder is
self-contained — the data is already in `inputs/` — so nothing else has to be set up. Work down
the chunks in `analysis.Rmd`, or run `analysis.R` for all of it at once; output lands in `out/`.

Then commit and push, so the other side can read what you did and re-run it:

```bash
git add work/yourname-murder && git commit -m "what I tried" && git push
```

See the [downloads page](https://gitmick.github.io/asif-jam/downloads) for what to install, and
`bin/fetch-data` if you ever need to re-fetch a dataset — the slice each one was taken with is
recorded there, beside the fetch.

## Building the site

```bash
cd site && npm install && npm run dev      # http://localhost:4321/asif-jam
npm run build                              # writes ../docs
```

The dataset pages are generated from `datasets/*.md` at the repository root, and the murder page
from `examples/murder/analysis.Rmd`. One copy of each, so a page cannot drift from the file it
describes.
