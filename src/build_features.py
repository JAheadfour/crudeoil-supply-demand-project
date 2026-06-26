from __future__ import annotations

from pathlib import Path

import numpy as np
import pandas as pd


FUNDAMENTAL_FEATURES = [
    "inventory_change",
    "cushing_change",
    "production_change",
    "net_import_change",
    "refinery_util_change",
    "crude_balance",
    "inventory_shock_z",
    "cushing_shock_z",
    "production_shock_z",
    "days_of_supply_z",
    "top_decile_inventory_draw",
    "top_decile_inventory_build",
    "top_decile_cushing_draw",
    "top_decile_cushing_build",
]

PRICE_FEATURES = [
    "brent_wti_spread",
    "spread_zscore",
    "trailing_20d_vol",
    "wti_return",
    "fwd_5d_realized_vol",
]


def compute_shock_zscore(series: pd.Series, window: int = 52) -> pd.Series:
    rolling = series.rolling(window=window, min_periods=26)
    return (series - rolling.mean()) / rolling.std()


def add_fundamental_features(balance: pd.DataFrame) -> pd.DataFrame:
    features = balance.copy().sort_index()
    features["inventory_shock_z"] = compute_shock_zscore(features["inventory_change"])
    features["cushing_shock_z"] = compute_shock_zscore(features["cushing_change"])
    features["production_change"] = features["us_crude_production"].diff()
    features["production_shock_z"] = compute_shock_zscore(features["production_change"])
    features["refinery_util_change"] = features["refinery_utilization"].diff()
    features["net_imports"] = features["crude_imports"] - features["crude_exports"]
    features["net_import_change"] = features["net_imports"].diff()
    features["days_of_supply"] = features["us_crude_stocks"] / features["refinery_inputs"] * 7
    features["days_of_supply_z"] = compute_shock_zscore(features["days_of_supply"])
    inventory_low = features["inventory_shock_z"].quantile(0.10)
    inventory_high = features["inventory_shock_z"].quantile(0.90)
    cushing_low = features["cushing_shock_z"].quantile(0.10)
    cushing_high = features["cushing_shock_z"].quantile(0.90)
    features["top_decile_inventory_draw"] = features["inventory_shock_z"] <= inventory_low
    features["top_decile_inventory_build"] = features["inventory_shock_z"] >= inventory_high
    features["top_decile_cushing_draw"] = features["cushing_shock_z"] <= cushing_low
    features["top_decile_cushing_build"] = features["cushing_shock_z"] >= cushing_high
    features["week_end"] = features.index
    features["release_date"] = features.index + pd.offsets.BDay(4)
    return features


def add_price_features(prices: pd.DataFrame) -> pd.DataFrame:
    price_features = prices.copy().sort_index()
    price_features["brent_wti_spread"] = (
        price_features["brent_price"] - price_features["wti_price"]
    )
    wti = price_features["wti_price"]
    previous_wti = wti.shift(1)
    valid_return = (wti > 0) & (previous_wti > 0)
    price_features["wti_return"] = np.nan
    price_features.loc[valid_return, "wti_return"] = np.log(
        wti.loc[valid_return] / previous_wti.loc[valid_return]
    )
    price_features["trailing_20d_vol"] = (
        price_features["wti_return"].rolling(20).std() * np.sqrt(252)
    )
    spread = price_features["brent_wti_spread"]
    price_features["spread_zscore"] = (spread - spread.rolling(60).mean()) / spread.rolling(60).std()

    future_returns = pd.concat(
        [price_features["wti_return"].shift(-step) for step in range(1, 6)],
        axis=1,
    )
    price_features["fwd_5d_realized_vol"] = future_returns.std(axis=1) * np.sqrt(252)
    price_features.loc[future_returns.count(axis=1) < 5, "fwd_5d_realized_vol"] = np.nan
    price_features["fwd_5d_spread_change"] = spread.shift(-5) - spread
    price_features["fwd_5d_wti_return"] = future_returns.sum(axis=1, min_count=5)
    price_features["date"] = price_features.index
    price_features = price_features.reset_index(drop=True)
    return price_features


def build_features(
    balance: pd.DataFrame | str | Path = "data/processed/crude_balance.csv",
    prices: pd.DataFrame | str | Path = "data/raw/daily_prices.csv",
    output_path: str | Path = "data/processed/merged_event_table.csv",
) -> pd.DataFrame:
    """Build weekly shock features, daily price outcomes, and event-aligned table."""

    if not isinstance(balance, pd.DataFrame):
        balance = pd.read_csv(balance, parse_dates=["week_end"], index_col="week_end")
    if not isinstance(prices, pd.DataFrame):
        prices = pd.read_csv(prices, parse_dates=["date"], index_col="date")

    fundamentals = add_fundamental_features(balance)
    price_features = add_price_features(prices)

    merged = pd.merge_asof(
        fundamentals.sort_values("release_date"),
        price_features.sort_values("date"),
        left_on="release_date",
        right_on="date",
        direction="nearest",
        tolerance=pd.Timedelta(days=2),
    )
    merged = merged.set_index("week_end").sort_index()

    output_path = Path(output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    merged.to_csv(output_path)

    feature_columns = [column for column in FUNDAMENTAL_FEATURES + PRICE_FEATURES if column in merged.columns]
    print(
        "Merged event table: "
        f"{len(merged):,} rows, {merged.index.min().date()} to {merged.index.max().date()}"
    )
    print(f"Feature count: {len(feature_columns)}")
    print("Features: " + ", ".join(feature_columns))
    return merged


if __name__ == "__main__":
    build_features()
