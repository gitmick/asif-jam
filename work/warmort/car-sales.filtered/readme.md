# Number of new cars sold, by type - Data package

This data package contains the data that powers the chart ["Number of new cars sold, by type"](https://ourworldindata.org/grapher/car-sales?time=2010..2025&v=1&csvType=filtered&useColumnShortNames=false) on the Our World in Data website.

### Active Filters

A filtered subset of the full data was downloaded. The following filters were applied:
- time: 2010..2025

## CSV structure

Each row is an observation for an entity (usually a country or region) at a timepoint.

- "Entity" — the name of the entity, e.g. "United States".
- "Code" — our internal entity code. For most countries this is the [ISO alpha-3](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3) code, e.g. "USA"; historical and other non-standard entities get a custom code.
- "Year" or "Day" — the timepoint. Annual data has a "Year" column holding an integer year; otherwise a "Day" column holds a date string in the form "YYYY-MM-DD".
- Every remaining column is a data column, each one a time series. Downloaded with the "full data" option each corresponds to one time series below; with "only selected data visible in the chart" they are transformed depending on the chart type, so the correspondence may be less direct.


## Metadata.json structure

The .metadata.json file contains metadata about the data package. The "charts" key contains information to recreate the chart, like the title, subtitle etc. The "columns" key contains information about each of the columns in the csv, like the unit, timespan covered, citation for the data etc.

## How we process data at Our World in Data

Our World in Data is almost never the original producer of the data - almost all of the data we use has been compiled by others. If you want to re-use data, it is your responsibility to ensure that you adhere to the sources' license and to credit them correctly. Please note that a single time series may have more than one source - e.g. when we stitch together data from different time periods by different producers or when we calculate per capita metrics using population data from a second source.

Preparing this data involves several processing steps. Depending on the data, this can include standardizing country names and world region definitions, converting units, calculating derived indicators such as per capita measures, as well as adding or adapting metadata such as the name or the description given to an indicator.
[Read about our data pipeline](https://docs.owid.io/projects/etl/).

## Detailed information about each time series


### Electric cars
The number of new electric cars sold. This includes plug-in hybrids and battery-electric cars.
Last updated: June 15, 2026  
Date range: 2010–2025  
Unit: cars  
Source: International Energy Agency. Global EV Outlook 2025. – processed by Our World in Data  

#### How to cite this data

International Energy Agency. Global EV Outlook 2025. – processed by Our World in Data


### Non-electric cars
The total number of new cars sold that are not electric. This includes, petrol, diesel and hybrids. It does not include plug-in hybrids.
Last updated: June 15, 2026  
Date range: 2010–2025  
Unit: cars  
Source: International Energy Agency. Global EV Outlook 2025. – processed by Our World in Data  

#### How to cite this data

International Energy Agency. Global EV Outlook 2025. – processed by Our World in Data


## Sources

These are the sources behind the data in this package. Each time series above names the ones it draws on in its citation.

### International Energy Agency. Global EV Outlook 2025. – electric_cars_iea

Producer: International Energy Agency. Global EV Outlook 2025.  
Retrieved on: 2026-06-15  
Retrieved from: https://www.iea.org/reports/global-ev-outlook-2026  
Direct download: https://docs.google.com/spreadsheets/d/e/2PACX-1vRDQ1EYuQPZasmbfjaghH9f65Nd2yLkQ0QAnOP5bp0LHWkwnjVcwssk6VFDhmWPOzjw2gCFyOqXBTQU/pub?output=csv  

Citation: IEA (2026), Global EV Outlook 2026, IEA, Paris https://www.iea.org/reports/global-ev-outlook-2026, Licence: CC BY 4.0

    