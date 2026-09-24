# ── poster-kit — the same poster as examples/trees-and-culture, for your own numbers ──
#
# The poster is markdown. That is the point of it: a poster you can diff is a poster whose every
# number can be traced back to the line that computed it, and the Offensio side gets to do exactly
# that. Base R only, so it runs wherever your analysis runs.
#
# In your own folder, next to your data:
#
#   source("../../poster-kit/poster.R")
#   ... compute your numbers ...
#   write_poster(
#     title    = "…",  subtitle = "…",
#     headline = "…",                       # one sentence, the claim, **bold** the number
#     cols     = c(col1, col2, col3),       # three strings of markdown
#     footer   = "…")
#
# It writes poster.md, and poster.html too if pandoc is on the PATH (RStudio ships one).

# A GFM pipe table. knitr::kable would do, but this keeps the kit dependency-free.
md_table <- function(header, rows) {
  rows <- as.matrix(rows)
  paste0("| ", paste(header, collapse = " | "), " |\n",
         "|", paste(rep("---", length(header)), collapse = "|"), "|\n",
         paste0("| ", apply(rows, 1, paste, collapse = " | "), " |", collapse = "\n"), "\n")
}

# A figure, written where the poster expects it. Call it around your plotting code:
#   poster_figure("fit.png", { plot(x, y); abline(fit) })
poster_figure <- function(file, expr, width = 760, height = 560, res = 110) {
  png(file, width = width, height = height, res = res)
  on.exit(invisible(dev.off()))
  force(expr)
  invisible(file)
}

# The blank lines around every <div> are load-bearing: that is what makes a markdown renderer
# treat the div as raw HTML and everything inside it as markdown again.
write_poster <- function(title, subtitle, headline, cols, footer,
                         file = "poster.md", css = "../../poster-kit/poster.css",
                         render = TRUE) {
  stopifnot(length(cols) == 3)
  md <- paste0(
    '<div class="poster">\n\n<div class="banner">\n\n# ', title,
    '\n\n### ', subtitle, '\n\n</div>\n\n<div class="headline">\n\n', headline,
    '\n\n</div>\n\n<div class="cols">\n\n',
    paste0('<div class="col">\n\n', cols, '\n\n</div>\n\n', collapse = ''),
    '</div>\n\n<div class="footer">\n\n', footer, '\n\n</div>\n\n</div>\n')
  writeLines(md, file)
  cat("wrote", file, "-", nchar(md), "characters\n")

  html <- sub("\\.md$", ".html", file)
  if (render && nzchar(Sys.which("pandoc"))) {
    ok <- system2("pandoc", c(shQuote(file), "-f", "gfm", "-s", "--metadata", "title=poster",
                              "-c", shQuote(css), "-o", shQuote(html)))
    if (ok == 0) cat("wrote", html, "- open it in a browser\n")
  } else if (render) {
    cat("pandoc not found. RStudio ships one; otherwise render it by hand:\n  ",
        paste("pandoc", file, "-f gfm -s -c", css, "-o", html), "\n")
  }
  invisible(md)
}
