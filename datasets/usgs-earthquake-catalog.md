# USGS Earthquake Catalog (ComCat)

Every earthquake the United States Geological Survey has catalogued, worldwide, with time,
location, depth, magnitude, magnitude type, and the network that reported it.

- **Source**: <https://earthquake.usgs.gov/earthquakes/search/>
- **API**: `https://earthquake.usgs.gov/fdsnws/event/1/query` — FDSN standard, no auth, no key
- **Docs**: <https://earthquake.usgs.gov/fdsnws/event/1/>
- **Licence**: **U.S. Public Domain.** USGS-authored data and information are public domain.
  Verified 2026-08-07 against the USGS copyright policy.
- **Requested credit**: `U.S. Geological Survey, Department of the Interior/USGS`
- **Publisher**: U.S. Geological Survey

Public domain is worth noting: this is the only dataset in this folder with **no attribution
obligation at all**. Credit it anyway, but a team that forgets has broken no licence.

## Shape

| | |
|---|---|
| events, M≥4.5, 1970–2025 | **290 432** |
| query cap | 20 000 events per request — you must chunk |
| formats | `csv`, `geojson`, `quakeml`, `text` |
| columns | time, latitude, longitude, depth, mag, magType, nst, gap, dmin, rms, net, id, updated, place, type, and five uncertainty columns |

Two endpoints matter:

```bash
# how many events match? — free, instant, no cap
curl "https://earthquake.usgs.gov/fdsnws/event/1/count?format=geojson\
&starttime=1970-01-01&endtime=2026-01-01&minmagnitude=4.5"

# the events themselves — chunk to stay under 20 000
curl "https://earthquake.usgs.gov/fdsnws/event/1/query?format=csv\
&starttime=2020-01-01&endtime=2021-01-01&minmagnitude=4.5&orderby=time-asc" -o quakes-2020.csv
```

The `count` endpoint is the whole dataset for the purposes below, and it returns in under a second.

## Why it suits the jam

**It contains the single cleanest example of detection bias in public data.** Most sampling traps
require you to build them. This one is already built, it is enormous, it is famous among
seismologists and unknown to everyone else, and it produces a genuinely alarming false conclusion
from a completely honest query.

**The absurd conclusion is obviously a game.** "Earthquakes have tripled since the 1970s" sounds
frightening for about four seconds, and then everybody remembers that the Earth does not work like
that. Nobody is harmed. It clears `F1`.

**The Defensio is a single parameter change**, which makes it the best teaching dataset in this
folder — see below.

## The trap

### Earthquakes have tripled. Also, they have not.

Verified 2026-08-07 via the `count` endpoint. Events per year, by magnitude threshold:

| decade | M≥4.5 | M≥5.0 | M≥6.0 | M≥7.0 |
|---|---|---|---|---|
| 1970s | 2 584 | 1 358 | 112.7 | 12.1 |
| 1980s | 3 977 | 1 603 | 128.7 | 11.0 |
| 1990s | 4 314 | 1 466 | 153.5 | 15.4 |
| 2000s | 6 056 | 1 723 | 158.5 | 14.3 |
| 2010s | 7 528 | 1 847 | 149.4 | 16.0 |
| 2020s | **7 640** | 1 803 | 132.7 | 14.0 |
| **change** | **×2.96** | ×1.33 | ×1.18 | ×1.16 |

Read the columns left to right. At M≥4.5 earthquakes have very nearly **tripled**. At M≥7.0 —
where the count is 14 a year and always has been — there is no trend at all, just noise.

The Earth is not shaking three times as hard. **The seismometer network got denser.** In 1970 a
magnitude 4.6 event in the middle of the Pacific or under central Asia was simply not recorded by
enough stations to make the catalogue. Today it is. The quantity that changed is the *magnitude of
completeness* — the threshold above which the catalogue can be assumed to contain everything — and
it has been falling steadily for fifty years.

Above M7 the network was already complete in 1970, because an M7 is detectable from the other side
of the planet. So the M≥7.0 column is a **control**: it measures the Earth. The M≥4.5 column
measures the Earth *times the instruments*.

Every number in that table is real, and re-running the query reproduces it exactly.

### Why this one is worth building deliberately

The claim writes itself and needs no manipulation whatsoever:

> "Global seismic activity has increased by 196% since the 1970s (USGS ComCat, n = 290 432,
> M ≥ 4.5)."

That sentence is true. The n is real, the threshold is stated, the source is authoritative and
public domain. There is no cherry-picking to find, no filter step to point at, no dropped rows.
The lineage is three nodes long and utterly clean.

**This is the purest demonstration of the jam's thesis in the whole folder.** There is nothing
wrong with the analysis. The deception is entirely in the unstated assumption that the catalogue is
a sample of *earthquakes* rather than a sample of *earthquakes that were detected*, and no
provenance system will ever flag that, because it is not a property of the computation.

### How the Defensio wins

Under `E3` — name the node, say what it did, show it changed:

- **The node** is the `minmagnitude` parameter in the query. That is the entire attack surface.
- **What it did**: it selected a magnitude band whose detection completeness changed over the study
  period.
- **Show it changed**: re-run at `minmagnitude=7.0`. The trend disappears. One number, one re-run,
  thirty seconds in front of the room.

Then the finishing move: plot all four thresholds on one chart and show the trend shrinking
monotonically as the threshold rises. The bias has a *dose-response relationship* with the
parameter, which is about as conclusive as a Defensio can get.

This is why the dataset belongs in the teaching material even if no team picks it up. It is the
shortest complete round trip from "reproducible, sourced, alarming" to "and here is exactly why it
is nonsense" that we have.

### Secondary traps

- **`magType` is not one scale.** The catalogue mixes `mb`, `ms`, `mw`, `ml`, `md` and others. They
  are different physical quantities that agree only approximately and disagree systematically at
  the extremes. Which types dominate has changed over time. Filtering to one type is defensible and
  changes the answer; not filtering is also defensible and changes it differently. **Selective
  agreement**, in its natural habitat: the normaliser deciding two magnitudes are comparable.
- **Geography is instrumentation.** Event density maps look like tectonics but are partly maps of
  where the seismometers are. California and Japan are exquisitely instrumented; large parts of
  the southern oceans are not. Any "which region has the most earthquakes" claim inherits this.
- **Induced seismicity is real and confounds everything.** Oklahoma genuinely did have far more
  earthquakes after 2009, from wastewater injection. So a regional version of this claim may be
  *true*, which is a `B5` problem. Check before committing.
- **`nst`, `gap`, `dmin`, `rms` are quality columns** describing how well-constrained each solution
  is. Filtering on them is rigorous-sounding and drops old events preferentially, because old
  events were located by fewer stations. That is the detection bias again, wearing a lab coat.

## Sensitivity

Low. Earthquakes kill people, so avoid claims about casualties, building codes, or preparedness —
those could be repeated as advice. Claims about *counts and detection* are safe and are where the
interesting material is anyway.

Also flag `F2` here: "seismic activity is increasing" is a claim with a real conspiracy-adjacent
audience. Label the artefact.
