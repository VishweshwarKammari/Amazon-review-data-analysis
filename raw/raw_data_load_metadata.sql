COPY amazon_reviews.metadata_raw FROM 's3://amazon-reviews-case-study/raw/metadata'
iam_role 'arn:aws:iam::446795026095:role/MyRedShiftRole'
json 's3://amazon-reviews-case-study/raw/json_path/matadata_json_path.json';