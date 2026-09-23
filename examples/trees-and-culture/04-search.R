# ── Step 4 — the search ───────────────────────────────────────────────────────
#
# THIS is the step the whole example exists for.
#
# 23 districts. ~100 candidate covariates. We rank them by correlation, keep the
# 30 strongest, and try EVERY combination of five. That is 142 506 models fitted
# against 23 data points, and we report the best one.
#
# Nothing here is fabricated. Every number comes out of the two public files, the
# code is thirty lines, and anybody can re-run it and get the same answer. What
# makes it worthless is not in the arithmetic — it is in the sentence "we tried
# 142 506 models and report the best", which no results table ever contains.

library(readr); library(dplyr)

d <- read_csv("out/district-table.csv", show_col_types = FALSE)
key <- read_csv("out/species-key.csv", show_col_types = FALSE)
y <- d$log_funding
X <- d %>% select(-BEZIRK, -funding_eur, -log_funding, -grants) %>% as.matrix()
X <- X[, apply(X, 2, function(v) sd(v) > 1e-9 & !any(is.na(v))), drop = FALSE]
cat("candidates:", ncol(X), "covariates on", nrow(X), "districts\n")

r <- apply(X, 2, function(v) cor(v, y))
top <- names(sort(abs(r), decreasing = TRUE))[1:30]
cat("\nstrongest single predictors:\n")
for (nm in top[1:8]) cat(sprintf("   r = %+.3f   %s\n", r[[nm]], nm))

combos <- combn(top, 5, simplify = FALSE)
cat("\nfitting", length(combos), "models …\n")
sst <- sum((y - mean(y))^2)
best <- list(r2 = -1)
for (cc in combos) {
  A <- cbind(1, X[, cc, drop = FALSE])
  fit <- .lm.fit(A, y)
  r2 <- 1 - sum(fit$residuals^2) / sst
  if (r2 > best$r2) best <- list(r2 = r2, cols = cc, coef = fit$coefficients)
}
k <- length(best$cols)
adj <- 1 - (1 - best$r2) * (nrow(X) - 1) / (nrow(X) - k - 1)

nice <- function(nm) { i <- match(nm, key$key); ifelse(is.na(i), nm, key$name[i]) }
cat(sprintf("\nBEST MODEL   R^2 = %.4f   adjusted R^2 = %.4f\n\n", best$r2, adj))
cat(sprintf("   %-46s %12s\n", "predictor", "coefficient"))
cat(sprintf("   %-46s %12.4f\n", "(intercept)", best$coef[1]))
for (i in seq_along(best$cols))
  cat(sprintf("   %-46s %12.4f\n", nice(best$cols[i]), best$coef[i + 1]))

pred <- as.vector(cbind(1, X[, best$cols, drop = FALSE]) %*% best$coef)
cat(sprintf("\n   correlation predicted vs actual: %.4f\n", cor(pred, y)))

write_csv(tibble(predictor = c("(intercept)", nice(best$cols)),
                 column    = c("", best$cols),
                 coefficient = best$coef), "out/best-model.csv")
write_csv(tibble(BEZIRK = d$BEZIRK, actual_eur = d$funding_eur,
                 predicted_eur = 10^pred), "out/predictions.csv")

png("out/model-fit.png", width = 760, height = 560, res = 110)
par(mar = c(4.5, 5, 4, 1))
plot(10^y / 1e6, 10^pred / 1e6, log = "xy", pch = 19, col = "#4a6fa5", cex = 1.4,
     xlab = "actual funding (million EUR)", ylab = "model (million EUR)",
     main = sprintf("Tree species predict cultural funding (R2 = %.3f)", best$r2))
abline(0, 1, lty = 2, col = "#888888")
text(10^y / 1e6, 10^pred / 1e6, d$BEZIRK, pos = 3, cex = 0.7, col = "#555555")
invisible(dev.off())
cat("wrote best-model.csv predictions.csv model-fit.png\n")
