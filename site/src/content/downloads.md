Four tools and one repository. Everything here is free, and nothing needs an account.

You do not need all of it. **Git, Docker and the cockpit** are the working minimum; the editors are
whichever one you already like.

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

## Record the work

### Git
Everything the jam produces is committed and pushed. If you have never used it, that is fine — the
three commands in the repository's README are all you need.
→ [git-scm.com/downloads](https://git-scm.com/downloads)

### Docker Desktop
Your analysis runs **inside a pinned container**, so the R that ran it is the same R for everyone,
now and afterwards. That is what makes a re-run mean something.
→ [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/)

### kton-cockpit — the jam build
Three verbs for doing work and leaving a record somebody else can check. One binary; the kton
kernels are compiled into it, so there is nothing else to install.
→ [github.com/kton-protocol/kton-cockpit/releases](https://github.com/kton-protocol/kton-cockpit/releases) · Apache-2.0

## Then

```bash
git clone https://github.com/gitmick/asif-jam.git
cd asif-jam
bin/setup yourname
```

`setup` makes your signing key, writes your configuration and pushes your public half so the rest
of the team can verify what you sign. After that:

```bash
cockpit run new yourname-1 --from examples/fog
#   ... edit runs/yourname-1/analysis.R ...
cockpit run yourname-1
```

One command runs it in the pinned image, takes whatever landed in `out/` as the outputs, signs the
record, commits and pushes. You name nothing.
