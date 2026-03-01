-- ============================================================
-- QUERY 1: Top 5 Suppliers by Total Procurement Value
-- ============================================================

SELECT
    s.supplier_id,
    s.supplier_name,
    s.city,
    s.category_supplied,
    s.reliability_tier,
    COUNT(po.po_id)                                      AS total_pos,
    ROUND(SUM(po.po_value_inr)::NUMERIC, 2)              AS total_procurement_value,
    ROUND(SUM(po.po_value_inr)::NUMERIC /
          SUM(SUM(po.po_value_inr)) OVER()::NUMERIC * 100, 2) AS pct_of_total_spend,
    ROUND(AVG(po.fill_rate)::NUMERIC * 100, 2)           AS avg_fill_rate_pct,
    ROUND(AVG(po.delay_days)::NUMERIC, 1)                AS avg_delay_days
FROM purchase_orders po
JOIN suppliers s ON po.supplier_id = s.supplier_id
WHERE po.po_status != 'Cancelled'
GROUP BY s.supplier_id, s.supplier_name, s.city,
         s.category_supplied, s.reliability_tier
ORDER BY total_procurement_value DESC
LIMIT 5;


-- ============================================================
-- QUERY 2: Monthly On-Time Delivery Rate per Supplier Tier
-- ============================================================

SELECT
    order_year,
    order_quarter,
    s.reliability_tier,
    COUNT(po.po_id)                                          AS total_pos,
    SUM(CASE WHEN po.is_delayed = 0 THEN 1 ELSE 0 END)      AS on_time_pos,
    ROUND(
        SUM(CASE WHEN po.is_delayed = 0 THEN 1 ELSE 0 END)::NUMERIC /
        COUNT(po.po_id)::NUMERIC * 100, 2
    )                                                        AS on_time_rate_pct,
    ROUND(AVG(po.delay_days)::NUMERIC, 2)                    AS avg_delay_days,
    ROUND(AVG(po.fill_rate)::NUMERIC * 100, 2)               AS avg_fill_rate_pct
FROM purchase_orders po
JOIN suppliers s ON po.supplier_id = s.supplier_id
WHERE po.po_status != 'Cancelled'
GROUP BY order_year, order_quarter, s.reliability_tier
ORDER BY order_year, order_quarter, s.reliability_tier;


-- ============================================================
-- QUERY 3: SKUs with Chronic Fill Rate Issues
-- ============================================================

SELECT
    po.sku_id,
    p.product_name,
    p.category,
    COUNT(po.po_id)                             AS total_pos,
    ROUND(AVG(po.fill_rate)::NUMERIC * 100, 2)  AS avg_fill_rate_pct,
    SUM(po.ordered_qty)                         AS total_ordered,
    SUM(po.received_qty)                        AS total_received,
    SUM(po.ordered_qty) -
    SUM(po.received_qty)                        AS total_units_short,
    ROUND(
        (SUM(po.ordered_qty) - SUM(po.received_qty))::NUMERIC *
        AVG(p.unit_cost_inr)::NUMERIC, 2
    )                                           AS value_of_shortfall_inr
FROM purchase_orders po
JOIN products p ON po.sku_id = p.sku_id
WHERE po.po_status != 'Cancelled'
GROUP BY po.sku_id, p.product_name, p.category
HAVING ROUND(AVG(po.fill_rate)::NUMERIC * 100, 2) < 85
ORDER BY avg_fill_rate_pct ASC;


-- ============================================================
-- QUERY 4: Inventory Turnover Ratio per SKU per Warehouse
-- ============================================================

SELECT
    i.sku_id,
    p.product_name,
    p.category,
    i.warehouse_id,
    SUM(i.units_sold)                               AS total_units_sold,
    ROUND(AVG(i.closing_stock)::NUMERIC, 0)         AS avg_closing_stock,
    ROUND(
        SUM(i.units_sold)::NUMERIC /
        NULLIF(AVG(i.closing_stock)::NUMERIC, 0), 2
    )                                               AS inventory_turnover_ratio,
    ROUND(AVG(i.days_of_inventory)::NUMERIC, 1)     AS avg_days_of_inventory,
    SUM(i.stockout_flag)                            AS stockout_occurrences,
    SUM(i.reorder_triggered)                        AS reorder_triggers
FROM inventory_snapshots i
JOIN products p ON i.sku_id = p.sku_id
GROUP BY i.sku_id, p.product_name, p.category, i.warehouse_id
ORDER BY inventory_turnover_ratio ASC
LIMIT 20;


-- ============================================================
-- QUERY 5: Revenue at Risk Summary by Disruption Scenario
-- ============================================================

