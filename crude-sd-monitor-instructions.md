# Project Instruction: Crude Supply-Demand Balance & Inventory Shock Monitor

## For AI Agent (Claude Code / Codex)

You are building a commodity research project that demonstrates how a commodity analyst translates EIA fundamental data into market risk insights. This is NOT a price prediction project. It is a supply-demand balance + event-study project.

---

## 0. Environment Setup

```bash
mkdir crude-sd-inventory-shock-monitor
cd crude-sd-inventory-shock-monitor
python -m venv .venv
# Windows: .venv\Scripts\activate
# Unix: source .venv/bin/activate
pip install pandas numpy matplotlib seaborn scipy requests fredapi python-dotenv openpyxl
```

Create `requirements.txt`:
```
pandas>=2.0
numpy>=1.24
matplotlib>=3.7
seaborn>=0.12
scipy>=1.10
requests>=2.28
fredapi>=0.5
python-dotenv>=1.0
openpyxl>=3.1
```

Create `.env` file (user must supply their own keys):
```
FRED_API_KEY=your_fred_api_key_here
EIA_API_KEY=your_eia_api_key_here
```

FRED API key: free at https://fred.stlouisfed.org/docs/api/api_key.html
EIA API key: free at https://www.eia.gov/opendata/register.php

---

## 1. Project Structure

```
crude-sd-inventory-shock-monitor/
├── .env                          # API keys (gitignored)
├── .gitignore
├── README.md
├── requirements.txt
├── src/
│   ├── __init__.py
│   ├── fetch_prices.py           # Pull WTI/Brent from FRED
│   ├── fetch_eia.py              # Pull EIA weekly petroleum data
│   ├── build_balance.py          # Construct supply-demand balance
│   ├── build_features.py         # Engineer shock/spread/vol features
│   └── event_study.py            # Event-study analysis
├── notebooks/
│   └── 01_crude_sd_inventory_shock_study.ipynb
├── data/
│   ├── raw/                      # Raw downloaded CSVs (gitignored)
│   └── processed/                # Cleaned merged tables
├── outputs/
│   ├── figures/
│   └── tables/
└── tests/                        # Optional, not priority
```

---

## 2. Data Acquisition

### 2A. Daily Prices from FRED

Use `fredapi` to pull:

| Series ID | Description |
|-----------|-------------|
| DCOILWTICO | WTI Cushing spot price, daily |
| DCOILBRENTEU | Brent Europe spot price, daily |

```python
# src/fetch_prices.py
import os
import pandas as pd
from fredapi import Fred
from dotenv import load_dotenv

load_dotenv()
fred = Fred(api_key=os.getenv("FRED_API_KEY"))

def fetch_daily_prices(start="2010-01-01"):
    wti = fred.get_series("DCOILWTICO", observation_start=start)
    brent = fred.get_series("DCOILBRENTEU", observation_start=start)

    df = pd.DataFrame({"wti_price": wti, "brent_price": brent})
    df.index.name = "date"
    df = df.dropna(subset=["wti_price"])  # trading days only
    return df
```

### 2B. Weekly EIA Petroleum Data

Use EIA API v2. The key series (all weekly, units in thousand barrels or percent):

| Series ID (API v2 route) | Description |
|---------------------------|-------------|
| petroleum/sum/sndw/data (series: WCESTUS1) | U.S. ending stocks of crude oil |
| petroleum/sum/sndw/data (series: WCRSTUS1) | U.S. crude oil production |
| petroleum/sum/sndw/data (series: WCRIMUS2) | U.S. crude oil imports |
| petroleum/sum/sndw/data (series: WCREXUS2) | U.S. crude oil exports |
| petroleum/sum/sndw/data (series: WGIRIUS2) | U.S. refinery crude inputs |
| petroleum/sum/sndw/data (series: WPULEUS3) | U.S. refinery utilization (%) |
| petroleum/sum/sndw/data (series: W_EPC0_SAX_YCUOK_MBBL) | Cushing OK crude stocks |

