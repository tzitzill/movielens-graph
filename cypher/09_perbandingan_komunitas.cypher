// Tabel irisan komunitas Louvain dan Leiden.
MATCH (u:User)
WHERE u.louvainUserCommunity IS NOT NULL AND u.leidenUserCommunity IS NOT NULL
RETURN u.louvainUserCommunity AS louvainCommunity,
       u.leidenUserCommunity AS leidenCommunity,
       count(*) AS jumlahUser
ORDER BY louvainCommunity,jumlahUser DESC;

// Profil genre berdasarkan komunitas Leiden (jumlah rating-genre, bukan film unik).
MATCH (u:User)-[r:RATED]->(m:Movie)-[:IN_GENRE]->(g:Genre)
WHERE u.leidenUserCommunity IS NOT NULL
WITH u.leidenUserCommunity AS communityId,g.name AS genre,
     count(r) AS jumlahRating,round(avg(toFloat(r.rating))*100)/100.0 AS rataRataRating
ORDER BY communityId,jumlahRating DESC
WITH communityId,collect({genre:genre,jumlahRating:jumlahRating,rataRataRating:rataRataRating})[0..5] AS topGenre
RETURN communityId,topGenre ORDER BY communityId;
