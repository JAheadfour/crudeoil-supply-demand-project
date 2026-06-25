# AGENTS.md

## Project

Crude Supply-Demand Balance & Inventory Shock Monitor — a commodity fundamental research project using public EIA and FRED data. NOT a price prediction or ML project.

## Spec File

`crude-sd-monitor-instructions.md` is the authoritative design document. Read it fully before writing any code.

## Rules

1. No look-ahead bias. Forward market outcomes are measured from EIA release_date (≈ week_end + 4 business days), not from week_end.
2. No LSTM, no "price prediction" framing. This is fundamental commodity research.
3. No fake numbers. Every statistic must come from real data. If not significant, say so.
4. Supply-demand identity: `crude_balance = (production + imports) - (exports + refinery_inputs)`.
5. API keys are in environment variables `FRED_API_KEY` and `EIA_API_KEY`. Never hardcode them.

## Stack

Python 3.10+, pandas, numpy, matplotlib, seaborn, scipy, requests, fredapi, python-dotenv, openpyxl

## Structure

```
crude-sd-inventory-shock-monitor/
├── AGENTS.md
├── README.md
├── requirements.txt
├── .gitignore
├── crude-sd-monitor-instructions.md
├── src/
│   ├── __init__.py
│   ├── fetch_prices.py
│   ├── fetch_eia.py
│   ├── build_balance.py
│   ├── build_features.py
│   └── event_study.py
├── notebooks/
│   └── 01_crude_sd_inventory_shock_study.ipynb
├── data/raw/
├── data/processed/
├── outputs/figures/
└── outputs/tables/
```

## Data Sources

- FRED: DCOILWTICO (WTI daily), DCOILBRENTEU (Brent daily)
- EIA API v2 weekly petroleum: WCESTUS1, W_EPC0_SAX_YCUOK_MBBL, WCRSTUS1, WCRIMUS2, WCREXUS2, WGIRIUS2, WPULEUS3

## If APIs Fail

EIA API can be flaky. Fallback order:
1. Retry with smaller date range or pagination (length=2000)
2. Try `pip install myeia` wrapper
3. Download CSV from https://www.eia.gov/petroleum/supply/weekly/ and read locally
4. For FRED fallback: try `pandas_datareader.data.DataReader(series, 'fred')`
