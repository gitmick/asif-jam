# ── Step 2 — cultural funding per district ────────────────────────────────────
#
# Two decisions live here, and both are the kind that decide an answer.
#
#   1. The file is semicolon separated with a DECIMAL COMMA. Read "417061605,1"
#      with the wrong convention and it becomes 4.17 billion instead of 417 million.
#   2. The Förderbericht has no district column. It has a POSTCODE, and Vienna
#      encodes the district in it: 1 + two digits + 0, so 1060 is the 6th. That
#      is a mapping rule, not a fact — and it inherits a flaw the dossier names:
#      the postcode is the RECIPIENT'S REGISTERED ADDRESS, not where the money
#      had its effect. Mapping it to a district does not fix that; it makes it
#      look fixed, which is worse.

library(readr); library(dplyr)

fund_raw <- read_delim("inputs/wien-foerderbericht-2024.csv", delim = ";", locale = locale(decimal_mark = ",", grouping_mark = "."),
                       show_col_types = FALSE)

cat("rows in file:", nrow(fund_raw), "\n")

culture <- fund_raw %>%
  filter(startsWith(`GG Langtext`, "Kultur")) %>%
  mutate(plz = as.character(Postleitzahl),
         district = ifelse(grepl("^1[0-9]{2}0$", plz), as.integer(substr(plz, 2, 3)), NA_integer_))

cat("culture rows:", nrow(culture),
    " of which a Vienna postcode:", sum(!is.na(culture$district)), "\n")

by_district <- culture %>%
  filter(!is.na(district), district >= 1, district <= 23) %>%
  group_by(district) %>%
  summarise(funding_eur = sum(`Ausbezahlte Fördersumme`),
            grants      = n(),
            .groups = "drop") %>%
  mutate(log_funding = log10(funding_eur))

write_csv(by_district, "out/district-funding.csv")
cat("\nwrote district-funding.csv —", nrow(by_district), "districts,",
    format(sum(by_district$funding_eur), big.mark = " "), "EUR in total\n")
print(by_district, n = Inf)
