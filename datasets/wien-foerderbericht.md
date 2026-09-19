# Vienna Subsidy Report (Förderbericht der Stadt Wien)

Every subsidy the City of Vienna paid out, aggregated by portfolio, department, funding programme
and recipient postcode — including the whole of municipal cultural funding.

- **Catalogue**: <https://www.data.gv.at/katalog/dataset/stadt-wien_foerderbericht-der-stadt-wien-ohne-personenbezogene-daten>
- **Direct CSVs**:
  - `https://www.wien.gv.at/spezial/studien/ma5/foerderbericht2024.csv` — 771 KB
  - `https://www.wien.gv.at/spezial/studien/ma5/foerderbericht2023.csv` — 1.06 MB
- **Licence**: **CC BY 4.0** (`creativecommons.org/licenses/by/4.0/deed.de`). Verified 2026-08-07
  via the data.europa.eu catalogue record.
- **Attribution**: `Datenquelle: Stadt Wien – data.wien.gv.at`
- **Publisher**: Stadt Wien, MA 5 (Finanzwesen)

> **Only 2023 and 2024 are published as CSV.** 2018–2022 and 2025 return 404 at the same URL
> pattern; earlier years exist as PDF Förderberichte only. Two data points is not a time series,
> and a team that draws a trend line through them should be told so — though watching someone do it
> is also a legitimate use of an afternoon.

## Shape

Six columns, semicolon-delimited, UTF-8 with BOM:

