# dbt-snowflake-analytics

Analytics Engineering sandbox: dbt medallion architecture (bronze/silver/gold) on Snowflake. See [README.md](README.md) for architecture and how to run it.

## Conventions

- **Layering**: `models/bronze/` = 1:1 staging on top of `seeds/` or `sources`, light renaming/casting only, no joins. `models/silver/` = joins/enrichment, still row-grain close to source. `models/gold/` = final marts (dimensional/aggregated), what BI tools would query.
- **Naming**: `stg_*` for bronze, `int_*` for silver, `dim_*`/`fct_*` for gold (standard dbt convention).
- **Every model gets a `_<layer>__models.yml`** with at least a `unique`+`not_null` test on its primary key, and `relationships` tests on foreign keys.
- **`profiles.yml` stays in the repo** using `env_var()` references only — never put literal credentials in it. Real values go in `.env` (gitignored).
- **New data**: add CSVs to `seeds/`, not hardcoded values in models — keeps models declarative and testable.

## Scope boundary

This repo is scoped to **dbt + Snowflake only**. No Airflow, no Spark — if orchestration is needed later, either add a minimal Airflow DAG here that just runs `dbt build`, or reference this repo from `spark-aws-pipeline`'s Airflow — don't merge the two stacks into one repo.
