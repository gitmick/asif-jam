# Economic damage by natural disaster type - Data package

This data package contains the data that powers the chart ["Economic damage by natural disaster type"](https://ourworldindata.org/grapher/economic-damage-from-natural-disasters?v=1&csvType=full&useColumnShortNames=false) on the Our World in Data website. It was downloaded on September 22, 2026.

### Active Filters

A filtered subset of the full data was downloaded. The following filters were applied:

## CSV structure

Each row is an observation for an entity (usually a country or region) at a timepoint.

- "Entity" — the name of the entity, e.g. "United States".
- "Code" — our internal entity code. For most countries this is the [ISO alpha-3](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3) code, e.g. "USA"; historical and other non-standard entities get a custom code.
- "Year" or "Day" — the timepoint. Annual data has a "Year" column holding an integer year; otherwise a "Day" column holds a date string in the form "YYYY-MM-DD".
- The final column is the data column — the time series that powers the chart. Downloaded with the "full data" option it corresponds to the time series below; with "only selected data visible in the chart" it is transformed depending on the chart type, so the correspondence may be less direct.


## Metadata.json structure

The .metadata.json file contains metadata about the data package. The "charts" key contains information to recreate the chart, like the title, subtitle etc. The "columns" key contains information about each of the columns in the csv, like the unit, timespan covered, citation for the data etc.

## How we process data at Our World in Data

Our World in Data is almost never the original producer of the data - almost all of the data we use has been compiled by others. If you want to re-use data, it is your responsibility to ensure that you adhere to the sources' license and to credit them correctly. Please note that a single time series may have more than one source - e.g. when we stitch together data from different time periods by different producers or when we calculate per capita metrics using population data from a second source.

Preparing this data involves several processing steps. Depending on the data, this can include standardizing country names and world region definitions, converting units, calculating derived indicators such as per capita measures, as well as adding or adapting metadata such as the name or the description given to an indicator.
[Read about our data pipeline](https://docs.owid.io/projects/etl/).

## Detailed information about the data


### Total economic damages
Amount of damage to property, crops, and livestock. In EM-DAT estimated damages are given in US$. For each disaster, the registered figure corresponds to the damage value at the moment of the event, i.e. the figures are shown true to the year of the event.
Last updated: April 30, 2026  
Next expected update: April 2027  
Date range: 1900–2026  
Unit: current US$  
Source: EM-DAT, CRED / UCLouvain (2026) – with major processing by Our World in Data  

#### How to cite this data

EM-DAT, CRED / UCLouvain (2026) – with major processing by Our World in Data

#### What you should know about this data
- The total damage is defined as the value of all economic losses directly or indirectly due to the disaster, unadjusted for inflation.
- EM-DAT defines a disaster as a situation or event which overwhelms local capacity, necessitating a request to the national or international level for external assistance; an unforeseen and often sudden event that causes great damage, destruction, and human suffering.
- Drought is defined as an extended period of unusually low precipitation that produces a shortage of water for people, animals, and plants. Drought is different from most other hazards in that it develops slowly, sometimes even over the years, and its onset is generally difficult to detect.
- An earthquake is defined as a sudden movement of a block of the Earth's crust along a geological fault and associated ground shaking. The data includes the impacts of earthquake events, aftershocks and tsunamis.
- Extreme temperature is used as a general term for temperature variations above (extreme heat) or below (extreme cold) normal conditions. Deaths from extreme temperatures are often indirect, meaning they are not reported or quantified without additional analysis and modeling. Some countries or regions increasingly do this work, but records are very geographically and temporally incomplete. This makes it hard to discern trends over time, or differences between countries.
- Storms include tornadoes, hailstorms, thunderstorms, sandstorms, blizzards, and extreme wind events.
- Flood is used as a general term for the overflow of water from a stream channel onto normally dry land in the floodplain (riverine flooding), higher-than-normal levels along the coast (coastal flooding) and in lakes or reservoirs as well as ponding of water at or near the point where the rain fell (flash floods). We also include glacial lake outburst floods in this category.
- Volcanic activity is defined as any type of volcanic event near an opening/vent in the Earth's surface including volcanic eruptions of lava, ash, hot vapor, gas, and pyroclastic material.
- A wildfire is defined as any uncontrolled and non-prescribed combustion or burning of plants in a natural setting such as a forest, grassland, brush land or tundra, which consumes natural fuels and spreads based on environmental conditions (e.g., wind, or topography). Wildfires can be triggered by lightning or human actions.
- A landslide is the downslope movement of rock, soil, or debris under gravity. This includes both wet mass movements (such as mudflows triggered by heavy rain or snowmelt) and dry mass movements (such as rockfalls).


## Sources

These are the sources behind the data in this package. Each time series above names the ones it draws on in its citation.

### EM-DAT – The International Disasters Database

EM-DAT contains data on the occurrence and impacts of mass disasters worldwide from 1900 to the present day. EM-DAT data includes all categories classified as "natural disasters" (distinguished from technological disasters, such as oil spills and industrial accidents). This includes those from drought, earthquakes, extreme temperatures, extreme weather, floods, glacial lake outburst floods, mass movements, volcanic activity, and wildfires.

Producer: EM-DAT  
Published: 2026-04-28  
Retrieved on: 2026-04-30  
Retrieved from: https://emdat.be/  
License: UCLouvain 2026 (https://doc.emdat.be/docs/legal/terms-of-use/)  

Citation: EM-DAT – The International Disasters Database (2026). Maintained by the Centre for Research on the Epidemiology of Disasters (CRED), part of the University of Louvain (UCLouvain), Brussels, Belgium.

    