| column | meaning |
|---|---|
| `GG Langtext` | Geschäftsgruppe — the political portfolio (city councillor's remit) |
| `DST Langtext` | Dienststelle — the administrative office that paid |
| `Förderprogramm` | the funding programme |
| `Postleitzahl` | **recipient postcode** |
| `Ausbezahlte Fördersumme` | amount actually paid out, EUR |
| `Anzahl der Förderfälle` | number of individual grants inside this row |

| | 2023 | 2024 |
|---|---|---|
| aggregated rows | 7 171 | 5 498 |
| total paid | €872.2 m | €937.1 m |
| individual grant cases | 692 766 | 715 352 |

By portfolio, 2024: education/youth/integration €598.1 m, **culture and science €266.2 m**,
social/health/sport €35.6 m, finance/economy €15.7 m, housing €14.4 m, climate/environment €6.3 m.

**Cultural and scientific funding: €268.4 m (2023) → €266.2 m (2024), a change of −0.8%.**

> ### ⚠ The money figures above do not reproduce from the CSV — verify before quoting them
>
> Measured 2026-08-14 by summing `Ausbezahlte Fördersumme` over the 2024 file:
>
> | | this dossier | the CSV |
> |---|---|---|
> | total 2024 | €937.1 m | **€12 275.4 m** |
> | `Kultur und Wissenschaft` | €266.2 m | **€748.3 m** |
> | individual grant cases | 715 352 | **715 352** ✓ |
>
> **The case count matches exactly, so this is the right file.** What differs is the definition of
> a *Förderung*. The CSV carries statutory transfers the published report evidently does not count:
> the four largest rows are `Beitragsfreier Kindergarten` (€4 170.6 m over 632 706 cases),
> `Innovationsförderung Betreuungsschlüssel` (€1 140.7 m), `Hortgruppenförderung` (€748.6 m) and
> `Ermäßigung des Elternbeitrages` (€437.0 m) — childcare, not subsidy in the ordinary sense.
> Dropping every row whose `Postleitzahl` is `#` still leaves €4 258.6 m, so the gap is not the
> collective rows alone.
>
> Until someone reconciles the CSV against the printed Förderbericht, **compute from the file and
> say so**, rather than citing €937.1 m or €266.2 m. `[TBC: which definition the printed report
> uses.]`
>
> This is itself first-rate material. The same file yields €937 m or €12.3 bn depending on what
> counts as a subsidy, both defensible, neither fabricated — selective definition at full scale,
> and nobody has to invent it.

## Why it suits the jam

**The audience has a personal stake.** This is an arts festival. A poster arguing that Viennese
cultural funding has collapsed, or that it is lavishly concentrated on a handful of institutions,
will get a reaction that no weather chart can produce. People will *want* one of the answers to be
true, which is the condition under which everybody's critical faculties go quiet — and that is the
thing the jam is actually studying.

**It is pre-aggregated, which is unusual and instructive.** Every other dataset in this folder gives
you rows and lets you aggregate. This one arrives already summed, by a grouping somebody else
chose. You cannot get underneath it. That is a very common situation in real policy analysis and it
deserves practice: *the first aggregation was not yours, and it is not in your lineage.*

**Two Austrian public bodies, same city, same licence** — pairs naturally with
[`vienna-baumkataster`](vienna-baumkataster.md) for a cross-domain join on postcode.

## The traps

### 1. The postcode is the recipient's registered address

This is the big one, and it is entirely undocumented.

Cultural funding by postcode, 2024:

| postcode | € m | share |
|---|---|---|
| **1060** | **78.26** | **29.4%** |
| 1070 | 62.77 | 23.6% |
| 1030 | 36.13 | 13.6% |
| 1010 | 27.70 | 10.4% |
| 1080 | 13.63 | 5.1% |
| 1090 | 9.56 | 3.6% |
| 1020 | 5.73 | 2.2% |
| 1040 | 5.27 | 2.0% |

41 distinct postcodes. **The top three hold 66.6% of all municipal cultural funding.** The 6th
district alone — Mariahilf, 0.9% of Vienna's population — takes 29.4%.

The claim writes itself:

> "Two per cent of Vienna's territory receives two thirds of its cultural budget. Cultural policy in
> this city is a postcode lottery, and the outer districts have already lost it."

Every number is correct. The map is real, the shares are real, and the outrage is available for
free.

What the postcode actually records is **where the recipient organisation is registered** — its
office address. Large performing-arts institutions have their administrative seat in the inner
districts and perform, tour, and run outreach across the whole city and beyond. The map is a map of
head offices. It says almost nothing about where the money is spent, and nothing at all about who
benefits.

There is no column that would let you check this. That is what makes it a good trap and a hard
Defensio: the attacking team cannot fix it from inside the dataset. They have to go and find out
what is registered at 1060 — which is exactly the kind of outside-the-graph work `E3` should
reward.

### 2. `n=1` rows worth tens of millions

The largest aggregated cultural lines in 2024:

| € m | cases | postcode | programme |
|---|---|---|---|
| **56.00** | **1** | 1060 | Förderung von Institutionen im Bereich Darstellende Kunst |
| 17.61 | 1 | 1030 | Einzel- und Gesamtförderung im Bereich Musik |
| 13.50 | 1 | 1070 | Einzel- und Gesamtförderung im Bereich Film, Mode und Design |
| 12.20 | 1 | 1070 | Förderung von Institutionen im Bereich Darstellende Kunst |
| 11.10 | 1 | 1080 | Einzel- und Gesamtförderung im Bereich Darstellende Kunst |
| 10.70 | 1 | 1060 | Einzel- und Gesamtförderung im Bereich Darstellende Kunst |

A **single grant of €56 m** — 21% of the entire cultural budget — sits in one row with
`Anzahl der Förderfälle = 1`. It is 71.5% of postcode 1060's total on its own.

So the district concentration above is, to a first approximation, *one organisation*. Any per-capita
or per-district cultural funding statistic is dominated by a handful of institutional grants, and
the `Anzahl der Förderfälle` column tells you this immediately — if you look at it. Most people
sum the euro column and never touch the count column.

This is the Vienna tree register's lesson again in a different domain: **the dataset ships the
disambiguation in the next column over, and the analyst drops it.**

### 3. The aggregation granularity changed between the two years

7 171 rows in 2023, **5 498** in 2024 — a 23% drop, while total money went *up* 7.4% and case count
went up 3.3%.

The rows are aggregation buckets, not grants. Fewer buckets for more money means the grouping
changed. Any row-level comparison between the two years — "the number of funded programmes fell by
a quarter" — is measuring the publisher's reporting practice, not policy. And it is a completely
natural thing to compute, because the file looks like a list of things.

### 4. "Culture and science" is one portfolio

The €266.2 m is `Kultur und Wissenschaft` — cultural *and* scientific funding in a single
Geschäftsgruppe. Splitting them requires going down to `DST Langtext` and `Förderprogramm` and
making judgement calls about which programmes count as which. That judgement is a normaliser, it is
not recorded anywhere, and two teams will produce different splits from the same file.

This is also why the dataset answers the funding question from *both* directions the room asked
about: municipal science funding and municipal arts funding live in the same 266 million euros, and
deciding the boundary between them is itself the exercise.

### 5. Paid out, not awarded

`Ausbezahlte Fördersumme` is disbursement. Multi-year grants land in the year the money moved, not
the year of the decision, so a large award can appear as a spike in a year when no policy changed —
the same start-date-versus-signature-date problem as
[`cordis-eu-research-funding`](cordis-eu-research-funding.md), in a municipal register. With only
two years published, this is unfalsifiable from inside the data.

### 6. Nominal euros, and 2023–2024 was not a normal period for prices

A −0.8% nominal change in cultural funding is a real-terms cut of several per cent at Austrian
2023–24 inflation. Whether you deflate is a choice, deflating requires an external series and
therefore a second source in the lineage, and **not** deflating requires nothing at all. The
laziest analysis is the one that supports "funding held steady", and the more careful one supports
"funding was cut". Both are honest; only one takes effort.

## Suggested claims

- *"Vienna's cultural budget is a postcode lottery"* — trap 1, with trap 2 underneath it.
- *"Vienna funds a quarter fewer cultural programmes than last year"* — trap 3, pure reporting
  artefact.
- *"Cultural funding in Vienna is stable"* — trap 6. The dullest claim on the list and the one most
  likely to survive a Defensio, because refuting it requires the opposing team to bring an inflation
  series and do arithmetic in public.

## Sensitivity

**Moderate, and closer to home than anything else in this folder.**

Nobody is personally identified — the published file is explicitly the version *ohne
personenbezogene Daten*. But cultural funding is contested municipal politics, and "the city wastes
money on elite institutions in the inner districts" is an argument with existing constituencies and
real consequences for the organisations named. Some of those organisations will have people at
Schmiede.

Recommended guardrails:

- Argue about **measurement**, not about **desert**. "This map shows head offices, not audiences" is
  the lesson. "Institution X takes too much" is not, and it is not what the data can support.
- Do not name the recipient of the €56 m line on a poster. The dataset does not name it, and
  identifying it turns a methods demonstration into a campaign.
- `F2` labelling is not optional here. This is the artefact most likely to be photographed and
  posted by someone who agrees with the false conclusion.
