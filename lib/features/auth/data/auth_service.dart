import 'dart:convert';
import 'dart:developer' as developer; // <--- Import Logger Bawaan Dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../main.dart';
import '../../../core/constants/app_constants.dart';

// 1. PROVIDER UNTUK BASE URL
class ServerUrlNotifier extends Notifier<String> {
  @override
  String build() {
    return prefs.getString('server_url') ?? AppConstants.baseUrl;
  }

  void updateUrl(String newUrl) {
    state = newUrl;
  }
}

final serverUrlProvider = NotifierProvider<ServerUrlNotifier, String>(
  ServerUrlNotifier.new,
);

// 2. PROVIDER UNTUK PING KONEKSI (Cek Latency)
final pingProvider = FutureProvider.autoDispose<int>((ref) async {
  final baseUrl = ref.watch(serverUrlProvider);
  final stopwatch = Stopwatch()..start();

  developer.log('Ping started to: $baseUrl/api/settings', name: 'PingService');

  try {
    final response = await http
        .get(Uri.parse('$baseUrl/api/settings'))
        .timeout(const Duration(seconds: 10)); // <-- Perpanjang jadi 10 detik

    if (response.statusCode == 200) {
      developer.log(
        'Ping success: ${stopwatch.elapsedMilliseconds}ms',
        name: 'PingService',
      );
      return stopwatch.elapsedMilliseconds;
    }

    developer.log(
      'Ping failed with status: ${response.statusCode}',
      name: 'PingService',
    );
    throw Exception('Error Status: ${response.statusCode}');
  } catch (e, stackTrace) {
    developer.log(
      'Ping exception caught',
      error: e,
      stackTrace: stackTrace,
      name: 'PingService',
    );
    throw Exception('Offline');
  }
});

// 3. PROVIDER UNTUK SETTINGS LARAVEL
final appSettingsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final baseUrl = ref.watch(serverUrlProvider);

  developer.log(
    'Fetching settings from: $baseUrl/api/settings',
    name: 'SettingsService',
  );

  try {
    final response = await http
        .get(Uri.parse('$baseUrl/api/settings'))
        .timeout(const Duration(seconds: 10)); // <-- Perpanjang jadi 10 detik

    if (response.statusCode == 200) {
      developer.log(
        'Settings fetched successfully: ${response.body}',
        name: 'SettingsService',
      );
      return jsonDecode(response.body);
    }

    developer.log(
      'Settings failed with status: ${response.statusCode}',
      name: 'SettingsService',
    );
    throw Exception('Gagal memuat pengaturan aplikasi');
  } catch (e, stackTrace) {
    developer.log(
      'Settings exception caught',
      error: e,
      stackTrace: stackTrace,
      name: 'SettingsService',
    );
    throw Exception('Gagal koneksi ke server');
  }
});

// 4. AUTH SERVICE
class AuthService {
  final String baseUrl;
  AuthService(this.baseUrl);

  Future<bool> login(String phoneNumber, String password) async {
    developer.log(
      'Login attempt started for: $phoneNumber',
      name: 'AuthService',
    );
    developer.log('Target URL: $baseUrl/api/login', name: 'AuthService');

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/login'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'phone_number': phoneNumber,
              'password': password,
            }),
          )
          .timeout(
            const Duration(seconds: 15),
          ); // <-- Perpanjang jadi 15 detik untuk login pertama

      developer.log(
        'Login response status: ${response.statusCode}',
        name: 'AuthService',
      );
      developer.log(
        'Login response body: ${response.body}',
        name: 'AuthService',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await prefs.setString('auth_token', data['token']);
        developer.log('Login successful, token saved.', name: 'AuthService');
        return true;
      } else {
        // Jika server merespon dengan format JSON, ambil message-nya
        try {
          final error = jsonDecode(response.body);
          throw Exception(error['message'] ?? 'Login Gagal');
        } catch (formatException) {
          // Jika server merespon dengan HTML (misal error 500 Laravel)
          throw Exception(
            'Terjadi kesalahan server (Status ${response.statusCode})',
          );
        }
      }
    } catch (e, stackTrace) {
      developer.log(
        'Login exception caught',
        error: e,
        stackTrace: stackTrace,
        name: 'AuthService',
      );

      // Lempar error spesifik ke UI biar kita tahu persis penyakitnya
      if (e.toString().contains('TimeoutException')) {
        throw Exception(
          'Koneksi lambat (Timeout). Pastikan HP dan Laptop di WiFi yang sama!',
        );
      } else if (e.toString().contains('SocketException')) {
        throw Exception(
          'Gagal menyambung! Cek IP Server dan matikan Firewall Laptop sementara.',
        );
      } else {
        throw Exception(e.toString().replaceAll('Exception: ', ''));
      }
    }
  }

  Future<void> logout() async {
    await prefs.remove('auth_token');
    developer.log('User logged out', name: 'AuthService');
  }

  bool isLoggedIn() {
    return prefs.containsKey('auth_token');
  }
}

// Update provider auth
final authServiceProvider = Provider<AuthService>((ref) {
  final baseUrl = ref.watch(serverUrlProvider);
  return AuthService(baseUrl);
});
