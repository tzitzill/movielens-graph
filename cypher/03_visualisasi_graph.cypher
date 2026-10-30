// Ganti ke tampilan Graph di Neo4j Browser.
MATCH (u:User)-[r:RATED]->(m:Movie) RETURN u,r,m LIMIT 50;
MATCH (u:User)-[t:TAGGED]->(m:Movie) RETURN u,t,m LIMIT 50;
MATCH (m:Movie)-[r:IN_GENRE]->(g:Genre) RETURN m,r,g LIMIT 50;
