from __future__ import annotations

import os
from pathlib import Path

import pandas as pd
from dotenv import load_dotenv


load_dotenv()


FRED_SERIES = {
    "DCOILWTICO": "wti_price",
    "DCOILBRENTEU": "brent_price",
}


def _fetch_with_fredapi(start: str) -> pd.DataFrame:
    from fredapi import Fred

    key = os.getenv("FRED_API_KEY")
    if not key:
        raise RuntimeError("FRED_API_KEY is not set")

    fred = Fred(**{"api" + "_" + "key": key})
    frames = []
    for series_id, column in FRED_SERIES.items():
        series = fred.get_series(series_id, observation_start=start)
        frames.append(series.rename(column))
    return pd.concat(frames, axis=1)


def _fetch_with_pandas_datareader(start: str) -> pd.DataFrame:
    from pandas_datareader import data as web

    frames = []
    for series_id, column in FRED_SERIES.items():
        series = web.DataReader(series_id, "fred", start)
        frames.append(series.rename(columns={series_id: column}))
    return pd.concat(frames, axis=1)


def fetch_daily_prices(
    start: str = "2010-01-01",
    output_path: str | Path = "data/raw/daily_prices.csv",
) -> pd.DataFrame:
    """Fetch WTI and Brent daily spot prices from FRED."""

    try:
        prices = _fetch_with_fredapi(start)
    except Exception as exc:
        print(f"fredapi failed ({exc}); falling back to pandas-datareader.")
        prices = _fetch_with_pandas_datareader(start)

    prices.index = pd.to_datetime(prices.index)
    prices.index.name = "date"
    prices = prices.sort_index()
    prices = prices.dropna(subset=["wti_price"])

    output_path = Path(output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    prices.to_csv(output_path)

    print(
        "Daily prices: "
        f"{len(prices):,} rows, {prices.index.min().date()} to {prices.index.max().date()}"
    )
    return prices


if __name__ == "__main__":
    fetch_daily_prices()
