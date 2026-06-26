# Extension Instruction: Weekly Analyst Memo Auto-Generation

## Context

This is an extension to an existing crude oil supply-demand research project. The base project already has:
- `data/raw/daily_prices.csv` — daily WTI and Brent spot prices
- `data/raw/eia_weekly.csv` — 7 weekly EIA petroleum series
- `data/processed/crude_balance.csv` — supply-demand balance (858 rows)
- `data/processed/merged_event_table.csv` — 858 rows × 37 columns with all features
- `src/` with modules: fetch_prices.py, fetch_eia.py, build_balance.py, build_features.py, event_study.py, figures.py
- Optionally `src/risk_overlay.py` if the GARCH extension was already built

**Do NOT modify or break any existing files.** Only add new files.

---

## 1. Purpose

Commodity research analysts produce weekly market commentary summarizing the latest EIA release, assessing market tone, and flagging key risks. This module automatically generates a structured weekly crude market memo from the project's data pipeline output.

The memo demonstrates the ability to translate quantitative supply-demand signals into analyst-readable market judgment — a core skill for commodity research roles.

---

## 2. Create Directory

```
outputs/memos/          # Weekly memo markdown files go here
```

---

## 3. Create `src/generate_memo.py`

### 3A. Imports

```python
from __future__ import annotations
import pandas as pd
import numpy as np
from pathlib import Path
from datetime import datetime
```

### 3B. Function: `load_latest_data(merged_path, balance_path) -> dict`

Load the most recent observation from the processed data:

```python
def load_latest_data(
    merged_path="data/processed/merged_event_table.csv",
    balance_path="data/processed/crude_balance.csv",
) -> dict:
    merged = pd.read_csv(merged_path, parse_dates=["week_end"])
    balance = pd.read_csv(balance_path, parse_dates=["week_end"])
    
    latest = merged.iloc[-1]
    prev = merged.iloc[-2]
    
    # Also get recent history for streak detection
    recent = merged.tail(8).copy()
    
    return {
        "latest": latest,
        "prev": prev,
        "recent": recent,
        "merged": merged,
        "balance": balance,
    }
```

### 3C. Function: `assess_inventory(data: dict) -> dict`

Evaluate the inventory situation:

```python
def assess_inventory(data: dict) -> dict:
    latest = data["latest"]
    recent = data["recent"]
    
    inv_change = latest.get("inventory_change", np.nan)
    inv_shock_z = latest.get("inventory_shock_z", np.nan)
    cushing_change = latest.get("cushing_change", np.nan)
    cushing_shock_z = latest.get("cushing_shock_z", np.nan)
    us_stocks = latest.get("us_crude_stocks", np.nan)
    cushing_stocks = latest.get("cushing_stocks", np.nan)
    
    # Inventory assessment
    if inv_shock_z < -1.5:
        inv_tone = "Strongly Bullish"
        inv_reason = f"Large inventory draw ({inv_change:+.1f} kb), {abs(inv_shock_z):.1f} std below seasonal norm"
    elif inv_shock_z < -0.5:
        inv_tone = "Moderately Bullish"
        inv_reason = f"Inventory draw ({inv_change:+.1f} kb), {abs(inv_shock_z):.1f} std below seasonal norm"
    elif inv_shock_z > 1.5:
        inv_tone = "Strongly Bearish"
        inv_reason = f"Large inventory build ({inv_change:+.1f} kb), {inv_shock_z:.1f} std above seasonal norm"
    elif inv_shock_z > 0.5:
        inv_tone = "Moderately Bearish"
        inv_reason = f"Inventory build ({inv_change:+.1f} kb), {inv_shock_z:.1f} std above seasonal norm"
    else:
        inv_tone = "Neutral"
        inv_reason = f"Inventory change ({inv_change:+.1f} kb) within seasonal norms (z={inv_shock_z:.2f})"
    
    # Cushing assessment
    if cushing_shock_z < -1.0:
        cushing_tone = "WTI Tightening"
        cushing_reason = f"Cushing draw ({cushing_change:+.1f} kb), approaching operational constraints"
    elif cushing_shock_z > 1.0:
        cushing_tone = "WTI Loosening"
        cushing_reason = f"Cushing build ({cushing_change:+.1f} kb), storage comfortable"
    else:
        cushing_tone = "Neutral"
        cushing_reason = f"Cushing change ({cushing_change:+.1f} kb) within normal range"
    
    # Consecutive draw/build streak
    recent_changes = recent["inventory_change"].dropna()
    if len(recent_changes) >= 2:
        if (recent_changes.tail(3) < 0).all():
            streak_note = f"Third consecutive weekly draw"
        elif (recent_changes.tail(2) < 0).all():
            streak_note = f"Second consecutive weekly draw"
        elif (recent_changes.tail(3) > 0).all():
            streak_note = f"Third consecutive weekly build"
        elif (recent_changes.tail(2) > 0).all():
            streak_note = f"Second consecutive weekly build"
        else:
            streak_note = None
    else:
        streak_note = None
    
    return {
        "inv_change": inv_change,
        "inv_shock_z": inv_shock_z,
        "inv_tone": inv_tone,
        "inv_reason": inv_reason,
        "cushing_change": cushing_change,
        "cushing_shock_z": cushing_shock_z,
        "cushing_stocks": cushing_stocks,
        "cushing_tone": cushing_tone,
        "cushing_reason": cushing_reason,
        "us_stocks": us_stocks,
        "streak_note": streak_note,
    }
```

