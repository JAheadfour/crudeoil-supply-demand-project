from __future__ import annotations

from pathlib import Path

import numpy as np
import pandas as pd


def load_latest_data(
    merged_path="data/processed/merged_event_table.csv",
    balance_path="data/processed/crude_balance.csv",
) -> dict:
    merged = pd.read_csv(merged_path, parse_dates=["week_end", "release_date", "date"])
    balance = pd.read_csv(balance_path, parse_dates=["week_end"])

    latest = merged.iloc[-1]
    prev = merged.iloc[-2]
    recent = merged.tail(8).copy()

    return {
        "latest": latest,
        "prev": prev,
        "recent": recent,
        "merged": merged,
        "balance": balance,
    }


def assess_inventory(data: dict) -> dict:
    latest = data["latest"]
    recent = data["recent"]

    inv_change = latest.get("inventory_change", np.nan)
    inv_shock_z = latest.get("inventory_shock_z", np.nan)
    cushing_change = latest.get("cushing_change", np.nan)
    cushing_shock_z = latest.get("cushing_shock_z", np.nan)
    us_stocks = latest.get("us_crude_stocks", np.nan)
    cushing_stocks = latest.get("cushing_stocks", np.nan)

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

    if cushing_shock_z < -1.0:
        cushing_tone = "WTI Tightening"
        cushing_reason = f"Cushing draw ({cushing_change:+.1f} kb), approaching operational constraints"
    elif cushing_shock_z > 1.0:
        cushing_tone = "WTI Loosening"
        cushing_reason = f"Cushing build ({cushing_change:+.1f} kb), storage comfortable"
    else:
        cushing_tone = "Neutral"
        cushing_reason = f"Cushing change ({cushing_change:+.1f} kb) within normal range"

    recent_changes = recent["inventory_change"].dropna()
    if len(recent_changes) >= 2:
        if (recent_changes.tail(3) < 0).all():
            streak_note = "Third consecutive weekly draw"
        elif (recent_changes.tail(2) < 0).all():
            streak_note = "Second consecutive weekly draw"
        elif (recent_changes.tail(3) > 0).all():
            streak_note = "Third consecutive weekly build"
        elif (recent_changes.tail(2) > 0).all():
            streak_note = "Second consecutive weekly build"
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


def assess_supply_demand(data: dict) -> dict:
    latest = data["latest"]

    production = latest.get("us_crude_production", np.nan)
    production_change = latest.get("production_change", np.nan)
    refinery_util = latest.get("refinery_utilization", np.nan)
    refinery_util_change = latest.get("refinery_util_change", np.nan)
    net_imports = latest.get("net_imports", np.nan)
    crude_balance = latest.get("crude_balance", np.nan)
    crude_supply = latest.get("crude_supply", np.nan)
    crude_demand = latest.get("crude_demand", np.nan)
    days_of_supply = latest.get("days_of_supply", np.nan)

    if not np.isnan(production_change):
        if production_change > 50:
            prod_note = f"Production rose {production_change:.0f} kb/d w/w - supply expanding"
        elif production_change < -50:
            prod_note = f"Production fell {abs(production_change):.0f} kb/d w/w - supply contracting"
        else:
            prod_note = f"Production roughly flat ({production_change:+.0f} kb/d w/w)"
    else:
        prod_note = "Production data unavailable"

    if not np.isnan(refinery_util):
        if refinery_util > 93:
            ref_note = f"Refinery utilization high at {refinery_util:.1f}% - strong crude demand"
        elif refinery_util < 85:
            ref_note = (
                f"Refinery utilization low at {refinery_util:.1f}% - weak crude demand "
                "(maintenance season or demand weakness)"
            )
        else:
            ref_note = f"Refinery utilization at {refinery_util:.1f}% - normal range"
    else:
        ref_note = "Refinery utilization data unavailable"

    if not np.isnan(crude_balance):
        if crude_balance < -500:
            balance_note = f"Implied deficit of {abs(crude_balance):.0f} kb - supply < demand"
        elif crude_balance > 500:
            balance_note = f"Implied surplus of {crude_balance:.0f} kb - supply > demand"
        else:
            balance_note = f"Supply-demand roughly balanced ({crude_balance:+.0f} kb)"
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
        "crude_supply": crude_supply,
        "crude_demand": crude_demand,
        "days_of_supply": days_of_supply,
        "balance_note": balance_note,
    }


