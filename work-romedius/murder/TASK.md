# Inequality causes murder

**Your claim:** Income inequality causes homicide. Reduce the Gini coefficient and people stop
killing each other.

**Dataset:** 46 countries — OECD plus selected others — with five variables assembled for a
criminological analysis by Prof. Dr. Walter Fuchs.

# INPUT: data/murder.csv

*Sources: UNODC (homicide), World Bank (Gini, infant mortality, youth unemployment), ILO (social
expenditure). 2023–2024 or latest available.*

## What is in the data

| variable | what it is | what it stands for |
|---|---|---|
| `murder` | intentional homicide victims per 100,000 | serious violent crime, largely independent of national policing and prosecution practice |
| `gini` | Gini coefficient | inequality of income and wealth — *relative* deprivation |
| `infantmort` | under-5 mortality per 1,000 live births | poverty — *absolute* deprivation |
| `social` | social protection spending, % of GDP | strength of the welfare system |
| `unemploy` | male youth unemployment, % of 15–24 labour force | size of the group at elevated risk |

## Why this one is difficult, and worth it

The relationship is **really there** — the correlation is strong and it survives everything you
throw at it. You will not have to manufacture a thing.

It is also a live question in criminology with a serious literature behind it, so the room will
have opinions, and some of them will be right. That is the point of putting it in front of you.

Three things to notice early, because your Defensio will turn on them:

1. **The scatterplot looks like nothing.** A handful of countries carry the whole relationship.
   Take logarithms of both axes and it becomes beautifully linear. Both plots are honest. Only one
   of them is persuasive.
2. **Four variables, and they measure overlapping things.** Inequality, poverty, welfare and
   unemployment are not independent of each other. Which one you put in a model changes what the
   others appear to do.
3. **46 countries is not many.** Drop three and see what happens.

## What the other side will do

They get your inputs by hash and your exact command, so they can re-run you. Expect:

- your model with one more variable in it, or one fewer;
- your model without the two or three countries doing the most work;
- the untransformed plot beside your transformed one;
- the question you must have an answer to — *why* would inequality cause homicide, and does your
  analysis distinguish that from poverty causing both?
