WITH 1 AS targetUserId
// 1. Menentukan pengguna target
MATCH (u1:User {userId: targetUserId})
WHERE u1.leidenUserCommunity IS NOT NULL
// 2. Mencari pengguna lain dalam komunitas Leiden yang sama
MATCH (u1)-[:RATED]->(m:Movie)<-[:RATED]-(u2:User)
WHERE u1 <> u2
  AND u1.leidenUserCommunity = u2.leidenUserCommunity
// 3. Menghitung jumlah film bersama
WITH u1, u2,
     count(DISTINCT m) AS jumlahFilmBersama
// 4. Hanya pengguna dengan minimal 3 film bersama
WHERE jumlahFilmBersama >= 3
// 5. Pilih pengguna dengan film bersama terbanyak
ORDER BY jumlahFilmBersama DESC
LIMIT 1
// 6. Visualisasi hubungan rating keduanya
MATCH (u1)-[r1:RATED]->(m:Movie)<-[r2:RATED]-(u2)
RETURN u1, r1, m, r2, u2
LIMIT 20;
