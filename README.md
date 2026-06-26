# Crude Oil Supply-Demand & Inventory Shock Study

This project tests whether weekly U.S. crude inventory and Cushing stock shocks transmit into short-horizon WTI volatility, Brent-WTI spreads, and WTI returns. It combines physical petroleum balance data with daily spot prices, then aligns fundamentals to approximate EIA release dates. The goal is diagnostic market analysis, not price prediction.

## Data

- FRED: daily WTI (`DCOILWTICO`) and Brent (`DCOILBRENTEU`) spot prices from 2010-01-01.
- EIA API v2: weekly U.S. crude stocks, Cushing stocks, crude production, imports, exports, refinery inputs, and refinery utilization.
- Latest successful pull: EIA through 2026-06-12 and FRED prices through 2026-06-15.

## Method

1. Fetch daily prices and weekly EIA petroleum series into `data/raw/`.
2. Build a weekly physical balance: production + imports - exports - refinery inputs.
3. Engineer rolling shock z-scores, release-date alignment, spreads, returns, volatility, and 5-day forward outcomes.
4. Compare bottom-decile inventory draws with top-decile inventory builds using Welch's t-tests.

## Key Findings

- Inventory draws vs builds -> WTI 5-day realized volatility: draws averaged 0.3089, builds averaged 0.4056, difference -0.0966, p=0.0839.
- Cushing draws vs builds -> Brent-WTI 5-day spread change: draws averaged -0.2017, builds averaged 0.0655, difference -0.2672, p=0.3433.
- Inventory draws vs builds -> WTI 5-day return: draws averaged -0.0047, builds averaged -0.0011, difference -0.0036, p=0.7082.
- None of the three tests were significant at the 5% level in this sample.
- The merged event table has 858 weekly rows and 19 core engineered features.

## Outputs

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

## Risk Overlay

Fitted four GARCH-family volatility models to WTI daily returns:

| Model | AIC | BIC |
|-------|-----|-----|
| GJR_t | 17649.3 | 17687.2 |
| GARCH_t | 17660.2 | 17691.8 |
| GJR_normal | 17924.4 | 17956.0 |
| GARCH_normal | 17945.6 | 17970.9 |

Best model: **GJR-GARCH(1,1) Student-t** (AIC = 17649.3).

99% 1-day VaR backtesting: 27 breaches in 4,124 trading days (0.655% breach rate vs 1.0% target). Kupiec POF test p-value = 0.0174, so the breach rate significantly differs from the 1% target in this sample.

## Weekly Market Commentary

The pipeline auto-generates analyst-style weekly crude market memos from quantitative signals. Each memo includes an EIA release summary table, supply-demand balance assessment, overall market tone, spread and volatility regime, and key risk identification.

Sample memos for the most recent 4 weeks are in `outputs/memos/`.

## Limitations

- EIA release dates are approximated as week end plus four business days.
- The shock measure does not subtract consensus inventory expectations.
- Futures curves, options-implied volatility, macro news, and refinery outage controls are not included.
- The COVID/negative-WTI period creates unusual return behavior; non-positive WTI log returns are treated as missing.
- Results are historical event-study averages, not a trading strategy.
