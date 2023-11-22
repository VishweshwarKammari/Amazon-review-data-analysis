create SCHEMA IF NOT EXISTS review_data_analysis_prd;

DROP TABLE  review_data_analysis_prd.Date CASCADE
CREATE TABLE IF NOT EXISTS review_data_analysis_prd.Date
(
  dateID INT,
  reviewDate varchar(10),
  reviewTimeStamp varchar(10),
  Month INT,
  QUARTER varchar(2),
  "YEAR" INT,
  PRIMARY KEY(dateID)
);

DROP TABLE review_data_analysis_prd.product_Categories CASCADE
CREATE TABLE IF NOT EXISTS review_data_analysis_prd.product_Categories
(
  CategoryID INT ,
  CategoryName varchar,
  PRIMARY KEY(CategoryID)
);

DROP TABLE review_data_analysis_prd.price_bucket CASCADE
CREATE TABLE IF NOT EXISTS review_data_analysis_prd.price_bucket
(
  BucketID INT IDENTITY(10000,1),
  PriceBucket varchar(10),
  BucketRange varchar,
  PRIMARY KEY(BucketID)
)

DROP TABLE review_data_analysis_prd.Product CASCADE;
CREATE TABLE IF NOT EXISTS review_data_analysis_prd.Product
(
  asin varchar(10),
  bucketID INT,
  categoryID INT,
  price FLOAT,
  ProductTimeStamp varchar(10),
  PRIMARY KEY(asin),
  FOREIGN KEY(bucketID) references review_data_analysis_prd.price_bucket(bucketID),
  FOREIGN KEY(categoryID) references review_data_analysis_prd.Product_Categories(CategoryID)
)
distkey(asin);

DROP TABLE review_data_analysis_prd.review_data
create TABLE IF NOT EXISTS review_data_analysis_prd.review_data
(
 reviewID BIGINT ,
 reviewerID varchar(25),
 asin varchar(10),
 dateID INT,
 PRICE FLOAT,
 helpful varchar,
 overall FLOAT,
 PRIMARY KEY(reviewID),
 FOREIGN KEY(asin) references review_data_analysis_prd.product(asin),
 FOREIGN KEY(dateID) references review_data_analysis_prd.Date(dateID)
 )
 DISTKEY(ASIN)
 SORTKEY(ASIN,DateID);