from __future__ import annotations

import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from src.build_balance import build_balance
from src.build_features import build_features
from src.event_study import run_all_event_studies
from src.fetch_eia import fetch_eia_weekly
from src.fetch_prices import fetch_daily_prices
from src.figures import generate_all_figures


def main() -> None:
    prices = fetch_daily_prices()
    eia = fetch_eia_weekly()
    balance = build_balance(eia)
    merged = build_features(balance, prices)
    results = run_all_event_studies(merged)
    generate_all_figures(prices, balance, merged)
    print("\nFinal event-study results:")
    print(results.to_string(index=False))


if __name__ == "__main__":
    main()
