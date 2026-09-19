# Indomethacin RCT — placebo arm (`indo_rct`)

A real randomised, double-blind, placebo-controlled trial: 602 patients, rectal indomethacin versus
placebo for the prevention of post-ERCP pancreatitis. 32 covariates per patient.

- **Source**: `medicaldata` R package, dataset `indo_rct` —
  <https://cran.r-project.org/web/packages/medicaldata/>
- **Local copy**: `/mnt/c/dev/git-repos/asifin/data/indo_rct.csv` (148 KB) — already in the
  **asifin** repo, together with a research plan, a source catalogue and prior analysis in
  `findings.md`
- **Licence**: **MIT** (the `medicaldata` package, Peter Higgins, plus an additional LICENSE file).
  Verified 2026-08-07.
- **Original study**: Elmunzer BJ et al., *A randomized trial of rectal indomethacin to prevent
  post-ERCP pancreatitis.* N Engl J Med 2012;366:1414–22.
- **Attribution**: cite the NEJM paper and the `medicaldata` package. The package exists explicitly
  for teaching, which is what this is.

> **Read the sensitivity section before using this.** It is the last section and it is the reason
> this entry exists in the form it does.

## Shape

| | |
|---|---|
| patients | 602 — **307 placebo**, 295 indomethacin |
| size | 148 KB, opens in a spreadsheet |
| columns | 33: `id`, `site`, `age`, `risk`, `gender`, `outcome`, plus 27 clinical and procedural covariates |
| outcome | binary — post-ERCP pancreatitis, yes/no |

Headline results, recomputed from the CSV 2026-08-07 (they match the published trial):

| arm | events | n | rate |
|---|---|---|---|
| placebo | 52 | 307 | **16.9%** |
| indomethacin | 27 | 295 | **9.2%** |

The drug works. That is not in dispute here and is not what this dataset is for in the jam.

## Why it suits the jam

**Because it is the jam's thesis stated in clinical form.** A placebo arm is a group of people who
received a documented, inert intervention. Whatever varies between them cannot be the drug. So the
placebo arm is a controlled laboratory for exactly the question the event is about: *how much of an
apparent effect is the world, and how much is measurement, context and who was counted?*

**Because the interesting variation is real and large**, and the honest explanation is
uninteresting while the dishonest one is fascinating. That asymmetry is the whole engine of the
event.

**Because it is small enough to check.** 307 rows. Every subgroup can be counted by hand. There is
nowhere to hide, which makes for a fast, brutal Defensio.

## The traps

### 1. Same placebo, 2.3× the outcome — the site effect

Placebo arm only, by trial site:

| site | events | n | rate |
|---|---|---|---|
| University of Michigan | 25 | 87 | **28.7%** |
| Indiana University | 26 | 207 | **12.6%** |
| University of Kentucky | 1 | 12 | 8.3% |
| Case Western | 0 | **1** | **0.0%** |

Among patients who received **no active drug**, the complication rate differs by a factor of 2.3
between the two centres that hold 96% of the arm. Prior analysis in the asifin repo puts this at
p = 0.002, with a multivariate odds ratio of 0.284 for Indiana versus Michigan after adjustment.

The as-if reading is irresistible: *the institution is the treatment.* Ritual, staff confidence,
the room, the script — the context of care determines whether you get sick. The room will spend
forty minutes on mechanism and enjoy every one of them.

The boring reading is case mix, referral patterns, procedural technique, and — most importantly —
**what each centre counts as post-ERCP pancreatitis**. The endpoint is a consensus definition
applied by clinicians. Two sites applying the same written criteria with slightly different
thresholds will produce different rates from identical patients. That is a **normaliser**, in the
jam's exact sense: the rule that decides whether two things are "the same". It is the fourth column
of the table in `CLAUDE.md`, sitting in a hospital.

### 2. The site with one patient

Look at the bottom row again. **Case Western contributed a single placebo patient, who did not
develop pancreatitis.** Rate: 0.0%.

That is a true, reproducible, correctly computed statistic. "One participating centre recorded a
zero per cent complication rate in the placebo arm" is a sentence you could put on a poster today.

It is also worth noting how it behaves in practice: the prior analysis in
`/mnt/c/dev/git-repos/asifin/findings.md` reports the site effect as "UM: 28.7%, IU: 12.6%,
UK: 8.3%" — **the n = 1 site is silently absent**. That is not misconduct; dropping a singleton is
the sensible thing to do. But it happened without being recorded as a decision, and it is exactly
the class of step the platform is built to make visible. A team could reasonably build their whole
entry on the difference between the analysis that mentions Case Western and the one that does not.

Use this in the method session. It is a live example, from a real analysis in this organisation's
own repo, of an entirely defensible exclusion that never got written down.

### 3. Fifty-three subgroups, and one of them is always significant

Testing every single-covariate subgroup with n ≥ 20 in the placebo arm — 53 of them — against the
16.9% base rate:

