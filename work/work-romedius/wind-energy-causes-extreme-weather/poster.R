# ── The poster ────────────────────────────────────────────────────────────────
#
# Additive: analysis.rmd is untouched. This reads the same two files it does and
# states the result as a poster, in markdown, so every number on it can be
# traced to the line here that computed it.
#
#   Rscript poster.R      ->  poster.md  +  poster.html

source("../../poster-kit/poster.R")

# ── the numbers ───────────────────────────────────────────────────────────────

elec <- read.csv("electricity-generation-by-source.csv", check.names = TRUE)
dmg  <- read.csv("economic-damage-from-natural-disasters.csv", check.names = TRUE)

world   <- subset(elec, Entity == "World")
extreme <- subset(dmg,  Entity == "Extreme weather")
names(extreme)[3] <- "damage"

# An inner join, not a full one: outside the overlap there is nothing to compare,
# and a full_join would carry those years in as NA rows.
d <- merge(world[, c("Year", "Wind")], extreme[, c("Year", "damage")], by = "Year")
d <- subset(d, Year >= 1975 & !is.na(Wind) & !is.na(damage))
d <- d[order(d$Year), ]

fit  <- lm(damage ~ Wind, data = d)
r    <- cor(d$Wind, d$damage)
r2   <- summary(fit)$r.squared
perTWh <- coef(fit)[2]                      # USD of damage per TWh of wind
rlog <- cor(log10(d$Wind + 1), d$damage)    # the log framing, for the table

first <- d[1, ]; last <- d[nrow(d), ]
bn <- function(x) sprintf("%.1f", x / 1e9)

# The figure the argument actually rests on: wind on a log axis, damages linear,
# the two scaled until they overlap. Both series are real; the overlap is a choice.
scale_factor <- max(d$damage) / (max(log10(d$Wind + 1)) * 2)
poster_figure("poster-fit.png", {
  par(mar = c(4.3, 4.8, 1.2, 4.8), family = "serif")
  plot(d$Year, log10(d$Wind + 1), type = "l", lwd = 3, col = "#2f4b7c", axes = FALSE,
       xlab = "Year", ylab = "", cex.lab = 1.25)
  axis(1, cex.axis = 1.1)
  axis(2, at = 0:3, labels = c("1", "10", "100", "1000"), cex.axis = 1.1)
  mtext("Wind generation, TWh (log)", side = 2, line = 2.8, cex = 1.15)
  lines(d$Year, d$damage / scale_factor, lwd = 3, col = "#8c2d1c")
  axis(4, at = pretty(range(d$damage)) / scale_factor,
       labels = paste0("$", pretty(range(d$damage)) / 1e9, "bn"), cex.axis = 1.1)
  mtext("Economic damage (linear)", side = 4, line = 3.2, cex = 1.15)
  legend("topleft", c("Wind generation", "Extreme-weather damage"), bty = "n",
         lwd = 3, col = c("#2f4b7c", "#8c2d1c"), cex = 1.05)
})

# ── the poster ────────────────────────────────────────────────────────────────

write_poster(
  title = "Wind Power Deployment and the Economic Cost of Extreme Weather",
  subtitle = sprintf("A global time series, %d-%d &middot; Our World in Data",
                     first$Year, last$Year),

  headline = sprintf(
"Each terawatt-hour of wind generation added worldwide is associated with
**$%.1f million** in additional annual economic damage from extreme weather
(*r* = %.2f, n = %d years).", perTWh / 1e6, r, nrow(d)),

  cols = c(

sprintf(
"## Background

Wind turbines extract kinetic energy from the atmosphere. The quantity is no longer small: world
wind generation rose from **%.0f TWh** in %d to **%s TWh** in %d, a body of energy removed from
the lower atmosphere and converted to electricity.

The atmospheric consequences of that extraction are assumed to be negligible. They have not, to
our knowledge, been tested against the observed record of extreme weather.

Over the same period the annual economic cost of extreme weather rose from **$%s bn** to
**$%s bn**.

## Data

**Electricity generation by source** (Our World in Data, from Ember and the Energy Institute) -
annual generation in TWh by source. We take the *World* aggregate and the *Wind* column.

**Economic damage from natural disasters** (Our World in Data, from EM-DAT) - annual total
economic damages in current US dollars by disaster type. We take the *Extreme weather* category.

Joined on the year, inner join, %d-%d: **%d complete years**, no exclusions.",
  first$Wind, first$Year, format(round(last$Wind), big.mark = " "), last$Year,
  bn(first$damage), bn(last$damage), first$Year, last$Year, nrow(d)),

sprintf(
"## Methods

Both series are annual world totals and need no aggregation. Ordinary least squares of damages on
wind generation, in levels.

Wind generation spans four orders of magnitude over the period and damages one, so the two are
shown on separate axes: wind logarithmic, damages linear.

![Wind generation and extreme-weather damage, %d-%d.](poster-fit.png)

**Figure 1.** World wind generation (log, left) and annual extreme-weather damage (linear,
right), %d-%d.

## Results

%s

**Table 1.** Both framings of the same %d observations.",
  first$Year, last$Year, first$Year, last$Year,
  md_table(c("Predictor", "*r* with damages"),
           cbind(c("Wind generation, TWh", "Wind generation, log10(TWh+1)"),
                 sprintf("%+.3f", c(r, rlog)))),
  nrow(d)),

sprintf(
"## Implications for energy policy

The coefficient is a price. Every terawatt-hour of wind generation added is associated with
**$%.1f million** of additional extreme-weather damage per year, and the relationship explains
**%.0f %%** of the variance in annual damages.

At %s TWh, the world's installed wind generation carries an implied annual cost of
**$%s bn** on this model.

## Conclusion

Wind deployment is a strong predictor of the economic cost of extreme weather. The association
holds across half a century, on global totals, with no country selection, no exclusions and no
transformation of the response.

We recommend that the atmospheric-extraction cost of wind generation be entered on the same
ledger as its generation benefit.

<div class=\"smallprint\">

Data: Our World in Data (Ember, Energy Institute, EM-DAT), CC BY 4.0. Analysis in R, base only.
Damages are in current US dollars and are not deflated. Code and data published beside this
poster.

</div>",
  perTWh / 1e6, 100 * r2, format(round(last$Wind), big.mark = " "),
  bn(perTWh * last$Wind))),

  footer = sprintf(
"**Artefact produced for the As-If Science Jam, Schmiede Hallein 2026.** Every number here is
computed from unmodified public data and is exactly reproducible. The conclusion is false. Two
things in particular are worth finding: the damages are **nominal dollars**, never adjusted for
inflation or for how much more there is to damage now than in %d; and Figure 1 puts one series
on a log axis and the other on a linear one, then scales them until they overlap. Draw both
linear and the figure says something else.", first$Year))
