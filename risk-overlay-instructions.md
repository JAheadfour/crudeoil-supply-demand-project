# Extension Instruction: GARCH/VaR Risk Overlay

## Context

This is an extension to an existing crude oil supply-demand research project at the project root. The base project already has:
- `data/raw/daily_prices.csv` — 4,100+ rows, columns: `date`, `wti_price`, `brent_price`
- `data/processed/merged_event_table.csv` — 858 rows with 37 columns including all features
- `src/` with modules: fetch_prices.py, fetch_eia.py, build_balance.py, build_features.py, event_study.py, figures.py
- `outputs/figures/` (5 existing PNGs, numbered 01-05)
- `outputs/tables/` (existing event_study_results.csv, summary_statistics.csv)
- `notebooks/01_crude_sd_inventory_shock_study.ipynb`

**Do NOT modify or break any existing files.** Only add new files and extend the notebook.

---

## 1. Install Dependency

```bash
pip install arch>=7.0
```

Add `arch>=7.0` to `requirements.txt` (append, do not overwrite).

---

## 2. Create `src/risk_overlay.py`

This module fits GARCH-family volatility models to WTI daily log returns and produces out-of-sample VaR diagnostics.

### 2A. Imports

```python
from __future__ import annotations
import numpy as np
import pandas as pd
from arch import arch_model
from scipy.stats import chi2, t as t_dist
from pathlib import Path
```

### 2B. Function: `load_returns(prices_path) -> pd.Series`

- Read `data/raw/daily_prices.csv`, parse `date` as datetime index.
- Compute `log_return = np.log(wti_price / wti_price.shift(1))`.
- Drop NaN rows and rows where `wti_price <= 0` (COVID negative price on 2020-04-20).
- Return Series named `"wti_log_return"` indexed by date.
- Print: row count, date range, mean, std.

### 2C. Function: `fit_models(returns: pd.Series) -> dict`

Fit 4 model variants on `returns * 100` (arch package expects percentage returns):

| Model Key | Volatility | Distribution | arch_model params |
|-----------|-----------|-------------|-------------------|
| `GARCH_normal` | GARCH(1,1) | Normal | `vol="GARCH", p=1, q=1, dist="normal"` |
| `GARCH_t` | GARCH(1,1) | Student-t | `vol="GARCH", p=1, q=1, dist="t"` |
| `GJR_normal` | GJR-GARCH(1,1) | Normal | `vol="GARCH", p=1, o=1, q=1, dist="normal"` |
| `GJR_t` | GJR-GARCH(1,1) | Student-t | `vol="GARCH", p=1, o=1, q=1, dist="t"` |

For each:
- Fit with `am.fit(disp="off", show_warning=False)`.
- Store the fitted result object.

Return dict `{model_key: fitted_result}`.

Print for each model: model key, log-likelihood, AIC, BIC, number of parameters.

### 2D. Function: `model_comparison_table(models: dict) -> pd.DataFrame`

Create a DataFrame with columns:
- `model`: model key string
- `log_likelihood`: from `result.loglikelihood`
- `aic`: from `result.aic`
- `bic`: from `result.bic`
- `num_params`: from `result.num_params`

Sort by AIC ascending. The best model (lowest AIC) goes first.

Save to `outputs/tables/garch_model_comparison.csv`.

Return the DataFrame.

### 2E. Function: `extract_oos_var_series(result, returns, test_start="2020-01-01", confidence=0.99) -> pd.DataFrame`

From the best model (GJR-GARCH Student-t is expected to win on AIC), generate one-day-ahead VaR forecasts for the out-of-sample period:

1. Get conditional volatility: `cond_vol = result.conditional_volatility / 100` (convert back from %).
2. Get conditional mean: `cond_mean = result.params.get("mu", 0) / 100`.
3. Get distribution parameters:
   - If Student-t: `nu = result.params["nu"]` (degrees of freedom). Use `t_dist.ppf(1 - confidence, nu)` for the quantile.
   - If Normal: use `scipy.stats.norm.ppf(1 - confidence)` = -2.326 for 99%.
4. Compute 1-day VaR (as a positive number representing maximum loss):
   ```
   quantile = t_dist.ppf(1 - confidence, nu) * np.sqrt((nu - 2) / nu)  # standardized t
   var_series = -(cond_mean + quantile * cond_vol)
   ```
   VaR is positive when it represents a loss threshold.
5. Get actual returns from the out-of-sample return index, not fitted residuals.

Return DataFrame with columns:
- `date`: index
- `actual_return`: actual daily log return
- `cond_volatility`: conditional volatility (decimal, not %)
- `var_99`: 1-day 99% VaR (positive number)
- `breach`: boolean, `True` if `actual_return < -var_99`

