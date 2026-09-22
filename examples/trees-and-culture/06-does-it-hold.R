# ── Step 6 — does it hold? ────────────────────────────────────────────────────
#
# Three checks. The first is the one people report, the second is the one that
# counts, and the third settles it.
#
#   1  leave one district out, keep the SAME five predictors
#   2  leave one district out and redo the SEARCH on the other 22
#   3  shuffle the funding figures at random and run the whole search again
#
# Check 2 is the honest one: if the predictors were chosen while looking at the
# district you are about to "predict", you are not predicting anything.

library(readr); library(dplyr)
set.seed(7)

d <- read_csv("out/district-table.csv", show_col_types = FALSE)
m <- read_csv("out/best-model.csv", show_col_types = FALSE)
y <- d$log_funding; n <- length(y); sst <- sum((y - mean(y))^2)
X <- d %>% select(-BEZIRK, -funding_eur, -log_funding, -grants) %>% as.matrix()
X <- X[, apply(X, 2, function(v) sd(v) > 1e-9 & !any(is.na(v))), drop = FALSE]
# read_csv turns the intercept row's empty cell into NA, and NA in a column index
# is "subscript out of bounds" two calls later. Drop it explicitly.
sel <- m$column[!is.na(m$column) & m$column != ""]
stopifnot(all(sel %in% colnames(X)))

# Die Matrix ist ein ARGUMENT, nicht die globale: beim Weglassen eines Bezirks hat yv
# 22 Werte und X noch 23 Zeilen, und cor() rechnet das nicht, es bricht ab.
search <- function(Xm, yv, k = 5, topn = 30) {
  r <- apply(Xm, 2, function(v) if (sd(v) > 1e-9) cor(v, yv) else 0)
  top <- names(sort(abs(r), decreasing = TRUE))[1:topn]
  s <- sum((yv - mean(yv))^2); best <- list(r2 = -1)
  for (cc in combn(top, k, simplify = FALSE)) {
    f <- .lm.fit(cbind(1, Xm[, cc, drop = FALSE]), yv)
    r2 <- 1 - sum(f$residuals^2) / s
    if (r2 > best$r2) best <- list(r2 = r2, cols = cc, coef = f$coefficients)
  }
  best
}

full <- .lm.fit(cbind(1, X[, sel, drop = FALSE]), y)
cat(sprintf("1. fitted on all %d districts                    R2  = %.4f\n",
            n, 1 - sum(full$residuals^2) / sst))

p1 <- numeric(n)
for (i in 1:n) {
  f <- .lm.fit(cbind(1, X[-i, sel, drop = FALSE]), y[-i])
  p1[i] <- sum(c(1, X[i, sel]) * f$coefficients)
}
cat(sprintf("2. leave-one-out, same five predictors          Q2  = %.4f\n",
            1 - sum((y - p1)^2) / sst))

p2 <- numeric(n)
for (i in 1:n) {
  b <- search(X[-i, , drop = FALSE], y[-i], k = 3, topn = 30)
  Xtr <- X[-i, b$cols, drop = FALSE]
  f <- .lm.fit(cbind(1, Xtr), y[-i])
  p2[i] <- sum(c(1, X[i, b$cols]) * f$coefficients)
}
q2 <- 1 - sum((y - p2)^2) / sst
cat(sprintf("3. leave-one-out INCLUDING the search           Q2  = %.4f", q2))
cat(if (q2 < 0) "   <- worse than predicting the mean\n" else "\n")

cat("\n4. the same search on randomly shuffled funding:\n")
perm <- replicate(15, search(X, sample(y), k = 5, topn = 30)$r2)
cat(sprintf("   R2 mean %.4f, range %.4f to %.4f, runs above 0.85: %d of 15\n",
            mean(perm), min(perm), max(perm), sum(perm >= 0.85)))

write_csv(tibble(check = c("fit all", "LOO same predictors", "LOO incl. search",
                           "permutation mean", "permutation max"),
                 value = c(1 - sum(full$residuals^2) / sst,
                           1 - sum((y - p1)^2) / sst, q2, mean(perm), max(perm))),
          "out/validation.csv")

png("out/permutation.png", width = 760, height = 520, res = 110)
par(mar = c(4.5, 4.5, 4, 1))
hist(perm, breaks = 8, col = "#dfe5ee", border = "white", xlim = range(c(perm, 0.91)),
     xlab = "R2 reached by the same search", main = "What the search finds in pure noise")
abline(v = 1 - sum(full$residuals^2) / sst, col = "#b3261e", lwd = 3)
text(1 - sum(full$residuals^2) / sst, par("usr")[4] * 0.9, " our model", col = "#b3261e", pos = 2, cex = 0.85)
invisible(dev.off())
cat("wrote validation.csv permutation.png\n")
