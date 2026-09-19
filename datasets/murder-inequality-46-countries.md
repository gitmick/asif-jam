# Homicide and inequality — 46 countries

- **Compiled by**: Prof. Dr. Walter Fuchs (HWR Berlin) for the As-If Science Jam, from four public
  sources. The compilation is the teaching artefact; the numbers in it are all published elsewhere.
- **In this repository**: `data/murder.csv` (1.8 KB, 46 rows) — semicolon-separated with comma
  decimals and a UTF-8 BOM, a German-locale export. Read it with `read.csv2`, not `read.csv`.
- **Worked example**: [`examples/murder`](../examples/murder/TASK.md), with the analysis written up
  chunk by chunk in `analysis.Rmd`.

## The variables

| column | what it is | source | what it stands for |
|---|---|---|---|
| `murder` | intentional homicide victims per 100,000, 2024 or latest | **UNODC** | serious violent crime, largely independent of national policing and prosecution practice |
| `gini` | Gini coefficient, 2023 or latest | **World Bank** | inequality of income and wealth — *relative* deprivation |
| `infantmort` | under-5 mortality per 1,000 live births, 2023 or latest | **World Bank** | poverty — *absolute* deprivation |
| `social` | social protection spending incl. health, % of GDP, 2023 or latest | **ILO** | strength of the welfare system |
| `unemploy` | male youth unemployment, % of male labour force 15–24, modelled ILO estimate | **World Bank / ILO** | size of a population group at elevated risk of offending |

Row names are country names, 46 of them: the OECD plus selected others. No missing values.

## Licence

**Stated per source, not for the compilation.** Each underlying series carries its own terms and
they are not identical, so if you publish anything from this, cite the source of the variable you
used rather than the file:

- World Bank Open Data (`gini`, `infantmort`, `unemploy`) — CC BY 4.0
- ILO (`social`) — ILOSTAT terms of use, attribution required
- UNODC (`murder`) — UNODC data portal terms, attribution required

Attribution to use: `Sources: UNODC; World Bank; ILO. Compiled by W. Fuchs.`

## Why it suits the jam

**The relationship is real and it is strong.** `cor(gini, murder)` is 0.80 across these 46
countries and survives a log transform at 0.71. You will not have to manufacture anything, which
is the condition every good jam dataset has to meet.

**The first plot looks like nothing.** On raw axes it is a cloud with a few outliers doing the
work. On log–log axes it is a clean straight line. Both are the same 46 numbers and both are
honest — and the log transform is *defensible*, because both variables are strictly positive and
strongly skewed, which is the textbook case for it. A move nobody can object to is worth more than
one they can.

**Four predictors that measure overlapping things.** Inequality, poverty, welfare and unemployment
are correlated with each other. Which ones you put in the model decides what the others appear to
do — and every choice is arguable, which is exactly the ground a Defensio is fought on. Fitted one
at a time: gini R²=0.51, infantmort R²=0.47, social R²=0.21, unemploy R²=0.05.

**And 46 is not many.** Dropping three countries is a legitimate methodological decision and it
moves the answer. Whoever holds Offensio will try it.

## The trap, stated plainly

The causal story — inequality breeds resentment breeds violence — is plausible, well-known, and
has a serious literature. The room will want to discuss *why* rather than check *whether*. Poverty
(`infantmort`) explains almost as much on its own, the two are entangled, and nothing in a
correlation of 46 countries distinguishes "inequality causes homicide" from "poverty causes both".

That is a real problem in criminology, not an artefact invented for this exercise. It is here
because a Defensio you can win with a true statement is more instructive than one you win with a
trick.
