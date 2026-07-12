# dbt + Snowflake Analytics

A medallion-architecture analytics project: raw e-commerce data → dbt models → clean, tested marts, running on Snowflake.

## Why this project

This is the Analytics Engineering counterpart to [spark-aws-pipeline](../spark-aws-pipeline): instead of a distributed processing cluster, this is the SQL-first, warehouse-native transformation layer — the pattern most Analytics Engineer roles are built around. It demonstrates a bronze/silver/gold layering, `ref()`-based lineage, and data tests, on top of a small self-contained e-commerce dataset (customers, orders, order items).

## Architecture

```
seeds/ (raw CSVs)
   │
   ▼
bronze/  stg_customers, stg_orders, stg_order_items      (1:1 cleanup of raw data)
   │
   ▼
silver/  int_orders_enriched                              (joins orders + customers + item totals)
   │
   ▼
gold/    dim_customers   (lifetime value per customer)
         fct_daily_sales (daily revenue / order metrics)
```

Each layer lives in its own Snowflake schema (`bronze`, `silver`, `gold`), configured in `dbt_project.yml`.

## Stack

- **dbt-core** + **dbt-snowflake** adapter
- **Snowflake** as the warehouse
- Seeds (CSV) as the raw data source — no external ingestion needed to run this end to end

## Running it

```bash
uv venv
uv pip install dbt-core dbt-snowflake

cp .env.example .env   # fill in your Snowflake account/user/password
export $(cat .env | xargs)
export DBT_PROFILES_DIR=$(pwd)

uv run dbt deps
uv run dbt seed         # load the raw CSVs into Snowflake
uv run dbt run          # build bronze -> silver -> gold
uv run dbt test         # run the data tests (uniqueness, not-null, referential integrity)
```

`profiles.yml` is safe to commit — it only references environment variables, no literal credentials.

## Data tests

14 tests across the bronze and gold layers: primary key uniqueness/not-null on every model, plus referential integrity (`relationships`) between orders → customers and order items → orders.