def _latest_market_row(data: dict) -> pd.Series:
    market_cols = ["wti_price", "brent_price", "brent_wti_spread", "spread_zscore", "trailing_20d_vol"]
    latest = data["latest"]
    if not latest[market_cols].isna().all():
        return latest
    available = data["merged"].dropna(subset=["wti_price", "brent_price"], how="any")
    if available.empty:
        return latest
    return available.iloc[-1]


def assess_market(data: dict) -> dict:
    latest = _latest_market_row(data)

    wti = latest.get("wti_price", np.nan)
    brent = latest.get("brent_price", np.nan)
    spread = latest.get("brent_wti_spread", np.nan)
    spread_z = latest.get("spread_zscore", np.nan)
    vol_20d = latest.get("trailing_20d_vol", np.nan)
    market_date = latest.get("date", pd.NaT)

    if not np.isnan(spread_z):
        if spread_z > 1.5:
            spread_note = (
                f"Brent premium elevated (${spread:.2f}/bbl, z={spread_z:.1f}) - "
                "potential Atlantic Basin tightness or WTI-specific weakness"
            )
        elif spread_z < -1.5:
            spread_note = f"Brent premium compressed (${spread:.2f}/bbl, z={spread_z:.1f}) - WTI relatively strong vs Brent"
        else:
            spread_note = f"Brent-WTI spread at ${spread:.2f}/bbl (z={spread_z:.1f}) - within normal range"
    else:
        spread_note = f"Brent-WTI spread at ${spread:.2f}/bbl" if not np.isnan(spread) else "Spread data unavailable"

    if not np.isnan(vol_20d):
        vol_annualized_pct = vol_20d * 100 if vol_20d < 1 else vol_20d
        if vol_annualized_pct > 40:
            vol_regime = "High"
            vol_note = f"20-day realized vol at {vol_annualized_pct:.1f}% - elevated risk environment"
        elif vol_annualized_pct > 25:
            vol_regime = "Moderate"
            vol_note = f"20-day realized vol at {vol_annualized_pct:.1f}% - moderate regime"
        else:
            vol_regime = "Low"
            vol_note = f"20-day realized vol at {vol_annualized_pct:.1f}% - quiet market"
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
        "market_date": market_date,
    }


def determine_overall_tone(inv, sd, mkt) -> tuple:
    score = 0
    reasons = []

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

    cz = inv["cushing_shock_z"]
    if not np.isnan(cz):
        if cz < -1.0:
            score += 1
            reasons.append(inv["cushing_reason"])
        elif cz > 1.0:
            score -= 1
            reasons.append(inv["cushing_reason"])

    ru = sd["refinery_util"]
    if not np.isnan(ru):
        if ru > 93:
            score += 1
            reasons.append(sd["ref_note"])
        elif ru < 85:
            score -= 1
            reasons.append(sd["ref_note"])

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


def identify_key_risk(inv, sd, mkt) -> str:
    risks = []

    if not np.isnan(inv["cushing_stocks"]) and inv["cushing_stocks"] < 25000:
        risks.append(
            f"Cushing stocks at {inv['cushing_stocks']/1000:.1f} Mb, approaching "
            "operational minimum (~22 Mb). Further draws could spike WTI basis."
        )

    if mkt["vol_regime"] == "High":
        risks.append(
            f"Volatility elevated ({mkt['vol_note']}). "
            "Risk of outsized moves on next EIA release or OPEC+ headlines."
        )

    if not np.isnan(mkt["spread_z"]) and abs(mkt["spread_z"]) > 2.0:
        risks.append(
            f"Brent-WTI spread at extreme levels (z={mkt['spread_z']:.1f}). "
            "Watch for mean-reversion or structural shift in Atlantic Basin flows."
        )

    if not np.isnan(sd["refinery_util"]) and sd["refinery_util"] < 82:
        risks.append(
            f"Refinery utilization at {sd['refinery_util']:.1f}%, unusually low. "
            "Potential demand-side weakness beyond seasonal maintenance."
        )

    if risks:
        return risks[0]
    return (
        "No acute risk signals this week. Monitor EIA release for deviation "
        "from seasonal inventory patterns and any OPEC+ headline risk."
    )


