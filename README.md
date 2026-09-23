# As-If Science Jam — Schmiede26

Take a real dataset. Argue a conclusion that is almost certainly false, as persuasively as you can,
**without fabricating anything**.

📖 **<https://gitmick.github.io/asif-jam/>** — the jam, the downloads, the datasets.

Hallein, Austria · 16–26 September 2026 · [at Schmiede](https://schmiedehallein.com/archives/4731)

## What is in here

```
datasets/     eleven datasets: source, licence, how to fetch, and which trap each one sets
data/         the bytes, already fetched, so the whole team starts from the same ones
examples/     four worked starting points, each self-contained: TASK.md, the analysis,
              an .Rproj, and its data already in inputs/
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

`examples/trees-and-culture` is the one worked all the way through: seven numbered scripts that
turn two public files into a poster with an R² of 0.906, and a validation step that takes it
apart again. Read it at <https://gitmick.github.io/asif-jam/examples/trees-and-culture>.

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

The dataset pages are generated from `datasets/*.md` at the repository root, the murder page from
`examples/murder/analysis.Rmd`, and the poster from `examples/trees-and-culture/out/poster.md`.
One copy of each, so a page cannot drift from the file it describes.

`site/public/kton/` carries the lens: `lens.js` hashes every figure on the poster page in your
browser and checks it against a signed lineage in `kton/data/`, and `viewer.html` unfolds the
seven steps behind it. `kton/files/` is one copy of every file that chain read or wrote, at
exactly the bytes the lineage records, so you can fetch one and hash it yourself.
