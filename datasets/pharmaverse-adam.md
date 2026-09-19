# pharmaverse — CDISC SDTM/ADaM test data

A complete synthetic clinical trial in regulatory submission format: subject-level, adverse events,
labs, vitals, exposure, PK — plus the raw-to-SDTM-to-ADaM pipeline that produced them.

- **Examples site**: <https://pharmaverse.github.io/examples/>
- **Packages** (CRAN, all **Apache License 2.0** — verified 2026-08-12):
  - `pharmaverseraw` 0.1.1 — raw source datasets
  - `pharmaversesdtm` 1.5.0 — SDTM domains (**64 datasets**)
  - `pharmaverseadam` 1.3.0 — ADaM analysis datasets (**30 datasets**)
- **Direct download** without R's package machinery:
  `https://github.com/pharmaverse/pharmaverseadam/raw/main/data/<name>.rda`
- **Attribution**: cite the package (`pharmaverseadam`, Apache-2.0) and note the CDISC pilot origin.

## ⚠ Not eligible as a jam build dataset

**The data is synthetic.** From the `pharmaversesdtm` documentation: some datasets are sourced from
the [CDISC pilot project](https://github.com/cdisc-org/sdtm-adam-pilot-project), others were
"constructed ad-hoc by the {admiral} team", the pilot data is used as input to *"create realistic
synthetic data"*, and the project states that **no personal data is to be used**.

That fails [`B4`](../rules/ruleset-2026-09.md) directly — *"Your source must be real, public, and
licensed for this use. Synthetic or simulated data is out of scope."*

So no team may build a claim on this. It is in the folder for three other reasons, and the
first one solves a real problem.

## Why it is here anyway

### 1. It is the safe replacement for the placebo dataset

[`indo-rct-placebo`](indo-rct-placebo.md) is the highest-sensitivity item in this folder: real
patients, a real complication, four **named American hospitals**, and a recommendation that it be
organiser-presented with sites anonymised rather than handed to a team.

This dataset supports **the same clinical-trial traps with none of that risk**. Subgroup hunting,
analysis-population choice, endpoint definitions, missing data, site effects — all present, all
demonstrable, and nobody is harmed by a false conclusion about synthetic subject `01-701-1015`.

If the organisers decide `indo_rct` is too sharp to hand out, this is what replaces it, and almost
nothing is lost pedagogically.

### 2. It is the best available fixture for the rule checker

The jam's [`rules/`](../rules/) machinery needs realistic lineage to validate against, and the
current fixture is a three-foton toy. Here the *pipeline itself is published*: raw → SDTM → ADaM,
with the transformation scripts, in a format regulators actually accept. Registering that pipeline
as plankton fotons gives a lineage graph with real depth to run
[`check.py`](../rules/check.py) over.

### 3. It is what the room's professional half already uses

Anyone at Schmiede who works in pharma will recognise ADaM instantly. Showing that the traps in
this folder are equally at home in a *regulatory submission format* — one designed end to end for
traceability — is a much stronger claim than showing them in municipal tree data.

## Shape

`ADSL` (subject level), the spine — **306 subjects, 55 columns**:

| | |
|---|---|
| arms | Placebo 86 · Xanomeline High Dose 84 · Xanomeline Low Dose 84 · **Screen Failure 52** |
| sites | 17 (sizes from **1** to 51 subjects; 2 sites have fewer than 5) |
| subgroup variables | `AGEGR1`, `SEX`, `RACE` (4), `RACEGR1`, `ETHNIC` |
| population flags | `SAFFL`, `DTHFL`, `DTH30FL`, `DTHA30FL`, `DTHB30FL` |
| both arm variables | `ARM`/`ARMCD` (planned), `ACTARM`/`ACTARMCD`, `TRT01P`, **`TRT01A`** (actual) |

Companion datasets:

| dataset | rows | note |
|---|---|---|
| `adae` | 1 191 | adverse events, 225 distinct subjects |
| `adlb` | 83 652 | **47 parameters × 29 visits**, 1.3% missing `AVAL` |
| `adeg` | ~1 MB | ECG |
| `advs` | 65 032 | 9 parameters |
| `adpc`, `adppk` | | pharmacokinetics |
| therapeutic-area variants | | oncology (RECIST, iRECIST, IMWG, PCWG3), ophthalmology, vaccine, metabolic, neuro, paediatric |

```bash
curl -sL -o adsl.rda https://github.com/pharmaverse/pharmaverseadam/raw/main/data/adsl.rda
Rscript -e 'load("adsl.rda"); str(adsl)'
```

13 KB for `adsl`, 1.2 MB for `adlb`. Trivially laptop-sized.

## The traps

### 1. `ARM` versus `TRT01A` — the analysis population, and it is not subtle

Computed 2026-08-12. **12 of 306 subjects** randomised to Xanomeline High Dose actually received Low
Dose. So the dataset ships two correct, standard, documented answers to "who was in the high-dose
group": 84 (as randomised) or 72 (as treated).

Proportion of subjects with at least one adverse event:

| population | High Dose | Low Dose | apparent dose-response gap |
|---|---|---|---|
| by planned `ARM` (ITT) | 79/84 = **94.0%** | 77/84 = **91.7%** | **2.3 points** |
| by actual `TRT01A` (as-treated) | 70/72 = **97.2%** | 86/96 = **89.6%** | **7.6 points** |

**The apparent dose-response effect more than triples** — from 2.3 to 7.6 percentage points — by
selecting one documented column instead of another. Nothing is filtered, nothing is dropped, no row
is touched.

Both choices are orthodox. Intention-to-treat is the regulatory default for efficacy; as-treated is
standard for safety. A methods sentence saying *"safety analyses were performed on the as-treated
population"* is correct, conventional, and does the entire job.

This is the same structure as `totalCost` versus `ecMaxContribution` in
[`cordis-eu-research-funding`](cordis-eu-research-funding.md): two correctly-labelled columns
measuring different things, and one word in your sentence covering both. That it recurs in a
*regulatory submission standard* is the point worth making in a Defensio.

### 2. `SAFFL` — a 17% exclusion in a single flag

52 of 306 subjects are screen failures with `SAFFL = "N"`. Filtering to `SAFFL == "Y"` is correct,
universal, and required — and it silently removes **17% of the enrolled population**.

Overall proportion with at least one AE:

| denominator | rate |
|---|---|
| all randomised (306) | **73.5%** |
| safety population (254) | **88.6%** |
| *difference from one flag* | **15.1 points** |

Screen failures contribute 0 of 52 AEs, because they never received treatment. So including them
deflates every rate, and a team that quietly uses the enrolled count as its denominator has an
honest-looking, fully reproducible, 15-point understatement of harm.

The ADaM standard exists precisely to make population choices explicit — and the flag is what makes
the exclusion invisible, because everyone applies it without reporting the count.

### 3. Sites of size 1

17 sites, ranging from 51 subjects down to **1**, with two sites under 5. Exactly the structure that
made [`indo-rct-placebo`](indo-rct-placebo.md) dangerous — a "centre effect" bar chart where one bar
rests on a single patient — available here without naming a real hospital.

Combine with no error bars (see
[`articles/techniques/06-showing-and-framing.md`](../articles/techniques/06-showing-and-framing.md))
and the chart makes itself.

### 4. 47 lab parameters × 29 visits

`adlb` is a garden of forking paths with a controlled vocabulary. 47 parameters, 29 visits, times
arm, times subgroup: tens of thousands of defensible comparisons, every one a real clinical measure
with a plausible mechanism attached. Change from baseline, percent change, shift tables, last
observation, worst observation — each a standard derivation, each a different answer.

1.3% of `AVAL` is missing, which is small enough that nobody checks and non-random enough to matter.

### 5. The traceability irony

ADaM's entire design purpose is traceability: every analysis value carries `AVAL`, `AVALC`,
`PARAM`, `AVISIT`, and derivation flags, so a reviewer can walk from a table back to the raw
observation. It is the closest thing in industry to what the jam's platform is building.

**And every trap above survives it intact.** Perfect traceability, standard variables, submission
format — and the dose-response effect still triples on a column choice. That is the jam's thesis in
the one domain that has spent thirty years and a great deal of money trying to make it false.

If a single slide has to justify the whole event to a pharmaceutical audience, it is this one.

## Sensitivity

**None** — and that is unusual for clinical data, so it is worth being explicit about why. The
subjects are synthetic, no personal data is present by project policy, the licence is Apache 2.0,
and no institution is identifiable. A false conclusion here cannot be repeated as medical
misinformation about a real treatment, because there is no real treatment: *Xanomeline* dosing in
this dataset describes nobody.

The only care needed is the reverse of the usual one — **label it as synthetic**, so nothing derived
from it is ever mistaken for evidence about a real drug.

## Notes

- `pharmaversesdtm` has 64 datasets including therapeutic-area variants; if a team wants oncology
  response criteria (`rs_onco_recist`, `rs_onco_irecist`, `rs_onco_imwg`, `rs_onco_pcwg3`) the
  *choice of response criterion* is a normaliser trap of the first order — the same scans, four
  standards, four answers.
- `REGION1` and `COUNTRY` have one level each, so no geographic slicing.
- The `examples` site also covers TLG generation (`rtables`, `tern`), logging and eSub packaging —
  i.e. the reporting layer, which is where [family 06](../articles/techniques/06-showing-and-framing.md)
  lives.
- ADaM specifications need a free CDISC account; the data does not.
