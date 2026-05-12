// Lokasi: lib/core/constants/app_constants.dart

class AppConstants {
  // ---------------------------------------------------------
  // 1. PENGATURAN API (Ganti di sini kalau pindah ke Production)
  // ---------------------------------------------------------

  // URL untuk testing Lokal pakai php artisan serve
  // - Emulator Android ke PC: 'http://10.0.2.2:8000'
  // - Real Device (HP) ke PC via WiFi: 'http://192.168.1.xxx:8000' (Sesuaikan IP PC sampeyan)
  // - Server Production: 'https://qurban.masjid-anda.com'

  static const String baseUrl =
      'http://10.215.177.63:8000'; // Ubah pakai port 8000 kalau pakai artisan serve

  // Otomatis menambahkan /api di belakang baseUrl
  static const String apiUrl = '$baseUrl/api';

  // Endpoint spesifik (biar gampang dipanggil di Service)
  static const String loginEndpoint = '$apiUrl/login';
  static const String settingsEndpoint = '$apiUrl/settings';
  static const String syncKuponEndpoint = '$apiUrl/kupon/sync';

  // ---------------------------------------------------------
  // 2. PENGATURAN LOKAL DATABASE (ISAR)
  // ---------------------------------------------------------
  static const String dbName = 'qurban_db';

  // ---------------------------------------------------------
  // 3. KEY SHARED PREFERENCES
  // ---------------------------------------------------------
  static const String tokenKey = 'auth_token';

  // ---------------------------------------------------------
  // 4. INFO APLIKASI
  // ---------------------------------------------------------
  static const String appVersion = '1.0.0';
}
