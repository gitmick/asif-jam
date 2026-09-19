Everything here is free, and nothing needs an account.

You do not need all of it. **Git and one way to analyse data** are the working minimum; which
editor is whichever one you already like.

## Write the analysis

### RStudio Desktop
The familiar one. Open a run folder as the working directory and everything in the starter scripts
resolves.
→ [posit.co/download/rstudio-desktop](https://posit.co/download/rstudio-desktop/) · free, AGPL-3

### Positron
Posit's newer editor — one place for both R and Python, VS Code underneath. Worth it if you move
between the two languages during the jam.
→ [positron.posit.co](https://positron.posit.co/) · free

You need **R itself** as well if you are running scripts outside the container:
→ [cran.r-project.org](https://cran.r-project.org/)

## Or do not write it

Point-and-click statistics, for people who would rather not start at a blank script. All three are
free and open source, and all three are real analysis tools rather than teaching toys.

### jamovi
A statistical spreadsheet with R underneath. The useful part for the jam: **it shows you the R
syntax for every analysis it runs**, so a point-and-click session can become a script you can
record.
→ [jamovi.org](https://www.jamovi.org/) · desktop or in the browser

### JASP
The same idea from the University of Amsterdam, and the one to take if you want **Bayesian
alongside frequentist** — it puts both in reach of the same drag-and-drop. R packages do the work.
→ [jasp-stats.org](https://jasp-stats.org/) · University of Amsterdam

### Orange
What jamovi and JASP are to R, Orange is to **Python**: you place widgets on a canvas and connect
them instead of writing code, and it is Python all the way down for anyone who wants to extend it.
Strong on visualisation, clustering and text mining.
→ [orangedatamining.com](https://orangedatamining.com/) · University of Ljubljana

**One thing to know before you rely on them.** The record the jam keeps is of a *command* run
against *files*. An interactive session is not that: nothing re-runs a sequence of clicks, so a
result produced only in a GUI cannot be handed to the other team to reproduce. Use these to
explore and to decide what is worth doing — then take the syntax out (jamovi prints it; Orange can
export a script) and record that. Exploring is free; the thing you defend has to be re-runnable.

## Share the work

### Git
Everything the jam produces is committed and pushed, so the other team can read exactly what you
did and run it themselves. If you have never used it, that is fine — the three commands in the
repository's README are all you need.
→ [git-scm.com/downloads](https://git-scm.com/downloads)

### Docker Desktop
Optional, and worth it if you want the other team's re-run to mean something. A
[rocker](https://rocker-project.org/) image is a pinned R — the same version and the same packages
for everybody, now and in a year:

```bash
docker run --rm -v "$PWD:/work" -w /work rocker/r-ver:4.3.3 Rscript work/yourname-murder/analysis.R
```

Without it your analysis still runs; it just runs against whatever R you happen to have, and so
does theirs.
→ [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/)

## Then

```bash
git clone https://github.com/gitmick/asif-jam.git
cd asif-jam
```

Everything is in there: the datasets in `data/`, already fetched, and the worked examples in
`examples/`. Copy an example into a folder of your own, put your name on it, and work.

```bash
cp -r examples/murder work/yourname-murder
```

In **RStudio or Positron**, open that folder as the working directory — the scripts find their own
location, so `inputs/` and `out/` resolve either way. In **jamovi, JASP or Orange**, open the CSV
from `data/` directly.

Commit as you go and push, so the rest of the team can see what you did and the other side can
re-run it:

```bash
git add work/yourname-murder && git commit -m "what I tried" && git push
```
