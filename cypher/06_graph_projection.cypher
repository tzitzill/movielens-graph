// Memerlukan plugin Graph Data Science (GDS).
// Jika graph sudah ada, jalankan DROP dahulu sebelum memproyeksikan ulang.
CALL gds.graph.exists('userSimilarity') YIELD exists RETURN exists;
// HANYA jika exists=true: CALL gds.graph.drop('userSimilarity') YIELD graphName RETURN graphName;
CALL gds.graph.project(
 'userSimilarity',
 'User',
 {COSINE_SIMILAR:{orientation:'UNDIRECTED',properties:'weight'}}
)
YIELD graphName,nodeCount,relationshipCount
RETURN graphName,nodeCount,relationshipCount;
