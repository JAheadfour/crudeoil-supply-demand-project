# Project Agent Notes

## Structure

- `src/`: reusable pipeline modules.
- `data/raw/`: downloaded source data, ignored by git.
- `data/processed/`: derived analytical tables.
- `outputs/tables/`: event-study and summary tables.
- `outputs/figures/`: publication-ready PNG figures.
- `notebooks/`: executable research notebook.
- `scripts/`: pipeline and notebook helpers.

## API Keys

Set `FRED_API_KEY` and `EIA_API_KEY` in the shell environment before running the pipeline.
Do not hardcode API keys in Python files, notebooks, or documentation.
