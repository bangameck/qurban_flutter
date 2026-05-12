# 📱 Qurban Scanner — Flutter Mobile App

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-00BCD4?style=for-the-badge&logo=flutter&logoColor=white)
![Isar](https://img.shields.io/badge/Isar_DB-FF6B35?style=for-the-badge&logo=databricks&logoColor=white)

**Qurban Scanner** adalah aplikasi mobile berbasis Flutter yang berfungsi sebagai _companion app_ resmi dari [Qurban App (Laravel Backend)](https://github.com/bangameck/qurban-app). Dirancang khusus untuk Panitia Qurban di lapangan, memungkinkan verifikasi kupon distribusi daging secara cepat, akurat, dan dapat bekerja dalam kondisi **offline**.

---

## ✨ Fitur Utama

### 🔍 Smart QR Scanner
- **Scan real-time** menggunakan kamera belakang perangkat via `mobile_scanner`.
- **Multi-Role Detection:** Otomatis membedakan kupon **Mudhohi** 🔵, **Mustahiq** 🟢, dan **Panitia** 🩷 dengan kode warna berbeda.
- **Anti-duplikasi:** Menampilkan peringatan `SUDAH DIAMBIL` jika kupon sudah pernah di-scan.
- **Input Manual Fallback:** Form input kode kupon manual jika kamera bermasalah.
- **Haptic Feedback:** Getaran ringan saat scan berhasil dan getaran kuat saat ditolak.
- **Senter & Flip Kamera** tersedia langsung di layar scanner.

### 📊 Dashboard Real-Time (Offline-First)
- Menampilkan **4 KPI Card:** Total Sapi, Pendaftar (Mudhohi), Total Kupon, dan Selesai Scan.
- **Grafik Donut (PieChart):** Status Sapi (Menunggu / Potong / Kuliti / Selesai) dan Komposisi Kupon (Umum / Mudhohi / Panitia).
- **Greeting Dinamis** berdasarkan waktu: Pagi / Siang / Sore / Malam.
- **Status Badge Koneksi:** Hijau (Online) / Merah (Offline) yang bisa diklik untuk ubah IP Server.
- **Pull-to-Refresh** untuk memperbarui data secara manual.
- **Cache Lokal:** Data dashboard tersimpan di `SharedPreferences`, tetap tampil walau offline.

### 🔄 Sinkronisasi Data (Offline-First Sync)
- **Isar Database** sebagai local database yang cepat dan ringan untuk menyimpan data kupon offline.
- **Progress Dialog** animasi saat sync berlangsung, menampilkan persentase real-time.
- **Push & Pull:** Mengirim data scan offline ke server, lalu menarik data terbaru.
- **Invalidasi Provider** otomatis setelah sync selesai untuk refresh tampilan.

### 🔐 Autentikasi & Keamanan
- **Login Screen** dengan UI glassmorphism premium menggunakan font `ElMessiri`.
- **Token-Based Auth** via Laravel Sanctum — token disimpan aman di `SharedPreferences`.
- **Auto-Login:** Jika token masih valid, langsung masuk ke Dashboard tanpa perlu login ulang.
- **Logout** dari Dashboard dengan konfirmasi.

### ⚙️ Pengaturan Server Dinamis
- **URL Server dapat diubah langsung dari dalam aplikasi** tanpa perlu build ulang — sangat berguna saat IP lokal berubah.
- Disimpan persisten di `SharedPreferences` melalui `serverUrlProvider` (Riverpod).

---

## 🛠️ Tech Stack

| Komponen | Teknologi | Versi |
|---|---|---|
| Framework | Flutter | SDK ^3.11.5 |
| Bahasa | Dart | — |
| State Management | flutter_riverpod | ^2.6.1 |
| Local Database | isar + isar_flutter_libs | ^3.1.0+1 |
| QR Scanner | mobile_scanner | ^7.2.0 |
| HTTP Client | http | ^1.6.0 |
| Charts | fl_chart | ^1.2.0 |
| Persistensi | shared_preferences | ^2.5.5 |
| App Icon | flutter_launcher_icons | ^0.14.4 |
| Code Gen | build_runner + isar_generator | — |

**Font Kustom:** `ElMessiri` (Regular & Bold) — tersimpan di `assets/fonts/`

---

## 🗂️ Struktur Project

```
lib/
├── main.dart                          # Entry point & Auto-Login logic
├── theme/
│   └── app_theme.dart                 # Tema & Color Palette dinamis
├── core/
│   ├── constants/
│   │   └── app_constants.dart         # Base URL, endpoint, key SharedPrefs
│   ├── models/
│   │   ├── kupon_model.dart           # Isar model untuk data kupon
│   │   └── kupon_model.g.dart        # Generated Isar adapter
│   ├── services/
│   │   └── database_service.dart      # Inisialisasi & akses Isar DB
│   └── utils/
│       └── premium_alert.dart         # Reusable alert dialog (Success/Error)
└── features/
    ├── auth/
    │   ├── data/auth_service.dart     # Login, logout, serverUrlProvider
    │   └── presentation/login_screen.dart
    ├── dashboard/
    │   ├── data/sync_service.dart     # Push & Pull sinkronisasi Isar ↔ API
    │   └── presentation/dashboard_screen.dart
    └── scanner/
        ├── data/scan_service.dart     # Logika verifikasi kode kupon via API
        └── presentation/scanner_screen.dart
```

---

## 🚀 Panduan Instalasi & Setup

### Prasyarat
- Flutter SDK **^3.11.5** sudah terinstall
- Backend **[Laravel Qurban App](https://github.com/bangameck/qurban-app)** sudah berjalan (lokal atau server)

### Langkah Instalasi

**1. Clone Repository**
```bash
git clone https://github.com/bangameck/qurban_flutter.git
cd qurban_flutter
```

**2. Install Dependencies**
```bash
flutter pub get
```

**3. Generate Isar Code** *(wajib sebelum build pertama kali)*
```bash
dart run build_runner build --delete-conflicting-outputs
```

**4. Generate App Icon**
```bash
dart run flutter_launcher_icons
```

**5. Konfigurasi URL Server**

Edit `lib/core/constants/app_constants.dart` dan sesuaikan `baseUrl`:
```dart
// Emulator Android → PC via artisan serve
static const String baseUrl = 'http://10.0.2.2:8000';

// Real Device (HP) → PC via WiFi
static const String baseUrl = 'http://192.168.1.xxx:8000';

// Production Server
static const String baseUrl = 'https://qurban.domain-anda.com';
```

> 💡 **Tip:** URL juga bisa diubah langsung dari dalam aplikasi tanpa rebuild, lewat tombol badge koneksi di Dashboard.

**6. Jalankan Aplikasi**
```bash
# Mode Development
flutter run

# Build APK Release (Android)
flutter build apk --release

# Build untuk iOS
flutter build ios --release
```

---

## 🔗 Kompatibilitas

- **Backend:** Laravel Qurban App v1.0.0+
- **Android:** API Level 21+ (Android 5.0 Lollipop ke atas)
- **iOS:** iOS 12.0 ke atas

---

## 👨‍💻 Dikembangkan Oleh

**RadevankaProject**
<br>
[![Typing SVG](https://readme-typing-svg.demolab.com?font=Work+Sans&weight=800&size=18&pause=1000&color=10B981&vCenter=true&width=600&lines=Digitalisasi+Manajemen+Qurban+Modern;Developer:+@bangameck;Lokasi:+Pekanbaru,+Riau)](https://git.io/typing-svg)

- 🧑‍💻 **Developer:** [@bangameck](https://instagram.com/bangameck)
- 📍 **Lokasi:** Pekanbaru, Riau, Indonesia 🇮🇩
- 🎯 **Visi:** _Memudahkan umat dalam ibadah melalui teknologi._

---

## 📄 Lisensi

Hak Cipta &copy; 2026 **Qurban App Radevanka**. Seluruh hak cipta dilindungi.
Lihat [LICENSE.md](LICENSE.md) untuk detail lengkap.