Alternative approach if API v2 routing is complex: use direct URL pattern:
```
https://api.eia.gov/v2/petroleum/sum/sndw/data/?api_key={KEY}&frequency=weekly&data[0]=value&facets[series][]={SERIES_ID}&start=2010-01-01&sort[0][column]=period&sort[0][direction]=asc&length=5000
```

```python
# src/fetch_eia.py
import os
import requests
import pandas as pd
from dotenv import load_dotenv

load_dotenv()
EIA_KEY = os.getenv("EIA_API_KEY")

EIA_SERIES = {
    "us_crude_stocks": "WCESTUS1",
    "us_crude_production": "WCRSTUS1",
    "crude_imports": "WCRIMUS2",
    "crude_exports": "WCREXUS2",
    "refinery_inputs": "WGIRIUS2",
    "refinery_utilization": "WPULEUS3",
    "cushing_stocks": "W_EPC0_SAX_YCUOK_MBBL",
}

def fetch_eia_series(series_id, start="2010-01-01"):
    """Fetch a single EIA weekly petroleum series via API v2."""
    url = "https://api.eia.gov/v2/petroleum/sum/sndw/data/"
    params = {
        "api_key": EIA_KEY,
        "frequency": "weekly",
        "data[0]": "value",
        "facets[series][]": series_id,
        "start": start,
        "sort[0][column]": "period",
        "sort[0][direction]": "asc",
        "length": 5000,
    }
    resp = requests.get(url, params=params)
    resp.raise_for_status()
    data = resp.json()["response"]["data"]
    df = pd.DataFrame(data)
    df["period"] = pd.to_datetime(df["period"])
    df = df.rename(columns={"period": "week_end", "value": "value"})
    df["value"] = pd.to_numeric(df["value"], errors="coerce")
    return df[["week_end", "value"]].dropna().set_index("week_end").sort_index()

def fetch_all_eia(start="2010-01-01"):
    """Fetch all EIA series and merge into one DataFrame."""
    frames = {}
    for name, sid in EIA_SERIES.items():
        print(f"  Fetching {name} ({sid})...")
        frames[name] = fetch_eia_series(sid, start)["value"].rename(name)
    df = pd.concat(frames.values(), axis=1)
    df.index.name = "week_end"
    return df
```

**IMPORTANT: Release-date alignment.**

EIA WPSR is released on Wednesdays (usually), covering data through the prior Friday. The market reacts on the release date, not the week-end date. For this project, approximate:
- `release_date = week_end + 4 business days` (Wednesday after the Friday week-end)
- Or use actual release dates from EIA schedule if available.

This is critical for avoiding look-ahead bias. In the notebook, explicitly note this alignment.

---

## 3. Build Supply-Demand Balance

```python
# src/build_balance.py
import pandas as pd

def build_crude_balance(eia_df):
    """
    Crude balance identity (approximate):
    crude_balance = production + imports - exports - refinery_inputs
    
    Observed outcome: inventory_change = stocks[t] - stocks[t-1]
    Residual: balance - inventory_change (captures adjustments, timing, measurement error)
    """
    df = eia_df.copy()
    
    # Weekly changes
    df["inventory_change"] = df["us_crude_stocks"].diff()
    df["cushing_change"] = df["cushing_stocks"].diff()
    
    # Supply-demand balance (all in thousand barrels)
    df["crude_supply"] = df["us_crude_production"] + df["crude_imports"]
    df["crude_demand"] = df["crude_exports"] + df["refinery_inputs"]
    df["crude_balance"] = df["crude_supply"] - df["crude_demand"]
    
    # Residual: implied vs observed
    df["balance_residual"] = df["crude_balance"] - df["inventory_change"]
    
    return df.dropna()
```

This is the core of the project. It shows you understand the physical accounting identity that commodity analysts use.

---

## 4. Feature Engineering

