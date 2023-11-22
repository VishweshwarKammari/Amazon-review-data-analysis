INSERT INTO review_data_analysis_prd.Date
SELECT s.* FROM review_data_analysis_stg.Date s LEFT JOIN review_data_analysis_prd.Date p
ON s.dateID=p.dateID WHERE p.dateID IS NULL

INSERT INTO review_data_analysis_prd.product_Categories
SELECT s.* FROM review_data_analysis_stg.product_Categories s LEFT JOIN review_data_analysis_prd.product_Categories p
ON s.categoryID=p.categoryID WHERE p.categoryID IS NULL

INSERT INTO review_data_analysis_prd.price_bucket
SELECT s.* FROM review_data_analysis_stg.price_bucket s LEFT JOIN review_data_analysis_prd.price_bucket p
ON s.bucketID=p.bucketID WHERE p.bucketID IS NULL

INSERT INTO review_data_analysis_prd.Product
SELECT s.* FROM review_data_analysis_stg.Product s LEFT JOIN review_data_analysis_prd.Product p
ON s.asin=p.asin WHERE p.asin IS NULL

INSERT INTO review_data_analysis_prd.review_data
SELECT s.* FROM review_data_analysis_stg.review_data s LEFT JOIN review_data_analysis_prd.review_data p
ON s.reviewID=p.reviewID WHERE p.reviewID IS NULL