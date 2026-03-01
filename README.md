# 🏭 Supply Chain Disruption Intelligence System
### End-to-End Advanced Data Analytics Project | Python • SQL • Power BI • Machine Learning

---

![Page 1 Executive Command Center](https://github.com/MohsinR11/supply-chain-intelligence/blob/main/Screenshots/Dashboard%20Screenshots/Page%201%20Executive%20Command%20Center.png)
![Page 2 Supplier Intelligence](https://github.com/MohsinR11/supply-chain-intelligence/blob/main/Screenshots/Dashboard%20Screenshots/Page%202%20Supplier%20Intelligence.png)
![Page 3 Inventory Health](https://github.com/MohsinR11/supply-chain-intelligence/blob/main/Screenshots/Dashboard%20Screenshots/Page%203%20Inventory%20Health.png)
![Page 4 Demand Forecast](https://github.com/MohsinR11/supply-chain-intelligence/blob/main/Screenshots/Dashboard%20Screenshots/Page%204%20Demand%20Forecast.png)
![Page 5 Disruption Simulation](https://github.com/MohsinR11/supply-chain-intelligence/blob/main/Screenshots/Dashboard%20Screenshots/Page%205%20Disruption%20Simulation.png)

---

## 📌 Problem Statement

Most supply chain dashboards tell you **what already broke**.

This system tells you **what is about to break** — and exactly how much it will cost if you don't act.

Indian D2C brands, FMCG manufacturers, and retail chains lose **15–30% of annual revenue** to supply chain disruptions — stockouts, supplier failures, dead stock, and demand volatility. Yet most analytics teams only build reactive dashboards.

This project builds a **proactive disruption intelligence system** that:
- Scores every supplier by reliability before they fail
- Detects dead stock before it becomes unsalvageable
- Forecasts demand 12 weeks ahead with ML
- Simulates what happens to revenue if your top suppliers fail tomorrow
- Predicts which incoming Purchase Orders will be delayed using Random Forest + SHAP

---

## 🎯 Business Impact (Key Findings)

| Metric | Finding |
|--------|---------|
| Suppliers in RED Zone | 3 of 15 suppliers (DrinkWell, GreenLeaf, SnackFactory) |
| Procurement Value at Risk | ₹16.7 Cr (15.1% of total spend) |
| Dead Stock SKUs | 44 of 50 SKUs with >26 weeks of stock |
| Capital Locked in Dead Stock | ₹4.67 Cr |
| Worst Case Revenue at Risk | ₹1.4 Cr (Dual supplier failure — 30 days) |
| Total Financial Exposure | ₹2.08 Cr across all 3 stress scenarios |
| ML Model AUC Score | 0.71 (Random Forest — PO delay prediction) |
| SKUs Needing Urgent Reorder | 1 immediate + 2 on high alert |
| Total Reorder Value Identified | ₹71.1 Lakhs |

---

## 🏗️ Project Architecture

```
Raw Data Generation (Python/Faker)
           ↓
    Data Cleaning & Validation
           ↓
    ┌──────────────────────────┐
    │   Python Analysis Layer  │
    │  • Supplier Scorecard    │
    │  • Inventory Health      │
    │  • Demand Forecasting    │
    │  • Disruption Simulation │
    │  • ML Risk Model         │
    └──────────────────────────┘
           ↓
    PostgreSQL Database
    (7 tables, 20,000+ rows)
           ↓
    10 SQL Analysis Queries
    (Window functions, CTEs, JOINs)
           ↓
    Power BI Dashboard
    (5 pages, 24 DAX measures)
```

---

## 📁 Repository Structure

```
supply-chain-intelligence/
│
├── README.md
│
├── data/
│   ├── raw/                          ← Generated source tables (5 CSVs)
│   │   ├── products.csv
│   │   ├── suppliers.csv
│   │   ├── purchase_orders.csv
│   │   ├── inventory_snapshots.csv
│   │   └── sales_orders.csv
│   │
│   └── processed/                    ← Cleaned + enriched outputs
│       ├── products_clean.csv
│       ├── suppliers_clean.csv
│       ├── purchase_orders_clean.csv
│       ├── inventory_snapshots_clean.csv
│       ├── sales_orders_clean.csv
│       ├── supplier_scorecard.csv
│       ├── inventory_abc_xyz.csv
│       ├── dead_stock_analysis.csv
│       ├── demand_forecast.csv
│       ├── reorder_alerts.csv
│       ├── disruption_scenarios.csv
│       ├── scenario_summary.csv
│       ├── feature_importance.csv
│       ├── model_predictions.csv
│       └── new_po_predictions.csv
│
├── notebooks/
│   ├── 01_data_generator.ipynb       ← Synthetic Indian FMCG dataset
│   ├── 02_data_cleaning.ipynb        ← Validation + derived columns
│   ├── 03_supplier_scorecard.ipynb   ← Composite risk scoring
│   ├── 04_inventory_health.ipynb     ← ABC-XYZ + dead stock detection
│   ├── 05_demand_forecasting.ipynb   ← Prophet ML forecasting
│   ├── 06_disruption_simulation.ipynb← 3-scenario stress testing
│   ├── 07_ml_supplier_risk.ipynb     ← Random Forest + SHAP
│   └── 08_load_to_postgresql.ipynb   ← ETL to PostgreSQL
│
├── sql/
│   ├── 01_schema.sql                 ← Full database schema (7 tables)
│   └── 02_analysis_queries.sql       ← 10 business analysis queries
│
├── dashboard/
│   ├── supply_chain_intelligence_dashboard.pbix
│   └── screenshots/
│       ├── page1_executive_command_center.png
│       ├── page2_supplier_intelligence.png
│       ├── page3_inventory_health.png
│       ├── page4_demand_forecast.png
│       └── page5_disruption_simulation.png
│
└── reports/
    └── executive_summary.pdf
```

---

## 🛠️ Tech Stack

| Layer | Tool | Purpose |
|-------|------|---------|
| Data Generation | Python + Faker | Realistic Indian FMCG dataset |
| Data Analysis | Python + Pandas + NumPy | Cleaning, transformation, scoring |
| Forecasting | Facebook Prophet | 12-week demand forecasting |
| Machine Learning | Scikit-Learn Random Forest | PO delay prediction |
| ML Explainability | SHAP | Feature importance explanation |
| Visualization | Matplotlib + Seaborn + Plotly | Python charts |
| Database | PostgreSQL 15 | Structured data storage |
| SQL Analysis | PostgreSQL SQL | 10 business queries with window functions |
| Dashboard | Power BI Desktop | 5-page interactive dashboard |
| Environment | Jupyter Notebook | Analysis environment |

---

## 📊 Dataset Overview

Simulated dataset representing a mid-size Indian D2C/FMCG brand (FY 2023–2024):

| Table | Rows | Description |
|-------|------|-------------|
| products | 50 | SKUs across 5 categories |
| suppliers | 15 | Suppliers across 10 Indian states |
| purchase_orders | 1,960 | 2 years of PO history |
| inventory_snapshots | 15,750 | Weekly stock levels across 3 warehouses |
| sales_orders | 2,600 | Orders across 4 channels |

**Total procurement value:** ₹110 Cr+
**Total gross revenue:** ₹5.69 Cr
**Channels:** Amazon, Flipkart, Own Website, Modern Trade
**Warehouses:** Mumbai, Delhi, Bengaluru

---

## 🔬 Analysis Modules

### Module 1 — Supplier Risk Scorecard
Composite scoring formula across 4 dimensions:

```
Supplier Risk Score (0–100) =
  On-Time Delivery Rate  × 40
  Avg Fill Rate          × 25
  Quality Rate           × 20
  (1 − Delay Rate)       × 15
```

**Result:** 3 RED zone suppliers identified with ₹16.7 Cr procurement at risk.

---

### Module 2 — Inventory Health (ABC-XYZ Matrix)

- **ABC Analysis:** Revenue contribution segmentation (A=top 70%, B=next 20%, C=bottom 10%)
- **XYZ Analysis:** Demand variability via Coefficient of Variation
- **Dead Stock Detection:** SKUs with >26 weeks of stock flagged
- **Result:** 44 dead stock SKUs, ₹4.67 Cr capital locked

---

### Module 3 — Demand Forecasting (Prophet)

- Facebook Prophet with Indian festival seasonality (Diwali, Q4 spikes)
- 12-week forward forecast for top 10 A-category SKUs
- Dynamic reorder point: `(Avg Daily Demand × Lead Time) + Safety Stock`
- **Result:** 1 urgent reorder, 2 high alert SKUs, ₹71.1L reorder value

---

### Module 4 — Disruption Simulation

Three business stress-test scenarios:

| Scenario | Description | Revenue at Risk |
|----------|-------------|----------------|
| A | SnackFactory India fails — 21 days | ₹X Lakhs |
| B | Diwali demand spike 1.8x — 14 days | ₹X Lakhs |
| C | Dual supplier failure — 30 days | ₹14.1 Lakhs (worst case) |

---

### Module 5 — ML Delay Prediction (Random Forest)

- **Target:** Will this PO be delayed? (Binary classification)
- **Features:** 20 features including supplier history, order size, seasonality, composite score
- **Model:** Random Forest (300 trees, balanced class weights)
- **Performance:** AUC = 0.71
- **Explainability:** SHAP values identify top delay drivers
- **Output:** Delay probability score for every incoming PO

---

## 💾 SQL Highlights

10 analysis queries demonstrating advanced SQL skills:

```sql
-- Example: Rolling demand with window functions
SELECT
    sku_id,
    snapshot_date,
    weekly_units_sold,
    ROUND(AVG(weekly_units_sold::NUMERIC) OVER (
        PARTITION BY sku_id
        ORDER BY snapshot_date
        ROWS BETWEEN 11 PRECEDING AND CURRENT ROW
    ), 1) AS rolling_12wk_avg_demand
FROM weekly_sku_demand;
```

**Concepts used:** CTEs, Window Functions (LAG, RANK, PERCENT_RANK, AVG OVER),
GROUP BY HAVING, CASE WHEN, NULLIF, multi-table JOINs, subqueries.

---

## 📈 Power BI Dashboard (5 Pages)

| Page | Content |
|------|---------|
| 1 — Executive Command Center | KPI cards, supplier risk table, revenue trend |
| 2 — Supplier Intelligence | Scorecard bar chart, scatter plot, defect trends |
| 3 — Inventory Health | ABC-XYZ heatmap, dead stock analysis, warehouse trends |
| 4 — Demand Forecast & Reorder Alerts | Prophet forecast, reorder urgency, ML predictions |
| 5 — Disruption Simulation | Scenario analysis, SKU impact table, financial exposure |

**24 DAX measures** including conditional aggregations, CALCULATE filters,
RELATED lookups, and DIVIDE with error handling.

---

## 🚀 How to Run This Project

### Prerequisites
```
Python 3.8+
PostgreSQL 15+
Power BI Desktop
Jupyter Notebook
```

### Step 1 — Install Python Libraries
```bash
pip install pandas numpy faker scikit-learn prophet matplotlib seaborn plotly shap openpyxl sqlalchemy psycopg2-binary
```

### Step 2 — Generate Dataset
```bash
# Run notebooks in order
01_data_generator.ipynb
02_data_cleaning.ipynb
```

### Step 3 — Run Analysis
```bash
03_supplier_scorecard.ipynb
04_inventory_health.ipynb
05_demand_forecasting.ipynb
06_disruption_simulation.ipynb
07_ml_supplier_risk.ipynb
```

### Step 4 — Load to PostgreSQL
```bash
# Create database in pgAdmin: supply_chain_db
# Run schema script
sql/01_schema.sql

# Load data
08_load_to_postgresql.ipynb
```

### Step 5 — Open Dashboard
```
Open dashboard/supply_chain_intelligence_dashboard.pbix
Connect to your PostgreSQL instance
Refresh data
```

---

## 🎯 Business Recommendations

Based on analysis findings:

**Immediate Actions (0–30 days)**
- Place emergency alternate sourcing for SnackFactory India and GreenLeaf Essentials
- Initiate promotional liquidation for 44 dead stock SKUs to recover ₹4.67 Cr
- Execute urgent reorder for 3 flagged A-category SKUs before stockout

**Short Term (30–90 days)**
- Renegotiate contracts with 3 RED zone suppliers or find alternatives
- Implement dynamic reorder points replacing static thresholds
- Deploy ML delay prediction model for all incoming POs

**Strategic (90+ days)**
- Reduce supplier concentration — top 3 suppliers account for 40%+ of spend
- Build multi-supplier strategy for each category
- Implement real-time inventory tracking replacing weekly snapshots

---

## 📞 Connect

**Built by:** Mohsin Raza
**LinkedIn:** https://www.linkedin.com/in/mohsinraza-data/
**Email:** mohsinansari1799@gmail.com

*This project was built to demonstrate end-to-end data analytics capability targeting Supply Chain, Operations, and Business Intelligence roles in Indian D2C, FMCG, and Manufacturing companies.*

---

> *"Most supply chain dashboards tell you what already broke. This system tells you what is about to break — and exactly how much it will cost if you don't act."*
