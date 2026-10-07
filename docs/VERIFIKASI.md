# Verifikasi Praktikum 2

Tanggal: **7 Oktober 2026**.

| Pemeriksaan | Hasil |
| --- | --- |
| `flutter analyze` | Lulus, tidak ada masalah |
| `flutter test` | Seluruh 8 pengujian lulus |
| `flutter test tool/capture_preview.dart` | Kedua skenario render lulus |
| `flutter build web --no-wasm-dry-run --no-web-resources-cdn` | Build release web berhasil dengan engine lokal |
| `flutter build apk --release` dengan mirror CFUG pada sesi build | Build release Android berhasil |

## Perilaku yang diuji

1. Nilai awal **0**, label **GENAP**, dan latar **biru**.
2. Tambah menghasilkan **1/oranye**, kemudian **2/biru**.
3. Kurang melewati nol: **−1/oranye**, **−2/biru**; tambah dari −2 menjadi −1.
4. Reset dari nilai positif maupun negatif menghasilkan **0/biru**. Reset saat nol tetap nol.
5. **25 ketukan cepat** menghasilkan nilai **25** tanpa kehilangan perubahan state.
6. Layout **320 × 568**, **844 × 390**, dan **1440 × 900** dapat digunakan tanpa overflow; tombol dapat dijangkau dengan scroll pada layar pendek.
7. Pembesaran teks **150%** dapat digunakan tanpa overflow.

Pratinjau pada `docs/screenshots/` dirender langsung dari widget Flutter dengan font aplikasi dan ikon Material. Tampilan kondisi genap dan ganjil telah diperiksa secara visual.

Konfigurasi build: Flutter **3.47.5**, Dart **3.13.4**, Android SDK **36**, NDK **30.0.16248370**. Mirror CFUG digunakan pada sesi build karena akses jaringan ke server artefak utama gagal; pilihan mirror tersedia dalam [dokumentasi Flutter](https://docs.flutter.dev/community/china). Aplikasi menggunakan aset lokal saat berjalan.

Pada workspace pengerjaan, APK tersedia sebagai `dist/counter-lab.apk` dan ZIP kode sumber sebagai `dist/itenas-counter-praktikum-2.zip`. Setelah clone repository, APK dapat dibuat dengan perintah build di atas.

Pengujian interaksi dilakukan melalui Flutter widget tests. Build Android berhasil; pengujian instalasi pada ponsel fisik belum dilakukan karena tidak ada perangkat Android yang terhubung. Build iOS memerlukan macOS dan Xcode.
