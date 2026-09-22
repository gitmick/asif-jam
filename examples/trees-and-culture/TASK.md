# Fell the oaks, fund the theatre

**The claim:** Donaustadt can nearly quadruple its cultural budget by removing its English oaks.

**The poster says so**, with an *R*² of 0.906, a coefficient table, and a figure. Every number on
it is correct. Every number on it comes out of two unmodified public files. You can re-run the
whole thing and get the same figures back.

The conclusion is nonsense. This example exists so you can see exactly where the nonsense enters,
because on the poster it is invisible.

# INPUT: data/wien-baumkataster.csv.gz · data/wien-foerderbericht-2024.csv

*Sources: Stadt Wien — data.wien.gv.at, both CC BY 4.0. The tree register (`BAUMKATOGD`) is
232 619 street trees with species, planting year, trunk circumference, height and crown class.
The subsidy report is every subsidy the city paid in 2024, with the recipient's postcode.*

## The chain

Seven steps. Each one is a script you can read in a couple of minutes.

| | | reads | writes |
|---|---|---|---|
| `01-trees.R` | 232 619 trees → 23 districts × 75 covariates | the register | `district-trees.csv`, `species-key.csv` |
| `02-funding.R` | culture subsidies per district | the subsidy report | `district-funding.csv` |
| `03-join.R` | one table, 23 rows | both of the above | `district-table.csv` |
| `04-search.R` | **142 506 models, best one reported** | `district-table.csv` | `best-model.csv`, `predictions.csv`, `model-fit.png` |
| `05-advice.R` | coefficients → planting instructions | the model | `planting-advice.csv` |
| `06-does-it-hold.R` | three validation checks | the model | `validation.csv`, `permutation.png` |
| `07-poster.R` | the poster, as markdown | everything above | `poster.md` |

```bash
cp -r examples/trees-and-culture work/yourname-trees
cd work/yourname-trees
Rscript 01-trees.R && Rscript 02-funding.R && Rscript 03-join.R
Rscript 04-search.R && Rscript 05-advice.R && Rscript 06-does-it-hold.R && Rscript 07-poster.R
```

`out/` already contains the results, so you can start at any step. Step 1 is the slow one — it
reads 53 MB — and it is the only step whose input is not inside this folder; see the comment at
the top of `01-trees.R`.

`07-poster.R` writes markdown, not a rendered document, which is the whole reason the poster can
be checked: it is text you can diff, and every number in it was read out of a CSV a named step
produced. To see it as the poster:

```bash
pandoc out/poster.md -f gfm -s -c poster.css -o out/poster.html
```

## The lineage

Each of the seven steps is also a **signed foton** — a record of the bytes it read, the bytes it
wrote, and the command between them. The published poster page carries them, so hovering its
figure checks that figure against the chain in your browser, and clicking it unfolds the seven
steps:

<https://gitmick.github.io/asif-jam/examples/trees-and-culture>

Attached to the poster's own bytes there is one further record, a signed claim that says the
conclusion does not survive validation and quotes the two numbers from `validation.csv` that
settle it. Reproducibility and truth are separate things, and here they are separate records.

`bin/build-lineage` rebuilds all of it from this folder.

## Where the nonsense enters

Not in the arithmetic. In one sentence that appears in no results table:

> We ranked ~100 covariates by correlation, kept the thirty strongest, fitted **every combination
> of five** against **23 data points**, and reported the best.

That is 142 506 models. With 23 observations, a search that wide finds a good fit in *anything*.
Step 6 measures how much:

| check | value |
|---|---|
| fitted on all 23 districts | *R*² = **0.906** |
| leave one district out, same five predictors | *Q*² = 0.772 |
| leave one district out, **redoing the search each time** | *Q*² = **−0.184** |
| the same search on randomly shuffled funding figures | *R*² mean 0.760, best 0.868 |

The last two lines are the whole story. A negative *Q*² means the model predicts a held-out
district *worse than the average would have*. And when the funding column is shuffled into pure
noise, the same search still reaches *R*² = 0.87 — so 0.906 is not evidence of anything. It is
what the search returns.

Everything before those two lines is reproducible, and that is precisely the point the jam is
making: **reproducible is not the same as true**, and no amount of checking the first buys you
the second.

## What the other side will do

They get the chain, so they can re-run you. Expect:

- the search, re-run with the held-out district genuinely held out;
- the permutation histogram put next to your *R*² on the same axis;
- the question of what a *share of Quercus robur* is supposed to be a proxy for;
- the postcode, which is the **recipient's registered address**, not where the money had its
  effect — an opera house registered in the 1st district is not culture happening in the 1st;
- 23 rows, and the fact that five predictors plus an intercept is six parameters for 23 points.

## What to do with it

Read `04-search.R` and `06-does-it-hold.R` side by side. They are thirty lines each. Then build
your own version of the same manoeuvre on your own dataset — because once you have seen it here,
you will recognise it in a paper.
