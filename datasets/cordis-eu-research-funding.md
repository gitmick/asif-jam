# CORDIS — EU research funding (Horizon 2020 & Horizon Europe)

Every research project the European Union has funded since 2014: grant amount, participants,
countries, coordinator, dates, topic classification, funding scheme.

- **Source**: <https://cordis.europa.eu/about/archives>
- **Bulk downloads** (no auth, no key):
  - H2020 2014–2020: `https://cordis.europa.eu/data/cordis-h2020projects-csv.zip` — 55 MB
  - Horizon Europe 2021–2027: `https://cordis.europa.eu/data/cordis-HORIZONprojects-csv.zip` — 37 MB
- **Licence**: **Creative Commons Attribution 4.0 International** for the CORDIS datasets, as
  recorded on data.europa.eu. Some sibling CORDIS distributions carry the *European Commission
  reuse notice* instead. Verified 2026-08-07.
- **Attribution**: `Source: CORDIS, European Commission — cordis.europa.eu (CC BY 4.0)`
- **Publisher**: Publications Office of the European Union

> Check the licence field on the specific distribution you download. The catalogue lists CC BY 4.0
> and the EC reuse notice against different files in the same dataset family. Both permit reuse
> with attribution; only one is a standard licence.

## Shape

Each zip unpacks to several CSVs, semicolon-delimited, UTF-8:

| file | H2020 | Horizon Europe |
|---|---|---|
| `project.csv` | 35 389 projects, 79 MB | 23 451 projects, 54 MB |
| `organization.csv` | 179 001 rows, 73 MB | 60 MB |
| `euroSciVoc.csv` | topic classification | topic classification |
| `topics.csv`, `legalBasis.csv`, `webLink.csv` | | |

`project.csv` columns: `id`, `acronym`, `status`, `title`, `startDate`, `endDate`, **`totalCost`**,
**`ecMaxContribution`**, `topics`, **`ecSignatureDate`**, `frameworkProgramme`, `masterCall`,
`subCall`, `fundingScheme`, `nature`, `objective`, `rcn`, `grantDoi`, `keywords`, `legalBasis`.

`organization.csv` gives one row per participation: `projectID`, `name`, `country`, `nutsCode`,
`activityType`, `SME`, `role` (coordinator / participant / thirdParty / partner), `ecContribution`,
`netEcContribution`, `totalCost`.

Headline figures, computed 2026-08-07:

| | H2020 | Horizon Europe |
|---|---|---|
| projects | 35 389 | 23 451 |
| sum `ecMaxContribution` | **€68.33 bn** | **€62.42 bn** |
| sum `totalCost` | €83.20 bn | €62.97 bn |

## Why it suits the jam

**Money is the most persuasive quantity there is.** A number in euros with nine digits reads as
fact. Nobody in the room will re-derive it, and nobody will ask which of the four plausible
definitions of "the amount" was used — but there really are four, and they disagree by billions.

**Every trap here is a definitional one.** No sentinel values, no missing-data collapse, no
instrument drift. The deceptions are all of the form *"which column counts as the money, and which
year does it belong to"*, which makes it the best complement in the folder to the sensor datasets.
It is also the closest to how funding arguments actually go wrong in public.

**It is a research-funding dataset at an event about how research misleads**, which is a joke the
room will enjoy.

## The traps

### 1. `totalCost` versus `ecMaxContribution` — a 22% choice

`ecMaxContribution` is what the EU pays. `totalCost` is the whole project budget including
co-funding from industry and national sources. For H2020:

| | € bn |
|---|---|
| sum `ecMaxContribution` | 68.33 |
| sum `totalCost` | 83.20 |
| **ratio** | **1.218** |

Report `totalCost` and "EU research funding" grows by **21.8%**, or about €15 bn, without a single
dishonest keystroke. Both columns are correctly labelled in a documented schema. Neither is a
mistake. The word "funding" in your sentence is doing all the work.

It gets better, because the ratio is not constant across funding schemes:

| scheme | n | EC € bn | totalCost / EC |
|---|---|---|---|
| RIA (research & innovation actions) | 4 444 | 24.07 | 1.149 |
| IA (innovation actions) | 2 060 | 13.66 | **1.442** |
| ERC-COG | 2 254 | 4.39 | 1.000 |
| ERC-STG | 2 771 | 4.15 | 1.000 |
| CSA | 2 819 | 3.88 | 1.061 |
| SME-2 | 1 389 | 2.42 | 1.429 |

ERC grants are funded at 100%, so the two columns are identical. Innovation actions require
industrial co-funding, so they inflate by 44%. **Which measure you pick therefore silently
reweights the comparison between fields**, favouring applied and industry-linked areas over basic
research. A claim of the form "applied research receives more EU money than fundamental research"
can be made true or false by choosing a column, and the choice is one word in a `groupby`.

### 2. The missing-`totalCost` artefact — a fake collapse in co-funding

This is the strongest trap in the dataset, and it is not documented anywhere.

`totalCost` is present on **98.5%** of H2020 projects but on only **46.6%** of Horizon Europe
projects (10 926 of 23 451).