### 3D. Function: `assess_supply_demand(data: dict) -> dict`

Evaluate supply-demand balance:

```python
def assess_supply_demand(data: dict) -> dict:
    latest = data["latest"]
    
    production = latest.get("us_crude_production", np.nan)
    production_change = latest.get("production_change", np.nan)
    refinery_util = latest.get("refinery_utilization", np.nan)
    refinery_util_change = latest.get("refinery_util_change", np.nan)
    net_imports = latest.get("net_imports", np.nan)
    crude_balance = latest.get("implied_stock_change_kbbl", latest.get("crude_balance", np.nan))
    balance_residual = latest.get("balance_residual_kbbl", latest.get("balance_residual", np.nan))
    crude_supply_kbd = latest.get("crude_supply_kbd", np.nan)
    crude_demand_kbd = latest.get("crude_demand_kbd", np.nan)
    crude_supply_kbbl_week = latest.get("crude_supply_kbbl_week", np.nan)
    crude_demand_kbbl_week = latest.get("crude_demand_kbbl_week", np.nan)
    days_of_supply = latest.get("days_of_supply", np.nan)
    weeks_of_supply = latest.get("weeks_of_supply", np.nan)
    
    # Production assessment
    if not np.isnan(production_change):
        if production_change > 50:
            prod_note = f"Production rose {production_change:.0f} kb/d w/w — supply expanding"
        elif production_change < -50:
            prod_note = f"Production fell {abs(production_change):.0f} kb/d w/w — supply contracting"
        else:
            prod_note = f"Production roughly flat ({production_change:+.0f} kb/d w/w)"
    else:
        prod_note = "Production data unavailable"
    
    # Refinery utilization assessment
    if not np.isnan(refinery_util):
        if refinery_util > 93:
            ref_note = f"Refinery utilization high at {refinery_util:.1f}% — strong crude demand"
        elif refinery_util < 85:
            ref_note = f"Refinery utilization low at {refinery_util:.1f}% — weak crude demand (maintenance season or demand weakness)"
        else:
            ref_note = f"Refinery utilization at {refinery_util:.1f}% — normal range"
    else:
        ref_note = "Refinery utilization data unavailable"
    
    # Balance assessment
    if not np.isnan(crude_balance):
        if crude_balance < -500:
            balance_note = f"Implied weekly stock draw of {abs(crude_balance):.0f} kbbl — supply < demand"
        elif crude_balance > 500:
            balance_note = f"Implied weekly stock build of {crude_balance:.0f} kbbl — supply > demand"
        else:
            balance_note = f"Supply-demand roughly balanced ({crude_balance:+.0f} kbbl/week)"
    else:
        balance_note = "Balance data unavailable"
    
    return {
        "production": production,
        "production_change": production_change,
        "prod_note": prod_note,
        "refinery_util": refinery_util,
        "refinery_util_change": refinery_util_change,
        "ref_note": ref_note,
        "net_imports": net_imports,
        "crude_balance": crude_balance,
        "balance_residual": balance_residual,
        "crude_supply_kbd": crude_supply_kbd,
        "crude_demand_kbd": crude_demand_kbd,
        "crude_supply_kbbl_week": crude_supply_kbbl_week,
        "crude_demand_kbbl_week": crude_demand_kbbl_week,
        "days_of_supply": days_of_supply,
        "weeks_of_supply": weeks_of_supply,
        "balance_note": balance_note,
    }
```

