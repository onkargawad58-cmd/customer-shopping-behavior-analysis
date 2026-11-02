-- Customer Shopping Behavior Analysis (MySQL 8.0+)
-- Table: customer_shopping_behavior (3,900 rows, loaded from the cleaned Pandas output)
-- Total revenue is 233,081 and the overall average purchase is 59.76.

USE customer_behavior;

-- Q1. Revenue by gender
SELECT gender, SUM(purchase_amount) AS revenue
FROM customer_shopping_behavior
GROUP BY gender
ORDER BY revenue DESC;

-- Q2. Customers who used a discount and spent above the overall average purchase
SELECT customer_id, purchase_amount
FROM customer_shopping_behavior
WHERE discount_applied = 'Yes'
  AND purchase_amount > (SELECT AVG(purchase_amount) FROM customer_shopping_behavior)
ORDER BY purchase_amount DESC;

-- Q3. Top 5 products by average review rating
SELECT item_purchased, ROUND(AVG(review_rating), 2) AS avg_rating
FROM customer_shopping_behavior
GROUP BY item_purchased
ORDER BY avg_rating DESC
LIMIT 5;

-- Q4. Average purchase amount by shipping type
SELECT shipping_type, COUNT(*) AS orders, ROUND(AVG(purchase_amount), 2) AS avg_purchase
FROM customer_shopping_behavior
GROUP BY shipping_type
ORDER BY avg_purchase DESC;

-- Q5. Revenue and average spend: subscribers vs non-subscribers
SELECT subscription_status,
       COUNT(*) AS customers,
       SUM(purchase_amount) AS revenue,
       ROUND(AVG(purchase_amount), 2) AS avg_spend,
       ROUND(AVG(review_rating), 2) AS avg_rating
FROM customer_shopping_behavior
GROUP BY subscription_status;

-- Q6. Top 5 products by discount usage rate
SELECT item_purchased,
       ROUND(100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS discount_rate_pct
FROM customer_shopping_behavior
GROUP BY item_purchased
ORDER BY discount_rate_pct DESC
LIMIT 5;

-- Q7. Customer segments by previous purchases
--     New = 1, Returning = 2 to 10, Loyal = more than 10
SELECT customer_segment, COUNT(*) AS customers
FROM (
    SELECT CASE
               WHEN previous_purchases <= 1  THEN 'New'
               WHEN previous_purchases <= 10 THEN 'Returning'
               ELSE 'Loyal'
           END AS customer_segment
    FROM customer_shopping_behavior
) s
GROUP BY customer_segment
ORDER BY customers DESC;

-- Q8. Top 3 items by revenue within each category (window function)
SELECT *
FROM (
    SELECT category,
           item_purchased,
           SUM(purchase_amount) AS revenue,
           DENSE_RANK() OVER (
               PARTITION BY category
               ORDER BY SUM(purchase_amount) DESC
           ) AS rnk
    FROM customer_shopping_behavior
    GROUP BY category, item_purchased
) t
WHERE rnk <= 3;

-- Q9. Subscription status among repeat buyers (more than 5 previous purchases)
SELECT subscription_status, COUNT(*) AS repeat_buyers
FROM customer_shopping_behavior
WHERE previous_purchases > 5
GROUP BY subscription_status;

-- Q10. Revenue contribution by age group
SELECT age_group,
       SUM(purchase_amount) AS revenue,
       ROUND(100.0 * SUM(purchase_amount) / (SELECT SUM(purchase_amount) FROM customer_shopping_behavior), 2) AS pct_of_total
FROM customer_shopping_behavior
GROUP BY age_group
ORDER BY revenue DESC;

-- Extra. Revenue and average purchase by category
SELECT category, SUM(purchase_amount) AS revenue, ROUND(AVG(purchase_amount), 2) AS avg_purchase
FROM customer_shopping_behavior
GROUP BY category
ORDER BY revenue DESC;

-- Extra. Discount vs no discount
SELECT discount_applied, COUNT(*) AS total_orders, ROUND(AVG(purchase_amount), 2) AS avg_purchase
FROM customer_shopping_behavior
GROUP BY discount_applied;
