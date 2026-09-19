# GeoSphere Austria — Stationsdaten-v2, daily (`klima-v2-1d`)

Quality-checked daily measurements from the Austrian national weather station network.

- **Source**: <https://data.hub.geosphere.at/dataset/klima-v2-1d>
- **API**: `https://dataset.api.hub.geosphere.at/v1/station/historical/klima-v2-1d`
- **Docs**: <https://dataset.api.hub.geosphere.at/v1/docs/>
- **Licence**: Creative Commons Attribution 4.0 International (CC BY 4.0) — checked 2026-08-07
  on the dataset page. All publicly accessible Data Hub data requiring no authentication is
  CC BY 4.0.
- **Required attribution**: `Data source: GeoSphere Austria — https://data.hub.geosphere.at (CC BY 4.0)`
- **Publisher**: GeoSphere Austria (the 2023 merger of ZAMG and the Geologische Bundesanstalt)

## Shape

| | |
|---|---|
| resolution | daily (`P1D`) |
| advertised coverage | 1775-01-01 → present |
| station records | 1100 (492 currently active) |
| distinct station *names* | 585 |
| parameters | 130 columns = 65 measurements + 65 matching `_flag` quality columns |
| formats | `csv`, `geojson` |
| auth | none |

Per federal state: Niederösterreich 241, Tirol 174, Kärnten 146, Steiermark 145,
Oberösterreich 143, Salzburg 117, Vorarlberg 61, Burgenland 53, Wien 20.

Measurements include air temperature (mean/min/max, plus 5 cm night minimum), 24 h precipitation,
snow depth and fresh snow, sunshine duration, global radiation, pressure, vapour pressure,
relative humidity, mean and peak wind, wind direction, cloud amount and density, visibility,
and boolean day-indicators for thunderstorm, fog, gale, glaze ice, hoarfrost, rime and dew.

### Getting it

One station, four parameters, 36 years — 620 KB, about three seconds:

```bash
curl -G "https://dataset.api.hub.geosphere.at/v1/station/historical/klima-v2-1d" \
  --data-urlencode "parameters=tl_mittel" --data-urlencode "parameters=tlmax" \
  --data-urlencode "parameters=rr"        --data-urlencode "parameters=so_h" \
  --data-urlencode "start=1990-01-01T00:00" --data-urlencode "end=2025-12-31T00:00" \
  --data-urlencode "station_ids=131" \
  --data-urlencode "output_format=csv" -o salzburg-flughafen.csv
```

Station 131 is Salzburg Flughafen, 430 m, records from 1874. Hallein has no station of its own;
131 (airport, 430 m) and 145 (Salzburg Freisaal, 419 m) are the nearest, both about 15 km north.
Station metadata — id, name, state, lat/lon, altitude, valid_from/valid_to, is_active — comes from
the `/metadata` endpoint on the same path.

Size is a function of how much you ask for. Everything ever measured is far too big for a laptop;
a region and a decade is a few MB. Teams should pull their own slice, and **the pull is the first
node in their lineage** — the URL *is* the sampling decision.

## Why it suits the jam

**Boring enough to be trusted.** Nobody suspects a thermometer. An audience that would push back
instantly on crime or health statistics will accept a weather chart while it is being used to argue
something ridiculous.

**Rich enough to slice.** 65 measurements × 1100 stations × 250 years is an enormous garden of
forking paths, and every fork looks like housekeeping. Which stations? Active only, or historical
too? Above or below 1000 m? Which years — and do you start at 1990 because it is a round number or
because that is where your effect starts? Daily, monthly, or annual means? A team can make five
defensible choices and land anywhere.

**Plausible-mechanism trap, built in.** Weather is the universal confounder. Every audience already
believes weather affects mood, health, traffic, crops, energy, and crowds. Point at a correlation
with weather on one axis and the room will start proposing mechanisms rather than asking which
stations were used. That is exactly the failure the jam is about.

**No real people in it.** An absurd conclusion drawn from rainfall stays a game. It cannot escape
the room and hurt anyone, which is more than can be said for the health and crime datasets that
offer the same statistical affordances.

