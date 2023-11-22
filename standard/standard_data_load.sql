 
INSERT INTO review_data_analysis_standard.price_bucket(priceBucket,BucketRange)
(SELECT 'cheap' as pricebucket,'<5' as bucketrange
UNION
SELECT 'Low Price' as pricebucket,'5-20' as bucketrange
UNION
SELECT 'Fair Price' as pricebucket,'20-50' as bucketrange
UNION
SELECT 'Expensive' as pricebucket,'>50' as bucketrange
UNION
SELECT 'Unpriced' as pricebucket,'NotAvailable' as bucketrange
)




INSERT INTO review_data_analysis_standard.Date
SELECT CASE WHEN LEN(trim(reviewTime))=10 THEN CAST(RIGHT(reviewTime,4)||LEFT(reviewTime,2)||'0'||SUBSTRING(reviewTime,4,1) AS INT) 
WHEN LEN(TRIM(reviewTime))=11 THEN CAST(RIGHT(reviewTime,4)||LEFT(reviewTime,2)||SUBSTRING(reviewTime,4,2) AS INT)
ELSE 99990101 END AS DateID,
CASE WHEN LEN(trim(reviewTime))=10 THEN LEFT(reviewTime,2)||'/'||'0'||SUBSTRING(reviewTime,4,1)||'/'||RIGHT(reviewTime,4) 
WHEN LEN(TRIM(reviewTime))=11 THEN LEFT(reviewTime,2)||'/'||SUBSTRING(reviewTime,4,2)||'/'||RIGHT(reviewTime,4)
ELSE '9999/01/01' END AS reviewDate ,
unixreviewTime,
CASE WHEN reviewTime is NOT NULL THEN CAST(LEFT(reviewTime,2) AS INT) ELSE 1 END as MONTH,
CASE WHEN CAST(LEFT(reviewTime,2) AS INT) BETWEEN 1 AND 3 THEN 'Q1'
WHEN CAST(LEFT(reviewTime,2) AS INT) BETWEEN 4 AND 6 THEN 'Q2'
WHEN CAST(LEFT(reviewTime,2) AS INT) BETWEEN 7 AND 9 THEN 'Q3'
WHEN CAST(LEFT(reviewTime,2) AS INT) BETWEEN 10 AND 12 THEN 'Q4' 
ELSE 'Q1' END AS QUARTER,                                                                                 
CASE WHEN reviewTime is NOT NULL THEN CAST(RIGHT(reviewTime,4) AS INT) ELSE 9999 END as YEAR FROM
(SELECT DISTINCT reviewTime,unixreviewTime FROM review_data_raw r LEFT JOIN review_data_analysis_standard.Date d ON 
 r.unixreviewTime=d.reviewTimeStamp WHERE d.reviewTimeStamp IS NULL and r.unixreviewTime IS NOT NULL)a
              