### 3E. Function: `assess_market(data: dict) -> dict`

Evaluate spread and volatility regime:

```python
def assess_market(data: dict) -> dict:
    latest = data["latest"]
    
    wti = latest.get("wti_price", np.nan)
    brent = latest.get("brent_price", np.nan)
    spread = latest.get("brent_wti_spread", np.nan)
    spread_z = latest.get("spread_zscore", np.nan)
    vol_20d = latest.get("trailing_20d_vol", np.nan)
    
    # Spread assessment
    if not np.isnan(spread_z):
        if spread_z > 1.5:
            spread_note = f"Brent premium elevated (${spread:.2f}/bbl, z={spread_z:.1f}) — potential Atlantic Basin tightness or WTI-specific weakness"
        elif spread_z < -1.5:
            spread_note = f"Brent premium compressed (${spread:.2f}/bbl, z={spread_z:.1f}) — WTI relatively strong vs Brent"
        else:
            spread_note = f"Brent-WTI spread at ${spread:.2f}/bbl (z={spread_z:.1f}) — within normal range"
    else:
        spread_note = f"Brent-WTI spread at ${spread:.2f}/bbl" if not np.isnan(spread) else "Spread data unavailable"
    
    # Volatility regime
    if not np.isnan(vol_20d):
        vol_annualized_pct = vol_20d * 100 if vol_20d < 1 else vol_20d
        if vol_annualized_pct > 40:
            vol_regime = "High"
            vol_note = f"20-day realized vol at {vol_annualized_pct:.1f}% — elevated risk environment"
        elif vol_annualized_pct > 25:
            vol_regime = "Moderate"
            vol_note = f"20-day realized vol at {vol_annualized_pct:.1f}% — moderate regime"
        else:
            vol_regime = "Low"
            vol_note = f"20-day realized vol at {vol_annualized_pct:.1f}% — quiet market"
    else:
        vol_regime = "Unknown"
        vol_note = "Volatility data unavailable"
    
    return {
        "wti": wti,
        "brent": brent,
        "spread": spread,
        "spread_z": spread_z,
        "spread_note": spread_note,
        "vol_20d": vol_20d,
        "vol_regime": vol_regime,
        "vol_note": vol_note,
    }
```

### 3F. Function: `determine_overall_tone(inv_assessment, sd_assessment, mkt_assessment) -> tuple[str, list[str]]`

Combine sub-assessments into one overall tone:

```python
def determine_overall_tone(inv, sd, mkt) -> tuple:
    """Return (tone_string, list_of_key_reasons)."""
    
    score = 0  # negative = bearish, positive = bullish
    reasons = []
    
    # Inventory signal (strongest weight)
    z = inv["inv_shock_z"]
    if not np.isnan(z):
        if z < -1.0:
            score += 2
            reasons.append(inv["inv_reason"])
        elif z < -0.5:
            score += 1
            reasons.append(inv["inv_reason"])
        elif z > 1.0:
            score -= 2
            reasons.append(inv["inv_reason"])
        elif z > 0.5:
            score -= 1
            reasons.append(inv["inv_reason"])
    
    # Cushing signal
    cz = inv["cushing_shock_z"]
    if not np.isnan(cz):
        if cz < -1.0:
            score += 1
            reasons.append(inv["cushing_reason"])
        elif cz > 1.0:
            score -= 1
            reasons.append(inv["cushing_reason"])
    
    # Refinery utilization
    ru = sd["refinery_util"]
    if not np.isnan(ru):
        if ru > 93:
            score += 1
            reasons.append(sd["ref_note"])
        elif ru < 85:
            score -= 1
            reasons.append(sd["ref_note"])
    
    # Determine tone label
    if score >= 3:
        tone = "Bullish"
    elif score >= 1:
        tone = "Moderately Bullish"
    elif score <= -3:
        tone = "Bearish"
    elif score <= -1:
        tone = "Moderately Bearish"
    else:
        tone = "Neutral"
    
    if not reasons:
        reasons.append("No strong directional signals this week")
    
    return tone, reasons
```

