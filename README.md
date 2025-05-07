# Todo App Flutter

Aplikasi To-Do List sederhana yang dibuat dengan Flutter.

## Fitur

- Loading screen dengan animasi Lottie
- Menambahkan tugas baru
- Menandai tugas sebagai selesai
- Menghapus tugas
- Penyimpanan data lokal menggunakan SharedPreferences

## Cara Menjalankan Aplikasi

1. Pastikan Flutter SDK telah terinstal di komputer Anda
2. Clone repository ini
3. Jalankan perintah `flutter pub get` untuk menginstal dependencies
4. Jalankan aplikasi dengan perintah `flutter run`

## Struktur Proyek

```
todo_app_flutter/
├── lib/
│   ├── main.dart                 # Entry point aplikasi
│   ├── models/
│   │   └── todo_model.dart       # Model data untuk Todo
│   ├── screens/
│   │   ├── loading_screen.dart   # Halaman loading dengan animasi
│   │   └── home_screen.dart      # Halaman utama aplikasi
│   └── services/
│       └── storage_service.dart  # Service untuk penyimpanan data
└── pubspec.yaml                  # Konfigurasi proyek
```

## Dependencies

- `flutter_dotlottie`: Untuk menampilkan animasi Lottie
- `shared_preferences`: Untuk menyimpan data secara lokal
- `uuid`: Untuk menghasilkan ID unik

## Pengembangan Selanjutnya

Beberapa fitur yang dapat ditambahkan untuk pengembangan aplikasi di masa depan:

1. Kategori tugas
2. Pengaturan prioritas tugas
3. Notifikasi pengingat
4. Fitur pencarian
5. Tema aplikasi yang dapat disesuaikan
6. Sinkronisasi data dengan cloud

## Screenshot

[Tambahkan screenshot aplikasi di sini]

## Kontak

[Tambahkan informasi kontak di sini]