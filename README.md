# MovieLens Graph Analytics

Proyek ini menggunakan **Neo4j** untuk melihat hubungan antara pengguna dan film dalam dataset MovieLens. Selain mengeksplorasi graph, kami juga menghitung kemiripan pengguna, mencari komunitas menggunakan **Louvain** dan **Leiden**, serta membuat rekomendasi film dengan **Collaborative Filtering**.

## Tujuan

- Membuat graph dari data pengguna, film, genre, dan rating.
- Melihat hubungan dan kemiripan antarpengguna berdasarkan rating film.
- Mengelompokkan pengguna menggunakan Louvain dan Leiden, lalu membandingkan hasil komunitasnya.
- Membuat rekomendasi film dengan Collaborative Filtering biasa dan Collaborative Filtering berbasis komunitas Leiden.

## Dataset

Dataset yang digunakan adalah **MovieLens**, dengan sekitar **610 pengguna, 9.742 film, dan 100.836 rating**. Data yang diimpor meliputi `movies.csv`, `ratings.csv`, `tags.csv`, dan `links.csv`.

Data diolah menjadi graph dengan node `User`, `Movie`, dan `Genre`, serta hubungan seperti `RATED`, `TAGGED`, dan `IN_GENRE`.

## Tools

- **Neo4j Desktop & Cypher** untuk membuat dan menganalisis graph.
- **Neo4j Graph Data Science (GDS)** untuk menjalankan Louvain dan Leiden.
- **Python / Jupyter Notebook** untuk visualisasi hasil komunitas.

## Alur Analisis

1. **Import dan eksplorasi data.** Data MovieLens dimasukkan ke Neo4j, kemudian struktur graph dan hubungan antarentitas diperiksa.
2. **Cosine Similarity.** Kemiripan pengguna dihitung dari rating pada film yang sama-sama mereka nilai. Hasilnya digunakan untuk membentuk jaringan kemiripan pengguna.
3. **Community Detection.** Louvain dan Leiden dijalankan pada graph kemiripan pengguna untuk melihat kelompok yang terbentuk dan membandingkan karakteristiknya.
4. **Rekomendasi film.** Dua pendekatan digunakan:
   - **User-Based Collaborative Filtering (`10_collaborative_filtering.cypher`)**: mencari pengguna yang mirip tanpa membatasi komunitas.
   - **Community-Based Collaborative Filtering (`11_community_based_cf.cypher`)**: mencari pengguna yang mirip, tetapi hanya dari komunitas Leiden yang sama.

Kedua pendekatan rekomendasi menghitung prediksi rating menggunakan rata-rata berbobot Cosine Similarity dan menampilkan **Top-10 film** yang belum dinilai pengguna target.

## Cara Menjalankan

1. Instal **Neo4j Desktop** dan plugin **Graph Data Science (GDS)** yang sesuai.
2. Letakkan file CSV dataset di folder `import` Neo4j.
3. Buka Neo4j Browser, lalu jalankan file `.cypher` dalam folder `cypher/` mengikuti urutan nomornya, mulai dari `01_import_data.cypher`.
4. Untuk melihat visualisasi tambahan, jalankan `Visualisasi Louvain Leiden.ipynb` setelah menyiapkan file CSV hasil ekspor graph yang dibutuhkan notebook.

## Hasil

Dari proyek ini, kami memperoleh graph MovieLens, hubungan kemiripan antarpengguna, hasil pengelompokan komunitas Louvain dan Leiden, serta daftar rekomendasi film dari dua pendekatan Collaborative Filtering. Query dan notebook dalam repository dapat digunakan untuk melihat hasil analisis tersebut.

## Batasan

- Graph kemiripan hanya menyimpan sebagian tetangga teratas, bukan seluruh pasangan pengguna.
- Hasil komunitas dapat berubah bergantung pada konfigurasi dan proses algoritma.
- Pada pendekatan berbasis komunitas, pengguna yang sangat mirip tetap bisa tidak dipilih jika berada di komunitas berbeda.

## Kontribusi Anggota

1. Raden Roro Azahra Tzitziliani Foulin (23031554003) - Data Preparation, Graph Analysis, Louvain & Leiden, Collaborative Filtering, Visualization
2. Fardaniyah Hazhiratul Dzauq (23031554045) - Data Preparation, Graph Analysis, Louvain & Leiden, Collaborative Filtering, Visualization
3. Novanna Zahrah Zahrani (23031554141) - Data Preparation, Graph Analysis, Louvain & Leiden, Collaborative Filtering, Visualization
4. Fherenilla Anandianus (23031554205) - Data Preparation, Graph Analysis, Louvain & Leiden, Collaborative Filtering, Visualization
