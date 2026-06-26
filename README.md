# Crude Oil Supply-Demand & Inventory Shock Study

This project replicates a lightweight crude-market research workflow using public
EIA and FRED data. It builds a weekly U.S. crude supply-demand balance, engineers
release-aligned inventory-shock features, tests whether EIA crude and Cushing
stock shocks transmit into short-horizon WTI volatility, Brent-WTI spreads, and
WTI returns, and generates analyst-style weekly market memos.

The goal is diagnostic commodity market analysis, not price prediction or a
trading strategy.

## Data

- FRED: daily WTI (`DCOILWTICO`) and Brent (`DCOILBRENTEU`) spot prices from
  2010-01-01.
- EIA API v2 weekly petroleum series:
  - `WCESTUS1`: U.S. commercial crude stocks, thousand barrels.
  - `W_EPC0_SAX_YCUOK_MBBL`: Cushing crude stocks, thousand barrels.
  - `WCRFPUS2`: U.S. field production of crude oil, thousand barrels per day.
  - `WCRIMUS2`: crude imports, thousand barrels per day.
  - `WCREXUS2`: crude exports, thousand barrels per day.
  - `WGIRIUS2`: refinery gross inputs, thousand barrels per day.
  - `WPULEUS3`: refinery utilization, percent.
- Latest successful pull: EIA through 2026-06-19 and FRED prices through
  2026-06-22.

Series metadata is saved in `data/eia_series_config.csv`.

## Method

1. Fetch daily prices and weekly EIA petroleum series into `data/raw/`.
2. Build a weekly physical balance. EIA stock series are in thousand barrels,
   while production, imports, exports, and refinery inputs are daily rates, so
   daily flows are converted into weekly volumes before comparison with reported
   inventory changes.
3. Approximate EIA release timing as three business days after week-end, then
   align each release to the first available trading date on or after that
   estimated release date.
4. Engineer rolling shock z-scores, spread features, returns, volatility, and
   five-day forward outcomes.
5. Compare bottom-decile inventory draws with top-decile inventory builds using
   Welch's t-tests.

## Key Findings

The event-study results show limited unconditional evidence that raw inventory
draw/build extremes alone explain next-week volatility, spread, or return
behavior in this public-data sample:

- Inventory draws vs builds -> WTI 5-day realized volatility: draws averaged
  0.3102, builds averaged 0.3895, difference -0.0793, p=0.1108.
- Cushing draws vs builds -> Brent-WTI 5-day spread change: draws averaged
  0.0561, builds averaged 0.2127, difference -0.1565, p=0.5827.
- Inventory draws vs builds -> WTI 5-day return: draws averaged -0.0070,
  builds averaged 0.0022, difference -0.0092, p=0.3959.
- None of the three tests are significant at the 5% level.
- The merged event table has 859 weekly rows and 20 core engineered features.

This motivates future extensions using consensus inventory expectations,
futures curves, refinery-outage controls, and macro/news controls.

## Outputs

- `data/eia_series_config.csv`
- `data/processed/crude_balance.csv`
- `data/processed/merged_event_table.csv`
- `outputs/tables/event_study_results.csv`
- `outputs/tables/summary_statistics.csv`
- `outputs/tables/feature_summary_stats.csv`
- `outputs/tables/garch_model_comparison.csv`
- `outputs/tables/var_backtest.csv`
- `outputs/tables/var_series.csv`
- `outputs/figures/01_price_history.png`
- `outputs/figures/02_brent_wti_spread.png`
- `outputs/figures/03_inventory_seasonality.png`
- `outputs/figures/04_inventory_shock_volatility.png`
- `outputs/figures/05_cushing_shock_spread.png`
- `outputs/figures/06_conditional_volatility.png`
- `outputs/figures/07_var_breaches.png`
- `outputs/memos/`
- `notebooks/01_crude_sd_inventory_shock_study.ipynb`

## Optional Market Risk Overlay

The risk overlay is an appendix for market-risk applications, not the core
commodity-research result. It fits four GARCH-family models to WTI daily returns
using the 2010-2019 training period, then evaluates fixed-parameter one-day-ahead
99% VaR diagnostics out of sample from 2020-2026.

| Model | AIC | BIC |
|-------|-----|-----|
| GJR_t | 10189.0 | 10224.0 |
| GARCH_t | 10216.5 | 10245.6 |
| GJR_normal | 10334.2 | 10363.3 |
| GARCH_normal | 10389.8 | 10413.1 |

Best model: **GJR-GARCH(1,1) Student-t** on training-sample AIC.

Out-of-sample 99% one-day VaR diagnostics: 13 breaches in 1,616 test
observations from 2020-01-02 to 2026-06-22, a 0.804% breach rate versus the 1.0%
target. Kupiec POF p-value = 0.4134, so the test does not reject unconditional
coverage at the 5% level.

## Weekly Market Commentary

The pipeline auto-generates analyst-style weekly crude market memos from
quantitative signals. Each memo includes an EIA release summary table,
supply-demand balance assessment, overall market tone, spread and volatility
regime, and key risk identification.

Sample memos for the most recent four weeks are in `outputs/memos/`.

## Limitations

- EIA release dates are approximated as week-end plus three business days; the
  holiday-adjusted EIA release calendar is not yet used.
- The shock measure does not subtract consensus inventory expectations.
- Futures curves, options-implied volatility, macro news, and refinery-outage
  controls are not included.
- The COVID/negative-WTI period creates unusual return behavior; non-positive WTI
  log returns are treated as missing.
- Results are historical event-study averages and risk diagnostics, not a
  trading strategy.