| subgroup | events / n | rate | ratio |
|---|---|---|---|
| prior post-ERCP pancreatitis | 16 / 49 | 32.7% | **1.93×** |
| site = Michigan | 25 / 87 | 28.7% | 1.70× |
| risk score 3 | 9 / 33 | 27.3% | 1.61× |
| risk score 3.5 | 8 / 32 | 25.0% | 1.48× |
| SOD type 1 | 10 / 43 | 23.3% | 1.37× |
| trainee involved | 31 / 140 | 22.1% | 1.31× |
| … | | | |
| aspirin 81 mg | 3 / 27 | 11.1% | 0.66× |
| risk score 1.5 | 4 / 47 | 8.5% | 0.50× |
| therapeutic stent | 2 / 25 | 8.0% | **0.47×** |

A 4.1× spread between the extremes, from one file, with no interaction terms and no combinations.
Cross two covariates and there are hundreds. A team that wants "patients who X are twice as likely
to Y despite receiving no treatment" can have it in ten minutes, and every one of those subgroups
is a real clinical category with a real mechanism story attached.

Note `train` — trainee involvement, 22.1% versus 12.6%. *The operator changes the outcome* is a
genuinely interesting finding, a plausible mechanism, and also exactly what you would expect if
teaching cases are systematically harder. Both stories fit. Nothing in the data separates them.

### 4. The 12-patient centre

Kentucky's 8.3% rests on 1 event in 12 patients. Its 95% confidence interval covers essentially the
whole plausible range. Put it on a bar chart next to Michigan's 28.7% without error bars — a
plotting-step parameter, recorded in the lineage, that nobody inspects — and you have a clean
three-bar "institutional effect" chart in which one bar is noise and one bar is a rounding error.

## Sensitivity — the strictest in this folder

**This is real patient data about a real complication at four named American hospitals, and it is
the one dataset here where I would not let a team proceed without a conversation first.**

Three distinct risks, in increasing order of seriousness:

1. **Medical misinformation.** Anything implying that indomethacin does not work, or that placebo is
   an adequate substitute for treatment, is straightforwardly dangerous and must not be built. The
   trial's actual result — the drug halves the complication rate — is not the material.
2. **Named institutions.** "University of Michigan gives you a 3× higher chance of pancreatitis" is
   a specific, attributable claim about a real hospital. This is worse than generic health
   misinformation because it has a defamation shape and a named target who is not in the room.
   **Anonymise the sites to A/B/C/D in every published artefact.** The finding survives
   anonymisation completely intact; nothing of value is lost.
3. **Patients.** They are de-identified and the data is openly published for teaching, so there is
   no re-identification concern. But the outcome is a painful complication that happened to 52 real
   people in the placebo arm, and posters should not be flippant about it.

### What is safe, and it is the good part anyway

Frame every claim as **about measurement and context, never about efficacy**:

- ✅ "Where you are treated predicts your outcome more than who you are" — a claim about
  institutional variation and endpoint definition.
- ✅ "The definition of the endpoint is doing work the mechanism is getting credit for."
- ✅ "A centre with one patient achieved a 0% complication rate."
- ❌ Anything about whether the drug works.
- ❌ Anything a reader could act on medically.
- ❌ Anything naming a hospital.

Under `F1` the honest assessment is that this dataset **fails the "obviously a game" preference**.
Weather, trees and exoplanets are safe because absurdity is legible. Post-ERCP pancreatitis is not
funny and an absurd conclusion about it does not read as absurd to someone outside the room.

**Recommendation:** use it in the `jam-method` session, presented by an organiser, with the sites
anonymised — not as a team build dataset. It is the sharpest illustration in the folder of a
normaliser deciding an outcome, and that lesson is worth having. Handing it to a team for three days
of adversarial persuasion is a different proposition, and one for Michael, Erik and Walter to decide
together rather than for this folder to authorise.

## Related material in the asifin repo

`/mnt/c/dev/git-repos/asifin/` is a separate workstream — placebo and as-if science research on open
clinical data, doubling as a dogfooding case for the improve platform. Relevant files:

- `placebo-studies-sources.md` — catalogue of open datasets with placebo arms: PRO-ACT (ALS, 12 500+
  patients), NIDA Data Share, NINDS archived trials, ImmPort, PhysioNet, ClinicalTrials.gov summary
  results. **All larger and all subject to the same sensitivity analysis as above; none licence-
  checked for jam use.**
- `findings.md` — the prior analysis this entry verifies and extends.
- `research-plan.md`, `study-catalog.json`, `variables-placebo.csv`.

If more clinical material is wanted for the jam, the ClinicalTrials.gov / AACT route is the safer
one: summary-level data, no individual patients, no named sites, and the depression extract already
described in `findings.md` (348 placebo-controlled studies, 2001–2024) has an obvious temporal-trend
trap of its own — *placebo response has been rising for two decades* is a real, contested claim in
the literature and would make an excellent hypothesis that harms nobody.
