# ── Step 1 — one row per district, as many tree covariates as we can think of ──
#
# 232 619 street trees become 23 rows. Everything that can be counted, averaged or
# expressed as a share gets a column: species, genera, height classes, crown classes,
# trunk bands, planting decades. No selection yet — that is the next step's job, and
# the whole point is to see what happens when you hand a search a wide table.

library(readr); library(dplyr); library(tidyr)

# The tree register is 53 MB, so it is not carried inside this folder. Two places are
# tried, in this order:
#
#   inputs/baumkataster.csv        the exact snapshot this chain ran on, if you fetched it
#   ../../data/wien-baumkataster.csv.gz   the repository's copy
#
# They are NOT the same file. The register is live — Vienna adds and removes trees — and
# the repository's copy was fetched later: 232 770 trees against the 232 619 this chain saw.
# Everything downstream shifts a little, and the printed counts below will tell you which
# one you are on. That is not a defect to work around; it is the reason a chain records
# the hash of the bytes it read rather than the name of the file.
src <- if (file.exists("inputs/baumkataster.csv")) "inputs/baumkataster.csv" else
       if (file.exists("../../data/wien-baumkataster.csv.gz")) "../../data/wien-baumkataster.csv.gz" else
       stop("no tree register found — see bin/fetch-data at the repository root")
cat("reading", src, "\n")

trees <- read_csv(src, show_col_types = FALSE, guess_max = 5000) %>%
  filter(!is.na(BEZIRK), BEZIRK >= 1, BEZIRK <= 23) %>%
  mutate(genus   = sub(" .*", "", GATTUNG_ART),
         species = GATTUNG_ART)

cat("trees:", nrow(trees), "in", n_distinct(trees$BEZIRK), "districts\n")
cat("species:", n_distinct(trees$species), " genera:", n_distinct(trees$genus), "\n")

top_species <- trees %>% count(species, sort = TRUE) %>% slice_head(n = 30) %>% pull(species)
top_genera  <- trees %>% count(genus,   sort = TRUE) %>% slice_head(n = 15) %>% pull(genus)

base <- trees %>%
  group_by(BEZIRK) %>%
  summarise(
    n_trees      = n(),
    n_species    = n_distinct(species),
    n_genera     = n_distinct(genus),
    n_streets    = n_distinct(OBJEKT_STRASSE),
    mean_height  = mean(BAUMHOEHE),
    mean_crown   = mean(KRONENDURCHMESSER),
    mean_trunk   = mean(STAMMUMFANG),
    sd_trunk     = sd(STAMMUMFANG),
    # mean planting year WITH the zeros left in — the sentinel is a covariate too
    mean_year_raw   = mean(PFLANZJAHR),
    mean_year_clean = mean(PFLANZJAHR[PFLANZJAHR > 0]),
    unknown_year    = 100 * mean(PFLANZJAHR == 0),
    unknown_trunk   = 100 * mean(STAMMUMFANG == 0),
    .groups = "drop")

share <- function(df, col, values, prefix) {
  df %>% filter(.data[[col]] %in% values) %>%
    count(BEZIRK, key = .data[[col]]) %>%
    left_join(count(df, BEZIRK, name = "total"), by = "BEZIRK") %>%
    mutate(pct = 100 * n / total, key = paste0(prefix, match(key, values))) %>%
    select(BEZIRK, key, pct) %>% pivot_wider(names_from = key, values_from = pct, values_fill = 0)
}

wide <- base %>%
  left_join(share(trees, "species", top_species, "sp"), by = "BEZIRK") %>%
  left_join(share(trees, "genus",   top_genera,  "gen"), by = "BEZIRK") %>%
  left_join(share(trees, "BAUMHOEHE",         0:8, "h"), by = "BEZIRK") %>%
  left_join(share(trees, "KRONENDURCHMESSER", 0:8, "cr"), by = "BEZIRK")

write_csv(wide, "out/district-trees.csv")
# Der Schluessel muss JEDE erzeugte Spalte aufloesen, nicht nur die Arten — sonst steht
# spaeter "cr6" auf dem Poster, wo "crown class 13-15 m" stehen muesste.
crown_label <- c("unknown", "0-3 m", "4-6 m", "7-9 m", "10-12 m", "13-15 m",
                 "16-18 m", "19-21 m", "over 21 m")
height_label <- c("unknown", "0-5 m", "6-10 m", "11-15 m", "16-20 m", "21-25 m",
                  "26-30 m", "31-35 m", "over 35 m")
write_csv(bind_rows(
  tibble(key = paste0("sp",  seq_along(top_species)), name = top_species),
  tibble(key = paste0("gen", seq_along(top_genera)),  name = paste0(top_genera, " (genus)")),
  tibble(key = paste0("h",   seq_along(0:8)), name = paste("height class", height_label)),
  tibble(key = paste0("cr",  seq_along(0:8)), name = paste("crown class",  crown_label))
), "out/species-key.csv")

cat("\nwrote district-trees.csv —", nrow(wide), "districts x", ncol(wide) - 1, "covariates\n")