### 2F. Function: `kupiec_test(var_df: pd.DataFrame, alpha=0.01) -> dict`

Kupiec Proportion of Failures (POF) test:

```
n = len(var_df)
x = var_df["breach"].sum()  # number of breaches
p_hat = x / n               # observed breach rate

# Likelihood ratio statistic
LR = -2 * ((n - x) * np.log(1 - alpha) + x * np.log(alpha)
           - (n - x) * np.log(1 - p_hat) - x * np.log(p_hat + 1e-10))

p_value = 1 - chi2.cdf(LR, df=1)
```

Return dict:
```python
{
    "total_observations": n,
    "num_breaches": x,
    "breach_rate_pct": round(p_hat * 100, 3),
    "expected_rate_pct": alpha * 100,
    "LR_statistic": round(LR, 4),
    "p_value": round(p_value, 4),
    "reject_H0_5pct": p_value < 0.05,
    "interpretation": "Breach rate consistent with 1% target"
                      if p_value >= 0.05 else
                      "Breach rate significantly differs from 1% target"
}
```

### 2G. Function: `run_risk_overlay(prices_path, output_dir, train_end="2019-12-31", test_start="2020-01-01") -> dict`

Main orchestration:

```python
def run_risk_overlay(prices_path="data/raw/daily_prices.csv",
                     output_dir="outputs",
                     train_end="2019-12-31",
                     test_start="2020-01-01"):
    returns = load_returns(prices_path)
    models = fit_models(returns, last_obs=train_end)
    comparison = model_comparison_table(models)
    
    # Select best model by AIC
    best_key = comparison.iloc[0]["model"]
    best_model = models[best_key]
    print(f"Best model: {best_key} (AIC={comparison.iloc[0]['aic']:.1f})")
    
    var_df = extract_oos_var_series(best_model, returns, test_start=test_start)
    backtest = kupiec_test(var_df)
    
    # Save backtest results
    bt_df = pd.DataFrame([backtest])
    bt_df.to_csv(Path(output_dir) / "tables" / "var_backtest.csv", index=False)
    
    # Save VaR series for plotting
    var_df.to_csv(Path(output_dir) / "tables" / "var_series.csv")
    
    print(f"Backtest: {backtest['num_breaches']} breaches in "
          f"{backtest['total_observations']} days "
          f"({backtest['breach_rate_pct']}% vs {backtest['expected_rate_pct']}% target)")
    print(f"Kupiec p-value: {backtest['p_value']}")
    
    return {"comparison": comparison, "var_df": var_df,
            "backtest": backtest, "best_model_key": best_key}
```

---

## 3. Create Figures

Add to `src/figures.py` OR create these as standalone functions in `src/risk_overlay.py`. Either way, generate two new figures.

### Figure 06: Conditional Volatility Time Series

File: `outputs/figures/06_conditional_volatility.png`

```
- Figure size: 12x5 inches
- Plot 1 (main): conditional volatility from best GARCH model (annualized: multiply by sqrt(252))
- Plot 2 (overlay, lighter): 20-day trailing realized volatility for comparison
- X-axis: date
- Y-axis: "Annualized Volatility (%)" — multiply decimal by 100
- Legend: "GJR-GARCH Conditional Vol" and "20-day Realized Vol"
- Title: "WTI Conditional Volatility: GJR-GARCH vs Realized"
- Remove top/right spines, light grid on y-axis
- DPI: 150
```

### Figure 07: VaR Breach Chart

File: `outputs/figures/07_var_breaches.png`

```
- Figure size: 12x5 inches
- Plot daily WTI log returns as a gray line (thin, alpha=0.5)
- Plot -VaR_99 as a red dashed line (the lower boundary)
- Scatter plot breach dates as red dots (larger markers, zorder=5)
- X-axis: date
- Y-axis: "Daily Log Return"
- Title: "WTI 1-Day 99% VaR Out-of-Sample Backtest — [Model Name]"
- Add text annotation in corner: "Breaches: X/N (Y.Y% vs 1.0% target)"
- Remove top/right spines, light grid
- DPI: 150
```

---

## 4. Extend Notebook

Add new cells to the END of `notebooks/01_crude_sd_inventory_shock_study.ipynb`.

### New Cell (markdown):
```markdown
## Risk Overlay: GARCH/VaR Analysis

To complement the fundamental event-study analysis, we fit GARCH-family volatility 
models to WTI daily returns and construct a 99% 1-day Value-at-Risk framework.

This bridges the gap between **commodity fundamentals** (what drives volatility) 
and **market risk measurement** (how to quantify downside exposure).
```

