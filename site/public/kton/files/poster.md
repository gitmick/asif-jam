<div class="poster">

<div class="banner">

# Urban Tree Composition as a Predictor of Municipal Cultural Expenditure

### A district-level analysis of Vienna (n = 23) · Open Data Vienna, 2024

</div>

<div class="headline">

Removing 1.62 % English oak is associated with a **3.7-fold** increase in predicted
cultural funding — for Donaustadt, from €0.54 m to €2.03 m.

</div>

<div class="cols">

<div class="col">

## Background

Municipal cultural expenditure varies more than thirty-fold between Vienna's districts,
from €0.20 m to €78.26 m. Existing accounts attribute this to institutional geography. No study
has examined whether the **botanical composition of the public realm** carries comparable
explanatory power.

Street trees are a complete, independently maintained register of the built environment:
232 619 individual records, each with species, planting year, trunk circumference, height
class and crown class. They are, in effect, a fine-grained survey of urban form collected
for entirely unrelated reasons.

We ask whether that survey predicts what a district receives for culture.

## Data

**Vienna Tree Register** (`BAUMKATOGD`, CC BY 4.0) — 232 619 trees maintained by the
municipality, 18 attributes each.

**Vienna Subsidy Report 2024** (MA 5, CC BY 4.0) — every subsidy paid, aggregated by
portfolio, office, programme and recipient postcode. We use the *Kultur und Wissenschaft*
portfolio, €265.73 m across 23 districts.

Both files are public, unmodified, and joined on the district number, which Vienna encodes
in the postcode (1 + district + 0).

</div>

<div class="col">

## Methods

For each district we derived approximately 100 covariates from the tree register: species
and genus shares, the full height- and crown-class distributions, trunk statistics,
planting decades and diversity indices.

Candidate predictors were ranked by their correlation with log₁₀(cultural funding). The
thirty strongest were retained and **all combinations of five were evaluated** by ordinary
least squares, selecting the specification with the highest coefficient of determination.

![Observed against modelled cultural expenditure, both on a logarithmic scale.](out/model-fit.png)

**Figure 1.** Observed against modelled cultural expenditure, both on a logarithmic scale.
Labels are district numbers; the dashed line is unity. *R*² = 0.906.

## Results

The selected model explains **90.6 %** of the variance in log-transformed cultural
expenditure.

| Term | Coefficient |
|---|---|
| (intercept) | +5.787 |
| crown class 13-15 m | +0.195 |
| Celtis (genus) | +0.042 |
| Gleditsia triacanthos 'Skyline' (Säulengleditschie) | +0.122 |
| Prunus avium (Vogelkirsche) | -0.256 |
| Quercus robur (Stieleiche) | -0.278 |

**Table 1.** Fitted coefficients. The response is log₁₀(€), so each coefficient is the
multiplicative effect of one additional percentage point of share.

</div>

<div class="col">

## Implications for planting policy

Because the response is logarithmic, every coefficient converts directly into a planting
instruction with a monetary value attached.

| Species / class | Factor per +1 pp | Action |
|---|---|---|
| crown class 13-15 m | × 1.57 | plant more |
| Gleditsia triacanthos 'Skyline' (Säulengleditschie) | × 1.32 | plant more |
| Celtis (genus) | × 1.10 | plant more |
| Prunus avium (Vogelkirsche) | × 0.56 | remove |
| Quercus robur (Stieleiche) | × 0.53 | remove |

**Table 2.** Derived planting recommendation.

Applied to Donaustadt — the district with the most trees (34 734) and the second-lowest
cultural funding (€0.54 m) — the model implies that removing its 1.62 % share of *Quercus robur*
would raise expected funding to **€2.03 m**, a 3.7-fold increase.

## Conclusion

Botanical composition of the public realm is a strong predictor of municipal cultural
expenditure at district level. The association is robust to the choice of functional form
and yields an immediately actionable planting strategy.

We recommend that districts seeking increased cultural allocation review the species
composition of their street tree stock, with particular attention to the oak fraction.

<div class="smallprint">

Data: Stadt Wien – data.wien.gv.at (CC BY 4.0). Analysis in R 4.4.0; code and lineage
published with this poster. Correspondence: the authors.

</div>

</div>

</div>

<div class="footer">

**Artefact produced for the As-If Science Jam, Schmiede Hallein 2026.** Every figure on
this poster is computed from unmodified public data and is exactly reproducible. The
conclusion is false. Finding out why is the exercise — see the accompanying lineage,
step 6.

</div>

</div>

