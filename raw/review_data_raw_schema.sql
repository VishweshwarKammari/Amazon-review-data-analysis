DROP TABLE  amazon_reviews.review_data_raw;
CREATE TABLE IF NOT EXISTS amazon_reviews.review_data_raw
(
reviewerid string,
asin varchar,  
  reviewername varchar,
  helpful varchar,
  reviewtext varchar(max) ,
  overall varchar,
  summary varchar(max) ,
  unixreviewtime varchar,
  reviewtime varchar
)


