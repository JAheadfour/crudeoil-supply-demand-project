from __future__ import annotations

from pathlib import Path
from textwrap import dedent

import nbformat as nbf


ROOT = Path(__file__).resolve().parents[1]
NOTEBOOK = ROOT / "notebooks" / "01_crude_sd_inventory_shock_study.ipynb"


def code(source: str):
    return nbf.v4.new_code_cell(dedent(source).strip())


def markdown(source: str):
    return nbf.v4.new_markdown_cell(dedent(source).strip())


def main() -> None:
    nb = nbf.v4.new_notebook()
    nb["metadata"] = {
        "kernelspec": {
            "display_name": "Python 3",
            "language": "python",
            "name": "python3",
        },
        "language_info": {"name": "python", "pygments_lexer": "ipython3"},
    }
    nb["cells"] = [
        markdown(
            """
            # Crude Supply-Demand Balance & Inventory Shock Study

            Objective: evaluate whether EIA inventory and Cushing shocks transmit into WTI volatility and the Brent-WTI spread. The analysis combines weekly physical petroleum balances with daily spot-market outcomes. This is **not** price prediction.
            """
        ),
        code(
            """
            from pathlib import Path
            import os
            import sys

            ROOT = Path.cwd()
            if not (ROOT / "src").exists():
                ROOT = ROOT.parent
            SRC = ROOT / "src"
            if str(SRC) not in sys.path:
                sys.path.insert(0, str(SRC))

            import numpy as np
            import pandas as pd
            import matplotlib.pyplot as plt
            import seaborn as sns
            from dotenv import load_dotenv

            load_dotenv()

            from build_balance import build_crude_balance
            from build_features import FUNDAMENTAL_FEATURES, PRICE_FEATURES, build_features, compute_shock_zscore
            from event_study import run_all_event_studies, run_event_study
            from fetch_eia import fetch_all_eia
            from fetch_prices import fetch_daily_prices
            from figures import (
                plot_extreme_bar,
                plot_event_study_comparison,
                plot_inventory_seasonality,
                plot_price_history,
                plot_spread,
            )
            from generate_memo import generate_all_historical_memos, generate_memo
            from risk_overlay import run_risk_overlay
            """
        ),
        code(
            """
            prices = fetch_daily_prices(start="2010-01-01")
            print(prices.shape)
            print(prices.index.min(), prices.index.max())
            prices.tail(5)
            """
        ),
        code(
            """
            eia = fetch_all_eia(start="2010-01-01")
            print(eia.shape)
            print(eia.index.min(), eia.index.max())
            eia.tail(5)
            """
        ),
        code(
            """
            balance = build_crude_balance(eia)
            balance[[
                "crude_supply_kbd",
                "crude_demand_kbd",
                "crude_supply_kbbl_week",
                "crude_demand_kbbl_week",
                "implied_stock_change_kbbl",
                "crude_balance",
                "inventory_change",
                "balance_residual",
            ]].describe()
            """
        ),
        markdown(
            """
            The weekly physical balance is approximated as crude supply minus crude demand, where supply is domestic production plus imports and demand is exports plus refinery inputs. EIA flow series are reported in thousand barrels per day, so daily rates are converted to weekly volumes before comparing implied stock change with reported inventory change. The residual checks whether the market story is grounded in physical barrels rather than only prices.
            """
        ),
        code(
            """
            merged = build_features(balance, prices)
            feature_names = [c for c in FUNDAMENTAL_FEATURES + PRICE_FEATURES if c in merged.columns]
            print(len(feature_names), feature_names)
            print(merged.shape)
            merged.tail(5)
            """
        ),
        markdown(
            """
            Release-date alignment maps each weekly EIA observation to the first available trading date on or after an approximate release date of three business days after the week end. Daily forward outcomes are computed before the merge. That ordering keeps the event row aligned to information available at or after the estimated release timestamp and avoids using pre-release prices.
            """
        ),
        code(
            """
            plot_price_history(prices)
            """
        ),
        code(
            """
            plot_spread(prices)
            """
        ),
        code(
            """
            plot_inventory_seasonality(balance)
            """
        ),
        code(
            """
            results = run_all_event_studies(merged)
            results
            """
        ),
        code(
            """
            plot_extreme_bar(
                merged,
                "inventory_shock_z",
                "fwd_5d_realized_vol",
                "Inventory Shock and Forward WTI Volatility",
                "Annualized realized volatility",
                "04_inventory_shock_volatility.png",
            )
            fig = plot_event_study_comparison(
                merged,
                "inventory_shock_z",
                "fwd_5d_realized_vol",
                "5-Day WTI Realized Volatility After Extreme Inventory Shocks",
                "Annualized Volatility",
            )
            plt.close(fig)
            """
        ),
        code(
            """
            plot_extreme_bar(
                merged,
                "cushing_shock_z",
                "fwd_5d_spread_change",
                "Cushing Shock and Forward Brent-WTI Spread",
                "5-day spread change, USD per barrel",
                "05_cushing_shock_spread.png",
            )
            fig = plot_event_study_comparison(
                merged,
                "cushing_shock_z",
                "fwd_5d_spread_change",
                "5-Day Brent-WTI Spread Change After Extreme Cushing Shocks",
                "Spread Change ($/bbl)",
            )
            plt.close(fig)
            """
        ),
        code(
            """
            key_features = [
                "inventory_change",
                "inventory_shock_z",
                "cushing_shock_z",
                "implied_stock_change_kbbl",
                "crude_balance",
                "balance_residual",
                "days_of_supply",
                "weeks_of_supply",
                "brent_wti_spread",
                "trailing_20d_vol",
                "fwd_5d_realized_vol",
                "fwd_5d_spread_change",
                "fwd_5d_wti_return",
            ]
            summary_stats = merged[key_features].describe().T
            summary_stats.to_csv(ROOT / "outputs" / "tables" / "summary_statistics.csv")
            summary_stats.to_csv(ROOT / "outputs" / "tables" / "feature_summary_stats.csv")
            summary_stats
            """
        ),
        markdown(
            """
            Inventory draws are negative stock changes and generally indicate a tighter physical crude market, while builds suggest looser conditions. Large draws can matter for volatility because they may force traders to reassess near-term balances quickly. Cushing is especially important for WTI because it is the delivery hub embedded in the benchmark's physical settlement logic. When Cushing inventories tighten, the Brent-WTI spread can react differently from broad U.S. stock changes. The event-study comparisons here are best read as diagnostics of market transmission, not a forecasting model. Statistical significance depends on the sample, the release-date approximation, and the fact that no consensus expectations are included. The results therefore describe historical conditional averages, not a trading rule.
            """
        ),
        markdown(
            """
            Limitations: the release date is approximated as three business days after week-end, not pulled from the actual EIA holiday-adjusted release calendar. The study does not include survey expectations, so it measures raw shocks rather than surprises relative to market consensus. It does not include the futures curve, options-implied volatility, refinery outages, storage constraints, or macro news controls. Forward returns and volatility are short-horizon realized outcomes, not tradable forecasts. This is not a trading strategy.
            """
        ),
        markdown(
            """
            ## Optional Market Risk Overlay

            The fundamentals workflow can be extended into market-risk diagnostics by modeling WTI conditional volatility and one-day 99% VaR. This section is intentionally framed as a risk appendix rather than the core commodity-research result.
            """
        ),
        code(
            """
            risk_results = run_risk_overlay(train_end="2019-12-31", test_start="2020-01-01")
            risk_results["comparison"]
            """
        ),
        code(
            """
            pd.DataFrame([risk_results["backtest"]])
            """
        ),
        markdown(
            """
            ## Weekly Analyst Memo

            A commodity research analyst's last mile is turning market data into concise commentary. The memo generator uses deterministic rules, not LLM text generation, to translate inventory shocks, Cushing tightness, refinery utilization, spread regime, and volatility state into a weekly market note.
            """
        ),
        code(
            """
            latest_memo_path = generate_memo()
            historical_paths = generate_all_historical_memos(last_n=4)
            latest_memo_path, len(historical_paths)
            """
        ),
        code(
            """
            from IPython.display import Markdown
            Markdown(latest_memo_path.read_text(encoding="utf-8"))
            """
        ),
    ]

    NOTEBOOK.parent.mkdir(parents=True, exist_ok=True)
    nbf.write(nb, NOTEBOOK)
    print(NOTEBOOK)


if __name__ == "__main__":
    main()