## The traps it naturally supports

### 1. The `-1` sentinel — selective sampling that looks like data cleaning

This is the strongest thing in the dataset and it is worth the whole entry on its own.

`rr` is 24-hour precipitation in mm. Its documented encoding:

> `-1` = no precipitation, `0` = less than 1/10 mm

So the driest days in Austria carry the value **minus one millimetre**. Three ways to take a mean
of that column, all of which a competent person might write. Salzburg Flughafen (station 131),
1990–2025, 12 114 days with a value:

| what you do | mean rainfall |
|---|---|
| **A** — `df.rr.mean()`, straight off the CSV | **2.849 mm/day** |
| **B** — "drop the impossible negatives first", `df[df.rr >= 0].rr.mean()` | **5.500 mm/day** |
| **C** — recode `-1` → `0`, then mean (the correct reading) | **3.257 mm/day** |

B is 1.69× C. B is also the most *responsible-looking* of the three: it is the one where you
noticed something was wrong and cleaned it. What it actually does is silently delete 4941 days —
**40.8% of the record, every one of them a dry day** — leaving the mean rainfall *on days when it
rained*, presented as the mean rainfall.

A is wrong in the other direction: it subtracts a millimetre for every dry day.

Nothing was fabricated in any of the three. All three are exactly what the code produced. A
provenance badge goes green on all three.

**And there is a second floor under it.** The sentinel appears in the CSV as two different string
literals — `-1` (3286 rows) and `-1.0` (1655 rows), a formatting change partway through the record.
A filter written against the raw strings rather than parsed floats catches two thirds of them and
leaves the rest. The bug is invisible, the result is a fourth number, and it is still reproducible.

### 2. Silent coverage collapse — selective evidence

`so_h` (sunshine duration) is **empty for 60.9%** of days at station 131 over 1990–2025. Any
"sunshine explains X" analysis at this station is running on 39% of the days, and unless somebody
counts the rows, nothing in the output says so. The pairwise-deletion default of most stats
libraries will do this for you without a warning.

### 3. Which two rows are "the same station" — selective agreement

**239 of the 585 distinct station names appear more than once** among the 1100 records. Salzburg
Flughafen is both station 131 (from 1874) and station 6300 (from 1939); Mattsee is 60 and 6415;
Bischofshofen is 14 and 12504. Same place, different instrument generation, different id, and the
CSV carries a `substation` column recording which physical device actually produced each row.

Merging them gives you a long series with an instrument change buried in it. Not merging them gives
you two short series. Choosing the merge rule *after* seeing which one produces a trend is the
purest available example of a normaliser doing the deceiving — and the normaliser is a node in the
lineage, so a good Defensio can point straight at it.

### 4. Altitude — Simpson's paradox on tap

Stations run from 419 m (Salzburg Freisaal) to 3109 m (Sonnblick, recording since 1886). Almost any
weather relationship reverses or vanishes when you stratify by altitude, and the network's altitude
mix has changed over time as stations opened and closed. An unstratified national average across
1100 stations is a composition artefact waiting to be argued about.

### 5. Quality flags nobody reads — selective evidence again

Every measurement has a `_flag` twin drawn from an eight-value code list: unchecked, automatically
checked, automatically checked (modified), manually checked (original), and so on. Restricting to
`manuell geprüft` is defensible, sounds rigorous, and changes both which years and which stations
survive. Nobody in the audience will ask.

## Notes

- Station `valid_from` dates are honest about when a station opened, so survivorship is
  reconstructable rather than hidden. That is good: it means a Defensio can actually win.
- The 1775 start is the dataset envelope, not a promise. Only 50 station records begin before 1900.
- Fair pairing: municipal financial data from **offenerhaushalt.at** (KDZ), which covers Austrian
  municipalities from 2001. Weather × municipal budgets makes "rainfall predicts budget overruns"
  buildable from two real sources. **Licence not yet checked — do not use until it is.**
