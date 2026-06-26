from __future__ import annotations

import os
import time
from pathlib import Path
from typing import Iterable

import pandas as pd
import requests
from dotenv import load_dotenv


load_dotenv()


EIA_SERIES_METADATA = [
    {
        "series_id": "WCESTUS1",
        "column": "us_crude_stocks",
        "description": "U.S. commercial crude oil stocks excluding SPR",
        "unit": "thousand barrels",
    },
    {
        "series_id": "W_EPC0_SAX_YCUOK_MBBL",
        "column": "cushing_stocks",
        "description": "Cushing, Oklahoma crude oil stocks",
        "unit": "thousand barrels",
    },
    {
        "series_id": "WCRFPUS2",
        "column": "us_crude_production",
        "description": "U.S. field production of crude oil",
        "unit": "thousand barrels per day",
    },
    {
        "series_id": "WCRIMUS2",
        "column": "crude_imports",
        "description": "U.S. imports of crude oil",
        "unit": "thousand barrels per day",
    },
    {
        "series_id": "WCREXUS2",
        "column": "crude_exports",
        "description": "U.S. exports of crude oil",
        "unit": "thousand barrels per day",
    },
    {
        "series_id": "WGIRIUS2",
        "column": "refinery_inputs",
        "description": "U.S. gross inputs to refineries",
        "unit": "thousand barrels per day",
    },
    {
        "series_id": "WPULEUS3",
        "column": "refinery_utilization",
        "description": "U.S. refinery operable-capacity utilization",
        "unit": "percent",
    },
]

EIA_SERIES = {row["series_id"]: row["column"] for row in EIA_SERIES_METADATA}

PRIMARY_ENDPOINT = "https://api.eia.gov/v2/petroleum/sum/sndw/data/"
CUSHING_ENDPOINT = "https://api.eia.gov/v2/petroleum/stoc/wstk/data/"


def _base_params(key: str, series_id: str, start: str, offset: int) -> list[tuple[str, str | int]]:
    return [
        ("api" + "_" + "key", key),
        ("frequency", "weekly"),
        ("data[0]", "value"),
        ("facets[series][]", series_id),
        ("start", start),
        ("sort[0][column]", "period"),
        ("sort[0][direction]", "asc"),
        ("length", 5000),
        ("offset", offset),
    ]


def _rows_from_payload(payload: dict) -> list[dict]:
    response = payload.get("response", {})
    rows = response.get("data", [])
    if not isinstance(rows, list):
        return []
    return rows


def _fetch_page(endpoint: str, key: str, series_id: str, start: str, offset: int) -> list[dict]:
    response = requests.get(
        endpoint,
        params=_base_params(key, series_id, start, offset),
        timeout=30,
    )
    response.raise_for_status()
    payload = response.json()
    return _rows_from_payload(payload)


def _fetch_series_from_endpoint(endpoint: str, key: str, series_id: str, start: str) -> pd.Series:
    rows: list[dict] = []
    offset = 0
    while True:
        page = _fetch_page(endpoint, key, series_id, start, offset)
        if not page:
            break
        rows.extend(page)
        if len(page) < 5000:
            break
        offset += 5000

    if not rows:
        raise RuntimeError(f"No EIA rows returned for {series_id} from {endpoint}")

    frame = pd.DataFrame(rows)
    if "period" not in frame or "value" not in frame:
        raise RuntimeError(f"Unexpected EIA payload for {series_id}: {frame.columns.tolist()}")

    values = pd.to_numeric(frame["value"], errors="coerce")
    periods = pd.to_datetime(frame["period"], errors="coerce")
    series = pd.Series(values.to_numpy(), index=periods, name=series_id)
    series = series[series.index.notna()].sort_index()
    series.index.name = "week_end"
    return series


def _candidate_endpoints(series_id: str) -> Iterable[str]:
    if series_id == "W_EPC0_SAX_YCUOK_MBBL":
        yield CUSHING_ENDPOINT
    yield PRIMARY_ENDPOINT
    if series_id != "W_EPC0_SAX_YCUOK_MBBL":
        yield CUSHING_ENDPOINT


def _fetch_series(key: str, series_id: str, start: str) -> pd.Series | None:
    last_error: Exception | None = None
    for endpoint in _candidate_endpoints(series_id):
        for attempt in range(2):
            try:
                return _fetch_series_from_endpoint(endpoint, key, series_id, start)
            except Exception as exc:
                last_error = exc
                if attempt == 0:
                    time.sleep(1)
                else:
                    print(f"Warning: {series_id} failed at {endpoint}: {exc}")
    print(f"Warning: skipping {series_id}; last error: {last_error}")
    return None


def fetch_eia_weekly(
    start: str = "2010-01-01",
    output_path: str | Path = "data/raw/eia_weekly.csv",
    series_config_path: str | Path = "data/eia_series_config.csv",
) -> pd.DataFrame:
    """Fetch weekly EIA petroleum series and merge them by week ending date."""

    key = os.getenv("EIA_API_KEY")
    if not key:
        raise RuntimeError("EIA_API_KEY is not set")

    frames = []
    for series_id, column in EIA_SERIES.items():
        series = _fetch_series(key, series_id, start)
        if series is None:
            continue
        series = series.rename(column)
        print(
            f"{series_id} -> {column}: "
            f"{len(series):,} rows, {series.index.min().date()} to {series.index.max().date()}"
        )
        frames.append(series)

    if not frames:
        raise RuntimeError("EIA API failed for all requested series.")

    eia = pd.concat(frames, axis=1).sort_index()
    eia.index.name = "week_end"

    output_path = Path(output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    eia.to_csv(output_path)

    series_config_path = Path(series_config_path)
    series_config_path.parent.mkdir(parents=True, exist_ok=True)
    pd.DataFrame(EIA_SERIES_METADATA).to_csv(series_config_path, index=False)

    print(
        "Merged EIA weekly: "
        f"{len(eia):,} rows, {eia.index.min().date()} to {eia.index.max().date()}"
    )
    return eia


def fetch_all_eia(start: str = "2010-01-01") -> pd.DataFrame:
    """Spec-compatible alias for fetching all EIA weekly series."""

    return fetch_eia_weekly(start=start)


if __name__ == "__main__":
    fetch_eia_weekly()
