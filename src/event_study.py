from __future__ import annotations

from pathlib import Path

import pandas as pd
from scipy import stats


STUDIES = [
    {
        "title": "Inventory Draw vs Build -> WTI 5-day Volatility",
        "shock_col": "inventory_shock_z",
        "outcome_col": "fwd_5d_realized_vol",
    },
    {
        "title": "Cushing Draw vs Build -> Brent-WTI Spread Change",
        "shock_col": "cushing_shock_z",
        "outcome_col": "fwd_5d_spread_change",
    },
    {
        "title": "Inventory Draw vs Build -> WTI 5-day Return",
        "shock_col": "inventory_shock_z",
        "outcome_col": "fwd_5d_wti_return",
    },
]


def run_event_study(
    df: pd.DataFrame,
    shock_col: str,
    outcome_col: str,
    quantile: float = 0.10,
) -> dict:
    study = df[[shock_col, outcome_col]].dropna()
    low_cutoff = study[shock_col].quantile(quantile)
    high_cutoff = study[shock_col].quantile(1 - quantile)

    draws = study.loc[study[shock_col] <= low_cutoff, outcome_col]
    builds = study.loc[study[shock_col] >= high_cutoff, outcome_col]
    t_statistic, p_value = stats.ttest_ind(draws, builds, equal_var=False, nan_policy="omit")

    mean_draw = draws.mean()
    mean_build = builds.mean()
    return {
        "n_draws": int(draws.count()),
        "n_builds": int(builds.count()),
        "mean_outcome_after_draw": mean_draw,
        "mean_outcome_after_build": mean_build,
        "difference": mean_draw - mean_build,
        "t_statistic": t_statistic,
        "p_value": p_value,
        "significant_5pct": bool(p_value < 0.05),
    }


def run_all_event_studies(
    df: pd.DataFrame | str | Path = "data/processed/merged_event_table.csv",
    output_path: str | Path = "outputs/tables/event_study_results.csv",
) -> pd.DataFrame:
    if not isinstance(df, pd.DataFrame):
        df = pd.read_csv(df, parse_dates=["week_end"], index_col="week_end")

    rows = []
    for study in STUDIES:
        result = run_event_study(df, study["shock_col"], study["outcome_col"])
        rows.append({**study, "study": study["title"], **result})

    results = pd.DataFrame(rows)
    output_path = Path(output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    results.to_csv(output_path, index=False)
    print(results.to_string(index=False))
    return results


if __name__ == "__main__":
    run_all_event_studies()
