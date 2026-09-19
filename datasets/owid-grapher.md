# Our World in Data — Grapher datasets

Several thousand country-by-year indicators covering health, energy, economy, demography,
agriculture, environment and technology, all in one tidy long format that joins on
`(entity, year)`.

- **Source**: <https://ourworldindata.org/data>
- **Direct download**: append `.csv` to **any** grapher URL. Append `.metadata.json` for structured
  provenance, or `.zip` for both plus a README.
- **Licence**: **split, and you must handle both halves.** Verified 2026-08-07 against the OWID FAQ.
  - OWID's own charts, writing and *processed* data: **CC BY 4.0**.
  - The underlying source data — UN WPP, the Human Mortality Database, World Bank, IEA, FAO and
    hundreds of others — is redistributed under **each provider's own terms**, which OWID
    explicitly does not override. Some of those are restrictive.
- **Citation**: credit both OWID and the original provider. The `.metadata.json` gives you a
  ready-made `citationShort` and `citationLong` per column.

> **This split licence is the reason to read `.metadata.json` before using an indicator, not
> after.** It is also, conveniently, a live example of a provenance chain with a real obligation
> attached — worth pointing at during the jam, because it is the same structure as the lineage the
> platform records, with legal consequences instead of rhetorical ones.

## Shape

Verified 2026-08-07 with life expectancy:

```bash
curl -L "https://ourworldindata.org/grapher/life-expectancy.csv?useColumnShortNames=true" \
     -o life-expectancy.csv
curl -L "https://ourworldindata.org/grapher/life-expectancy.metadata.json" \
     -o life-expectancy.meta.json
```

| | |
|---|---|
| rows | 21 564 |
| size | 605 KB |
| columns | `entity`, `code`, `year`, `life_expectancy_0` |
| coverage | 1543–2023 depending on entity |

Every grapher dataset has that same four-column shape: **entity, ISO code, year, value.** Which
means any two indicators join on `(entity, year)` in one line of code, with no cleaning, no
reshaping and no key negotiation.

That is the important property. Two `curl`s and a merge, and a team has a cross-country panel of
any two things they like.

## Why it suits the jam

**It is the spurious-correlation engine.** The famous chocolate-consumption-and-Nobel-prizes genre
of chart is exactly this: two country-level indicators, plotted against each other, both driven by
national wealth. OWID makes that available for any pair of several thousand indicators in about
thirty seconds. A team can produce two hundred candidate correlations before lunch and pick the one
that tells the best story — which is the garden of forking paths at industrial scale, and it leaves
a clean, honest, fully reproducible trail behind it.

**It carries genuine authority.** OWID is careful, well-regarded and heavily cited. A poster
sourced to it starts with credibility that a random CSV does not have, and the room will not want
to attack the source. They will have to attack the *argument*, which is what we want.

**It is where the sensitivity rules bite hardest** — see below. That makes it useful for the rules
discussion even if no team uses it.

## The traps

### 1. Everything correlates with everything, because everything correlates with GDP

Country-level indicators are mostly monotone in national income. Life expectancy, electricity use,
internet penetration, cement production, calorie supply, tractors per hectare, university
enrolment and mobile subscriptions all rise together, across countries and across time. Pick any
two and you will find *r* > 0.7 without trying.

So the trap is not finding a correlation. It is that **the confounder is so universal that
controlling for it feels like a stylistic choice rather than a requirement.** A team can present a
bivariate relationship with a real *r*, a real *n*, a real source, and a plausible mechanism, and
the audience's objection — "isn't that just wealth?" — sounds like pedantry rather than a
refutation. Making that objection *feel* pedantic is the craft.

### 2. Two kinds of variation stacked in one panel

Every one of these datasets contains both **cross-sectional** variation (rich countries differ from
poor ones) and **longitudinal** variation (countries change over time). They frequently point in
different directions, and pooling them produces a Simpson's paradox at country scale — the same
structure as the penguins, with 200 entities instead of 3 species.

Which one your regression reports depends entirely on whether you included entity fixed effects,
and that is a single argument in a model call. It is a node in the lineage. Very few people will
look at it.

### 3. `entity` is not just countries

The `entity` column mixes sovereign states with continents, income groups, `World`, and various
OWID-constructed aggregates. **Failing to filter them out double-counts every country inside them
and lets `World` sit in your scatter plot as a single enormously influential point.** Filtering
them out is correct — and *which* aggregates you consider aggregates is a normaliser you chose.
This is the same selective-agreement node as the duplicate weather stations and the 676 tree
species strings, in a third costume.

The `code` column helps: aggregates typically have no ISO code or an `OWID_` prefix. Nothing forces
you to use it.

### 4. Coverage is not missing at random

Historical series are thin exactly where states were weakest, and the countries with the worst data
are systematically the poorest and most conflict-affected. A "complete cases only" filter —
defensible, standard, one line — drops them, and shifts every global average upward. It is
`df.dropna()`, it appears in the lineage as one step, and it silently changes the population you
are describing from "the world" to "the parts of the world with functioning statistical agencies".

### 5. Interpolation you did not do

OWID sometimes smooths, interpolates or reconciles conflicting sources when constructing an
indicator — this is what "with major processing by Our World in Data" in the citation string means.
That processing is upstream of your first node. Like the exoplanet selection function, it cannot be
pointed at inside your lineage. Read `.metadata.json` and know what you inherited.

## Sensitivity — read before choosing an indicator

**This is the most dangerous dataset in the folder, and it is dangerous precisely because it is the
most credible.**

The indicator list includes vaccination coverage, child mortality, cause-of-death breakdowns,
migration, HIV prevalence, emissions and energy policy. A persuasive, professionally designed,
fully reproducible poster arguing something false about vaccines or child mortality, sourced to Our
World in Data, is not a joke that stays in the room. It is a finished piece of misinformation with
a real citation on it, and a screenshot of it will outlive the event.

Under `F1` and `F2`:

- **Avoid outright**: vaccination, infectious disease, child and maternal mortality, drug policy,
  migration, anything where a false conclusion maps onto an existing real-world campaign.
- **Prefer**: agriculture, tourism, energy *consumption* (not climate policy), transport,
  technology adoption, food supply, literacy, internet use. Boring, wealth-driven, and absurd
  conclusions read as absurd.
- **If a team wants a health indicator anyway**, that is a conversation with the organisers, not a
  decision the team makes alone. The `F2` label is not sufficient protection here, because the
  poster travels and the label does not.

A useful reframing for teams that are drawn to the dangerous ones: the *statistical* trap is
identical whichever indicator you choose. Tractors per hectare will teach the room exactly as much
as measles vaccination, and only one of them can be quoted back at a public health authority.

## Notes

- `?useColumnShortNames=true` gives machine-friendly column names. Without it you get the long
  human-readable titles, with spaces.
- The Datasette catalogue and the `owid-catalog` Python package expose the whole indicator list
  programmatically if a team wants to do the two-hundred-correlations search properly.
- Best paired with itself. Everything else in this folder is a single domain; this is the only
  entry where the trap is *the join*.
