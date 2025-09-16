-- Criando a Tabela Silver

CREATE TABLE amazon_db.silver_amazon_products ( 
title TEXT, 
rating DECIMAL(2,1), 
number_of_reviews INT, 
bought_in_last_month INT, 
current_discounted_price DECIMAL(10,2), 
listed_price DECIMAL(10,2), 
is_best_seller VARCHAR(100), 
is_sponsored VARCHAR(100), 
is_couponed VARCHAR(100), 
buy_box_availability VARCHAR(100), 
delivery_details DATE, 
sustainability_badges VARCHAR(255), 
image_url TEXT, 
product_url TEXT, 
collected_at DATETIME );

--Inserirndo a transformaçao dos dados na tabela Silver
INSERT INTO amazon_db.silver_amazon_products(
	title,
    rating,
    number_of_reviews,
    bought_in_last_month,
    current_discounted_price,
    listed_price,
    is_best_seller,
    is_sponsored,
    is_couponed,
    buy_box_availability,
    delivery_details,
    sustainability_badges,
    image_url,
    product_url,
    collected_at
)
SELECT
	TRIM(title)
    ,SUBSTRING(rating,1,3)
    ,CAST(REPLACE(number_of_reviews, ",","") AS  UNSIGNED)
    ,CASE 
		WHEN bought_in_last_month LIKE "%K%" AND REGEXP_SUBSTR(bought_in_last_month, '[0-9]+') IS NOT NULL
			THEN CAST(REGEXP_SUBSTR(bought_in_last_month, '[0-9]+') AS UNSIGNED) * 1000
		WHEN REGEXP_SUBSTR(bought_in_last_month, '[0-9]+') IS NOT NULL
			THEN CAST(REGEXP_SUBSTR(bought_in_last_month, '[0-9]+') AS UNSIGNED)
		ELSE NULL
        END AS bought_in_last_month
	,CAST(current_discounted_price AS DECIMAL(10,2))
	,CASE 
    WHEN listed_price IS NOT NULL AND TRIM(listed_price) <> "" AND UPPER(TRIM(listed_price)) <> "NO DISCOUNT"
        THEN CAST(REPLACE(TRIM(listed_price), "$", "") AS DECIMAL(10,2))
    WHEN current_discounted_price IS NOT NULL AND TRIM(current_discounted_price) <> ""
        THEN CAST(current_discounted_price AS DECIMAL(10,2))
    WHEN price_on_variant LIKE '%$%'
        THEN REGEXP_SUBSTR(
    REPLACE(REPLACE(TRIM(price_on_variant), '$',''), ',', ''),
    '[0-9]+(\.[0-9]+)?'
)
    ELSE NULL
	END AS listed_price
    ,TRIM(is_best_seller)
    ,TRIM(is_sponsored)
    ,TRIM(is_couponed)
    ,TRIM(buy_box_availability)
    ,STR_TO_DATE(
    CONCAT(REGEXP_SUBSTR(UPPER(delivery_details), "(AUG|SEP|OUT) [0-9]{1,2}"), " 2025"), "%b %d %Y"
    ) AS delivery_details
    ,TRIM(sustainability_badges)
    ,image_url
    ,product_url
    ,collected_at
FROM amazon_db.bronze_amazon_products;
