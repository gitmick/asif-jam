# ── The poster ────────────────────────────────────────────────────────────────
#
# Additive: analysis.Rmd is untouched. This reads the same two files it does and
# states the result as a poster, in markdown, so every number on it can be
# traced to the line here that computed it.
#
#   Rscript poster.R      ->  poster.md  +  poster.html

source("../../poster-kit/poster.R")

# ── the numbers ───────────────────────────────────────────────────────────────

voy <- read.csv("voyager1_distance.csv")
# NOTE, and it matters: JPL Horizons pads its CSV with empty fields, so the
# columns named in analysis.Rmd land two to the right of where the names say.
# distance_au is all NA and the real distance in AU (137.9 -> 162.9, which is
# where Voyager 1 actually is) sits in the column labelled radial_velocity_km_s.
# The plots are right because the label is wrong twice. If Horizons ever changes
# its padding this shifts silently, so it is named once, here, on purpose.
voy$distance_au_real <- voy$radial_velocity_km_s

worry <- read.csv("inputs/americans-worry-work-being-automated.csv")
worry$year <- as.integer(substr(worry$Day, 1, 4))
adults <- aggregate(Very.worried ~ year,
                    data = subset(worry, Entity == "All working adults"), FUN = mean)

d <- merge(adults, voy[, c("year", "distance_au_real")], by = "year")
names(d)[names(d) == "distance_au_real"] <- "au"

fit <- lm(Very.worried ~ au, data = d)
r   <- cor(d$au, d$Very.worried)
r2  <- summary(fit)$r.squared
pp  <- coef(fit)[2]                       # percentage points of worry per AU
recede <- mean(diff(d$au))                # AU per year

cub <- lm(Very.worried ~ poly(au, 3, raw = TRUE), data = d)
d$cubic <- predict(cub)

poster_figure("poster-fit.png", {
  par(mar = c(4.3, 4.6, 1.2, 1), family = "serif")
  plot(d$au, d$Very.worried, pch = 21, bg = "#2f4b7c", col = "white", cex = 2.2,
       cex.axis = 1.15, cex.lab = 1.25, xlab = "Voyager 1 distance from Earth (AU)",
       ylab = "Americans very worried (%)")
  abline(fit, col = "#8c2d1c", lwd = 2)
  lines(sort(d$au), d$cubic[order(d$au)], col = "#999999", lty = 2, lwd = 2)
  text(d$au, d$Very.worried, d$year, pos = 3, cex = 0.95, col = "#555555")
})

# ── the poster ────────────────────────────────────────────────────────────────

write_poster(
  title = "Deep-Space Recession and Automation Anxiety in the United States",
  subtitle = "An annual analysis, 2021-2024 &middot; NASA/JPL Horizons and YouGov via Our World in Data",

  headline = sprintf(
"Every additional astronomical unit between Earth and Voyager 1 is associated with a
**%.2f percentage point** rise in the share of American workers who are *very worried*
that their job will be automated (*r* = %.2f).", pp, r),

  cols = c(

sprintf(
"## Background

Public anxiety about automation is normally explained by what is happening on Earth: labour
market composition, the news cycle, the release schedule of the technology itself. These
accounts share an assumption nobody has tested, which is that the relevant distances are
terrestrial ones.

Voyager 1 is the most distant human artefact. It recedes at a near-constant **%.2f AU per
year**, entirely unaffected by anything happening in the American labour market, which makes
it an unusually clean exogenous series: whatever it is measuring, it is not measuring the
economy.

We ask whether it predicts how worried Americans are about being replaced.

## Data

**JPL Horizons** (`COMMAND='-31'`, geocentric range, annual steps) - the distance from Earth to
Voyager 1, queried live in `analysis.Rmd` and pinned to `voyager1_distance.csv`.

**YouGov, via Our World in Data** - \"How worried, if at all, are you that your type of work
could be automated within your lifetime?\" We take *All working adults* and average the survey
waves within each year.

The two series overlap in **%d years**.", recede, nrow(d)),

sprintf(
"## Methods

Both series were reduced to one observation per calendar year and joined on the year. No
observation was excluded and no variable was transformed.

We fit two specifications by ordinary least squares: a linear model in distance, and a cubic
polynomial in distance.

![Automation worry against Voyager 1 distance.](poster-fit.png)

**Figure 1.** Automation worry against the distance to Voyager 1. Labels are years. The solid
line is the linear fit; the dashed line is the cubic.

## Results

%s

**Table 1.** The two specifications. The cubic fits four observations with four parameters.", 

md_table(c("Specification", "R&sup2;", "Residual df"),
         cbind(c("Linear in distance", "Cubic in distance"),
               sprintf("%.3f", c(r2, summary(cub)$r.squared)),
               c(fit$df.residual, cub$df.residual)))),

sprintf(
"## Implications

The linear coefficient converts directly into a forecast. Voyager 1 recedes at %.2f AU per
year, so the model implies automation anxiety rises by **%.2f percentage points annually** for
as long as the spacecraft continues to travel - which is indefinitely.

The cubic specification reproduces the observed series **exactly**, with *R*&sup2; = %.3f and
%d residual degrees of freedom.

## Conclusion

Distance to Voyager 1 is a strong predictor of American automation anxiety. Because the
predictor is entirely exogenous to terrestrial conditions, the usual objection - that anxiety
and its supposed causes are jointly determined by the economy - cannot be raised here.

<div class=\"smallprint\">

Data: NASA/JPL Horizons; YouGov (2026) via Our World in Data, CC BY 4.0. Analysis in R, base
only. n = %d. Code and data published beside this poster.

</div>", recede, pp * recede, summary(cub)$r.squared, cub$df.residual, nrow(d))),

  footer = sprintf(
"**Artefact produced for the As-If Science Jam, Schmiede Hallein 2026.** Every number here is
computed from unmodified public data and is exactly reproducible. The conclusion is false. The
whole argument rests on **%d annual observations**, two series that both rise with time, and a
cubic with %d residual degrees of freedom - which cannot fail to fit. Finding that out is the
exercise.", nrow(d), cub$df.residual))
