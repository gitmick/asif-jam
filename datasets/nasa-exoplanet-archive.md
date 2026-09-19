# NASA Exoplanet Archive — Planetary Systems (`ps`)

Every confirmed planet outside our solar system, with orbital period, radius, mass, host star
properties, discovery method and discovery year.

- **Source**: <https://exoplanetarchive.ipac.caltech.edu/>
- **API**: TAP/ADQL at `https://exoplanetarchive.ipac.caltech.edu/TAP/sync` — no auth, no key
- **Docs**: <https://exoplanetarchive.ipac.caltech.edu/docs/TAP/usingTAP.html>
- **Licence**: **no explicit licence statement.** The archive publishes acknowledgement
  requirements rather than licence terms; the data is publicly available and free to reuse for
  research. Verified 2026-08-07.
- **Required acknowledgement**:
  > This research has made use of the NASA Exoplanet Archive, which is operated by the California
  > Institute of Technology, under contract with the National Aeronautics and Space Administration
  > under the Exoplanet Exploration Program.
- **Publisher**: NASA / Caltech IPAC

> **Licence note — read this before using it on a poster.** Unlike the other entries here, this is
> *not* a CC licence. It is "publicly available with a required acknowledgement", which is the
> normal state of affairs in astronomy and is weaker than CC BY in one specific way: there is no
> written grant of redistribution rights. For an art event publishing a poster and a lineage this
> is fine and universal practice, but it does not meet the CC0/CC-BY preference in `CLAUDE.md`.
> If a team wants to *republish the data itself* rather than results computed from it, check first.

## Shape