```python
# src/build_features.py
import numpy as np
import pandas as pd

def compute_shock_zscore(series, window=52):
    """Z-score relative to trailing 52-week mean/std (seasonal adjustment proxy)."""
    rolling_mean = series.rolling(window, min_periods=26).mean()
    rolling_std = series.rolling(window, min_periods=26).std()
    return (series - rolling_mean) / rolling_std

def build_features(balance_df, prices_df):
    """
    Merge weekly fundamentals with daily prices, engineer features.
    """
    df = balance_df.copy()
    
    # --- Fundamental shock features ---
    df["inventory_shock_z"] = compute_shock_zscore(df["inventory_change"])
    df["cushing_shock_z"] = compute_shock_zscore(df["cushing_change"])
    df["production_change"] = df["us_crude_production"].diff()
    df["production_shock_z"] = compute_shock_zscore(df["production_change"])
    df["refinery_util_change"] = df["refinery_utilization"].diff()
    df["net_imports"] = df["crude_imports"] - df["crude_exports"]
    df["net_import_change"] = df["net_imports"].diff()
    
    # --- Tightness indicators ---
    # Days of supply (crude stocks / refinery inputs)
    df["days_of_supply"] = df["us_crude_stocks"] / df["refinery_inputs"] * 7
    df["days_of_supply_z"] = compute_shock_zscore(df["days_of_supply"])
    
    # --- Approximate release date (Wednesday after week-end Friday) ---
    df["release_date"] = df.index + pd.offsets.Week(weekday=2)  # next Wednesday
    # If week_end is already a Friday, +5 calendar days = Wednesday
    # More robust: shift by 4-5 business days
    df["release_date"] = df.index.map(
        lambda d: d + pd.offsets.BDay(4)
    )
    
    # --- Merge with daily prices on release_date ---
    prices = prices_df.copy()
    prices["brent_wti_spread"] = prices["brent_price"] - prices["wti_price"]
    prices["wti_return"] = np.log(prices["wti_price"] / prices["wti_price"].shift(1))
    
    # Forward-looking market outcomes (measured AFTER release)
    # 5-day forward realized volatility
    prices["fwd_5d_wti_vol"] = (
        prices["wti_return"]
        .shift(-5)  # we need future 5 days
        .rolling(5)
        .std()
        * np.sqrt(252)
    )
    # Better approach: for each date, compute vol of next 5 days
    # Use a loop or vectorized forward window
    fwd_vol = []
    fwd_spread_change = []
    fwd_return = []
    for i in range(len(prices)):
        future_slice = prices.iloc[i+1:i+6]  # next 5 trading days
        if len(future_slice) >= 4:
            fwd_vol.append(future_slice["wti_return"].std() * np.sqrt(252))
            fwd_spread_change.append(
                future_slice["brent_wti_spread"].iloc[-1] - prices["brent_wti_spread"].iloc[i]
            )
            fwd_return.append(
                future_slice["wti_return"].sum()
            )
        else:
            fwd_vol.append(np.nan)
            fwd_spread_change.append(np.nan)
            fwd_return.append(np.nan)
    
    prices["fwd_5d_realized_vol"] = fwd_vol
    prices["fwd_5d_spread_change"] = fwd_spread_change
    prices["fwd_5d_wti_return"] = fwd_return
    
    # Trailing volatility and spread z-score
    prices["trailing_20d_vol"] = prices["wti_return"].rolling(20).std() * np.sqrt(252)
    spread_mean = prices["brent_wti_spread"].rolling(60).mean()
    spread_std = prices["brent_wti_spread"].rolling(60).std()
    prices["spread_zscore"] = (prices["brent_wti_spread"] - spread_mean) / spread_std
    
    # --- Merge: align EIA release dates to price data ---
    df_reset = df.reset_index()
    merged = pd.merge_asof(
        df_reset.sort_values("release_date"),
        prices.reset_index().sort_values("date"),
        left_on="release_date",
        right_on="date",
        direction="nearest",
        tolerance=pd.Timedelta("2D"),
    )
    
    return merged.dropna(subset=["fwd_5d_realized_vol", "inventory_shock_z"])
```

Target feature count for resume: **15-20 features** including:
- Supply-demand balance features (6): inventory_change, cushing_change, production_change, net_import_change, refinery_util_change, crude_balance
- Shock z-scores (4): inventory_shock_z, cushing_shock_z, production_shock_z, days_of_supply_z
- Market features (5): brent_wti_spread, spread_zscore, trailing_20d_vol, wti_return, fwd_5d_realized_vol
- Event dummies (4): top_decile_inventory_draw, top_decile_inventory_build, top_decile_cushing_draw, top_decile_cushing_build