### 3G. Function: `identify_key_risk(inv, sd, mkt) -> str`

Identify the single most important risk to watch:

```python
def identify_key_risk(inv, sd, mkt) -> str:
    """Pick the top risk to flag for the week."""
    risks = []
    
    # Cushing approaching operational minimum (~22,000 kb)
    if not np.isnan(inv["cushing_stocks"]) and inv["cushing_stocks"] < 25000:
        risks.append(
            f"Cushing stocks at {inv['cushing_stocks']/1000:.1f} Mb, approaching "
            f"operational minimum (~22 Mb). Further draws could spike WTI basis."
        )
    
    # High volatility regime
    if mkt["vol_regime"] == "High":
        risks.append(
            f"Volatility elevated ({mkt['vol_note']}). "
            f"Risk of outsized moves on next EIA release or OPEC+ headlines."
        )
    
    # Extreme spread
    if not np.isnan(mkt["spread_z"]) and abs(mkt["spread_z"]) > 2.0:
        risks.append(
            f"Brent-WTI spread at extreme levels (z={mkt['spread_z']:.1f}). "
            f"Watch for mean-reversion or structural shift in Atlantic Basin flows."
        )
    
    # Low refinery utilization (demand concern)
    if not np.isnan(sd["refinery_util"]) and sd["refinery_util"] < 82:
        risks.append(
            f"Refinery utilization at {sd['refinery_util']:.1f}%, unusually low. "
            f"Potential demand-side weakness beyond seasonal maintenance."
        )
    
    # Large production change
    prod_z = None
    # Use production_shock_z if available from latest data
    # Otherwise skip
    
    if risks:
        return risks[0]  # Return highest-priority risk
    else:
        return (
            "No acute risk signals this week. Monitor EIA release for deviation "
            "from seasonal inventory patterns and any OPEC+ headline risk."
        )
```

### 3H. Function: `format_memo(data, inv, sd, mkt, tone, reasons, key_risk) -> str`

Generate the full markdown memo:

```python
def format_memo(data, inv, sd, mkt, tone, reasons, key_risk) -> str:
    latest = data["latest"]
    week_end = pd.Timestamp(latest["week_end"]).strftime("%B %d, %Y")
    
    # Approximate release date
    release_date = (pd.Timestamp(latest["week_end"]) + pd.offsets.BDay(3)).strftime("%B %d, %Y")
    
    memo = f"""# Weekly Crude Market Monitor

**Week Ending:** {week_end}
**Approximate Release Date:** {release_date}
**Overall Tone:** {tone}

---

## EIA Release Summary

| Metric | Level | Weekly Change | Shock Z-Score |
|--------|-------|--------------|---------------|
| U.S. Crude Stocks | {inv['us_stocks']/1000:.1f} Mb | {inv['inv_change']:+.1f} kb | {inv['inv_shock_z']:+.2f} |
| Cushing Stocks | {inv['cushing_stocks']/1000:.1f} Mb | {inv['cushing_change']:+.1f} kb | {inv['cushing_shock_z']:+.2f} |
| Production | {sd['production']:.0f} kb/d | {sd['production_change']:+.0f} kb/d | — |
| Refinery Utilization | {sd['refinery_util']:.1f}% | {sd['refinery_util_change']:+.1f} pp | — |
| Net Imports | {sd['net_imports']:.0f} kb/d | — | — |

## Supply-Demand Balance

{sd['balance_note']}

- Supply (production + imports): {sd['crude_supply_kbd']:.0f} kb/d ({sd['crude_supply_kbbl_week']:.0f} kbbl/week)
- Demand (exports + refinery inputs): {sd['crude_demand_kbd']:.0f} kb/d ({sd['crude_demand_kbbl_week']:.0f} kbbl/week)
- Implied stock change: {sd['crude_balance']:+.0f} kbbl/week
- Residual vs reported inventory change: {sd['balance_residual']:+.0f} kbbl
- Days of supply: {sd['days_of_supply']:.1f} days ({sd['weeks_of_supply']:.1f} weeks)

## Market Assessment

**Tone: {tone}**

"""
    for r in reasons:
        memo += f"- {r}\n"
    
    if inv["streak_note"]:
        memo += f"- {inv['streak_note']}\n"
    
    memo += f"""
## Spread & Volatility

- **WTI:** ${mkt['wti']:.2f}/bbl
- **Brent:** ${mkt['brent']:.2f}/bbl
- {mkt['spread_note']}
- {mkt['vol_note']}
- **Volatility Regime:** {mkt['vol_regime']}

## Key Risk

{key_risk}

---

*This memo is auto-generated from the Crude Supply-Demand Balance & Inventory 
Shock Monitor pipeline. Data sources: EIA Weekly Petroleum Status Report, 
FRED (WTI/Brent spot prices). Not investment advice.*
"""
    return memo
```

