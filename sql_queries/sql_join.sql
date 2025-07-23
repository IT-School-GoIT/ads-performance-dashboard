CREATE OR REPLACE VIEW public.babenko_enhanced_metrics AS
WITH monthly_revenue AS (
  SELECT
    gp.user_id,
    DATE_TRUNC('month', gp.payment_date) AS month,
    SUM(gp.revenue_amount_usd) AS revenue
  FROM project.games_payments gp
  GROUP BY gp.user_id, DATE_TRUNC('month', gp.payment_date)
),

-- Додаємо попередній/наступний місяць
lagged_data AS (
  SELECT
    mr.*,
    LAG(mr.month) OVER (PARTITION BY mr.user_id ORDER BY mr.month) AS prev_month,
    LEAD(mr.month) OVER (PARTITION BY mr.user_id ORDER BY mr.month) AS next_month,
    LAG(mr.revenue) OVER (PARTITION BY mr.user_id ORDER BY mr.month) AS prev_revenue
  FROM monthly_revenue mr
),

-- Розрахунок MRR-факторів + resurrected
mrr_factors AS (
  SELECT
    ld.user_id,
    ld.month,
    ld.revenue,

    CASE
      WHEN ld.prev_month IS NULL THEN ld.revenue
      ELSE 0
    END AS new_mrr,

    CASE
      WHEN ld.prev_revenue IS NOT NULL AND ld.revenue > ld.prev_revenue THEN ld.revenue - ld.prev_revenue
      ELSE 0
    END AS expansion,

    CASE
      WHEN ld.prev_revenue IS NOT NULL AND ld.revenue < ld.prev_revenue THEN ld.prev_revenue - ld.revenue
      ELSE 0
    END AS contraction,

    CASE
      WHEN ld.prev_revenue IS NOT NULL AND ld.next_month IS NULL THEN ld.revenue
      ELSE 0
    END AS churned,

    CASE
      WHEN ld.prev_revenue IS NULL AND ld.next_month IS NOT NULL THEN 1
      ELSE 0
    END AS resurrected_flag
  FROM lagged_data ld
),

-- Обчислюємо сумарні метрики по місяцях
monthly_summary AS (
  SELECT
    mf.month,
    COUNT(DISTINCT mf.user_id) AS users_count,
    SUM(mf.new_mrr) AS new_mrr,
    SUM(mf.expansion) AS expansion,
    SUM(mf.contraction) AS contraction,
    SUM(mf.churned) AS churned,
    SUM(CASE WHEN mf.churned > 0 THEN 1 ELSE 0 END) AS churned_users,
    SUM(mf.revenue) AS total_revenue,
    SUM(mf.resurrected_flag) AS resurrected_users
  FROM mrr_factors mf
  GROUP BY mf.month
),

-- Обчислюємо LTV по юзерам
user_ltv AS (
  SELECT
    mr.user_id,
    SUM(mr.revenue) AS ltv
  FROM monthly_revenue mr
  GROUP BY mr.user_id
),

-- Основна таблиця з деталями
final AS (
  SELECT
    mf.month,
    mf.user_id,
    mf.revenue,
    mf.new_mrr,
    mf.expansion,
    mf.contraction,
    mf.churned,
    mf.resurrected_flag,
    gpu.game_name,
    gpu.language,
    gpu.age,
    gpu.has_older_device_model,
    ul.ltv
  FROM mrr_factors mf
  LEFT JOIN project.games_paid_users gpu ON mf.user_id = gpu.user_id
  LEFT JOIN user_ltv ul ON mf.user_id = ul.user_id
)

SELECT * FROM final
ORDER BY month, user_id;
