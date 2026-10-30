// MovieLens ml-latest-small. Letakkan movies.csv, ratings.csv, links.csv, tags.csv di folder import Neo4j.
// Jalankan bagian ini pada database kosong. File ratings.csv berisi userId,movieId,rating,timestamp.
CREATE CONSTRAINT movie_id_unique IF NOT EXISTS FOR (m:Movie) REQUIRE m.movieId IS UNIQUE;
CREATE CONSTRAINT user_id_unique IF NOT EXISTS FOR (u:User) REQUIRE u.userId IS UNIQUE;
CREATE CONSTRAINT genre_name_unique IF NOT EXISTS FOR (g:Genre) REQUIRE g.name IS UNIQUE;

LOAD CSV WITH HEADERS FROM 'file:///movies.csv' AS row
WITH row WHERE row.movieId IS NOT NULL
MERGE (m:Movie {movieId: toInteger(row.movieId)})
SET m.title = row.title;

LOAD CSV WITH HEADERS FROM 'file:///movies.csv' AS row
MATCH (m:Movie {movieId: toInteger(row.movieId)})
WITH m, split(coalesce(row.genres,''),'|') AS genres
UNWIND genres AS genreName
WITH m, genreName WHERE genreName <> '' AND genreName <> '(no genres listed)'
MERGE (g:Genre {name: genreName})
MERGE (m)-[:IN_GENRE]->(g);

LOAD CSV WITH HEADERS FROM 'file:///ratings.csv' AS row
WITH row WHERE row.userId IS NOT NULL AND row.movieId IS NOT NULL
MERGE (u:User {userId: toInteger(row.userId)})
WITH u, row
MATCH (m:Movie {movieId: toInteger(row.movieId)})
MERGE (u)-[r:RATED]->(m)
SET r.rating = toFloat(row.rating), r.timestamp = toInteger(row.timestamp);

LOAD CSV WITH HEADERS FROM 'file:///links.csv' AS row
MATCH (m:Movie {movieId: toInteger(row.movieId)})
SET m.imdbId = CASE WHEN row.imdbId = '' THEN null ELSE row.imdbId END,
    m.tmdbId = CASE WHEN row.tmdbId = '' THEN null ELSE row.tmdbId END;

LOAD CSV WITH HEADERS FROM 'file:///tags.csv' AS row
MATCH (u:User {userId: toInteger(row.userId)})
MATCH (m:Movie {movieId: toInteger(row.movieId)})
CREATE (u)-[:TAGGED {tag:row.tag, timestamp:toInteger(row.timestamp)}]->(m);