### 3I. Function: `generate_memo(merged_path, balance_path, output_dir) -> Path`

Main orchestration:

```python
def generate_memo(
    merged_path="data/processed/merged_event_table.csv",
    balance_path="data/processed/crude_balance.csv",
    output_dir="outputs/memos",
) -> Path:
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    
    data = load_latest_data(merged_path, balance_path)
    inv = assess_inventory(data)
    sd = assess_supply_demand(data)
    mkt = assess_market(data)
    tone, reasons = determine_overall_tone(inv, sd, mkt)
    key_risk = identify_key_risk(inv, sd, mkt)
    
    memo_text = format_memo(data, inv, sd, mkt, tone, reasons, key_risk)
    
    # Filename based on week-end date
    week_end_str = pd.Timestamp(data["latest"]["week_end"]).strftime("%Y-%m-%d")
    output_path = output_dir / f"weekly_crude_monitor_{week_end_str}.md"
    output_path.write_text(memo_text, encoding="utf-8")
    
    print(f"Memo generated: {output_path}")
    print(f"Overall tone: {tone}")
    print(f"Key risk: {key_risk[:80]}...")
    
    return output_path
```

### 3J. Function: `generate_all_historical_memos(merged_path, balance_path, output_dir, last_n=4) -> list[Path]`

Generate memos for the most recent N weeks to show the memo evolves over time:

```python
def generate_all_historical_memos(
    merged_path="data/processed/merged_event_table.csv",
    balance_path="data/processed/crude_balance.csv",
    output_dir="outputs/memos",
    last_n=4,
) -> list:
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    
    merged = pd.read_csv(merged_path, parse_dates=["week_end"])
    balance = pd.read_csv(balance_path, parse_dates=["week_end"])
    
    paths = []
    for i in range(last_n, 0, -1):
        idx = len(merged) - i
        if idx < 1:
            continue
        
        # Create a slice that makes this row the "latest"
        data = {
            "latest": merged.iloc[idx],
            "prev": merged.iloc[idx - 1],
            "recent": merged.iloc[max(0, idx-7):idx+1],
            "merged": merged,
            "balance": balance,
        }
        
        inv = assess_inventory(data)
        sd = assess_supply_demand(data)
        mkt = assess_market(data)
        tone, reasons = determine_overall_tone(inv, sd, mkt)
        key_risk = identify_key_risk(inv, sd, mkt)
        memo_text = format_memo(data, inv, sd, mkt, tone, reasons, key_risk)
        
        week_end_str = pd.Timestamp(data["latest"]["week_end"]).strftime("%Y-%m-%d")
        path = output_dir / f"weekly_crude_monitor_{week_end_str}.md"
        path.write_text(memo_text, encoding="utf-8")
        paths.append(path)
        print(f"  Generated: {path.name} — Tone: {tone}")
    
    return paths
```

---

## 4. Extend Notebook

Add new cells to the END of `notebooks/01_crude_sd_inventory_shock_study.ipynb`.

### New Cell (markdown):
```markdown
## Weekly Analyst Memo

A commodity research analyst's core output is translating fundamental data into 
market judgment. This section demonstrates automated memo generation from the 
pipeline's quantitative signals.

The memo template follows industry convention: EIA release summary table, 
supply-demand balance assessment, bullish/bearish tone with supporting evidence, 
spread and volatility regime, and key risk identification.
```

