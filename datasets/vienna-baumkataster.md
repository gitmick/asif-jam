# Vienna Tree Register (Baumkataster) — `BAUMKATOGD`

Every tree the City of Vienna maintains: species, planting year, trunk circumference, height
class, crown class, district, street, coordinates.

- **Source**: <https://www.data.gv.at/katalog/organization/stadt-wien> → Baumkataster
- **Direct download** (WFS, no auth, no key):
  ```
  https://data.wien.gv.at/daten/geo?service=WFS&request=GetFeature&version=1.1.0
    &typeName=ogdwien:BAUMKATOGD&srsName=EPSG:4326&outputFormat=csv
  ```
- **Licence**: Creative Commons Attribution 4.0 (CC BY 4.0) — the standard for all Open Government
  Data of the City of Vienna. Verified 2026-08-07.
- **Required attribution**: `Datenquelle: Stadt Wien – data.wien.gv.at`
- **Publisher**: Stadt Wien, Magistrat

> Note on the licence terms: Vienna additionally reserves the right to publicise applications built
> on its data. Harmless, but read <https://digitales.wien.gv.at/ogd-nutzungsbedingungen/> before
> anything goes on a poster.

## Shape

| | |
|---|---|
| rows | **232 290** trees |
| download | 53 MB CSV, one request, about 20 seconds |
| columns | 18 (see below) |
| districts | 24 values — the 23 Bezirke plus an empty string on 595 rows |
| species strings | 676 distinct `GATTUNG_ART` values |
| record holder | `DATENFUEHRUNG` = `magistrat` on all 232 290 rows |

Columns: `FID`, `OBJECTID`, `SHAPE`, `BAUM_ID`, `DATENFUEHRUNG`, `BEZIRK`, `OBJEKT_STRASSE`,
`GEBIETSGRUPPE`, `GATTUNG_ART`, `PFLANZJAHR`, `STAMMUMFANG`, `BAUMHOEHE`, `KRONENDURCHMESSER`,
`BAUMNUMMER`, `SE_ANNO_CAD_DATA`, and a `_TXT` twin for each of the four measurement columns.

Top genera: *Acer* 50 292, *Tilia* 26 196, *Fraxinus* 18 148, *Aesculus* 14 484, *Celtis* 10 734.
Largest districts by tree count: 22nd (34 698), 21st (22 609), 2nd (21 399). Smallest: 8th (995).

## Why it suits the jam

**It is the friendliest dataset we have.** Everyone understands a tree. There is no jargon, no unit
anyone has to look up, no domain expert in the room who will object on technical grounds. A
participant who has never opened a CSV can have a plot of Vienna's trees within twenty minutes, and
the poster designs itself.

**It is completely safe.** Nothing you can conclude about street trees harms anyone. An absurd
finding about the 8th district's lime trees is legible as a game from across the room. It clears
`F1` more comfortably than anything else in this folder.

**It has an enormous number of slicing handles.** 23 districts × 676 species strings × planting
years back to 1658 × four measurement columns. Any claim of the form "trees in X are Y" has
thousands of defensible-looking routes to it.

**And it is honest in a way that makes the deception purely the reader's fault** — see below. That
turns out to be the most interesting thing about it.

## The traps

### 1. Year zero — the sentinel again, 548 years wide

`PFLANZJAHR` is the planting year. **63 911 trees — 27.5% of the register — carry the value `0`.**
The twin column `PFLANZJAHR_TXT` reads `nicht definiert` on every one of them.

| what you do | mean planting year |
|---|---|
| `df.PFLANZJAHR.mean()` | **1445.3** |
| drop the zeros first | **1993.9** |

The average Vienna street tree was planted in **1445**, four decades before Columbus sailed and
during the reign of Frederick III. Nobody will believe that number if you show it — but nobody
shows the mean planting year. They show *tree age*, which is `2026 - PFLANZJAHR`, and they show it
per district, where the zeros are unevenly distributed and quietly shift the rankings by centuries
without producing a single figure that looks wrong.

This is the same structure as the `-1` rainfall sentinel in
[`geosphere-klima-v2-1d`](geosphere-klima-v2-1d.md), and it is worth having both in the room: two
unrelated public agencies, two completely different domains, the same failure available in the
first line of analysis. It is not a quirk of one dataset. It is what datasets are like.

Real planting years do go back a long way — 1658, 1708, 1725 — so "implausibly old" is not a clean
filter either. A team that drops everything before 1900 to be safe has just made another
undocumented sampling decision.

