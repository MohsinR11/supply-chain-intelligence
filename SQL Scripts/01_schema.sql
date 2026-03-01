-- ============================================================
-- SUPPLY CHAIN INTELLIGENCE SYSTEM
-- Database Schema — supply_chain_db
-- ============================================================

-- Drop tables if they exist (clean start)
DROP TABLE IF EXISTS sales_orders      CASCADE;
DROP TABLE IF EXISTS inventory_snapshots CASCADE;
DROP TABLE IF EXISTS purchase_orders   CASCADE;
DROP TABLE IF EXISTS products          CASCADE;
DROP TABLE IF EXISTS suppliers         CASCADE;
DROP TABLE IF EXISTS supplier_scorecard CASCADE;
DROP TABLE IF EXISTS dead_stock_analysis CASCADE;
DROP TABLE IF EXISTS disruption_scenarios CASCADE;
DROP TABLE IF EXISTS demand_forecast    CASCADE;
DROP TABLE IF EXISTS reorder_alerts     CASCADE;


-- ============================================================
-- TABLE 1: PRODUCTS
-- ============================================================
CREATE TABLE products (
    sku_id                VARCHAR(10)    PRIMARY KEY,
    product_name          VARCHAR(100)   NOT NULL,
    category              VARCHAR(50)    NOT NULL,
    unit_cost_inr         NUMERIC(10,2)  NOT NULL,
    selling_price_inr     NUMERIC(10,2)  NOT NULL,
    gross_margin_pct      NUMERIC(6,2),
    shelf_life_days       INTEGER,
    reorder_point_units   INTEGER,
    minimum_order_qty     INTEGER,
    is_active             SMALLINT       DEFAULT 1
);


-- ============================================================
-- TABLE 2: SUPPLIERS
-- ============================================================
CREATE TABLE suppliers (
    supplier_id           VARCHAR(10)    PRIMARY KEY,
    supplier_name         VARCHAR(100)   NOT NULL,
    city                  VARCHAR(50),
    state                 VARCHAR(50),
    category_supplied     VARCHAR(50),
    avg_lead_time_days    INTEGER,
    payment_terms_days    INTEGER,
    annual_capacity_units INTEGER,
    credit_limit_inr      NUMERIC(12,2),
    contract_start_date   DATE,
    reliability_tier      VARCHAR(10),
    is_active             SMALLINT       DEFAULT 1
);


-- ============================================================
-- TABLE 3: PURCHASE ORDERS
-- ============================================================
CREATE TABLE purchase_orders (
    po_id                   VARCHAR(10)   PRIMARY KEY,
    supplier_id             VARCHAR(10)   REFERENCES suppliers(supplier_id),
    sku_id                  VARCHAR(10)   REFERENCES products(sku_id),
    order_date              DATE,
    promised_delivery_date  DATE,
    actual_delivery_date    DATE,
    ordered_qty             INTEGER,
    received_qty            INTEGER,
    defect_qty              INTEGER,
    unit_cost_inr           NUMERIC(10,2),
    po_value_inr            NUMERIC(12,2),
    delay_days              NUMERIC(6,1),
    po_status               VARCHAR(20),
    fill_rate               NUMERIC(6,4),
    defect_rate             NUMERIC(6,4),
    is_delayed              SMALLINT,
    is_cancelled            SMALLINT,
    order_month             VARCHAR(10),
    order_quarter           VARCHAR(10),
    order_year              INTEGER
);


-- ============================================================
-- TABLE 4: INVENTORY SNAPSHOTS
-- ============================================================
CREATE TABLE inventory_snapshots (
    id                  SERIAL         PRIMARY KEY,
    snapshot_date       DATE,
    sku_id              VARCHAR(10)    REFERENCES products(sku_id),
    warehouse_id        VARCHAR(10),
    opening_stock       INTEGER,
    units_received      INTEGER,
    units_sold          INTEGER,
    closing_stock       INTEGER,
    days_of_inventory   NUMERIC(8,1),
    stockout_flag       SMALLINT,
    reorder_triggered   SMALLINT,
    is_low_stock        SMALLINT,
    is_dead_stock       SMALLINT,
    stock_month         VARCHAR(10)
);


