import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Import Database Service (Isar)
import 'core/services/database_service.dart';
import 'core/constants/app_constants.dart';
import 'theme/app_theme.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/data/auth_service.dart';
// Tambahkan import Dashboard!
import 'features/dashboard/presentation/dashboard_screen.dart';

// Cukup SharedPreferences saja yang global di sini
late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await SharedPreferences.getInstance(); // Load preferensi lokal

  // Inisialisasi Isar via Service yang rapi
  await DatabaseService.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pantau data settings dari API
    final settingsAsync = ref.watch(appSettingsProvider);

    // Ambil string warna dari API, default 'emerald' kalau gagal/belum dapet
    String themeColorString = 'emerald';

    settingsAsync.whenData((data) {
      themeColorString = data['theme_color'] ?? 'emerald';
    });

    // Konversi string ke MaterialColor
    final activePalette = AppTheme.getColorPalette(themeColorString);

    // LOGIKA AUTO-LOGIN: Cek apakah token sudah ada di HP
    final bool isLoggedIn = prefs.containsKey(AppConstants.tokenKey);

    return MaterialApp(
      title: 'Qurban Scanner',
      theme: AppTheme.getTheme(primarySwatch: activePalette),
      debugShowCheckedModeBanner: false,
      // Jika sudah login, langsung ke Dashboard! Jika belum, ke Login.
      home: isLoggedIn ? const DashboardScreen() : const LoginScreen(),
    );
  }
}
