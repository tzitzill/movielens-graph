// Baseline user-based Collaborative Filtering: seluruh pengguna, tanpa filter komunitas.
// Ubah 1 untuk memilih user target lain. Rating yang dipakai adalah data yang sudah ada.
WITH 1 AS targetUserId
MATCH (target:User {userId:targetUserId})
MATCH (target)-[tr:RATED]->(common:Movie)<-[orating:RATED]-(other:User)
WHERE other <> target
WITH target,other,collect({targetRating:toFloat(tr.rating),otherRating:toFloat(orating.rating)}) AS commonRatings
WHERE size(commonRatings)>=3
WITH target,other,
     reduce(d=0.0,x IN commonRatings|d+x.targetRating*x.otherRating) AS dot,
     sqrt(reduce(s=0.0,x IN commonRatings|s+x.targetRating*x.targetRating)) AS n1,
     sqrt(reduce(s=0.0,x IN commonRatings|s+x.otherRating*x.otherRating)) AS n2
WITH target,other,CASE WHEN n1=0 OR n2=0 THEN 0.0 ELSE dot/(n1*n2) END AS similarity
WHERE similarity>0
MATCH (other)-[r:RATED]->(candidate:Movie)
WHERE NOT EXISTS { MATCH (target)-[:RATED]->(candidate) }
WITH candidate,sum(similarity*toFloat(r.rating))/sum(similarity) AS predictedRating,
     count(DISTINCT other) AS similarUsers
WHERE similarUsers>=2
OPTIONAL MATCH (candidate)-[:IN_GENRE]->(g:Genre)
RETURN candidate.movieId AS movieId,candidate.title AS title,
       collect(DISTINCT g.name) AS genre,
       round(predictedRating*100)/100.0 AS predictedRating,similarUsers
ORDER BY predictedRating DESC,similarUsers DESC,movieId ASC LIMIT 10;