-- ============================================================
-- TABLE 5: SALES ORDERS
-- ============================================================
CREATE TABLE sales_orders (
    order_id                    VARCHAR(15)   PRIMARY KEY,
    order_date                  DATE,
    sku_id                      VARCHAR(10)   REFERENCES products(sku_id),
    category                    VARCHAR(50),
    channel                     VARCHAR(20),
    city                        VARCHAR(50),
    units_ordered               INTEGER,
    units_fulfilled             INTEGER,
    units_returned              INTEGER,
    selling_price_inr           NUMERIC(10,2),
    gross_revenue_inr           NUMERIC(12,2),
    commission_pct              NUMERIC(6,4),
    commission_inr              NUMERIC(10,2),
    net_revenue_inr             NUMERIC(12,2),
    fulfillment_rate            NUMERIC(6,4),
    fulfillment_status          VARCHAR(20),
    order_month                 VARCHAR(10),
    order_quarter               VARCHAR(10),
    order_year                  INTEGER,
    return_value_inr            NUMERIC(10,2),
    net_revenue_after_returns   NUMERIC(12,2)
);


-- ============================================================
-- TABLE 6: SUPPLIER SCORECARD
-- ============================================================
CREATE TABLE supplier_scorecard (
    supplier_id              VARCHAR(10)   PRIMARY KEY,
    supplier_name            VARCHAR(100),
    city                     VARCHAR(50),
    state                    VARCHAR(50),
    category_supplied        VARCHAR(50),
    avg_lead_time_days       INTEGER,
    payment_terms_days       INTEGER,
    on_time_delivery_rate    NUMERIC(6,4),
    avg_fill_rate            NUMERIC(6,4),
    avg_defect_rate          NUMERIC(6,4),
    quality_rate             NUMERIC(6,4),
    lead_time_consistency    NUMERIC(6,4),
    total_po_value_inr       NUMERIC(14,2),
    total_po_count           INTEGER,
    composite_score          NUMERIC(6,2),
    delay_rate               NUMERIC(6,4),
    risk_category            VARCHAR(20),
    rank                     INTEGER
);


-- ============================================================
-- TABLE 7: DISRUPTION SCENARIOS
-- ============================================================
CREATE TABLE disruption_scenarios (
    id                    SERIAL         PRIMARY KEY,
    scenario              VARCHAR(100),
    supplier_id           VARCHAR(10),
    supplier_name         VARCHAR(100),
    disruption_days       INTEGER,
    demand_spike          NUMERIC(4,2),
    sku_id                VARCHAR(10),
    product_name          VARCHAR(100),
    category              VARCHAR(50),
    current_stock         NUMERIC(10,1),
    avg_daily_demand      NUMERIC(8,1),
    days_to_stockout      NUMERIC(8,1),
    stockout_occurs       BOOLEAN,
    days_without_stock    NUMERIC(8,1),
    units_short           NUMERIC(10,1),
    revenue_at_risk_inr   NUMERIC(12,2),
    emergency_cost_inr    NUMERIC(12,2),
    urgency_level         VARCHAR(20),
    recommended_action    VARCHAR(100)
);


SELECT 'All tables created successfully!' AS status;


SELECT 'products'            AS table_name, COUNT(*) AS row_count FROM products
UNION ALL
SELECT 'suppliers',                          COUNT(*) FROM suppliers
UNION ALL
SELECT 'purchase_orders',                    COUNT(*) FROM purchase_orders
UNION ALL
SELECT 'inventory_snapshots',                COUNT(*) FROM inventory_snapshots
UNION ALL
SELECT 'sales_orders',                       COUNT(*) FROM sales_orders
UNION ALL
SELECT 'supplier_scorecard',                 COUNT(*) FROM supplier_scorecard
UNION ALL
SELECT 'disruption_scenarios',               COUNT(*) FROM disruption_scenarios
ORDER BY table_name;