SELECT
    scenario,
    COUNT(DISTINCT supplier_id)                   AS suppliers_failing,
    COUNT(sku_id)                                 AS skus_affected,
    SUM(CASE WHEN stockout_occurs
        THEN 1 ELSE 0 END)                        AS skus_that_stockout,
    ROUND(AVG(days_to_stockout)::NUMERIC, 1)      AS avg_days_to_stockout,
    ROUND(SUM(units_short)::NUMERIC, 0)           AS total_units_short,
    ROUND(SUM(revenue_at_risk_inr)::NUMERIC, 2)   AS total_revenue_at_risk,
    ROUND(SUM(emergency_cost_inr)::NUMERIC, 2)    AS total_emergency_cost,
    ROUND(
        SUM(revenue_at_risk_inr)::NUMERIC +
        SUM(emergency_cost_inr)::NUMERIC, 2
    )                                             AS total_financial_exposure
FROM disruption_scenarios
GROUP BY scenario
ORDER BY total_revenue_at_risk DESC;


-- ============================================================
-- QUERY 6: Supplier Defect Rate Trend — RED Tier Suppliers
-- ============================================================

SELECT
    po.order_year,
    po.order_quarter,
    s.supplier_name,
    s.reliability_tier,
    COUNT(po.po_id)                                    AS total_pos,
    ROUND(AVG(po.defect_rate)::NUMERIC * 100, 3)       AS avg_defect_rate_pct,
    SUM(po.defect_qty)                                 AS total_defect_units,
    SUM(po.received_qty)                               AS total_received_units,
    ROUND(
        SUM(po.defect_qty)::NUMERIC /
        NULLIF(SUM(po.received_qty), 0)::NUMERIC * 100, 3
    )                                                  AS actual_defect_rate_pct,
    LAG(ROUND(AVG(po.defect_rate)::NUMERIC * 100, 3))
        OVER (PARTITION BY s.supplier_id
              ORDER BY po.order_year, po.order_quarter)
                                                       AS prev_quarter_defect_rate,
    ROUND(AVG(po.defect_rate)::NUMERIC * 100, 3) -
    LAG(ROUND(AVG(po.defect_rate)::NUMERIC * 100, 3))
        OVER (PARTITION BY s.supplier_id
              ORDER BY po.order_year, po.order_quarter)
                                                       AS defect_rate_change
FROM purchase_orders po
JOIN suppliers s ON po.supplier_id = s.supplier_id
WHERE po.po_status != 'Cancelled'
  AND s.reliability_tier = 'low'
GROUP BY po.order_year, po.order_quarter,
         s.supplier_id, s.supplier_name, s.reliability_tier
ORDER BY s.supplier_name, po.order_year, po.order_quarter;


-- ============================================================
-- QUERY 7: Dead Stock Capital Analysis by Category
-- ============================================================

WITH latest_snapshot AS (
    SELECT
        sku_id,
        warehouse_id,
        closing_stock,
        days_of_inventory,
        ROW_NUMBER() OVER (
            PARTITION BY sku_id, warehouse_id
            ORDER BY snapshot_date DESC
        ) AS rn
    FROM inventory_snapshots
),
current_stock AS (
    SELECT
        sku_id,
        SUM(closing_stock)      AS total_current_stock,
        AVG(days_of_inventory)  AS avg_days_inventory
    FROM latest_snapshot
    WHERE rn = 1
    GROUP BY sku_id
)
SELECT
    p.category,
    COUNT(DISTINCT p.sku_id)                              AS total_skus,
    SUM(CASE WHEN cs.avg_days_inventory > 180
        THEN 1 ELSE 0 END)                                AS dead_stock_skus,
    ROUND(SUM(CASE WHEN cs.avg_days_inventory > 180
        THEN cs.total_current_stock * p.unit_cost_inr
        ELSE 0 END)::NUMERIC, 2)                          AS dead_stock_value_inr,
    ROUND(SUM(
        cs.total_current_stock * p.unit_cost_inr
    )::NUMERIC, 2)                                        AS total_stock_value_inr,
    ROUND(
        SUM(CASE WHEN cs.avg_days_inventory > 180
            THEN cs.total_current_stock * p.unit_cost_inr
            ELSE 0 END)::NUMERIC /
        NULLIF(SUM(cs.total_current_stock * p.unit_cost_inr), 0)::NUMERIC * 100
    , 2)                                                  AS dead_stock_pct
FROM products p
JOIN current_stock cs ON p.sku_id = cs.sku_id
GROUP BY p.category
ORDER BY dead_stock_value_inr DESC;


-- ============================================================
-- QUERY 8: Rolling Average Demand per SKU (Window Functions)
-- ============================================================

WITH weekly_sku_demand AS (
    SELECT
        snapshot_date,
        sku_id,
        SUM(units_sold) AS weekly_units_sold
    FROM inventory_snapshots
    GROUP BY snapshot_date, sku_id
),
top_skus AS (
    SELECT sku_id
    FROM weekly_sku_demand
    GROUP BY sku_id
    ORDER BY SUM(weekly_units_sold) DESC
    LIMIT 10
)
SELECT
    w.snapshot_date,
    w.sku_id,
    p.product_name,
    p.category,
    w.weekly_units_sold,
    ROUND(AVG(w.weekly_units_sold::NUMERIC) OVER (
        PARTITION BY w.sku_id
        ORDER BY w.snapshot_date
        ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
    ), 1)                                AS rolling_4wk_avg_demand,
    ROUND(AVG(w.weekly_units_sold::NUMERIC) OVER (
        PARTITION BY w.sku_id
        ORDER BY w.snapshot_date
        ROWS BETWEEN 11 PRECEDING AND CURRENT ROW
    ), 1)                                AS rolling_12wk_avg_demand,
    RANK() OVER (
        PARTITION BY w.snapshot_date
        ORDER BY w.weekly_units_sold DESC
    )                                    AS demand_rank_that_week
