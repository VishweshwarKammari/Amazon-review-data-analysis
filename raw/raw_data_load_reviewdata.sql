copy review_data_raw from 's3://amazon-reviews-case-study/raw/reviews'
iam_role 'arn:aws:iam::446795026095:role/MyRedShiftRole'
json 's3://amazon-reviews-case-study/raw/reviews/json_path/json_path_review.json';