---

## 5. Event-Study Analysis

```python
# src/event_study.py
import numpy as np
import pandas as pd
from scipy import stats

def run_event_study(df, shock_col, outcome_col, quantile=0.10):
    """
    Compare market outcomes after extreme positive vs negative shocks.
    
    Parameters:
    - shock_col: e.g. "inventory_shock_z" or "cushing_shock_z"
    - outcome_col: e.g. "fwd_5d_realized_vol" or "fwd_5d_spread_change"
    - quantile: threshold for extreme events (0.10 = top/bottom decile)
    
    Returns dict with summary statistics.
    """
    clean = df[[shock_col, outcome_col]].dropna()
    
    low_threshold = clean[shock_col].quantile(quantile)
    high_threshold = clean[shock_col].quantile(1 - quantile)
    
    # For inventory: negative shock = draw (bullish), positive = build (bearish)
    draws = clean[clean[shock_col] <= low_threshold][outcome_col]
    builds = clean[clean[shock_col] >= high_threshold][outcome_col]
    
    t_stat, p_value = stats.ttest_ind(draws, builds, equal_var=False)
    
    result = {
        "shock_variable": shock_col,
        "outcome_variable": outcome_col,
        "n_draws": len(draws),
        "n_builds": len(builds),
        "mean_outcome_after_draw": draws.mean(),
        "mean_outcome_after_build": builds.mean(),
        "difference": draws.mean() - builds.mean(),
        "t_statistic": t_stat,
        "p_value": p_value,
        "significant_5pct": p_value < 0.05,
    }
    return result


def run_all_event_studies(df):
    """Run the two core event studies."""
    results = []
    
    # Study 1: Inventory shock -> WTI volatility
    r1 = run_event_study(df, "inventory_shock_z", "fwd_5d_realized_vol")
    r1["study"] = "Inventory Draw vs Build -> WTI 5-day Volatility"
    results.append(r1)
    
    # Study 2: Cushing shock -> Brent-WTI spread change
    r2 = run_event_study(df, "cushing_shock_z", "fwd_5d_spread_change")
    r2["study"] = "Cushing Draw vs Build -> Brent-WTI Spread Change"
    results.append(r2)
    
    # Bonus: Inventory shock -> WTI 5-day return (directional)
    r3 = run_event_study(df, "inventory_shock_z", "fwd_5d_wti_return")
    r3["study"] = "Inventory Draw vs Build -> WTI 5-day Return"
    results.append(r3)
    
    return pd.DataFrame(results)
```

---

## 6. Visualization

Generate these 5 key figures:

### Figure 1: WTI & Brent Price History
- Dual-axis or overlay line chart of WTI and Brent spot prices
- Title: "WTI and Brent Crude Oil Spot Prices (2010-2024)"

### Figure 2: Brent-WTI Spread Time Series
- Line chart with horizontal line at 0
- Shade positive/negative differently
- Title: "Brent-WTI Spread ($\\/bbl)"

### Figure 3: U.S. Crude Inventories vs 5-Year Seasonal Range
- Current year inventories overlaid on 5-year min/max band
- Title: "U.S. Commercial Crude Stocks vs 5-Year Seasonal Range"

### Figure 4: Event Study - Inventory Shock vs Forward Volatility
- Box plot or bar chart comparing fwd_5d_realized_vol for extreme draws vs extreme builds
- Include error bars or confidence interval
- Title: "5-Day WTI Realized Volatility After Extreme Inventory Draws vs Builds"

### Figure 5: Event Study - Cushing Shock vs Forward Spread Change
- Same structure as Figure 4 but for Cushing shock -> spread change
- Title: "5-Day Brent-WTI Spread Change After Extreme Cushing Draws vs Builds"