INSERT INTO review_data_analysis_standard.product_Categories (CategoryName)
(SELECT DISTINCT  REPLACE(CATEGORY,'"','') AS categoryName FROM
(SELECT distinct SPLIT_PART(REPLACE(REPLACE(Categories,']',''),'[',''),',',1) AS CATEGORY FROM  metadata_raw 
UNION
SELECT distinct SPLIT_PART(REPLACE(REPLACE(Categories,']',''),'[',''),',',2) AS CATEGORY FROM  metadata_raw
UNION
SELECT distinct SPLIT_PART(REPLACE(REPLACE(Categories,']',''),'[',''),',',3) AS CATEGORY FROM  metadata_raw
UNION
SELECT distinct SPLIT_PART(REPLACE(REPLACE(Categories,']',''),'[',''),',',4) AS CATEGORY FROM  metadata_raw
UNION
SELECT distinct SPLIT_PART(REPLACE(REPLACE(Categories,']',''),'[',''),',',5) AS CATEGORY FROM  metadata_raw
UNION
SELECT distinct SPLIT_PART(REPLACE(REPLACE(Categories,']',''),'[',''),',',6) AS CATEGORY FROM  metadata_raw
UNION
SELECT distinct SPLIT_PART(REPLACE(REPLACE(Categories,']',''),'[',''),',',7) AS CATEGORY FROM  metadata_raw
UNION
SELECT distinct SPLIT_PART(REPLACE(REPLACE(Categories,']',''),'[',''),',',8) AS CATEGORY FROM  metadata_raw
UNION
SELECT distinct SPLIT_PART(REPLACE(REPLACE(Categories,']',''),'[',''),',',9) AS CATEGORY FROM  metadata_raw
UNION
SELECT distinct SPLIT_PART(REPLACE(REPLACE(Categories,']',''),'[',''),',',10) AS CATEGORY FROM  metadata_raw
UNION
SELECT distinct SPLIT_PART(REPLACE(REPLACE(Categories,']',''),'[',''),',',11) AS CATEGORY FROM  metadata_raw
UNION
SELECT distinct SPLIT_PART(REPLACE(REPLACE(Categories,']',''),'[',''),',',12) AS CATEGORY FROM  metadata_raw
UNION
SELECT distinct SPLIT_PART(REPLACE(REPLACE(Categories,']',''),'[',''),',',13) AS CATEGORY FROM  metadata_raw
UNION
SELECT distinct SPLIT_PART(REPLACE(REPLACE(Categories,']',''),'[',''),',',14) AS CATEGORY FROM  metadata_raw
UNION
SELECT distinct SPLIT_PART(REPLACE(REPLACE(Categories,']',''),'[',''),',',15) AS CATEGORY FROM  metadata_raw
UNION
SELECT distinct SPLIT_PART(REPLACE(REPLACE(Categories,']',''),'[',''),',',16) AS CATEGORY FROM  metadata_raw
UNION
SELECT distinct SPLIT_PART(REPLACE(REPLACE(Categories,']',''),'[',''),',',17) AS CATEGORY FROM metadata_raw
UNION
SELECT distinct SPLIT_PART(REPLACE(REPLACE(Categories,']',''),'[',''),',',18) AS CATEGORY FROM metadata_raw
UNION
SELECT distinct SPLIT_PART(REPLACE(REPLACE(Categories,']',''),'[',''),',',19) AS CATEGORY FROM  metadata_raw
UNION
SELECT distinct SPLIT_PART(REPLACE(REPLACE(Categories,']',''),'[',''),',',20) AS CATEGORY FROM  metadata_raw
)a LEFT JOIN review_data_analysis_standard.product_Categories c ON REPLACE(a.category,'"','')=c.CategoryName
 WHERE c.category IS NULL
              

              
INSERT INTO review_data_analysis_standard.Product (Asin,price,categoryID,ProductTimeStamp)              
SELECT a.* FROM 
(SELECT DISTINCT Asin,categoryID,PRICE, EXTRACT(EPOCH FROM GETDATE()) as "TimeStamp" FROM 
metadata_raw a LEFT JOIN review_data_analysis_standard.product_Categories b
ON REPLACE(SPLIT_PART(REPLACE(REPLACE(a.Categories,']',''),'[',''),',',1),'"','')=b.CategoryName)a 
LEFT JOIN review_data_analysis_standard.Product p ON a.asin=p.asin WHERE p.asin IS NULL

 
UPDATE review_data_analysis_standard.Product 
SET bucketID =CASE WHEN CAST(PRICE AS FLOAT) <5 THEN 10001 
WHEN CAST(PRICE AS FLOAT) >=5 AND CAST(PRICE AS FLOAT)<20 THEN 10003
WHEN CAST(PRICE AS FLOAT) >=20 AND CAST(PRICE AS FLOAT)<50 THEN 10000
WHEN CAST(PRICE AS FLOAT) >=50 THEN 10002
ELSE 10004 END

INSERT INTO review_data_analysis_standard.review_data (reviewerID,asin,dateID,PRICE,helpful,overall)
SELECT * FROM 
(SELECT DISTINCT reviewerid, r.asin,d.dateID,p.price,helpful,CAST(overall AS FLOAT) FROM
review_data_raw r LEFT JOIN review_data_analysis_standard.Product pr ON r.asin=pr.asin
LEFT JOIN review_data_analysis_standard.Date d ON r.unixreviewTime=d.reviewTimeStamp)a
LEFT JOIN  review_data_analysis_standard.review_data r ON a.reviewerid||a.asin=r.reviewerid||r.asin 
WHERE r.reviewerID IS NULL
