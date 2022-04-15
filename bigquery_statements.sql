-- left join on answers table to get accepted_answer_creation_date
SELECT q.*, a.creation_date as accepted_answer_creation_date 
FROM `bigquery-public-data.stackoverflow.posts_questions` as q
left join `bigquery-public-data.stackoverflow.posts_answers` as a
on q.accepted_answer_id = a.id
WHERE q.tags like '%reactjs%' or q.tags like '%angular%' AND q.creation_date BETWEEN '2021-01-01' and '2021-06-30' 
ORDER BY view_count DESC

-- inner join on questions table to get linked question's tags
SELECT a.*, q.tags as parent_tags
FROM `bigquery-public-data.stackoverflow.posts_answers` as a 
join `bigquery-public-data.stackoverflow.posts_questions` as q 
on a.parent_id = q.id
WHERE q.tags like '%reactjs%' or q.tags like '%angular%' AND q.creation_date BETWEEN '2021-01-01' and '2021-06-30' 
ORDER BY view_count DESC