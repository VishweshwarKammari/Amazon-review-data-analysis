create SCHEMA IF NOT EXISTS review_data_analysis_standard;


CREATE TABLE IF NOT EXISTS review_data_analysis_standard.Date
(
  dateID INT,
  reviewDate varchar(10),
  reviewTimeStamp varchar(10),
  Month INT,
  QUARTER varchar(2),
  "YEAR" INT,
  PRIMARY KEY(dateID)
);


CREATE TABLE IF NOT EXISTS review_data_analysis_standard.product_Categories
(
  CategoryID INT IDENTITY(1000,1),
  CategoryName varchar,
  PRIMARY KEY(CategoryID)
);

CREATE TABLE IF NOT EXISTS review_data_analysis_standard.price_bucket
(
  BucketID INT IDENTITY(10000,1),
  PriceBucket varchar(10),
  BucketRange varchar,
  PRIMARY KEY(BucketID)
)


CREATE TABLE IF NOT EXISTS review_data_analysis_standard.Product
(
  asin varchar(10),
  bucketID INT,
  categoryID INT,
  ProductTimeStamp varchar(10),
  Price FLOAT,
  PRIMARY KEY(asin),
  FOREIGN KEY(BucketID) references review_data_analysis_standard.price_bucket(BucketID),
  FOREIGN KEY(categoryID) references review_data_analysis_standard.Product_Categories(CategoryID)
)
distkey(asin);


create TABLE IF NOT EXISTS review_data_analysis_standard.review_data
(
 reviewID BIGINT IDENTITY(1000000,1),
 reviewerID varchar(25),
 asin varchar(10),
 dateID INT,
 PRICE FLOAT,
 helpful varchar,
 overall FLOAT,
 PRIMARY KEY(reviewID),
 FOREIGN KEY(asin) references review_data_analysis_standard.product(asin),
 FOREIGN KEY(dateID) references review_data_analysis_standard.Date(dateID)
 )
 DISTKEY(ASIN)
 SORTKEY(ASIN,DateID);