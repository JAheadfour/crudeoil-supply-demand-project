from __future__ import annotations

from pathlib import Path

import pandas as pd


def build_balance(
    eia: pd.DataFrame | str | Path = "data/raw/eia_weekly.csv",
    output_path: str | Path = "data/processed/crude_balance.csv",
) -> pd.DataFrame:
    """Build weekly crude supply-demand balance from EIA data.

    EIA stock series are reported in thousand barrels, while production, trade,
    and refinery-input flow series are reported in thousand barrels per day.
    The implied stock change is therefore computed after converting daily flows
    into a weekly volume.
    """

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
    balance["inventory_change_kbbl"] = balance["inventory_change"]
    balance["cushing_change"] = balance["cushing_stocks"].diff()
    balance["cushing_change_kbbl"] = balance["cushing_change"]

    balance["crude_supply_kbd"] = balance["us_crude_production"] + balance["crude_imports"]
    balance["crude_demand_kbd"] = balance["crude_exports"] + balance["refinery_inputs"]
    balance["net_imports_kbd"] = balance["crude_imports"] - balance["crude_exports"]

    balance["crude_supply_kbbl_week"] = balance["crude_supply_kbd"] * 7
    balance["crude_demand_kbbl_week"] = balance["crude_demand_kbd"] * 7
    balance["implied_stock_change_kbbl"] = (
        balance["crude_supply_kbbl_week"] - balance["crude_demand_kbbl_week"]
    )
    balance["balance_residual_kbbl"] = (
        balance["implied_stock_change_kbbl"] - balance["inventory_change_kbbl"]
    )

    # Backward-compatible aliases used by the event-study code. These are weekly
    # stock-change volumes, not daily rates.
    balance["crude_balance"] = balance["implied_stock_change_kbbl"]
    balance["balance_residual"] = balance["balance_residual_kbbl"]
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
