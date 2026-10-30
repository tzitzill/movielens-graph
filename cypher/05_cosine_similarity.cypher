// Hapus hubungan hasil run sebelumnya agar dapat dijalankan ulang.
MATCH ()-[s:COSINE_SIMILAR]->() DELETE s;
// Similarity dari film bersama (>=5), simpan top-10 tetangga untuk SETIAP user.
MATCH (u1:User)-[r1:RATED]->(m:Movie)<-[r2:RATED]-(u2:User)
WHERE u1 <> u2
WITH u1,u2,
     sum(toFloat(r1.rating)*toFloat(r2.rating)) AS dotProduct,
     sum(toFloat(r1.rating)*toFloat(r1.rating)) AS sumSq1,
     sum(toFloat(r2.rating)*toFloat(r2.rating)) AS sumSq2,
     count(DISTINCT m) AS commonMovies
WHERE commonMovies >= 5 AND sumSq1 > 0 AND sumSq2 > 0
WITH u1,u2,commonMovies,dotProduct/sqrt(sumSq1*sumSq2) AS cosine
ORDER BY u1.userId,cosine DESC,commonMovies DESC,u2.userId
WITH u1,collect({user:u2,similarity:cosine,commonMovies:commonMovies})[0..10] AS topUsers
UNWIND topUsers AS c
MERGE (u1)-[s:COSINE_SIMILAR]->(c.user)
SET s.weight=c.similarity,s.commonMovies=c.commonMovies
RETURN count(s) AS totalRelationships,round(avg(s.weight)*10000)/10000.0 AS averageCosine;

MATCH (u1:User)-[s:COSINE_SIMILAR]->(u2:User)
RETURN u1,s,u2 ORDER BY s.weight DESC LIMIT 30;
