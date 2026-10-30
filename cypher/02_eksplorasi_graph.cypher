// Jalankan setiap query secara terpisah di Neo4j Browser.
MATCH (n) RETURN labels(n) AS label, count(*) AS jumlahNode ORDER BY jumlahNode DESC;
MATCH ()-[r]->() RETURN type(r) AS relationship, count(*) AS jumlah ORDER BY jumlah DESC;
MATCH (u:User) WITH u.userId AS userId, count(*) AS n WHERE n > 1 RETURN userId,n;
MATCH (m:Movie) WITH m.movieId AS movieId, count(*) AS n WHERE n > 1 RETURN movieId,n;
MATCH (u:User)-[r:RATED]->(m:Movie) RETURN count(r) AS totalRating, count(DISTINCT u) AS jumlahUser, count(DISTINCT m) AS filmDinilai;
MATCH (u:User)-[r:RATED]->(m:Movie) WITH u,m,count(r) AS n WHERE n > 1 RETURN u.userId AS userId,m.movieId AS movieId,n LIMIT 20;
