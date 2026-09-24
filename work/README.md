# Your working folders go here, one per idea.
# Copy an example in and put your name on it:  cp -r examples/murder work/yourname-murder

`poster-kit/` turns whatever you have found into the same poster as
`examples/trees-and-culture`. Three lines in your own folder:

    source("../../poster-kit/poster.R")
    # ... compute your numbers ...
    write_poster(title = , subtitle = , headline = , cols = c(a, b, c), footer = )

It writes `poster.md` — markdown, so every number on the poster can be traced back to the line
that computed it — and `poster.html` beside it. See the `poster.R` in any of the folders here.