FROM weekly_sku_demand w
JOIN products p ON w.sku_id = p.sku_id
WHERE w.sku_id IN (SELECT sku_id FROM top_skus)
ORDER BY w.sku_id, w.snapshot_date
LIMIT 100;


-- ============================================================
-- QUERY 9: Channel Revenue & Return Analysis
-- ============================================================

SELECT
    channel,
    COUNT(order_id)                                    AS total_orders,
    SUM(units_ordered)                                 AS total_units_ordered,
    SUM(units_fulfilled)                               AS total_units_fulfilled,
    SUM(units_returned)                                AS total_units_returned,
    ROUND(AVG(fulfillment_rate)::NUMERIC * 100, 2)     AS avg_fulfillment_rate_pct,
    ROUND(
        SUM(units_returned)::NUMERIC /
        NULLIF(SUM(units_fulfilled), 0)::NUMERIC * 100, 2
    )                                                  AS return_rate_pct,
    ROUND(SUM(gross_revenue_inr)::NUMERIC, 2)          AS total_gross_revenue,
    ROUND(SUM(commission_inr)::NUMERIC, 2)             AS total_commission_paid,
    ROUND(SUM(return_value_inr)::NUMERIC, 2)           AS total_return_value,
    ROUND(SUM(net_revenue_after_returns)::NUMERIC, 2)  AS total_net_revenue,
    ROUND(
        SUM(net_revenue_after_returns)::NUMERIC /
        NULLIF(SUM(gross_revenue_inr), 0)::NUMERIC * 100, 2
    )                                                  AS net_revenue_margin_pct,
    ROUND(
        SUM(net_revenue_after_returns)::NUMERIC /
        NULLIF(COUNT(order_id), 0)::NUMERIC, 2
    )                                                  AS net_revenue_per_order
FROM sales_orders
GROUP BY channel
ORDER BY total_net_revenue DESC;


-- ============================================================
-- QUERY 10: Executive Risk Dashboard — High Spend + High Risk
-- ============================================================

WITH supplier_spend AS (
    SELECT
        supplier_id,
        SUM(po_value_inr)                             AS total_spend,
        COUNT(po_id)                                  AS total_pos,
        AVG(fill_rate)                                AS avg_fill_rate,
        AVG(defect_rate)                              AS avg_defect_rate,
        SUM(CASE WHEN is_delayed = 1
            THEN 1 ELSE 0 END)::NUMERIC /
        COUNT(po_id)::NUMERIC                         AS actual_delay_rate
    FROM purchase_orders
    WHERE po_status != 'Cancelled'
    GROUP BY supplier_id
),
spend_percentiles AS (
    SELECT
        supplier_id,
        total_spend,
        PERCENT_RANK() OVER (ORDER BY total_spend)    AS spend_percentile
    FROM supplier_spend
)
SELECT
    ss.supplier_id,
    s.supplier_name,
    s.city,
    s.category_supplied,
    sc.risk_category,
    ROUND(sc.composite_score::NUMERIC, 2)             AS composite_score,
    ROUND(ss.total_spend::NUMERIC, 0)                 AS total_spend_inr,
    ROUND(sp.spend_percentile::NUMERIC * 100, 1)      AS spend_percentile,
    ss.total_pos,
    ROUND(ss.actual_delay_rate::NUMERIC * 100, 2)     AS delay_rate_pct,
    ROUND(ss.avg_fill_rate::NUMERIC * 100, 2)         AS fill_rate_pct,
    ROUND(ss.avg_defect_rate::NUMERIC * 100, 3)       AS defect_rate_pct,
    CASE
        WHEN sp.spend_percentile >= 0.7
         AND sc.risk_category = 'RED - At Risk'
        THEN 'CRITICAL — High Spend + High Risk'
        WHEN sp.spend_percentile >= 0.7
         AND sc.risk_category = 'YELLOW - Watch'
        THEN 'WATCH — High Spend + Medium Risk'
        WHEN sp.spend_percentile >= 0.7
        THEN 'SAFE — High Spend + Low Risk'
        WHEN sc.risk_category = 'RED - At Risk'
        THEN 'MANAGE — Low Spend + High Risk'
        ELSE 'OK — Low Spend + Low Risk'
    END                                               AS strategic_classification
FROM supplier_spend ss
JOIN spend_percentiles sp  ON ss.supplier_id = sp.supplier_id
JOIN suppliers s           ON ss.supplier_id = s.supplier_id
JOIN supplier_scorecard sc ON ss.supplier_id = sc.supplier_id
ORDER BY ss.total_spend DESC;
