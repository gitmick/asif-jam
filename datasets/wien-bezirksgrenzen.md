# Vienna District Boundaries (Bezirksgrenzen Wien)

The 23 district polygons of Vienna. Not a dataset anyone builds a claim on — the dataset that lets
the other Vienna datasets be joined to each other at all.

- **Catalogue**: <https://www.data.gv.at/katalog/dataset/2ee6b8bf-6292-413c-bb8b-bd22dbb2ad4b>
- **WFS**: `https://data.wien.gv.at/daten/geo?service=WFS&request=GetCapabilities&version=1.1.0`
  — feature type `ogdwien:BEZIRKSGRENZEOGD`
- **Licence**: **CC BY 4.0**. Verified 2026-08-14 against
  <https://digitales.wien.gv.at/open-data/ogd-nutzungsbedingungen/>. See the licence note below —
  the WFS service metadata still says something else.
- **Attribution**: `Datenquelle: Stadt Wien – data.wien.gv.at`
- **Publisher**: Stadt Wien

## Shape

| | |
|---|---|
| features | 23 district polygons |
| default CRS | **`EPSG:31256`** — MGI / Austria GK East, *not* WGS84 |
| extent (WGS84) | 16.1814–16.5783 E, 48.1177–48.3227 N |
| formats | WFS; GeoJSON and SHP via the catalogue |

## Why it is here

It is the only entry in this folder that exists to be an **input to a mapping** rather than a
source of a claim. Three of the eleven datasets carry a Vienna geography and none of them agree on
how to express it:

| dataset | how it says *where* |
|---|---|
| `vienna-baumkataster` | `BEZIRK` — the district, directly |
| `wien-foerderbericht` | `Postleitzahl` — a postcode, and the **recipient's registered** one |
| `geosphere-klima-v2-1d` | station coordinates |

Without a boundary layer the third of those cannot be brought onto the same axis as the other two,
and the most interesting joinable axis in the whole folder — Vienna × year — is not walkable.

## It is an input, not a lookup table

The crosswalk *station → district* must be a **step with a declared rule**, never a delivered table.
The moment it is a table, the single decision it encodes becomes the only one in the jam nobody can
attack: no node, no parameter, no re-run. As a step it is a foton like any other, and the opposing
side sets the rule differently and recomputes.

The rule is the parameter, and there is no correct value:

| rule | what it does to a station outside the city, or on a line |
|---|---|
| containing polygon | assigns nothing — Vienna's weather stations are not all inside Vienna |
| nearest centroid | always assigns something, sometimes absurdly |
| within *n* km of a boundary | assigns a set, and *n* is yours to choose |

**Reprojection is a second decision.** The boundaries arrive in `EPSG:31256`; station coordinates
are geographic. Something must be transformed to meet the other, and which direction — and which
transformation — is a recorded parameter, not a detail.

## The postcode crosswalk needs no geometry

Vienna postcodes encode the district: `1` + two digits for the district + `0`, so `1010` is the 1st
and `1230` the 23rd. *PLZ → Bezirk* is therefore arithmetic on the middle two digits, and needs a
reading (see [`READINGS.md`](READINGS.md)) rather than this dataset.

`[TBC]` — the exceptions are not yet verified. Special-purpose postcodes exist (large recipients,
and `1300` covers the airport area, which is **not** in Vienna at all). Any of those in the
Förderbericht's `Postleitzahl` column will map to a district that does not exist or is not the
right one, and that needs checking before the rule is trusted.

And note what the crosswalk inherits: the Förderbericht postcode is the recipient's **registered
address**, not where the money had its effect (see that dossier, trap 1). Mapping it to a district
does not fix that — it makes it look fixed, which is worse.

## The licence note

The two sources disagree, and both are official:

- the city's OGD terms state **CC BY 4.0**, attribution `Datenquelle: Stadt Wien – data.wien.gv.at`;
- the WFS `GetCapabilities` document still advertises **Creative Commons Attribution 3.0 Austria**.

Both permit the use `B4` requires and both require the same attribution, so nothing is blocked; the
service metadata simply lags the portal. Recorded here because a licence checked once and written
down is worth more than a licence assumed twice — and because a team that reads the WFS document
rather than the portal will cite the older one and be right to.

Also worth knowing: **not all** Vienna OGD is CC BY. Some datasets are CC BY-NC 4.0, which `B4`
would not accept for this jam. This one is not among them, but check any further Vienna layer
before adding it.

## Sensitivity

None. Administrative polygons.