### New Cell (code):
```python
from generate_memo import generate_memo, generate_all_historical_memos

# Generate memo for the latest week
latest_memo_path = generate_memo()

# Generate memos for the last 4 weeks to show evolution
print("\n--- Generating historical memos ---")
historical_paths = generate_all_historical_memos(last_n=4)
print(f"\nGenerated {len(historical_paths)} memos in outputs/memos/")
```

### New Cell (code):
```python
# Display the latest memo
latest_memo_text = latest_memo_path.read_text(encoding="utf-8")
from IPython.display import Markdown
Markdown(latest_memo_text)
```

### New Cell (markdown):
```markdown
### Memo Design Notes

- **Tone scoring** is rule-based, driven by inventory shock z-scores, Cushing 
  tightness, and refinery utilization. This is a structured approximation of 
  the qualitative judgment an analyst makes each week.

- **Key risk identification** prioritizes: Cushing operational minimum, 
  volatility regime shift, extreme spread levels, and refinery demand weakness.

- **Streak detection** flags consecutive draws or builds, which traders watch 
  as trend signals.

- The memo is generated from the same data pipeline as the event study — 
  ensuring consistency between quantitative analysis and qualitative commentary.
```

---

## 5. Update README.md

Add a new section:

```markdown
## Weekly Market Commentary

The pipeline auto-generates analyst-style weekly crude market memos from 
quantitative signals. Each memo includes:

- EIA release summary table (stocks, Cushing, production, refinery utilization)
- Supply-demand balance assessment
- Overall market tone (Bullish/Bearish/Neutral) with supporting evidence
- Spread and volatility regime assessment
- Key risk identification

Sample memos for the most recent 4 weeks are in `outputs/memos/`.
```

Update "Outputs" section to include:
```
- Weekly analyst memos (outputs/memos/)
```

---

## 6. Verification Checklist

After building everything, verify:

- [ ] `src/generate_memo.py` exists with all functions (load_latest_data, assess_inventory, assess_supply_demand, assess_market, determine_overall_tone, identify_key_risk, format_memo, generate_memo, generate_all_historical_memos)
- [ ] `python -c "from src.generate_memo import generate_memo; generate_memo()"` runs without error
- [ ] `outputs/memos/` directory exists with at least 4 markdown files
- [ ] Each memo file is valid markdown with: title, EIA table, balance section, tone, spread/vol, key risk
- [ ] Latest memo has reasonable numbers (not NaN everywhere)
- [ ] Tone assessment makes directional sense (large draw = bullish, large build = bearish)
- [ ] Notebook has 3-4 new cells at the end displaying the memo
- [ ] README updated with weekly commentary section
- [ ] No hardcoded file paths (all use function parameters with defaults)

Print the latest memo content and confirm it reads like a real analyst note.

---

## 7. Important Design Principles

1. **Rule-based, not LLM-generated.** The memo uses deterministic rules, not GPT/Claude text generation. This is intentional — it shows you can codify market judgment into structured logic, which is what quant research teams actually want.

2. **Tone scoring is transparent.** Every tone assessment traces back to specific z-scores and thresholds. An interviewer can ask "why is this week bullish?" and you can point to the exact inventory shock z-score.

3. **Conservative risk identification.** The key risk section only flags when indicators cross specific thresholds. It defaults to "no acute signals" rather than fabricating urgency.

4. **Historical memos show evolution.** Generating 4 weeks of memos demonstrates the system responds to changing market conditions, not just a static snapshot.

5. **The memo is the project's "last mile."** It connects data engineering (fetch) → analytics (features) → research (event study) → communication (memo). This full pipeline is exactly what commodity research teams want to see.

---

## 8. Resume Contribution

This extension enables the project title to include:

```
Independent Commodity Research Project — Crude Supply-Demand Balance 
& Inventory Shock Monitor (with automated weekly market commentary)
```

And adds a potential bullet:

```
• Automated rule-based weekly crude market commentary translating EIA 
  supply-demand signals, inventory-shock severity, spread regime, and 
  volatility state into structured analyst memos with directional tone 
  scoring and risk identification.
```

Or shorter:

```
• Built automated weekly market monitor generating analyst-style crude 
  commentary from EIA supply-demand balance, inventory-shock z-scores, 
  Brent-WTI spread regime, and volatility indicators.
```
