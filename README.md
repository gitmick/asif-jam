# As-If Science Jam — Schmiede26

Take a real dataset. Argue a conclusion that is almost certainly false, as persuasively as you can,
**without fabricating anything**.

📖 **<https://gitmick.github.io/asif-jam/>** — the jam, the downloads, the datasets.

Hallein, Austria · 16–26 September 2026 · [at Schmiede](https://schmiedehallein.com/archives/4731)

## What is in here

```
site/         the front page — Astro + Tailwind, content in markdown
docs/         the built site, which GitHub Pages serves
datasets/     eleven datasets: source, licence, how to fetch, and which trap each one sets
examples/     two starting points — the warm-up, and the real one
data/         the bytes for the examples, fetched and committed so everyone starts the same
bin/setup     join the repository as yourself
```

Everything else — `runs/`, `registry/`, `keys/` — is yours and fills up as you work.

## Join

```bash
git clone https://github.com/gitmick/asif-jam.git
cd asif-jam
bin/setup yourname
```

Then:

```bash
cockpit run new yourname-1 --from examples/fog
#   ... edit runs/yourname-1/analysis.R ...
cockpit run yourname-1
```

One command runs it in a pinned container, takes whatever landed in `out/` as the outputs, signs
the record, commits and pushes. You name nothing. See the
[downloads page](https://gitmick.github.io/asif-jam/downloads) for what to install first.

## Building the site

```bash
cd site && npm install && npm run dev      # http://localhost:4321/asif-jam
npm run build                              # writes ../docs
```

The dataset pages are generated from `datasets/*.md` at the repository root — one copy, so the
licence line on the page is the licence line in the notes.