def _fmt(value, fmt: str, fallback: str = "n/a") -> str:
    if pd.isna(value):
        return fallback
    return format(value, fmt)


def format_memo(data, inv, sd, mkt, tone, reasons, key_risk) -> str:
    latest = data["latest"]
    week_end = pd.Timestamp(latest["week_end"]).strftime("%B %d, %Y")
    release_date = (pd.Timestamp(latest["week_end"]) + pd.offsets.BDay(4)).strftime("%B %d, %Y")
    market_date = pd.Timestamp(mkt["market_date"]).strftime("%B %d, %Y") if not pd.isna(mkt["market_date"]) else "n/a"

    memo = f"""# Weekly Crude Market Monitor

**Week Ending:** {week_end}  
**Approximate Release Date:** {release_date}  
**Overall Tone:** {tone}

---

## EIA Release Summary

| Metric | Level | Weekly Change | Shock Z-Score |
|--------|-------|--------------|---------------|
| U.S. Crude Stocks | {_fmt(inv['us_stocks']/1000, '.1f')} Mb | {_fmt(inv['inv_change'], '+.1f')} kb | {_fmt(inv['inv_shock_z'], '+.2f')} |
| Cushing Stocks | {_fmt(inv['cushing_stocks']/1000, '.1f')} Mb | {_fmt(inv['cushing_change'], '+.1f')} kb | {_fmt(inv['cushing_shock_z'], '+.2f')} |
| Production | {_fmt(sd['production'], '.0f')} kb/d | {_fmt(sd['production_change'], '+.0f')} kb/d | - |
| Refinery Utilization | {_fmt(sd['refinery_util'], '.1f')}% | {_fmt(sd['refinery_util_change'], '+.1f')} pp | - |
| Net Imports | {_fmt(sd['net_imports'], '.0f')} kb | - | - |

## Supply-Demand Balance

{sd['balance_note']}

- Supply (production + imports): {_fmt(sd['crude_supply'], '.0f')} kb
- Demand (exports + refinery inputs): {_fmt(sd['crude_demand'], '.0f')} kb
- Implied balance: {_fmt(sd['crude_balance'], '+.0f')} kb
- Days of supply: {_fmt(sd['days_of_supply'], '.1f')} days

## Market Assessment

**Tone: {tone}**

"""
    for reason in reasons:
        memo += f"- {reason}\n"

    if inv["streak_note"]:
        memo += f"- {inv['streak_note']}\n"

    memo += f"""
## Spread & Volatility

*Market data shown from latest available aligned price date: {market_date}.*

- **WTI:** ${_fmt(mkt['wti'], '.2f')}/bbl
- **Brent:** ${_fmt(mkt['brent'], '.2f')}/bbl
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

    week_end_str = pd.Timestamp(data["latest"]["week_end"]).strftime("%Y-%m-%d")
    output_path = output_dir / f"weekly_crude_monitor_{week_end_str}.md"
    output_path.write_text(memo_text, encoding="utf-8")

    print(f"Memo generated: {output_path}")
    print(f"Overall tone: {tone}")
    print(f"Key risk: {key_risk[:80]}...")

    return output_path


def generate_all_historical_memos(
    merged_path="data/processed/merged_event_table.csv",
    balance_path="data/processed/crude_balance.csv",
    output_dir="outputs/memos",
    last_n=4,
) -> list[Path]:
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    merged = pd.read_csv(merged_path, parse_dates=["week_end", "release_date", "date"])
    balance = pd.read_csv(balance_path, parse_dates=["week_end"])

    paths = []
    for i in range(last_n, 0, -1):
        idx = len(merged) - i
        if idx < 1:
            continue

        data = {
            "latest": merged.iloc[idx],
            "prev": merged.iloc[idx - 1],
            "recent": merged.iloc[max(0, idx - 7) : idx + 1],
            "merged": merged.iloc[: idx + 1],
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
        print(f"  Generated: {path.name} - Tone: {tone}")

    return paths


if __name__ == "__main__":
    generate_memo()
    generate_all_historical_memos(last_n=4)
