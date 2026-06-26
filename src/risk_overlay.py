from __future__ import annotations

from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from arch import arch_model
from scipy.stats import chi2, norm, t as t_dist


MODEL_SPECS = {
    "GARCH_normal": {"vol": "GARCH", "p": 1, "q": 1, "dist": "normal"},
    "GARCH_t": {"vol": "GARCH", "p": 1, "q": 1, "dist": "t"},
    "GJR_normal": {"vol": "GARCH", "p": 1, "o": 1, "q": 1, "dist": "normal"},
    "GJR_t": {"vol": "GARCH", "p": 1, "o": 1, "q": 1, "dist": "t"},
}


def load_returns(prices_path="data/raw/daily_prices.csv") -> pd.Series:
    prices = pd.read_csv(prices_path, parse_dates=["date"], index_col="date")
    prices = prices.sort_index()
    prices = prices.loc[prices["wti_price"] > 0].copy()
    returns = np.log(prices["wti_price"] / prices["wti_price"].shift(1)).dropna()
    returns.name = "wti_log_return"
    print(
        "WTI returns: "
        f"{len(returns):,} rows, {returns.index.min().date()} to {returns.index.max().date()}, "
        f"mean={returns.mean():.6f}, std={returns.std():.6f}"
    )
    return returns


def fit_models(returns: pd.Series) -> dict:
    scaled_returns = returns * 100
    models = {}
    for model_key, params in MODEL_SPECS.items():
        am = arch_model(scaled_returns, mean="Constant", **params)
        result = am.fit(disp="off", show_warning=False, options={"maxiter": 500})
        models[model_key] = result
        print(
            f"{model_key}: loglik={result.loglikelihood:.2f}, "
            f"AIC={result.aic:.2f}, BIC={result.bic:.2f}, params={result.num_params}"
        )
    return models


def model_comparison_table(models: dict) -> pd.DataFrame:
    rows = []
    for model_key, result in models.items():
        rows.append(
            {
                "model": model_key,
                "log_likelihood": result.loglikelihood,
                "aic": result.aic,
                "bic": result.bic,
                "num_params": result.num_params,
            }
        )
    comparison = pd.DataFrame(rows).sort_values("aic", ascending=True).reset_index(drop=True)
    output_path = Path("outputs/tables/garch_model_comparison.csv")
    output_path.parent.mkdir(parents=True, exist_ok=True)
    comparison.to_csv(output_path, index=False)
    return comparison


def extract_var_series(result, confidence=0.99) -> pd.DataFrame:
    cond_vol = result.conditional_volatility / 100
    cond_mean = result.params.get("mu", 0) / 100
    if "nu" in result.params.index:
        quantile = t_dist.ppf(1 - confidence, result.params["nu"])
    else:
        quantile = norm.ppf(1 - confidence)

    var_series = -(cond_mean + quantile * cond_vol)
    actual = result.resid / 100
    var_df = pd.DataFrame(
        {
            "date": actual.index,
            "actual_return": actual.to_numpy(),
            "cond_volatility": cond_vol.to_numpy(),
            "var_99": var_series.to_numpy(),
        }
    )
    var_df["breach"] = var_df["actual_return"] < -var_df["var_99"]
    return var_df


def kupiec_test(var_df: pd.DataFrame, alpha=0.01) -> dict:
    n = len(var_df)
    x = int(var_df["breach"].sum())
    p_hat = x / n
    eps = 1e-10
    p_hat_safe = np.clip(p_hat, eps, 1 - eps)
    lr_stat = -2 * (
        (n - x) * np.log(1 - alpha)
        + x * np.log(alpha)
        - (n - x) * np.log(1 - p_hat_safe)
        - x * np.log(p_hat_safe)
    )
    p_value = 1 - chi2.cdf(lr_stat, df=1)
    return {
        "total_observations": n,
        "num_breaches": x,
        "breach_rate_pct": round(p_hat * 100, 3),
        "expected_rate_pct": alpha * 100,
        "LR_statistic": round(lr_stat, 4),
        "p_value": round(p_value, 4),
        "reject_H0_5pct": bool(p_value < 0.05),
        "interpretation": (
            "Breach rate consistent with 1% target"
            if p_value >= 0.05
            else "Breach rate significantly differs from 1% target"
        ),
    }


def _clean_axis(ax) -> None:
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    ax.grid(True, axis="y", alpha=0.25)


