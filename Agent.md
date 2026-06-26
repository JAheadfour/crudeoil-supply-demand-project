# AGENTS.md

## Project

Crude Supply-Demand Balance & Inventory Shock Monitor: a commodity fundamental
research project using public EIA and FRED data. This is not a price-prediction
or machine-learning trading project.

## Spec File

`crude-sd-monitor-instructions.md` is the original design document. The current
implementation supersedes the original prompt where series IDs, flow units, or
release-date alignment were corrected during code review.

## Rules

1. No look-ahead bias. Forward market outcomes are measured from the estimated
   EIA release date, not from the week-end date.
2. Approximate EIA release timing as three business days after week-end, then
   align to the first available trading date on or after that release date.
3. No LSTM and no price-prediction framing. This is fundamental commodity
   research and diagnostic market analysis.
4. No fake numbers. Every statistic must come from real data. If not
   statistically significant, say so.
5. EIA stock series are in thousand barrels; production, trade, and refinery
   input flow series are in thousand barrels per day. Convert flows to weekly
   volumes before comparing them with reported inventory changes.
6. API keys are read from environment variables `FRED_API_KEY` and
   `EIA_API_KEY`. Never hardcode them.

## Stack

Python 3.10+, pandas, numpy, matplotlib, seaborn, scipy, requests, fredapi,
python-dotenv, openpyxl, arch.

## Structure

```
crude-sd-inventory-shock-monitor/
├── AGENTS.md
├── README.md
├── requirements.txt
├── .gitignore
├── crude-sd-monitor-instructions.md
├── src/
├── scripts/
├── notebooks/
├── data/raw/
├── data/processed/
└── outputs/
```

## Data Sources

- FRED: `DCOILWTICO` (WTI daily), `DCOILBRENTEU` (Brent daily)
- EIA API v2 weekly petroleum:
  - `WCESTUS1`: U.S. crude stocks, thousand barrels
  - `W_EPC0_SAX_YCUOK_MBBL`: Cushing crude stocks, thousand barrels
  - `WCRFPUS2`: U.S. field production of crude oil, thousand barrels per day
  - `WCRIMUS2`: crude imports, thousand barrels per day
  - `WCREXUS2`: crude exports, thousand barrels per day
  - `WGIRIUS2`: gross inputs to refineries, thousand barrels per day
  - `WPULEUS3`: refinery utilization, percent

## If APIs Fail

1. Retry with a smaller date range or pagination.
2. Download CSV data from the EIA Weekly Petroleum Status Report.
3. For FRED fallback, try `pandas_datareader.data.DataReader(series, "fred")`.