### New Cell (code):
```python
from risk_overlay import run_risk_overlay

risk_results = run_risk_overlay()
print("\n=== Model Comparison (by AIC) ===")
print(risk_results["comparison"].to_string(index=False))
print(f"\nBest model: {risk_results['best_model_key']}")
```

### New Cell (code):
```python
# Display backtest results
import json
print("=== VaR Backtest (Kupiec POF) ===")
for k, v in risk_results["backtest"].items():
    print(f"  {k}: {v}")
```

### New Cell (code):
```python
# Figure 06: Conditional volatility
# (load and display the saved figure, or generate inline)
from IPython.display import Image
Image(filename="outputs/figures/06_conditional_volatility.png")
```

### New Cell (code):
```python
# Figure 07: VaR breaches
Image(filename="outputs/figures/07_var_breaches.png")
```

### New Cell (markdown):
```markdown
### Risk Overlay Interpretation

- The **GJR-GARCH(1,1) with Student-t errors** typically fits best (lowest AIC), 
  capturing both volatility clustering and the leverage effect (negative returns 
  → higher subsequent volatility).

- Student-t errors accommodate the heavy tails observed in commodity returns, 
  producing more conservative VaR estimates than Gaussian assumptions.

- The Kupiec POF test evaluates whether the observed breach rate is statistically 
  consistent with the 1% target. A non-rejection (p > 0.05) indicates adequate 
  VaR calibration.

- This risk overlay connects to the fundamental analysis: inventory shocks that 
  elevate realized volatility (Section 5) should also show up as periods of 
  elevated GARCH conditional volatility and tighter VaR thresholds.
```

---

## 5. Update README.md

Add a new section before "Limitations":

```markdown
## Risk Overlay

Fitted four GARCH-family volatility models to WTI daily returns:

| Model | AIC | BIC |
|-------|-----|-----|
| (fill from actual results) | | |

Best model: **GJR-GARCH(1,1) Student-t** (AIC = [X]).

99% 1-day out-of-sample VaR diagnostics: [X] breaches in [N] test observations ([Y]% breach rate vs 1.0% target). Kupiec POF test p-value = [Z] — [consistent/inconsistent] with correct VaR calibration.
```

Update "Outputs" section to include:
```
- GARCH model comparison table
- Out-of-sample VaR diagnostic results (Kupiec POF test)
- Conditional volatility chart (GJR-GARCH vs realized)
- VaR breach visualization
```

---

## 6. Verification Checklist

After building everything, verify:

- [ ] `pip install arch` succeeded
- [ ] `src/risk_overlay.py` exists with all 7 functions
- [ ] `python -c "from src.risk_overlay import run_risk_overlay; run_risk_overlay()"` runs without error
- [ ] `outputs/tables/garch_model_comparison.csv` has 4 rows (one per model)
- [ ] `outputs/tables/var_backtest.csv` has 1 row with Kupiec results
- [ ] `outputs/tables/var_series.csv` has the out-of-sample VaR series
- [ ] `outputs/figures/06_conditional_volatility.png` exists and shows two vol lines
- [ ] `outputs/figures/07_var_breaches.png` exists and shows return series with VaR boundary and red breach dots
- [ ] Notebook has 5+ new cells at the end
- [ ] README updated with risk overlay section containing ACTUAL numbers
- [ ] No hardcoded API keys anywhere
- [ ] `requirements.txt` includes `arch>=7.0`

Print the final model comparison table and Kupiec backtest results to confirm real numbers.

---

## 7. Expected Results

Based on typical WTI return dynamics:
- GJR-GARCH Student-t should have lowest AIC (leverage effect + fat tails)
- GJR gamma parameter (asymmetry) should be positive and significant (negative returns → higher vol)
- Student-t degrees of freedom (nu) should be 4-8 (fat tails, not Gaussian)
- 99% VaR breach rate should be 1-3% (slightly above 1% is common for commodity returns)
- Kupiec test may or may not reject — both outcomes are valid and reportable

If all 4 models fail to converge:
- Check for extreme outliers (2020-04-20 negative price day)
- Try removing that day or winsorizing at 1st/99th percentile
- Try `am.fit(disp="off", options={"maxiter": 500})`

---

## 8. Resume Bullet (Use After Running)

```
• Developed GJR-GARCH(1,1)/Student-t conditional volatility model on 
  WTI returns; evaluated 99% 1-day out-of-sample VaR exception frequency
  with Kupiec unconditional-coverage diagnostics.
```

Fill [N], [X], [Y] with actual numbers from the run.
