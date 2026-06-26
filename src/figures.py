from __future__ import annotations

from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns


DRAW_COLOR = "#b23a48"
BUILD_COLOR = "#2f855a"


def _clean_axis(ax) -> None:
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    ax.grid(True, axis="y", alpha=0.25)


def _save(fig, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fig.tight_layout()
    fig.savefig(path, dpi=150)
    plt.close(fig)


def plot_price_history(prices: pd.DataFrame, output_dir: str | Path = "outputs/figures") -> Path:
    output_dir = Path(output_dir)
    fig, ax = plt.subplots(figsize=(12, 5))
    ax.plot(prices.index, prices["wti_price"], label="WTI", linewidth=1.4)
    ax.plot(prices.index, prices["brent_price"], label="Brent", linewidth=1.4)
    ax.set_title("WTI and Brent Daily Spot Prices")
    ax.set_ylabel("USD per barrel")
    ax.legend(frameon=False)
    _clean_axis(ax)
    path = output_dir / "01_price_history.png"
    _save(fig, path)
    return path


def plot_spread(prices: pd.DataFrame, output_dir: str | Path = "outputs/figures") -> Path:
    output_dir = Path(output_dir)
    spread = prices["brent_price"] - prices["wti_price"]
    fig, ax = plt.subplots(figsize=(12, 4))
    ax.plot(spread.index, spread, color="#2b6cb0", linewidth=1.2)
    ax.fill_between(
        spread.index,
        spread.to_numpy(dtype=float),
        0,
        where=(spread.to_numpy(dtype=float) >= 0),
        color="#2b6cb0",
        alpha=0.22,
        interpolate=True,
    )
    ax.fill_between(
        spread.index,
        spread.to_numpy(dtype=float),
        0,
        where=(spread.to_numpy(dtype=float) < 0),
        color=DRAW_COLOR,
        alpha=0.22,
        interpolate=True,
    )
    ax.axhline(0, color="black", linewidth=0.8)
    ax.set_title("Brent-WTI Spot Spread")
    ax.set_ylabel("USD per barrel")
    _clean_axis(ax)
    path = output_dir / "02_brent_wti_spread.png"
    _save(fig, path)
    return path


def plot_inventory_seasonality(
    balance: pd.DataFrame,
    output_dir: str | Path = "outputs/figures",
) -> Path:
    output_dir = Path(output_dir)
    stocks = balance[["us_crude_stocks"]].dropna().copy()
    stocks["year"] = stocks.index.year
    stocks["week"] = stocks.index.isocalendar().week.astype(int)
    current_year = int(stocks["year"].max())
    band_years = list(range(current_year - 5, current_year))

    band = (
        stocks.loc[stocks["year"].isin(band_years)]
        .groupby("week")["us_crude_stocks"]
        .agg(["min", "max"])
    )
    current = stocks.loc[stocks["year"] == current_year].set_index("week")["us_crude_stocks"]

    fig, ax = plt.subplots(figsize=(10, 5))
    ax.fill_between(
        band.index.to_numpy(dtype=float),
        band["min"].to_numpy(dtype=float),
        band["max"].to_numpy(dtype=float),
        color="#718096",
        alpha=0.28,
        label="Prior 5-year min-max",
    )
    ax.plot(current.index, current, color="#1a202c", linewidth=2, label=str(current_year))
    ax.set_title("U.S. Crude Stocks Seasonality")
    ax.set_xlabel("ISO week of year")
    ax.set_ylabel("Million barrels")
    ax.legend(frameon=False)
    _clean_axis(ax)
    path = output_dir / "03_inventory_seasonality.png"
    _save(fig, path)
    return path


def _extreme_groups(
    df: pd.DataFrame,
    shock_col: str,
    outcome_col: str,
    quantile: float = 0.10,
) -> pd.DataFrame:
    study = df[[shock_col, outcome_col]].dropna()
    low = study[shock_col].quantile(quantile)
    high = study[shock_col].quantile(1 - quantile)
    grouped = pd.DataFrame(
        {
            "group": ["Extreme draws", "Extreme builds"],
            "mean": [
                study.loc[study[shock_col] <= low, outcome_col].mean(),
                study.loc[study[shock_col] >= high, outcome_col].mean(),
            ],
            "sem": [
                study.loc[study[shock_col] <= low, outcome_col].sem(),
                study.loc[study[shock_col] >= high, outcome_col].sem(),
            ],
        }
    )
    grouped["ci95"] = 1.96 * grouped["sem"]
    return grouped


def plot_extreme_bar(
    df: pd.DataFrame,
    shock_col: str,
    outcome_col: str,
    title: str,
    ylabel: str,
    filename: str,
    output_dir: str | Path = "outputs/figures",
) -> Path:
    output_dir = Path(output_dir)
    grouped = _extreme_groups(df, shock_col, outcome_col)
    fig, ax = plt.subplots(figsize=(8, 5))
    sns.barplot(
        data=grouped,
        x="group",
        y="mean",
        hue="group",
        palette=[DRAW_COLOR, BUILD_COLOR],
        legend=False,
        ax=ax,
    )
    ax.errorbar(
        x=np.arange(len(grouped)),
        y=grouped["mean"],
        yerr=grouped["ci95"],
        fmt="none",
        ecolor="#1a202c",
        capsize=5,
        linewidth=1.2,
    )
    ax.set_title(title)
    ax.set_xlabel("")
    ax.set_ylabel(ylabel)
    _clean_axis(ax)
    path = output_dir / filename
    _save(fig, path)
    return path


def plot_event_study_comparison(
    df: pd.DataFrame,
    shock_col: str,
    outcome_col: str,
    title: str,
    ylabel: str,
    quantile: float = 0.10,
):
    """Spec-compatible bar chart comparing outcomes after extreme draws vs builds."""

    grouped = _extreme_groups(df, shock_col, outcome_col, quantile)
    fig, ax = plt.subplots(figsize=(8, 5))
    ax.bar(
        grouped["group"],
        grouped["mean"],
        yerr=grouped["ci95"],
        color=[DRAW_COLOR, BUILD_COLOR],
        alpha=0.78,
        capsize=8,
        edgecolor="#1a202c",
        linewidth=0.8,
    )
    ax.axhline(0, color="#4a5568", linestyle="--", linewidth=0.8)
    ax.set_ylabel(ylabel)
    ax.set_title(title)
    _clean_axis(ax)
    fig.tight_layout()
    return fig


def generate_all_figures(
    prices: pd.DataFrame | str | Path = "data/raw/daily_prices.csv",
    balance: pd.DataFrame | str | Path = "data/processed/crude_balance.csv",
    merged: pd.DataFrame | str | Path = "data/processed/merged_event_table.csv",
    output_dir: str | Path = "outputs/figures",
) -> list[Path]:
    if not isinstance(prices, pd.DataFrame):
        prices = pd.read_csv(prices, parse_dates=["date"], index_col="date")
    if not isinstance(balance, pd.DataFrame):
        balance = pd.read_csv(balance, parse_dates=["week_end"], index_col="week_end")
    if not isinstance(merged, pd.DataFrame):
        merged = pd.read_csv(merged, parse_dates=["week_end"], index_col="week_end")

    sns.set_theme(style="whitegrid")
    paths = [
        plot_price_history(prices, output_dir),
        plot_spread(prices, output_dir),
        plot_inventory_seasonality(balance, output_dir),
        plot_extreme_bar(
            merged,
            "inventory_shock_z",
            "fwd_5d_realized_vol",
            "Inventory Shock and Forward WTI Volatility",
            "Annualized realized volatility",
            "04_inventory_shock_volatility.png",
            output_dir,
        ),
        plot_extreme_bar(
            merged,
            "cushing_shock_z",
            "fwd_5d_spread_change",
            "Cushing Shock and Forward Brent-WTI Spread",
            "5-day spread change, USD per barrel",
            "05_cushing_shock_spread.png",
            output_dir,
        ),
    ]
    print("Figures saved:")
    for path in paths:
        print(path)
    return paths


if __name__ == "__main__":
    generate_all_figures()
