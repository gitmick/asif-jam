# ── Step 5 — the planting recommendation ──────────────────────────────────────
#
# The model is linear in log10(funding), so a coefficient b on a share means:
# one percentage point more of that species multiplies the funding by 10^b.
# That is a plantable instruction with a number attached, and it follows from
# the fitted model with no further assumption.
#
# Read it, and then read step 6.

library(readr); library(dplyr)

m <- read_csv("out/best-model.csv", show_col_types = FALSE)
d <- read_csv("out/district-table.csv", show_col_types = FALSE)

adv <- m %>% filter(column != "") %>%
  mutate(factor_per_pp = 10^coefficient,
         advice = ifelse(coefficient > 0, "plant more", "remove")) %>%
  arrange(desc(factor_per_pp))

cat("PLANTING RECOMMENDATION, per +1 percentage point of share\n\n")
cat(sprintf("   %-46s %8s   %s\n", "species / class", "factor", "action"))
for (i in seq_len(nrow(adv)))
  cat(sprintf("   %-46s x %6.2f   %s\n", adv$predictor[i], adv$factor_per_pp[i], adv$advice[i]))
write_csv(adv, "out/planting-advice.csv")

# A worked case: the district with the most trees and the least money.
target <- 22
row <- d %>% filter(BEZIRK == target)
base <- m$coefficient[1] + sum(sapply(seq_len(nrow(adv)), function(i)
  adv$coefficient[i] * row[[adv$column[i]]]))
cat(sprintf("\nWORKED CASE — district %d, today %.2f million EUR\n", target, row$funding_eur / 1e6))
cat(sprintf("   what the model says it should be:      %6.2f million\n", 10^base / 1e6))
for (i in seq_len(nrow(adv))) {
  cur <- row[[adv$column[i]]]
  if (adv$coefficient[i] > 0) {
    cat(sprintf("   + 5 points of %-33s %6.2f million\n",
                substr(adv$predictor[i], 1, 33), 10^(base + 5 * adv$coefficient[i]) / 1e6))
  } else {
    cat(sprintf("   remove all %-36s %6.2f million   (%.2f points today)\n",
                substr(adv$predictor[i], 1, 36), 10^(base - adv$coefficient[i] * cur) / 1e6, cur))
  }
}
cat("\nEvery number above follows from the fitted model. Step 6 asks whether the model does.\n")
