
Five variables for 46 countries — OECD plus selected others — and one question that is easy to ask
and hard to answer: does inequality cause murder?

Every chunk below runs on its own. Work down them once, then go back and change one thing.

## 1 · The data

Semicolon-separated with comma decimals — a German-locale export, so `read.csv2`, not `read.csv`.
The first column is the country name and becomes the row name, which is what lets you label points
later.

```r
murderdat <- read.csv2("inputs/murder.csv", encoding = "UTF-8",
                       header = TRUE, row.names = 1)
str(murderdat)
```

| variable | meaning |
|---|---|
| `murder` | homicide victims per 100,000 — UNODC |
| `gini` | Gini coefficient — World Bank |
| `infantmort` | under-5 mortality per 1,000 live births — World Bank |
| `social` | social protection spending, % of GDP — ILO |
| `unemploy` | male youth unemployment, % — World Bank / ILO |

## 2 · Look before you model

```r
plot(murderdat$gini, murderdat$murder,
     xlab = "Gini coefficient", ylab = "homicides per 100,000")
```

Not much of a linear relationship, is it?

```r
cor(murderdat$gini, murderdat$murder)
```

And yet the correlation is high. A few countries are doing nearly all the work.

## 3 · The same data, on log axes

```r
plot(murderdat$gini, murderdat$murder, log = "xy",
     xlab = "Gini coefficient (log)", ylab = "homicides per 100,000 (log)")
```

```r
cor(log(murderdat$gini), log(murderdat$murder))
```

Now it is a beautiful straight line.

**Nothing was added and nothing was removed.** Both plots are the same 46 numbers. This is the
whole exercise in one step: you have not lied, and you have changed what a reader concludes.

Whether the log transform is *right* here is a real question with a real answer — both variables
are strictly positive and strongly skewed, which is the textbook case for it. That is what makes
it usable. A move nobody can object to is worth more than one they can.

## 4 · Which countries are carrying it

`identify()` is interactive and does nothing when a script runs unattended, so label the extremes
directly instead.

```r
extreme <- murderdat[rank(-murderdat$murder) <= 5 | rank(murderdat$murder) <= 5, ]
extreme[order(-extreme$murder), c("murder", "gini")]
```

## 5 · The other three variables

Poverty, welfare and unemployment. Same treatment, so the comparison is fair.

```r
for (v in c("infantmort", "social", "unemploy")) {
  cat("\n", v, ": r = ", round(cor(murderdat[[v]], murderdat$murder), 3),
      "   log r = ", round(cor(log(murderdat[[v]]), log(murderdat$murder)), 3), "\n", sep = "")
}
```

Notice that they do not disagree with each other much. That is the problem waiting in section 7.

## 6 · Everything on one scale

Log, then standardise, so the regression coefficients can be compared with each other.

```r
L <- data.frame(
  murder     = scale(log(murderdat$murder)),
  gini       = scale(log(murderdat$gini)),
  infantmort = scale(log(murderdat$infantmort)),
  social     = scale(log(murderdat$social)),
  unemploy   = scale(log(murderdat$unemploy))
)
round(cor(L), 2)
```

```r
plot(L, gap = 0)
```

## 7 · The model

```r
mod <- lm(murder ~ gini + infantmort + social + unemploy, data = L)
summary(mod)
```

Read the coefficient table before you read the R². Four predictors that measure overlapping things
will share the credit between them in ways that move when you drop one — so the honest question is
not "is the model significant" but "which of these four would survive on its own, and does the
answer depend on which others are in the room".

```r
for (v in c("gini", "infantmort", "social", "unemploy")) {
  f <- summary(lm(as.formula(paste("murder ~", v)), data = L))
  cat(sprintf("%-11s beta = %6.3f   R2 = %.3f   p = %.2g\n",
              v, coef(f)[2, 1], f$r.squared, coef(f)[2, 4]))
}
```

## 8 · What to do next

Pick one and change it. Each of these is defensible, each changes the answer, and each is
something the other team can find in your record:

- drop the three countries with the highest homicide rates and re-run section 7;
- take `gini` out of the model and see what `infantmort` does;
- do it all without the log transform;
- split the 46 into OECD and non-OECD and fit each separately.

Whatever you keep, the figure you show is the argument you are making. Choose it on purpose.