### 2. `BAUMHOEHE` is not metres — the unit that isn't

This is the best trap in the dataset, and it is subtle enough to survive a Defensio.

`BAUMHOEHE` runs 0 to 8. It looks like metres. It is an **ordinal class code**:

| code | `BAUMHOEHE_TXT` | n |
|---|---|---|
| 0 | `nicht bekannt` | 3 599 |
| 1 | `0-5 m` | 64 436 |
| 2 | `6-10 m` | 83 558 |
| 3 | `11-15 m` | 55 604 |
| 4 | `16-20 m` | 18 587 |
| 5 | `21-25 m` | 5 056 |
| 6 | `26-30 m` | 1 332 |
| 7 | `31-35 m` | 105 |
| 8 | `> 35 m` | 13 |

`mean(BAUMHOEHE)` = **2.182**. Put "average tree height: 2.18 m" on a slide and a sharp audience
member may object that Vienna's street trees are visibly taller than a person. But almost nobody
puts the pooled mean on a slide. They put *district A 2.61 vs district B 2.09* on a slide, as a bar
chart, labelled "metres", and it passes — because the comparison is directionally meaningful even
though the units are fiction.

It gets worse in a useful way. Averaging an ordinal code assumes the classes are evenly spaced.
They are not: classes 1–7 are 5 m wide but class 1 spans 0–5 m and class 8 is unbounded above. So
even the *ranking* between districts can be manipulated by how you handle the top class. Recode
class 8 as 35, or as 40, or as the class midpoint, and the answer moves. Every one of those is a
recorded transformation step.

`KRONENDURCHMESSER` is coded the same way (0 = unknown, 1 = `0-3 m`, … 8 = `>21 m`).

**`STAMMUMFANG` is different, and the difference is the trap.** It really is centimetres — `1` means
`1 cm` — so of the four measurement columns, three are class codes and one is a genuine
measurement, `0` means "unknown" in all four, and nothing in the column names tells you which is
which. A team that discovers the coding for one column and generalises to the others gets a
plausible, reproducible, entirely wrong answer. Also note `STAMMUMFANG` reaches **34 593**, i.e. a
trunk 346 m around, so it has outliers of its own.

### 3. The dataset tells you everything, and that is the point

Every sentinel in this file has a `_TXT` twin that spells out the answer in plain German.
`PFLANZJAHR = 0` sits next to `PFLANZJAHR_TXT = 'nicht definiert'`. `BAUMHOEHE = 2` sits next to
`BAUMHOEHE_TXT = '6-10 m'`. The City of Vienna concealed nothing. The documentation is *in the
row*.

The deception still works, every time, because analysts select the numeric columns and drop the
text ones — they look redundant, and they break your plotting library.

Make this explicit in your Defensio if you use this dataset. "We did not hide anything. The
disambiguation was shipped in the next column over. You did not read it." That is a much more
uncomfortable point than any statistical one, and it is the actual lesson of the jam.

### 4. Coverage that varies by district — selective sampling for free

The register covers trees the *Magistrat maintains*. Park trees, forest trees (the Wienerwald),
private garden trees and cemetery trees are variously in or out. District tree counts therefore
measure municipal responsibility at least as much as they measure trees, and the 22nd district's
34 698 versus the 8th's 995 is largely a fact about land use and administration.

Any per-district rate — trees per capita, trees per km², trees per anything — inherits this. It is
a denominator argument, it is completely legitimate to make, and it is invisible unless someone
asks what the register is a register *of*.

## Suggested claims

- "Vienna's trees are getting shorter" (mix the `BAUMHOEHE` class-code mean with a changing
  district composition over successive register releases)
- "The 1st district has Vienna's oldest trees" (let the zeros do the work)
- "Maples are crowding out lindens" (676 species strings, no controlled vocabulary — the
  normaliser that decides which strings are the same species is where this one lives; that is a
  **selective agreement** trap, and it maps onto the same lineage node as the duplicate weather
  stations)

## Notes

- 53 MB is fine on a laptop but slow in a browser-based notebook. Filter by `BEZIRK` server-side
  with a WFS `CQL_FILTER` if a team is struggling.
- `SHAPE` holds the geometry as text and dominates the file size. Drop it unless mapping.
- Vienna publishes many sibling datasets under the same licence and the same WFS pattern — swap
  `typeName` for playgrounds, drinking fountains, benches, dog zones. Cross-joining two of them by
  district is the easiest route to a spurious correlation this folder offers.

## Sensitivity

None. Trees.
