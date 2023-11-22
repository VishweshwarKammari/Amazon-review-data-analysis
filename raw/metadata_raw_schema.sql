DROP TABLE IF EXISTS amazon_reviews.metadata_raw;
CREATE TABLE IF NOT EXISTS amazon_reviews.metadata_raw
(
  asin varchar,
  title varchar(max),
  price varchar,
  imUrl varchar,
  related_also_bought varchar(max),
  related_also_viewed varchar(max),
  related_bought_together varchar(max),
  related_buy_after_viewing varchar(max),
  salesRank varchar,
  brand varchar,
  categories varchar(max)
);


