// User-based CF dibatasi pada komunitas Leiden yang sama.
WITH 1 AS targetUserId
MATCH (target:User {userId:targetUserId})
WHERE target.leidenUserCommunity IS NOT NULL
MATCH (target)-[tr:RATED]->(common:Movie)<-[orating:RATED]-(other:User)
WHERE other<>target AND other.leidenUserCommunity=target.leidenUserCommunity
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

// BUKTI: commonRatings adalah pasangan rating film bersama, bukan rating >=3.
WITH 1 AS targetUserId
MATCH (target:User {userId:targetUserId})
WHERE target.leidenUserCommunity IS NOT NULL
MATCH (target)-[tr:RATED]->(common:Movie)<-[orating:RATED]-(other:User)
WHERE other<>target AND other.leidenUserCommunity=target.leidenUserCommunity
WITH target,other,collect({movieId:common.movieId,movieTitle:common.title,
 targetRating:toFloat(tr.rating),otherRating:toFloat(orating.rating)}) AS commonRatings
RETURN target.userId AS targetUser,other.userId AS otherUser,
       commonRatings,size(commonRatings) AS jumlahFilmBersama,
       CASE WHEN size(commonRatings)>=3 THEN 'Memenuhi' ELSE 'Tidak Memenuhi' END AS status
ORDER BY jumlahFilmBersama DESC LIMIT 10;

// GRAPH: dua pengguna dari komunitas Leiden yang sama, minimal 3 film bersama.
WITH 1 AS targetUserId
MATCH (u1:User {userId:targetUserId})
WHERE u1.leidenUserCommunity IS NOT NULL
MATCH (u1)-[:RATED]->(m:Movie)<-[:RATED]-(u2:User)
WHERE u1<>u2 AND u1.leidenUserCommunity=u2.leidenUserCommunity
WITH u1,u2,count(DISTINCT m) AS jumlahFilmBersama
WHERE jumlahFilmBersama>=3
ORDER BY jumlahFilmBersama ASC LIMIT 1
MATCH (u1)-[r1:RATED]->(m:Movie)<-[r2:RATED]-(u2)
RETURN u1,r1,m,r2,u2 LIMIT 20;