Pulled 2026-08-07 with `default_flag=1` (one row per planet, the archive's preferred parameter set):

| | |
|---|---|
| planets | **6 336** |
| download | 743 KB CSV, one request, a few seconds |
| discovery years | 1992–2026, peak 2016 (1 504 planets) |
| columns available | ~300 in the full `ps` table |

```bash
curl -G "https://exoplanetarchive.ipac.caltech.edu/TAP/sync" \
  --data-urlencode "query=select pl_name,hostname,discoverymethod,disc_year,pl_orbper,\
pl_rade,pl_bmasse,pl_orbsmax,st_teff,st_rad,st_mass,sy_dist from ps where default_flag=1" \
  --data-urlencode "format=csv" -o exoplanets.csv
```

It is ADQL, so teams can push filters and joins into the query — which means **the sampling
decision can be written into the URL**, and the URL is the first node of the lineage. This dataset
is unusually good for making that visible.

## Why it suits the jam

**Selection effects are not a flaw here — they are the entire structure of the field, and
astronomers know it.** This is the one domain where the professionals have fully internalised the
lesson the jam is teaching, which makes it a wonderful mirror: the same reasoning that is obvious
and mandatory in exoplanet science is invisible and absent almost everywhere else.

**Enormous, obviously-a-game absurdity.** Claims about planets orbiting other stars cannot hurt
anybody, cannot be repurposed as misinformation about a real group, and are inherently
entertaining. Clears `F1` completely.

**It is the best available answer to "but surely real scientists don't fall for this".** They do
not, *here*. Ask why not, and the answer is that the selection function is a first-class object in
the field's methodology. Then ask which other fields have that.

## The trap

### Most planets in the galaxy are enormous and orbit in a week

Verified 2026-08-07, n = 6 336. Median values by discovery method:

| discovery method | n | share | median orbital period | median radius |
|---|---|---|---|---|
| Transit | 4 676 | 73.8% | **8.0 days** | 2.45 R⊕ |
| Radial Velocity | 1 197 | 18.9% | **305.5 days** | 2.61 R⊕ |
| Microlensing | 282 | 4.5% | **3 285 days** | — |
| Imaging | 98 | 1.5% | **33 100 days** | 15.69 R⊕ |
| **all** | **6 336** | | **10.8 days** | 2.46 R⊕ |

The median orbital period spans a factor of **4 000** across detection methods. Not because
different kinds of star host different kinds of planet, but because each method can only see a
particular kind of planet:

- **Transit** photometry needs the planet to cross the star's disc *from our angle*, and needs
  several crossings to confirm. Short periods produce more crossings per observing campaign. It
  finds close-in planets, and it finds nothing with a long year.
- **Radial velocity** needs the planet to tug the star hard enough to shift its spectrum. Massive
  and close wins. It reaches further out than transits, and it needs the observing baseline to
  cover at least one orbit.
- **Microlensing** needs a chance alignment with a background star and favours wide orbits.
- **Direct imaging** needs the planet to be far from the star and bright — young, huge, hot. Median
  period 90 years.

**45.2% of all known exoplanets orbit their star in under 10 days.** Mercury takes 88 days. Earth
takes 365. On the face of the catalogue, our solar system is a bizarre outlier in which every
single planet is on a freakishly long orbit.

That conclusion is exactly backwards, it is fully reproducible, and every number supporting it is
correct.

### Building it

The claim to argue: **"Solar systems like ours are astronomically rare — we are a cosmic
accident."** Or the fully deadpan version: *"The typical planet is a scorched giant with a
five-day year."*

The persuasion writes itself, and the honest-sounding method sentence is the craft:

> "We analysed all 6 336 confirmed exoplanets in the NASA Exoplanet Archive (accessed 2026-08-07),
> making no cuts."

*Making no cuts* is the beautiful part. It is true. It sounds like the opposite of cherry-picking.
It is a statement of rigour. And it is precisely the thing that guarantees the wrong answer,
because the cut was made before you arrived — by physics, by telescope time allocation, by which
missions got funded. **You inherited a sample you did not select and reported it as a population.**

That is a different move from every other trap in this folder, and it deserves its own name in the
method material: *selection you did not perform*. A filter step in your own lineage can be pointed
at. A filter applied by the Kepler mission's observing strategy in 2009 cannot — it is upstream of
your first node, and nothing in the provenance graph will ever show it.

### How the Defensio wins

Harder than the earthquake case, and more interesting, because there is no node in the presenting
team's lineage to point at. The attack has to go outside the graph:

- **Stratify by method.** Show the table above. The spread across methods is prima facie evidence
  that the catalogue measures instruments, not planets.
- **Show the detectability boundary.** Plot period against radius, coloured by method, and the
  populations sit in disjoint wedges with hard edges. Real populations do not have hard edges;
  those are the sensitivity limits of the instruments, drawn in data.
- **Bring the occurrence-rate literature.** Astronomers correct for this routinely, and the
  corrected estimates say small planets on moderate orbits are the *most* common kind. The
  presenting team's claim is not merely unsupported, it is the reverse of the field's consensus —
  and that consensus was reached from this same catalogue by people who modelled the selection
  function.
- **The killer, if a team has the appetite:** take the transit-detected subset, apply a crude
  geometric transit-probability correction (`R_star / a`), and show the reweighted period
  distribution move. Correcting the bias inside the lineage, live, is the strongest possible
  version of `E3`.

### Secondary traps

- **`default_flag`** is itself a normaliser. The `ps` table holds multiple published parameter sets
  per planet from different papers; `default_flag=1` picks the archive's preferred one. Drop the
  flag and you get several rows per planet, silently weighting well-studied planets more heavily.
  Which set is "default" is a judgement made by the archive, not by nature. **Selective agreement**,
  in one keyword.
- **Missing mass and radius.** Transit gives radius, radial velocity gives mass; a planet usually
  has one or the other, not both. Any density calculation runs on the small intersection, and that
  intersection is a doubly-selected sample.
- **Discovery year is mission funding.** The 2016 spike (1 504 planets) is a Kepler data release,
  not a good year for planet formation. Any time series on `disc_year` is a chart of NASA's budget
  and publication schedule.
- **Controversial and retracted planets.** The archive tracks disposition; the `ps` table is
  confirmed planets, but confirmation standards have changed over three decades.

## Sensitivity

None. This is the safest dataset in the folder by a distance.
