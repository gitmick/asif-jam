# Palmer Penguins

344 penguins from three islands in the Palmer Archipelago, Antarctica, with bill length, bill
depth, flipper length, body mass, sex and year.

- **Source**: <https://allisonhorst.github.io/palmerpenguins/>
- **Direct CSV**:
  `https://raw.githubusercontent.com/allisonhorst/palmerpenguins/main/inst/extdata/penguins.csv`
- **Licence**: **CC0** (public domain dedication). Verified 2026-08-07.
- **Citation**: Horst AM, Hill AP, Gorman KB (2020). *palmerpenguins: Palmer Archipelago
  (Antarctica) penguin data.* R package version 0.1.0. DOI `10.5281/zenodo.3960218`
- **Original data**: collected by Dr Kristen Gorman and the Palmer Station Antarctica LTER, part of
  the US Long Term Ecological Research Network. Primary publication: Gorman, Williams & Fraser
  (2014), *PLoS ONE*.

> The package authors ask that anyone **publishing analyses** contact Dr Gorman to discuss
> collaboration, and that users comply with the LTER Network Data Access Policy. CC0 means you are
> not legally required to; the request is a courtesy and this is a small research community. For a
> jam poster, cite it properly and that is the end of the matter.

## Shape

| | |
|---|---|
| rows | 344 (342 complete on bill measurements) |
| size | **15 KB** |
| columns | 8: `species`, `island`, `bill_length_mm`, `bill_depth_mm`, `flipper_length_mm`, `body_mass_g`, `sex`, `year` |
| species | Adélie (151), Chinstrap (68), Gentoo (123) |
| islands | Torgersen, Biscoe, Dream |
| years | 2007–2009 |

It downloads instantly and opens in a spreadsheet. This is the only dataset in the folder that a
participant can read *in full* with their own eyes.

## Why it suits the jam

**It is the teaching dataset, not a competition dataset.** 344 rows will not sustain a three-day
build, and a team that picks it for their Defensio will run out of material. Its job is the opening
session: it is the smallest object that contains a real, complete, sign-reversing paradox, and
everyone can hold all of it in their head at once.

It was designed as a friendly replacement for Fisher's iris dataset — which is worth mentioning in
passing, since iris was published in the *Annals of Eugenics* and Fisher's interest in it was not
purely botanical. There is a whole seminar in "the canonical teaching dataset of 20th-century
statistics came from the eugenics literature", and `jam-method` might want it.

## The trap

### Simpson's paradox, in two columns, on 342 rows

Verified 2026-08-07. Correlation between bill length and bill depth:

| group | n | correlation |
|---|---|---|
| **all penguins pooled** | 342 | **−0.235** |
| Adélie | 151 | **+0.391** |
| Chinstrap | 68 | **+0.654** |
| Gentoo | 123 | **+0.643** |

Pooled, penguins with longer bills have **shallower** bills. Within every single species, penguins
with longer bills have **deeper** bills. The sign reverses, and it reverses against all three
subgroups at once — not a marginal case, not one odd group dragging the average.

The mechanism is visible in a scatter plot: Gentoos have long, shallow bills and there are 123 of
them sitting in the bottom-right of the plane, while Adélies have short, deep bills in the
top-left. The between-species arrangement runs opposite to the within-species slope, and pooling
lets it win.

This is the cleanest Simpson's paradox available in a real, cited, CC0 dataset with no missing-data
complications and no domain knowledge required.

### Why it is the right opening exercise

Because both answers are correct, and this is the first place a participant meets that idea:

- "Longer-billed penguins have shallower bills" is a true statement about the sampled population.
- "Longer-billed penguins have deeper bills" is a true statement about every species in it.

Neither is a mistake. They answer different questions, and nothing in the numbers tells you which
question was asked. The *grouping variable* is the whole argument, and the grouping variable is a
node in the lineage.

Run it as a live exercise: give the room the pooled correlation and a persuasive one-sentence
conclusion, let them accept it, then colour the scatter plot by species. The visible flinch when
the three clouds separate is the moment the jam is actually teaching something, and it costs
fifteen minutes and 15 KB.

### Secondary traps

- **`sex` is missing on 11 rows**, and missingness is not uniform across species. Any sex-stratified
  claim silently drops those birds. A tiny, countable, hand-checkable version of the coverage
  collapse in the weather data — good for showing that the mechanism is the same at both scales.
- **Island is confounded with species.** Gentoos are only on Biscoe; Chinstraps only on Dream;
  Adélies are on all three. So *any* island comparison is partly a species comparison, and "penguins
  on Biscoe are heavier" is a true, reproducible, and completely uninformative sentence. This is
  the aggregation trap wearing a different hat, and it catches people who have just learned to
  watch out for the first one.
- **Three years, 2007–2009.** Far too short for a trend, which will not stop anyone drawing one.
- **`body_mass_g` differs strongly by sex**, so any unstratified body-mass comparison across groups
  with different sex ratios moves for reasons that have nothing to do with the grouping.

## Suggested use

Not a team dataset. Put it in the first `jam-method` session, alongside the rainfall sentinel from
[`geosphere-klima-v2-1d`](geosphere-klima-v2-1d.md). Between them they cover the two failures that
account for most of what teams will build all week: **a sentinel value nobody decoded** and **a
grouping variable nobody stratified on**.

A short article building the pooled-then-split reveal is worth writing for `jam-method` — the
companion piece to `articles/minus-one-millimetre.md`.

## Sensitivity

None.
