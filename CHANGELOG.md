# 📋 Changelog - Qurban App (Flutter Mobile)

Semua perubahan penting pada proyek ini akan didokumentasikan di file ini.

Format mengikuti [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
dan proyek ini mengikuti [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [v1.0.0] - 2026-05-12

### 🎉 Initial Release - Qurban Scanner Mobile App

Rilis perdana aplikasi **Qurban Scanner** berbasis Flutter sebagai companion app dari **Qurban App (Laravel Backend)**. Dirancang untuk mempercepat proses verifikasi kupon di lapangan menggunakan smartphone.

---

### ✨ Added (Fitur Baru)

#### 📱 Core Application
- **Inisialisasi proyek Flutter** dengan struktur folder yang terorganisir dan clean architecture.
- **Konfigurasi tema aplikasi** dengan warna utama Emerald Green (`#10B981`) yang selaras dengan Admin Panel Laravel.
- **Splash Screen** dengan animasi logo Qurban App yang smooth.

#### 🔍 Smart QR Scanner
- **Real-time QR Code Scanner** menggunakan kamera perangkat untuk membaca kupon digital Mudhohi, Mustahiq, dan Panitia.
- **Multi-Role Detection:** Sistem otomatis mendeteksi jenis pemegang kupon berdasarkan data dari API backend.
- **Validasi Ganda:** Pencegahan scan kupon yang sudah diambil dengan notifikasi visual yang jelas (warna merah/hijau).
- **Haptic Feedback** saat scan berhasil atau gagal untuk pengalaman pengguna yang lebih baik.

#### 🔐 Authentication & Security
- **Login Screen** dengan antarmuka glassmorphism yang premium dan elegan.
- **Token-based Authentication** menggunakan Laravel Sanctum untuk keamanan komunikasi API.
- **Persistent Session:** Status login tersimpan secara lokal menggunakan `SharedPreferences`.
- **Auto Logout** saat token kadaluarsa atau tidak valid.

#### 📊 Dashboard & Monitoring
- **Dashboard Real-Time** menampilkan ringkasan statistik harian langsung dari API:
  - Total Mudhohi terdaftar
  - Total sudah mengambil daging
  - Total Mustahiq
  - Sisa kupon belum diambil
- **Greeting dinamis** berdasarkan waktu (Pagi / Siang / Sore / Malam).

#### 🔄 Offline-First Sync
- **Isar Database** sebagai local database untuk menyimpan data kupon secara offline.
- **Sinkronisasi otomatis** saat koneksi internet tersedia kembali.
- **Indikator status koneksi** yang informatif di bagian atas layar.
- **Progress bar sinkronisasi** untuk transparansi proses unduh data.

#### 🖼️ Gallery & Media
- **Gallery Screen** untuk melihat foto-foto dokumentasi hewan qurban yang diunggah dari Admin Panel.
- **Integrasi Biometrik** (fingerprint / face ID) sebagai perlindungan akses galeri privat.
- **Cloud Sync** untuk mengunduh foto dari storage Laravel ke perangkat lokal.

#### ⚙️ Settings & Konfigurasi
- **Pengaturan URL Server** yang dapat diubah langsung dari aplikasi tanpa perlu build ulang.
- **Manajemen Sesi** aktif dengan opsi logout yang aman.
- **Info Aplikasi:** Versi, developer, dan tautan ke repository GitHub.

---

### 🛠️ Tech Stack (v1.0.0)

| Komponen | Teknologi |
|---|---|
| Framework | Flutter 3.x (Dart) |
| State Management | Provider / Riverpod |
| Local Database | Isar DB |
| HTTP Client | Dio |
| QR Scanner | `mobile_scanner` |
| Authentication | Laravel Sanctum (Token) |
| Storage | SharedPreferences |
| Biometric | `local_auth` |

---

### 🔗 Kompatibilitas

- **Backend:** Laravel Qurban App v1.3.0+
- **Android:** API Level 21+ (Android 5.0 Lollipop ke atas)
- **iOS:** iOS 12.0 ke atas

---

### 👨‍💻 Developer

**RadevankaProject** — [@bangameck](https://instagram.com/bangameck)
📍 Pekanbaru, Riau, Indonesia

---

*Changelog ini dibuat mengikuti standar [Keep a Changelog](https://keepachangelog.com/).*
