from __future__ import annotations

from pathlib import Path

import pandas as pd


def build_balance(
    eia: pd.DataFrame | str | Path = "data/raw/eia_weekly.csv",
    output_path: str | Path = "data/processed/crude_balance.csv",
) -> pd.DataFrame:
    """Build weekly crude supply-demand balance from EIA data."""

    if not isinstance(eia, pd.DataFrame):
        eia = pd.read_csv(eia, parse_dates=["week_end"], index_col="week_end")

    balance = eia.copy().sort_index()
    required = [
        "us_crude_stocks",
        "cushing_stocks",
        "us_crude_production",
        "crude_imports",
        "crude_exports",
        "refinery_inputs",
    ]
    missing = [column for column in required if column not in balance.columns]
    if missing:
        raise ValueError(f"Missing required EIA columns: {missing}")

    balance["inventory_change"] = balance["us_crude_stocks"].diff()
    balance["cushing_change"] = balance["cushing_stocks"].diff()
    balance["crude_supply"] = balance["us_crude_production"] + balance["crude_imports"]
    balance["crude_demand"] = balance["crude_exports"] + balance["refinery_inputs"]
    balance["crude_balance"] = balance["crude_supply"] - balance["crude_demand"]
    balance["balance_residual"] = balance["crude_balance"] - balance["inventory_change"]
    balance = balance.iloc[1:].copy()

    output_path = Path(output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    balance.to_csv(output_path)
    print(
        "Crude balance: "
        f"{len(balance):,} rows, {balance.index.min().date()} to {balance.index.max().date()}"
    )
    return balance


def build_crude_balance(eia_df: pd.DataFrame) -> pd.DataFrame:
    """Spec-compatible alias for building the crude balance table."""

    return build_balance(eia_df)


if __name__ == "__main__":
    build_balance()
