WITH 1 AS targetUserId
// 1. Menentukan pengguna target
MATCH (target:User {userId: targetUserId})
WHERE target.leidenUserCommunity IS NOT NULL
// 2. Mencari pengguna dalam komunitas Leiden yang sama
MATCH (target)-[tr:RATED]->(common:Movie)
MATCH (other:User)-[orating:RATED]->(common)
WHERE other <> target
  AND other.leidenUserCommunity = target.leidenUserCommunity
// 3. Mengumpulkan pasangan rating
WITH target, other,
     collect({
         movieId: common.movieId,
         movieTitle: common.title,
         targetRating: toFloat(tr.rating),
         otherRating: toFloat(orating.rating)
     }) AS commonRatings
// 4. Menampilkan isi commonRatings
RETURN
    target.userId AS targetUser,
    other.userId AS otherUser,
    commonRatings,
    size(commonRatings) AS jumlahCommonRatings,
    CASE
        WHEN size(commonRatings) >= 3
        THEN 'Memenuhi'
        ELSE 'Tidak Memenuhi'
    END AS status
ORDER BY jumlahCommonRatings DESC
LIMIT 10;