```python
# Visualization code (in notebook or separate file)
import matplotlib.pyplot as plt
import seaborn as sns

def plot_event_study_comparison(df, shock_col, outcome_col, title, ylabel, quantile=0.10):
    """Bar chart comparing outcomes after extreme draws vs builds."""
    clean = df[[shock_col, outcome_col]].dropna()
    low_q = clean[shock_col].quantile(quantile)
    high_q = clean[shock_col].quantile(1 - quantile)
    
    draws = clean[clean[shock_col] <= low_q][outcome_col]
    builds = clean[clean[shock_col] >= high_q][outcome_col]
    
    fig, ax = plt.subplots(figsize=(8, 5))
    
    means = [draws.mean(), builds.mean()]
    sems = [draws.sem(), builds.sem()]
    labels = [f"Extreme Draws\n(n={len(draws)})", f"Extreme Builds\n(n={len(builds)})"]
    colors = ["#d62728", "#2ca02c"]
    
    bars = ax.bar(labels, means, yerr=[1.96*s for s in sems], 
                  color=colors, alpha=0.7, capsize=10, edgecolor="black", linewidth=0.8)
    
    ax.axhline(0, color="gray", linestyle="--", linewidth=0.8)
    ax.set_ylabel(ylabel)
    ax.set_title(title)
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    
    plt.tight_layout()
    return fig
```

---

## 7. Notebook Flow (01_crude_sd_inventory_shock_study.ipynb)

The notebook should follow this exact structure:

```python
# Cell 1: Title and Objective
"""
# Crude Supply-Demand Balance & Inventory Shock Study

**Objective:** Evaluate whether EIA weekly crude inventory and Cushing stock shocks
are associated with systematic changes in near-term WTI realized volatility 
and Brent-WTI spread behavior.

**This is NOT a price prediction model.** It is a fundamental research workflow:
EIA supply-demand data → inventory/Cushing shock metrics → market risk diagnostics.

**Data sources:** FRED (WTI/Brent daily spot prices), EIA API v2 (Weekly Petroleum Status Report)
"""

# Cell 2: Imports and setup
import os, sys
sys.path.insert(0, os.path.join(os.getcwd(), "src"))
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from dotenv import load_dotenv
load_dotenv()

from fetch_prices import fetch_daily_prices
from fetch_eia import fetch_all_eia
from build_balance import build_crude_balance
from build_features import build_features, compute_shock_zscore
from event_study import run_event_study, run_all_event_studies

# Cell 3: Fetch daily prices
prices = fetch_daily_prices(start="2010-01-01")
print(f"Daily prices: {len(prices)} observations, {prices.index.min()} to {prices.index.max()}")
prices.tail()

# Cell 4: Fetch EIA weekly data
eia = fetch_all_eia(start="2010-01-01")
print(f"EIA weekly: {len(eia)} observations, {eia.index.min()} to {eia.index.max()}")
eia.tail()

# Cell 5: Build supply-demand balance
balance = build_crude_balance(eia)
print(f"Balance table: {len(balance)} weeks")
balance[["crude_supply", "crude_demand", "crude_balance", "inventory_change", "balance_residual"]].describe()

# Cell 6: Display supply-demand identity
"""
## Supply-Demand Balance Identity

```
crude_balance = (production + imports) - (exports + refinery_inputs)
```

- If crude_balance > 0: implied stock build
- If crude_balance < 0: implied stock draw
- balance_residual = crude_balance - observed_inventory_change (captures adjustments)
"""

# Cell 7: Build features and merge
merged = build_features(balance, prices)
print(f"Merged event table: {len(merged)} EIA release weeks with market data")
print(f"Features: {merged.columns.tolist()}")

# Cell 8: Release-date alignment note
"""
## Release-Date Alignment (No Look-Ahead Bias)

EIA WPSR reports week-ending Friday data, released the following Wednesday.
Market outcomes (fwd_5d_realized_vol, fwd_5d_spread_change) are measured 
starting from the release date, ensuring no forward-looking information leakage.

This detail matters for commodity research credibility.
"""

# Cell 9: Figure 1 - Price history
fig, ax = plt.subplots(figsize=(12, 5))
ax.plot(prices.index, prices["wti_price"], label="WTI", alpha=0.8)
ax.plot(prices.index, prices["brent_price"], label="Brent", alpha=0.8)
ax.set_ylabel("$/bbl")
ax.set_title("WTI and Brent Crude Oil Spot Prices")
ax.legend()
plt.tight_layout()
plt.savefig("outputs/figures/01_price_history.png", dpi=150)
plt.show()

# Cell 10: Figure 2 - Brent-WTI spread
fig, ax = plt.subplots(figsize=(12, 4))
spread = prices["brent_price"] - prices["wti_price"]
ax.plot(prices.index, spread, color="purple", alpha=0.7)
ax.axhline(0, color="gray", linestyle="--")
ax.fill_between(prices.index, spread, 0, where=spread>0, alpha=0.1, color="blue")
ax.fill_between(prices.index, spread, 0, where=spread<0, alpha=0.1, color="red")
ax.set_ylabel("$/bbl")
ax.set_title("Brent-WTI Spread")
plt.tight_layout()
plt.savefig("outputs/figures/02_brent_wti_spread.png", dpi=150)
plt.show()

# Cell 11: Figure 3 - Inventory seasonality
# (compute 5-year seasonal band)
# Group by week-of-year, compute min/max/mean over trailing 5 years

# Cell 12: Event Study Results
results = run_all_event_studies(merged)
print(results.to_string(index=False))
results.to_csv("outputs/tables/event_study_results.csv", index=False)

# Cell 13: Figure 4 - Inventory shock -> volatility
fig = plot_event_study_comparison(
    merged, "inventory_shock_z", "fwd_5d_realized_vol",
    "5-Day WTI Realized Volatility After Extreme Inventory Shocks",
    "Annualized Volatility"
)
plt.savefig("outputs/figures/04_inventory_shock_volatility.png", dpi=150)
plt.show()

# Cell 14: Figure 5 - Cushing shock -> spread
fig = plot_event_study_comparison(
    merged, "cushing_shock_z", "fwd_5d_spread_change",
    "5-Day Brent-WTI Spread Change After Extreme Cushing Shocks",
    "Spread Change ($/bbl)"
)
plt.savefig("outputs/figures/05_cushing_shock_spread.png", dpi=150)
plt.show()

# Cell 15: Summary statistics table
summary = merged[[
    "inventory_shock_z", "cushing_shock_z", "production_shock_z",
    "days_of_supply_z", "spread_zscore", "trailing_20d_vol",
    "fwd_5d_realized_vol", "fwd_5d_spread_change"
]].describe().round(3)
summary.to_csv("outputs/tables/feature_summary_stats.csv")
print(summary)

# Cell 16: Market Interpretation
"""
## Market Interpretation

1. **Inventory draws signal tightness.** Large crude stock drawdowns are associated 
   with elevated near-term WTI volatility, consistent with the market pricing 
   supply uncertainty.

2. **Cushing matters for WTI-specific pricing.** Cushing is the WTI delivery hub; 
   extreme Cushing draws create local tightness that widens the Brent-WTI spread 
   (or narrows it depending on direction), distinct from national inventory signals.

3. **This is a diagnostic framework, not a trading signal.** The purpose is 
   fundamental monitoring — translating physical supply-demand changes into 
   risk-relevant market metrics — not generating standalone alpha.
"""

# Cell 17: Limitations
"""
## Limitations

- EIA release dates are approximated (actual Wednesday release assumed).
- No survey expectations: ideally, shock = actual - consensus forecast.
- No futures curve data (contango/backwardation structure).
- No options-implied volatility comparison.
- No OPEC+ decision events or geopolitical overlays.
- This is diagnostic research, not a standalone trading strategy.
"""
```

---

## 8. Key Design Decisions (Defend These in Interview)

1. **Why not predict price levels?**
   Commodity analysts care about spreads, volatility, and tightness — not flat price forecasts. Price level prediction is econometrically problematic (non-stationary) and doesn't connect to trading/risk decisions.

2. **Why release-date alignment?**
   Without it, you have look-ahead bias: you'd be measuring market reactions before the market knew the data. This is the single most important data-engineering detail in the project.

3. **Why z-scores instead of raw changes?**
   A 5M-barrel inventory draw in summer (high refinery demand season) means something different than in winter. The z-score relative to trailing 52 weeks acts as a rough seasonal adjustment.