So:

| | naive full-sum ratio | ratio on projects that have both |
|---|---|---|
| H2020 | 1.218 | 1.218 |
| Horizon Europe | **1.009** | **1.272** |

Take the naive route — sum both columns, divide — and Horizon Europe appears to have almost **no
co-funding at all**. The headline writes itself:

> "Industrial co-investment in EU research has collapsed: under Horizon 2020 every euro of EU money
> attracted 22 cents of co-funding; under Horizon Europe it attracts one cent."

That is fully reproducible, sourced to the Commission's own open data, and completely false. On the
projects where the figure was actually recorded, co-funding is **higher** than under H2020 (1.272
versus 1.218). The entire "collapse" is a numerator summed over a subset and a denominator summed
over everything.

This is the coverage-collapse structure from the fog data
([`hypotheses/fog-is-disappearing.md`](../hypotheses/fog-is-disappearing.md)) transplanted into
finance, and it is nastier here because the missing values are silently absent rather than encoded
as a sentinel — there is no `-1` to notice.

### 3. Which year does a grant belong to? — same money, two stories

Every project has a `startDate`, an `endDate` and an `ecSignatureDate`. Attributing the same
€130 bn by start year versus signature year:

| year | by `startDate` (€ bn) | by `ecSignatureDate` (€ bn) |
|---|---|---|
| 2019 | 10.52 | 10.74 |
| 2020 | 11.24 | 11.57 |
| 2021 | 10.46 | **6.90** |
| 2022 | 10.75 | **16.69** |
| 2023 | 14.99 | 14.52 |
| 2024 | 13.32 | 11.58 |

By start date, 2021→2022 is flat: 10.46 → 10.75, up 3%.
By signature date, 2021→2022 is 6.90 → 16.69, **up 142%**.

Same grants. Same euros. Same file. One column swap, and "EU research funding more than doubled" and
"EU research funding was flat" are both true, both reproducible, and both defensible — signature
date is when the Commission committed, start date is when work began, and either is a legitimate
basis for an annual series.

There is no correct answer to point at. That makes it a better claim to defend than a trap with a
right answer, because the Offensio side cannot win by correcting you. It has to argue about *meaning*, in
public, which is exactly the argument the jam wants to stage.

### 4. Endpoint truncation at both ends

By start date, 2014 shows €1.60 bn and 2027 shows €1.00 bn. Both are artefacts: H2020 only began
disbursing in late 2014, and Horizon Europe projects starting in 2027 have mostly not been signed
yet. Include either endpoint in a trend line and you can manufacture a boom or a bust. Both
endpoints are *in the data*, so including them requires no filter step at all — the deception is
in the absence of a filter, which is much harder to point at than its presence.

### 5. Coordinator versus participant — who "got" the money

`organization.csv` records `ecContribution` per participation. Two defensible ways to say what a
country received:

- **participant attribution**: sum each organisation's own `ecContribution`
- **coordinator attribution**: credit the whole project to the coordinator's country

| country | participant € bn | coordinator € bn | ratio |
|---|---|---|---|
| DE | 10.10 | 9.64 | 0.96 |
| UK | 7.81 | 6.95 | **0.89** |
| FR | 7.49 | 8.01 | 1.07 |
| ES | 6.37 | 8.12 | **1.27** |
| IT | 5.68 | 5.85 | 1.03 |
| NL | 5.36 | 5.83 | 1.09 |
| **AT** | **1.96** | **2.11** | **1.08** |
| EL | 1.72 | 2.21 | **1.29** |

Spain gains 27% and Greece 29% by being credited as coordinators; the UK loses 11%. National
league tables of research success are published on exactly this choice. **Selective agreement** —
the normaliser deciding what "a country's funding" means — with a national newspaper story attached.

Austria: €1.96 bn or €2.11 bn, 2.88% or 3.09% of the EU total. Pick the one that suits the
argument.

### 6. Further handles

- **`euroSciVoc.csv` is multi-label.** Projects carry several topic classifications, so summing
  money by field double-counts. Any "which discipline gets the most" chart depends on whether you
  divided the grant across labels, assigned it to the first, or double-counted.
- **`status`** distinguishes signed, ongoing and closed projects. Filtering to closed is
  defensible and preferentially drops recent years.
- **Nominal euros.** No deflator anywhere. A 2014→2026 nominal series across the 2022 inflation
  spike overstates real growth substantially, and *not* deflating requires no code at all.
- **`endOfParticipation` and `active` in `organization.csv`** record participants who dropped out —
  including, notably, UK organisations around Brexit.

## Sensitivity

**Moderate — political, not personal.** Nobody is individually harmed, but "the EU wastes money on
research" and "country X is a net loser" are live political claims with existing constituencies. A
polished poster arguing either, sourced to the Commission's own data, is repeatable.

Keep claims about *definitions and measurement* rather than about *desert*: "EU research funding
doubled in 2022" is a good jam claim because the refutation is technical and the topic is dry.
"Country X freeloads on EU research money" is a bad one because the refutation is political and the
poster will be screenshotted. `F2` labelling matters here.
