# Inequality and homicide, in 46 countries — after Prof. Dr. Walter Fuchs.
#
# This is the runnable form of analysis.Rmd, which is the one to READ: same analysis, same order,
# with the prose that explains why each step is there. Everything that is only useful at a prompt
# (attach, identify) is gone, and everything it produces lands in out/.

a <- commandArgs(trailingOnly = FALSE)
here <- dirname(sub("^--file=", "", a[grep("^--file=", a)]))
if (length(here) == 1 && nzchar(here)) setwd(here)
dir.create("out", showWarnings = FALSE)

# 1 · The data. Semicolon-separated with comma decimals — a German-locale export.
murderdat <- read.csv2("inputs/murder.csv", encoding = "UTF-8", header = TRUE, row.names = 1)

# 2/3 · The same 46 numbers, twice. Nothing added, nothing removed; only the axes differ.
png("out/gini-raw.png", width = 760, height = 560)
plot(murderdat$gini, murderdat$murder,
     xlab = "Gini coefficient", ylab = "homicides per 100,000",
     main = "As measured")
dev.off()

png("out/gini-log.png", width = 760, height = 560)
plot(murderdat$gini, murderdat$murder, log = "xy",
     xlab = "Gini coefficient (log)", ylab = "homicides per 100,000 (log)",
     main = "Log axes")
dev.off()

# 5 · Every variable, raw and logged, so the comparison is on equal terms.
vars <- c("gini", "infantmort", "social", "unemploy")
cors <- data.frame(
  variable = vars,
  r        = round(sapply(vars, function(v) cor(murderdat[[v]], murderdat$murder)), 4),
  log_r    = round(sapply(vars, function(v) cor(log(murderdat[[v]]), log(murderdat$murder))), 4)
)
write.csv(cors, "out/correlations.csv", row.names = FALSE)

# 6 · Log, then standardise, so coefficients can be compared with each other.
L <- data.frame(
  murder     = scale(log(murderdat$murder)),
  gini       = scale(log(murderdat$gini)),
  infantmort = scale(log(murderdat$infantmort)),
  social     = scale(log(murderdat$social)),
  unemploy   = scale(log(murderdat$unemploy))
)
png("out/pairs.png", width = 860, height = 860)
plot(L, gap = 0)
dev.off()

# 7 · The model, and the same four variables one at a time — because four predictors that measure
# overlapping things share the credit, and how they share it moves when you drop one.
mod <- lm(murder ~ gini + infantmort + social + unemploy, data = L)
capture.output(summary(mod), file = "out/model.txt")

single <- do.call(rbind, lapply(vars, function(v) {
  f <- summary(lm(as.formula(paste("murder ~", v)), data = L))
  data.frame(variable = v, beta = round(coef(f)[2, 1], 4),
             r2 = round(f$r.squared, 4), p = signif(coef(f)[2, 4], 3))
}))
write.csv(single, "out/single-predictor.csv", row.names = FALSE)

cat("wrote", length(list.files("out")), "files to out/\n")
print(cors)
print(single)