def _plot_conditional_volatility(var_df: pd.DataFrame, output_path: Path) -> None:
    plot_df = var_df.copy()
    plot_df["date"] = pd.to_datetime(plot_df["date"])
    realized_vol = plot_df["actual_return"].rolling(20).std() * np.sqrt(252)

    fig, ax = plt.subplots(figsize=(12, 5))
    ax.plot(
        plot_df["date"],
        plot_df["cond_volatility"] * np.sqrt(252) * 100,
        label="GJR-GARCH Conditional Vol",
        linewidth=1.3,
        color="#2b6cb0",
    )
    ax.plot(
        plot_df["date"],
        realized_vol * 100,
        label="20-day Realized Vol",
        linewidth=1.0,
        color="#4a5568",
        alpha=0.45,
    )
    ax.set_title("WTI Conditional Volatility: GJR-GARCH vs Realized")
    ax.set_ylabel("Annualized Volatility (%)")
    ax.legend(frameon=False)
    _clean_axis(ax)
    fig.tight_layout()
    fig.savefig(output_path, dpi=150)
    plt.close(fig)


def _plot_var_breaches(var_df: pd.DataFrame, model_name: str, backtest: dict, output_path: Path) -> None:
    plot_df = var_df.copy()
    plot_df["date"] = pd.to_datetime(plot_df["date"])
    breaches = plot_df.loc[plot_df["breach"]]

    fig, ax = plt.subplots(figsize=(12, 5))
    ax.plot(
        plot_df["date"],
        plot_df["actual_return"],
        color="#4a5568",
        alpha=0.5,
        linewidth=0.8,
        label="WTI daily log return",
    )
    ax.plot(
        plot_df["date"],
        -plot_df["var_99"],
        color="#c53030",
        linestyle="--",
        linewidth=1.1,
        label="-99% VaR",
    )
    ax.scatter(
        breaches["date"],
        breaches["actual_return"],
        color="#c53030",
        s=28,
        zorder=5,
        label="VaR breach",
    )
    ax.text(
        0.015,
        0.95,
        "Breaches: "
        f"{backtest['num_breaches']}/{backtest['total_observations']} "
        f"({backtest['breach_rate_pct']}% vs 1.0% target)",
        transform=ax.transAxes,
        va="top",
        ha="left",
        bbox={"boxstyle": "round,pad=0.35", "facecolor": "white", "edgecolor": "#cbd5e0"},
    )
    ax.set_title(f"WTI 1-Day 99% VaR Backtesting - {model_name}")
    ax.set_ylabel("Daily Log Return")
    ax.legend(frameon=False, loc="lower right")
    _clean_axis(ax)
    fig.tight_layout()
    fig.savefig(output_path, dpi=150)
    plt.close(fig)


def run_risk_overlay(prices_path="data/raw/daily_prices.csv", output_dir="outputs") -> dict:
    output_dir = Path(output_dir)
    (output_dir / "tables").mkdir(parents=True, exist_ok=True)
    (output_dir / "figures").mkdir(parents=True, exist_ok=True)

    returns = load_returns(prices_path)
    models = fit_models(returns)
    comparison = model_comparison_table(models)

    best_key = comparison.iloc[0]["model"]
    best_model = models[best_key]
    print(f"Best model: {best_key} (AIC={comparison.iloc[0]['aic']:.1f})")

    var_df = extract_var_series(best_model)
    backtest = kupiec_test(var_df)

    bt_df = pd.DataFrame([backtest])
    bt_df.to_csv(output_dir / "tables" / "var_backtest.csv", index=False)
    var_df.to_csv(output_dir / "tables" / "var_series.csv", index=False)

    _plot_conditional_volatility(var_df, output_dir / "figures" / "06_conditional_volatility.png")
    _plot_var_breaches(var_df, best_key, backtest, output_dir / "figures" / "07_var_breaches.png")

    print(
        f"Backtest: {backtest['num_breaches']} breaches in "
        f"{backtest['total_observations']} days "
        f"({backtest['breach_rate_pct']}% vs {backtest['expected_rate_pct']}% target)"
    )
    print(f"Kupiec p-value: {backtest['p_value']}")

    return {
        "comparison": comparison,
        "var_df": var_df,
        "backtest": backtest,
        "best_model_key": best_key,
    }


if __name__ == "__main__":
    run_risk_overlay()
