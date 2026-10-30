CALL gds.leiden.write('userSimilarity',{
 relationshipWeightProperty:'weight',
 writeProperty:'leidenUserCommunity'
})
YIELD communityCount,modularity,nodePropertiesWritten
RETURN communityCount,modularity,nodePropertiesWritten;

MATCH (u:User)
WHERE u.leidenUserCommunity IS NOT NULL
RETURN u.leidenUserCommunity AS communityId,count(*) AS jumlahUser
ORDER BY jumlahUser DESC;

MATCH (u1:User)-[r:COSINE_SIMILAR]->(u2:User)
WHERE u1.leidenUserCommunity=u2.leidenUserCommunity
RETURN u1,r,u2 LIMIT 100;