4. **Why Brent-WTI spread, not just WTI price?**
   Brent-WTI spread reflects regional supply-demand imbalances (Cushing congestion, pipeline capacity, export constraints). It's what arb traders and physical desks actually watch.

5. **Why forward 5-day window?**
   One day is too noisy. One month loses the signal in other events. Five trading days captures the immediate market digestion of the EIA release.

---

## 9. Expected Results

You should expect to find (based on prior research and market structure):

- **Inventory draws → higher short-term vol:** Large unexpected draws create uncertainty about supply adequacy, increasing volatility. Difference should be 2-8 annualized vol points.
- **Cushing draws → some spread effect:** When Cushing stocks fall sharply, WTI strengthens vs Brent (spread narrows) because Cushing is the WTI delivery point. Effect may be $0.20-$1.00/bbl.
- **Effects may be asymmetric:** Draws may have stronger effects than builds (tightness is scarier than surplus).

If results are not statistically significant, that is ALSO a valid finding. Write: "Ran event-study diagnostics across N EIA release weeks; point estimates suggest [direction] but lack statistical significance at conventional levels, consistent with the high noise-to-signal ratio in weekly commodity markets."

---

## 10. Resume Bullets (Use After Running)

### If results ARE significant:

```
• Built a Python commodity analytics pipeline using pandas, NumPy, FRED, and EIA petroleum
  data to align 10+ years of daily WTI/Brent prices with 500+ weekly EIA releases across
  crude inventories, Cushing stocks, refinery utilization, production, and import/export data.

• Engineered 18 supply-demand balance, inventory-shock, spread, and volatility features;
  found top-decile crude inventory draws were followed by [X] pp higher 5-day WTI realized
  volatility than top-decile builds (p < 0.05) across [N] EIA release observations.
```

### If results are NOT significant:

```
• Built a Python commodity analytics pipeline using pandas, NumPy, FRED, and EIA petroleum
  data to align 10+ years of daily WTI/Brent prices with 500+ weekly EIA releases across
  crude inventories, Cushing stocks, refinery utilization, production, and import/export data.

• Engineered 18 supply-demand balance, inventory-shock, spread, and volatility features;
  ran release-date-aligned event-study diagnostics to quantify how EIA fundamental surprises
  transmit into next-week WTI volatility and Brent-WTI spread behavior.
```

---

## 11. What to Run First (MVP in <4 hours)

Priority order:
1. Get API keys (FRED + EIA) — 10 min
2. Run `fetch_prices.py` — confirm you get WTI/Brent data
3. Run `fetch_eia.py` — confirm you get 7 EIA series
4. Run `build_balance.py` — see the supply-demand identity work
5. Run `build_features.py` — merge and get the event table
6. Run `event_study.py` — get your headline numbers
7. Make 2-3 charts — save to outputs/figures/
8. Write README — copy from Section 13 of the GPT plan

After this, you have a working project with real numbers.

---

## 12. Fallback if EIA API Fails

If the EIA API v2 is unreliable or rate-limited:

**Option A:** Download CSVs manually from https://www.eia.gov/petroleum/supply/weekly/
- Go to "Downloads" tab
- Get the full history XLS/CSV files

**Option B:** Use FRED for some series:
- WCRSTUS1 (crude production) is also on FRED
- Some inventory series are on FRED

**Option C:** Use the `myeia` package:
```bash
pip install myeia
```
```python
from myeia.api import API
eia = API(token=os.getenv("EIA_API_KEY"))
df = eia.get_series(series_id="WCESTUS1")
```

---

## 13. .gitignore

```
.env
.venv/
data/raw/
__pycache__/
*.pyc
.ipynb_checkpoints/
```

---

## 14. Final Checklist Before Committing

- [ ] All API keys are in .env and gitignored
- [ ] No hardcoded API keys anywhere in code
- [ ] release_date alignment is documented in notebook
- [ ] At least 2 event-study results with real numbers
- [ ] At least 3 figures saved in outputs/figures/
- [ ] README has Objective, Data, Method, Outputs, Limitations
- [ ] No LSTM, no "price prediction" language anywhere
- [ ] Feature count matches what resume says (15-20)
- [ ] Notebook runs end-to-end without errors
