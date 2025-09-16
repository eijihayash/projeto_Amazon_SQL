-- Verificando os dados
SELECT * FROM amazon_db.bronze_amazon_products;

-- Quantidade de linhas no dataset
SELECT COUNT(*) FROM amazon_db.bronze_amazon_products;

-- Criar coluna 'lited_price' priorizando listed_price, depois current_discounted_price, e por fim price_on_variant quando listed_price estiver como "No Discount" ou vazio
SELECT 
	CASE 
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
	,current_discounted_price
    ,price_on_variant
    ,listed_price
FROM amazon_db.bronze_amazon_products;

-- Selecionando somente o número do rating
SELECT SUBSTRING(rating,1,3) as rating_NEW  FROM amazon_db.bronze_amazon_products group by rating_NEW;

-- verificando a coluna number_of_reviews
SELECT CAST(REPLACE(number_of_reviews, ",","") AS  UNSIGNED) FROM amazon_db.bronze_amazon_products;

-- transformando a coluna bought_in_last_month em número
SELECT 
	bought_in_last_month 
	,CASE 
		WHEN bought_in_last_month LIKE "%K%"
			THEN CAST(REGEXP_REPLACE(TRIM(bought_in_last_month ), '[^0-9.]', '') AS UNSIGNED) * 1000
		WHEN REGEXP_REPLACE(TRIM(bought_in_last_month ), '[^0-9.]', '') 
			THEN CAST(REGEXP_REPLACE(TRIM(bought_in_last_month ), '[^0-9.]', '') AS UNSIGNED)
		ELSE NULL
        END AS bought_in_last_month_cleaned
FROM amazon_db.bronze_amazon_products;

-- Nenhuma modificação necessário
SELECT DISTINCT TRIM(is_best_seller)
FROM amazon_db.bronze_amazon_products;

-- Nenhuma modificação necessário
SELECT DISTINCT TRIM(is_sponsored)
FROM amazon_db.bronze_amazon_products;

-- Nenhuma modificação necessário
SELECT DISTINCT TRIM(is_couponed)
FROM amazon_db.bronze_amazon_products;

-- Nenhuma modificação necessário
SELECT DISTINCT TRIM(buy_box_availability)
FROM amazon_db.bronze_amazon_products;

-- Nenhuma modificação necessário
SELECT DISTINCT TRIM(sustainability_badges)
FROM amazon_db.bronze_amazon_products;

-- tranformando delivery_details em data yyyy-mm-dd
SELECT 
	delivery_details
    ,REGEXP_SUBSTR(UPPER(delivery_details), "(AUG|SEP|OUT) [0-9]{1,2}") AS Extraido
    ,STR_TO_DATE(
    CONCAT(REGEXP_SUBSTR(UPPER(delivery_details), "(AUG|SEP|OUT) [0-9]{1,2}"), " 2025"), "%b %d %Y"
    ) AS delivery_date
FROM amazon_db.bronze_amazon_products
GROUP BY delivery_details;

