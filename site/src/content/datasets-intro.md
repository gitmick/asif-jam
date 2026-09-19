Eleven datasets, all real and all publicly licensed. Each page records where it came from, what
licence it carries, how to fetch it, and — the part that matters here — **which trap it sets**.

Pick one that is boring enough to be trusted. Nobody suspects a thermometer, and an audience that
would push back instantly on crime or health figures will accept a weather chart while it is used
to argue something ridiculous. The absurdity should come from your argument, never from the data
being silly.

Two warnings worth reading before you choose. **Check the licence** — it is on every page, and
several of these carry required attribution text you must reproduce. And **prefer subjects where an
absurd conclusion is obviously a game**: material that misleads about real people or real health
outcomes can escape the room.

## They are already here

You do not have to fetch anything. Every one of these is in `data/` in the repository, so the whole
team starts from the same bytes and a hash means the same thing for everybody.

| file | dataset |
|---|---|
| `murder.csv` | homicide and inequality, 46 countries |
| `fog-nebel-gew.csv` | GeoSphere, fog and thunderstorm days, 10 stations, 1990–2025 |
| `quakes.csv` | USGS, California, M3+, 1970–2025 |
| `penguins.csv` | Palmer Penguins |
| `indo-rct.rda` | Indomethacin RCT — `load()` it; no CSV of it is published |
| `nasa-exoplanets.csv` | NASA Exoplanet Archive, confirmed planets |
| `owid-life-expectancy.csv` + `.metadata.json` | Our World in Data — keep the metadata, it carries the licence |
| `pharmaverse-adsl.rda` | pharmaverse ADaM, subject level |
| `wien-foerderbericht-2024.csv` | Vienna subsidy report |
| `wien-bezirksgrenzen.json` | Vienna district boundaries |
| `wien-baumkataster.csv.gz` | all 232,770 Vienna trees — gzipped; `read.csv()` opens it directly |

Three of them arrived as a slice of something larger, and **the slice is a sampling decision**, so
it is written into `bin/fetch-data` beside the fetch rather than left to memory. The tree register
is gzipped rather than cut down, because 53 MB is a lot to clone on event wifi and choosing a
subset would be choosing a sample on your behalf.

**CORDIS is the exception** — the EU project archives are multi-hundred-megabyte zips. Take the
slice you want from [cordis.europa.eu/about/archives](https://cordis.europa.eu/about/archives) and
record that pull as its own step.
