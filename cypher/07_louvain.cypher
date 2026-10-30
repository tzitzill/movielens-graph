CALL gds.louvain.write('userSimilarity',{
 relationshipWeightProperty:'weight',
 writeProperty:'louvainUserCommunity'
})
YIELD communityCount,modularity,nodePropertiesWritten
RETURN communityCount,modularity,nodePropertiesWritten;

MATCH (u:User)
WHERE u.louvainUserCommunity IS NOT NULL
RETURN u.louvainUserCommunity AS communityId,count(*) AS jumlahUser
ORDER BY jumlahUser DESC;

MATCH (u1:User)-[r:COSINE_SIMILAR]->(u2:User)
WHERE u1.louvainUserCommunity IS NOT NULL AND u2.louvainUserCommunity IS NOT NULL
RETURN CASE WHEN u1.louvainUserCommunity=u2.louvainUserCommunity THEN 'Internal' ELSE 'Eksternal' END AS jenis,
       count(r) AS jumlahHubungan,round(avg(r.weight)*10000)/10000.0 AS rataRataCosine;

MATCH (u1:User)-[r:COSINE_SIMILAR]->(u2:User)
WHERE u1.louvainUserCommunity=u2.louvainUserCommunity
RETURN u1,r,u2 LIMIT 100;
