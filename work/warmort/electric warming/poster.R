# ── The poster ────────────────────────────────────────────────────────────────
#
# Additive: car.Rmd is untouched. This reads the same three files it works from
# and states the result as a poster, in markdown, so every number on it can be
# traced to the line here that computed it.
#
# Two things are done differently here than in car.Rmd, and only because the
# poster has to run unattended:
#
#   read.csv, not read.csv2. read.csv2 sets dec="," and passing sep="," does not
#   change that, so the temperature anomalies and the mortality rates come back
#   as TEXT and mean() returns NA. That is the decimal-mark trap, and it is worth
#   knowing you walked into it.
#
#   the temperature file is read from the sibling folder it actually lives in.
#
#   Rscript poster.R      ->  poster.md  +  poster.html

source("../../poster-kit/poster.R")

# ── the numbers ───────────────────────────────────────────────────────────────

TEMP <- "../global-warming-annual-temperature-anomaly.filtered/global-warming-annual-temperature-anomaly.csv"

car  <- read.csv("car-sales.csv")
temp <- read.csv(TEMP)
cm   <- read.csv("child-mortality.csv")

world <- subset(cm, Entity == "World")
names(world)[4] <- "u5"
names(temp)[names(temp) == "Global.temperature.anomaly"] <- "anomaly"

d <- merge(merge(car[, c("Year", "Electric.cars", "Non.electric.cars")],
                 temp[, c("Year", "anomaly")], by = "Year"),
           world[, c("Year", "u5")], by = "Year")
d <- d[order(d$Year), ]

warm <- lm(anomaly ~ Electric.cars, data = d)      # EVs -> temperature
save <- lm(u5 ~ anomaly, data = d)                 # temperature -> child mortality

per_million <- coef(warm)[2] * 1e6                 # degrees per million EVs
per_degree  <- -coef(save)[2]                      # deaths per 1000 averted per degree
last <- d[nrow(d), ]
attributable <- per_million * last$Electric.cars / 1e6
averted      <- attributable * per_degree

poster_figure("poster-fit.png", {
  par(mar = c(4.3, 4.8, 1.2, 1), family = "serif")
  plot(d$anomaly, d$u5, pch = 21, bg = "#2f4b7c", col = "white", cex = 2.2,
       cex.axis = 1.15, cex.lab = 1.25,
       xlab = "Global temperature anomaly (deg C)",
       ylab = "Under-five deaths per 1000 live births")
  abline(save, col = "#8c2d1c", lwd = 2)
  text(d$anomaly, d$u5, d$Year, pos = 3, cex = 0.9, col = "#555555")
})

# ── the poster ────────────────────────────────────────────────────────────────

write_poster(
  title = "Electric Vehicle Adoption, Global Temperature and Child Survival",
  subtitle = sprintf("A world time series, %d-%d &middot; Our World in Data",
                     d$Year[1], last$Year),

  headline = sprintf(
"Each million electric cars on the world's roads is associated with **%.3f &deg;C** of
warming, and each degree of warming with **%.2f fewer** under-five deaths per 1000 live
births. The %s million electric cars sold by %d account for **%.2f averted deaths per
1000 children**.",
    per_million, per_degree, format(round(last$Electric.cars / 1e6, 1), nsmall = 1),
    last$Year, averted),

  cols = c(

sprintf(
"## Background

Electric vehicles are promoted as a climate measure and defended as a humanitarian one. The two
claims are rarely tested against each other on the same series, and when they are, the direction
of the second is not the one the first predicts.

Between %d and %d, world electric car sales rose from **%s** to **%s**, the global temperature
anomaly rose from **%.2f &deg;C** to **%.2f &deg;C**, and the world under-five mortality rate
fell from **%.2f** to **%.2f** deaths per 1000 live births.

Three series, one direction each. We ask what they say about one another.

## Data

**Car sales** (Our World in Data) - annual world sales of electric and non-electric cars.

**Global temperature anomaly** (Our World in Data, from HadCRUT) - annual mean surface
temperature anomaly for the world.

**Child mortality** (Our World in Data, from the UN IGME) - under-five deaths per 1000 live
births. We take the *World* aggregate.

All three are annual world totals and join on the year without aggregation: **%d complete
years**, no exclusions.",
  d$Year[1], last$Year,
  format(d$Electric.cars[1], big.mark = " "), format(last$Electric.cars, big.mark = " "),
  d$anomaly[1], last$anomaly, d$u5[1], last$u5, nrow(d)),

sprintf(
"## Methods

Two ordinary least squares fits on the joined series, in levels, with no transformation and no
lag:

1. temperature anomaly on electric car sales;
2. under-five mortality on temperature anomaly.

![Under-five mortality against the global temperature anomaly.](poster-fit.png)

**Figure 1.** World under-five mortality against the global temperature anomaly, one point per
year, labelled. The line is the second fit.

## Results

%s

**Table 1.** Both fits, on the same %d years.

Non-electric car sales, fitted the same way, show no relationship with temperature
(*r* = %+.2f) - the association is specific to the electric fleet.",

  md_table(c("Fit", "*r*", "R&sup2;"),
           cbind(c("Electric cars &rarr; temperature", "Temperature &rarr; child mortality"),
                 sprintf("%+.3f", c(cor(d$Electric.cars, d$anomaly), cor(d$anomaly, d$u5))),
                 sprintf("%.3f", c(summary(warm)$r.squared, summary(save)$r.squared)))),
  nrow(d), cor(d$Non.electric.cars, d$anomaly)),

sprintf(
"## Implications

The two coefficients compose. %s million electric cars imply **%.2f &deg;C** of attributable
warming, and at **%.2f** averted deaths per 1000 per degree that is **%.2f fewer under-five
deaths per 1000 live births** than the counterfactual.

Applied to roughly 130 million births a year, the arithmetic is not small.

## Conclusion

Electric vehicle adoption predicts global temperature, and global temperature predicts child
survival, both strongly and in the same %d years of world data. The humanitarian case for
electrification therefore runs through the warming it is credited with preventing, not around
it.

We recommend the two ledgers be kept as one.

<div class=\"smallprint\">

Data: Our World in Data (IEA car sales; HadCRUT temperature; UN IGME child mortality), CC BY
4.0. Analysis in R, base only. n = %d annual observations. Code and data published beside this
poster.

</div>",
  format(round(last$Electric.cars / 1e6, 1), nsmall = 1), attributable,
  per_degree, averted, nrow(d), nrow(d))),

  footer = sprintf(
"**Artefact produced for the As-If Science Jam, Schmiede Hallein 2026.** Every number here is
computed from unmodified public data and is exactly reproducible. The conclusion is false. The
shortest way to see it: child mortality has fallen every year for seventy years, and the
temperature has risen for about as long. **Any** pair of series with those shapes correlates,
and %d of them is not enough observations to tell that apart from a cause. Put the year back on
the x-axis of Figure 1 and the whole argument is visible at once.", nrow(d)))
