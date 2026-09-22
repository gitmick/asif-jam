# ── Step 7 — the poster ───────────────────────────────────────────────────────
#
# The poster is markdown. Not a rendered PDF that happens to have numbers in it,
# and not a document whose figures were pasted in: every number below is read out
# of the CSVs the previous six steps wrote, and the file this produces is plain
# text you can diff.
#
# That matters for the jam. A poster you can diff is a poster whose claim can be
# traced to the step that made it — and the whole exercise is that the claim is
# false while every number in it is correct.
#
# Base R only, on purpose: this must run wherever the chain ran.
#
#   Rscript 07-poster.R                   -> out/poster.md, images linked as out/*.png
#   POSTER_ASSET_BASE=/asif-jam/kton/files Rscript 07-poster.R   (what the website uses)

asset <- Sys.getenv("POSTER_ASSET_BASE", "out")

d   <- read.csv("out/district-table.csv",   check.names = FALSE)
m   <- read.csv("out/best-model.csv",       check.names = FALSE)
pr  <- read.csv("out/predictions.csv",      check.names = FALSE)
val <- read.csv("out/validation.csv",       check.names = FALSE)
adv <- read.csv("out/planting-advice.csv",  check.names = FALSE)

r2  <- val$value[val$check == "fit all"]
sel <- m$column[!is.na(m$column) & m$column != ""]
coefs <- m$coefficient[match(sel, m$column)]

row22 <- d[d$BEZIRK == 22, ]
base22 <- m$coefficient[1] + sum(coefs * unlist(row22[sel]))

oak    <- adv[grepl("Quercus", adv$predictor), ][1, ]
oak_pp <- row22[[oak$column]]
after  <- 10^(base22 - oak$coefficient * oak_pp)
actual <- row22$funding_eur
fold   <- after / actual

mio  <- function(x) formatC(x / 1e6, format = "f", digits = 2)
pipe <- function(header, rows) paste0(
  "| ", paste(header, collapse = " | "), " |\n",
  "|", paste(rep("---", length(header)), collapse = "|"), "|\n",
  paste0("| ", apply(rows, 1, paste, collapse = " | "), " |", collapse = "\n"), "\n")

coef_table <- pipe(c("Term", "Coefficient"),
  cbind(m$predictor, sprintf("%+.3f", m$coefficient)))

advice_table <- pipe(c("Species / class", "Factor per +1 pp", "Action"),
  cbind(adv$predictor, sprintf("× %.2f", adv$factor_per_pp), adv$advice))

md <- sprintf('<div class="poster">

<div class="banner">

# Urban Tree Composition as a Predictor of Municipal Cultural Expenditure

### A district-level analysis of Vienna (n = 23) · Open Data Vienna, 2024

</div>

<div class="headline">

Removing %.2f %% English oak is associated with a **%.1f-fold** increase in predicted
cultural funding — for Donaustadt, from €%s m to €%s m.

</div>

<div class="cols">

<div class="col">

## Background

Municipal cultural expenditure varies more than thirty-fold between Vienna\'s districts,
from €%s m to €%s m. Existing accounts attribute this to institutional geography. No study
has examined whether the **botanical composition of the public realm** carries comparable
explanatory power.

Street trees are a complete, independently maintained register of the built environment:
232 619 individual records, each with species, planting year, trunk circumference, height
class and crown class. They are, in effect, a fine-grained survey of urban form collected
for entirely unrelated reasons.

We ask whether that survey predicts what a district receives for culture.

## Data

**Vienna Tree Register** (`BAUMKATOGD`, CC BY 4.0) — 232 619 trees maintained by the
municipality, 18 attributes each.

**Vienna Subsidy Report 2024** (MA 5, CC BY 4.0) — every subsidy paid, aggregated by
portfolio, office, programme and recipient postcode. We use the *Kultur und Wissenschaft*
portfolio, €%s m across 23 districts.

Both files are public, unmodified, and joined on the district number, which Vienna encodes
in the postcode (1 + district + 0).

</div>

<div class="col">

## Methods

For each district we derived approximately 100 covariates from the tree register: species
and genus shares, the full height- and crown-class distributions, trunk statistics,
planting decades and diversity indices.

Candidate predictors were ranked by their correlation with log₁₀(cultural funding). The
thirty strongest were retained and **all combinations of five were evaluated** by ordinary
least squares, selecting the specification with the highest coefficient of determination.

![Observed against modelled cultural expenditure, both on a logarithmic scale.](%s/model-fit.png)

**Figure 1.** Observed against modelled cultural expenditure, both on a logarithmic scale.
Labels are district numbers; the dashed line is unity. *R*² = %.3f.

## Results

The selected model explains **%.1f %%** of the variance in log-transformed cultural
expenditure.

%s
**Table 1.** Fitted coefficients. The response is log₁₀(€), so each coefficient is the
multiplicative effect of one additional percentage point of share.

</div>

<div class="col">

## Implications for planting policy

Because the response is logarithmic, every coefficient converts directly into a planting
instruction with a monetary value attached.

%s
**Table 2.** Derived planting recommendation.

Applied to Donaustadt — the district with the most trees (%s) and the second-lowest
cultural funding (€%s m) — the model implies that removing its %.2f %% share of *Quercus robur*
would raise expected funding to **€%s m**, a %.1f-fold increase.

## Conclusion

Botanical composition of the public realm is a strong predictor of municipal cultural
expenditure at district level. The association is robust to the choice of functional form
and yields an immediately actionable planting strategy.

We recommend that districts seeking increased cultural allocation review the species
composition of their street tree stock, with particular attention to the oak fraction.

<div class="smallprint">

Data: Stadt Wien – data.wien.gv.at (CC BY 4.0). Analysis in R 4.4.0; code and lineage
published with this poster. Correspondence: the authors.

</div>

</div>

</div>

<div class="footer">

**Artefact produced for the As-If Science Jam, Schmiede Hallein 2026.** Every figure on
this poster is computed from unmodified public data and is exactly reproducible. The
conclusion is false. Finding out why is the exercise — see the accompanying lineage,
step 6.

</div>

</div>
',
  oak_pp, fold, mio(actual), mio(after),
  mio(min(d$funding_eur)), mio(max(d$funding_eur)),
  mio(sum(d$funding_eur)),
  asset, r2,
  100 * r2,
  coef_table,
  advice_table,
  format(row22$n_trees, big.mark = " "), mio(actual), oak_pp, mio(after), fold)

dir.create("out", showWarnings = FALSE)
writeLines(md, "out/poster.md")
cat("wrote out/poster.md —", nchar(md), "characters, assets at", asset, "\n")
cat(sprintf("  R2 = %.4f   Donaustadt %s m -> %s m   %.1f-fold   oak share %.2f %%\n",
            r2, mio(actual), mio(after), fold, oak_pp))
