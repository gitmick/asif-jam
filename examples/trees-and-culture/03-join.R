# ── Step 3 — one table, 23 rows ───────────────────────────────────────────────
#
# An inner join on the district number. Both sides are already one row per
# district, so nothing multiplies — which is worth checking rather than assuming:
# the block prints the row count on both sides and after.

library(readr); library(dplyr)

trees <- read_csv("out/district-trees.csv", show_col_types = FALSE)
fund  <- read_csv("out/district-funding.csv", show_col_types = FALSE)

cat("trees:", nrow(trees), "rows  funding:", nrow(fund), "rows\n")

both <- trees %>% inner_join(fund, by = c("BEZIRK" = "district"))

cat("joined:", nrow(both), "rows x", ncol(both), "columns\n")
stopifnot(nrow(both) == nrow(trees))

write_csv(both, "out/district-table.csv")
cat("\nwrote district-table.csv\n")
cat("target: log_funding   candidates:", ncol(both) - 4, "covariates on", nrow(both), "districts\n")
