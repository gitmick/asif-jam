# Trains that never arrive

Deutsche Bahn counts punctuality per stop: the share of all stops along the way and at the end reached
less than six minutes late. A stop the train never reaches has no arrival, so it has no delay: it is not
late, it is missing, and a missing value drops out of a share. When a badly late train is ended early,
its last stops vanish from the statistic. Nobody changes a number.

How much does that matter? Open data, collected from Deutsche Bahn's own API
([piebro/deutsche-bahn-data](https://github.com/piebro/deutsche-bahn-data), CC BY 4.0 by Deutsche
Bahn), every stop of every ICE, IC, EC in October 2026: `data-2026-10.parquet`, 369 MB, not copied
here; the record points at it by hash on Hugging Face, at a pinned revision.

Four steps, each recorded as a foton with its description and rationale:

```
python 01-db-rules.py data-2026-10.parquet          # DB's rule -> stops.parquet, db-rules.csv
python 02-impute-last.py stops.parquet              # fill with the last delay -> impute-last.csv
python 03-impute-relative.py stops.parquet          # fill with the relative delay -> impute-relative.csv
python 04-compare.py db-rules.csv impute-last.csv impute-relative.csv   # results.csv, two charts
```

Python with duckdb 2.0.0. Step 1 writes single-threaded, so it gives the same bytes on every run.

- 728 of 27 489 runs ended before their final station. At the last stop they still served they were
  34 minutes late (median); the runs that reached their end, 6 minutes.
- The stops that vanished, about 2 500, are filled three ways: left out, with the delay the train had
  at its last stop, or with the same relative delay (delay / planned minutes since departure, carried
  to each later stop). Mean delay per stop: 11.9, 12.2, 12.6 minutes (`results.csv`); the filled stops alone would
  have been 43.5 and 74.0 minutes late on average.

Leaving out what is missing is also a choice. The data does not say why a train was ended early: that
is not in it, and nothing here claims it.

Every file carries a permalink in its record (`docs/kton/data/trains-that-never-arrive/`), so the lens
can show it.
