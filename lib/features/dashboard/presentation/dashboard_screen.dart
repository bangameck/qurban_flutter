import 'dart:convert';
import 'dart:ui';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_constants.dart';
import '../../auth/data/auth_service.dart';
import '../../auth/presentation/login_screen.dart';
import '../../../main.dart';
import '../../scanner/presentation/scanner_screen.dart';
import '../data/sync_service.dart';
import '../../../core/utils/premium_alert.dart';

// --- PROVIDER UNTUK FETCH DATA DASHBOARD (OFFLINE-FIRST) ---
final dashboardProvider = FutureProvider.autoDispose<Map<String, dynamic>>((
  ref,
) async {
  final baseUrl = ref.watch(serverUrlProvider);
  final token = prefs.getString(AppConstants.tokenKey);
  final cacheKey = 'dashboard_cache_data';

  try {
    // 1. Coba narik data dari server
    final response = await http
        .get(
          Uri.parse('$baseUrl/api/dashboard'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      // 2. Kalau sukses, simpan JSON-nya ke Cache dan set status Online
      prefs.setString(cacheKey, response.body);
      final data = jsonDecode(response.body);
      data['is_online'] = true;
      return data;
    } else {
      // Server terjangkau tapi response error (404, 401, 500, dll)
      developer.log(
        'Server error: HTTP ${response.statusCode}. Fallback ke cache.',
        name: 'Dashboard',
      );
    }
  } catch (e) {
    developer.log(
      'Server tidak terjangkau (${e.runtimeType}). Menggunakan Mode Offline.',
      name: 'Dashboard',
    );
  }

  // 3. Kalau gagal konek (Offline), cek Cache Lokal
  final cachedData = prefs.getString(cacheKey);
  if (cachedData != null) {
    developer.log('Membaca data dari Cache Lokal.', name: 'Dashboard');
    final data = jsonDecode(cachedData);
    data['is_online'] = false;
    return data;
  }

  // 4. Kalau Cache kosong (Belum pernah Sync), return Nilai Default 0
  developer.log('Cache kosong. Menampilkan Data 0 Default.', name: 'Dashboard');
  return {
    'is_online': false,
    'kpi': {'sapi': 0, 'mudhohi': 0, 'kupon_total': 0, 'kupon_scan': 0},
    'nama_admin': 'Panitia',
    'tahun_aktif': DateTime.now().year.toString(),
    'chart_sapi': [0, 0, 0, 0],
    'chart_kategori': [0, 0, 0],
  };
});

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  // --- MODAL PREMIUM: KONFIGURASI IP SERVER ---
  void _showChangeServerPremiumModal(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final urlController = TextEditingController(
      text: ref.read(serverUrlProvider),
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (ctx) {
        bool isSaving = false;
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Center(
                child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.redAccent.withValues(alpha: 0.2),
                          blurRadius: 60,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon Status
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.primaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.dns_rounded,
                            size: 48,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Judul
                        const Text(
                          'KONFIGURASI SERVER',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: Colors.black54,
                            fontFamily: 'ElMessiri',
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Jika status indikator merah, silakan sesuaikan ulang IP / Domain server di bawah ini.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            height: 1.5,
                            fontFamily: 'ElMessiri',
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Input URL
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: TextField(
                            controller: urlController,
                            keyboardType: TextInputType.url,
                            style: const TextStyle(
                              fontFamily: 'ElMessiri',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              hintText: 'http://192.168.x.x:8000',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontFamily: 'ElMessiri',
                              ),
                              prefixIcon: Icon(
                                Icons.dns_rounded,
                                color: theme.primaryColor,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '💡 Emulator: http://10.0.2.2:8000  |  HP: http://192.168.x.x:8000',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                              fontFamily: 'ElMessiri',
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Tombol Simpan
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            onPressed: isSaving
                                ? null
                                : () async {
                                    final newUrl = urlController.text.trim();
                                    if (newUrl.isEmpty) return;
                                    setModalState(() => isSaving = true);
                                    await prefs.setString('server_url', newUrl);
                                    ref.invalidate(serverUrlProvider);
                                    ref.invalidate(dashboardProvider);
                                    if (ctx.mounted) Navigator.pop(ctx);
                                  },
                            icon: isSaving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(
                                    Icons.save_rounded,
                                    color: Colors.white,
                                  ),
                            label: Text(
                              isSaving ? 'Menyimpan...' : 'Simpan & Hubungkan',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'ElMessiri',
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Tombol Lanjutkan Offline
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text(
                            'Batal',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 13,
                              fontFamily: 'ElMessiri',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  // --- LOGIKA TARIK DATA DARI SERVER KE ISAR ---
  Future<void> _handleSync(BuildContext context, WidgetRef ref) async {
    final theme = Theme.of(context);
    const String customFont = 'ElMessiri';

    final progressNotifier = ValueNotifier<double>(0.0);
    final messageNotifier = ValueNotifier<String>('Menyiapkan sinkronisasi...');

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 50,
                  spreadRadius: 10,
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.5),
                  blurRadius: 20,
                  spreadRadius: -5,
                  offset: const Offset(-5, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.primaryColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.cloud_sync_rounded,
                        color: theme.primaryColor,
                        size: 42,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'SINKRONISASI KUPON',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.5,
                    color: Colors.grey,
                    fontFamily: customFont,
                  ),
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder<String>(
                  valueListenable: messageNotifier,
                  builder: (context, msg, _) {
                    return Text(
                      msg,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontFamily: customFont,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                ValueListenableBuilder<double>(
                  valueListenable: progressNotifier,
                  builder: (context, progress, _) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Progress',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontFamily: customFont,
                              ),
                            ),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: theme.primaryColor,
                                height: 1.0,
                                fontFamily: customFont,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 14,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Stack(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOutCubic,
                                    width: (constraints.maxWidth * progress)
                                        .clamp(0.0, constraints.maxWidth),
                                    height: 14,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          theme.primaryColor.withValues(
                                            alpha: 0.7,
                                          ),
                                          theme.primaryColor,
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.primaryColor.withValues(
                                            alpha: 0.4,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOutCubic,
                                    left:
                                        ((constraints.maxWidth * progress) - 14)
                                            .clamp(0.0, constraints.maxWidth),
                                    top: 0,
                                    child: Opacity(
                                      opacity: progress > 0.05 ? 1.0 : 0.0,
                                      child: Container(
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white.withValues(
                                                alpha: 0.8,
                                              ),
                                              blurRadius: 6,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final syncService = ref.read(syncServiceProvider);

      // 1. SETOR DATA DULU (PUSH)
      messageNotifier.value = 'Mengirim data offline...';
      progressNotifier.value = 0.1;
      final totalPushed = await syncService.pushData();

      // 2. TARIK DATA TERBARU (PULL)
      messageNotifier.value = 'Menarik data server...';
      final pullResult = await syncService.pullData(
        onProgress: (progress, message) {
          progressNotifier.value = progress;
          messageNotifier.value = message;
        },
      );

      if (context.mounted) {
        Navigator.pop(context);
      }

      String finalMsg = pullResult['message'];
      if (totalPushed > 0) {
        finalMsg = '$totalPushed data offline terkirim! $finalMsg';
      }

      if (context.mounted) {
        PremiumAlert.showSuccess(context, finalMsg);
      }
      ref.invalidate(dashboardProvider);
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
      }
      if (context.mounted) {
        PremiumAlert.showError(
          context,
          e.toString().replaceAll('Exception: ', ''),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dashboardAsync = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      drawer: _buildDrawer(context, ref, theme),
      body: dashboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                size: 64,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),
              const Text(
                'Gagal terhubung & Data Lokal Kosong',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(dashboardProvider),
                child: const Text(
                  'Coba Lagi',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () async =>
                    await ref.read(authServiceProvider).logout(),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
        data: (data) {
          final kpi = data['kpi'];
          final namaAdmin = data['nama_admin'];
          final tahun = data['tahun_aktif'];
          final isOnline = data['is_online'] ?? false; // Status Koneksi

          // KALKULASI PENCEGAH CRASH FLCHART
          final sumSapi = (data['chart_sapi'] as List)
              .fold<num>(0, (a, b) => a + (b as num))
              .toInt();
          final sumKategori = (data['chart_kategori'] as List)
              .fold<num>(0, (a, b) => a + (b as num))
              .toInt();

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(dashboardProvider),
            child: CustomScrollView(
              slivers: [
                // --- HERO BANNER (HEADER) ---
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16).copyWith(top: 48),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [theme.primaryColor, theme.primaryColorDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // BADGE INTERAKTIF (MERAH / HIJAU)
                            GestureDetector(
                              onTap: () {
                                // Buka form premium untuk ganti IP
                                _showChangeServerPremiumModal(context, ref);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isOnline
                                      ? Colors.white.withValues(alpha: 0.2)
                                      : Colors.redAccent.withValues(
                                          alpha: 0.9,
                                        ), // Merah Menyala jika Error
                                  borderRadius: BorderRadius.circular(20),
                                  border: isOnline
                                      ? null
                                      : Border.all(color: Colors.white54),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: isOnline
                                            ? Colors.greenAccent
                                            : Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          if (!isOnline)
                                            const BoxShadow(
                                              color: Colors.white,
                                              blurRadius: 4,
                                            ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      isOnline
                                          ? 'Sistem Qurban $tahun Online'
                                          : 'Offline - Ketuk Ubah IP Server',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // TOMBOL BURGER MENU
                            Builder(
                              builder: (ctx) => IconButton(
                                onPressed: () => Scaffold.of(ctx).openDrawer(),
                                icon: const Icon(
                                  Icons.menu_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                splashRadius: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          '${_getGreeting()},\n$namaAdmin! 👋',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Pantau progres distribusi real-time.',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: theme.primaryColor,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const ScannerScreen(),
                                  ),
                                ),
                                icon: const Icon(Icons.qr_code_scanner_rounded),
                                label: const Text(
                                  'BUKA SCANNER',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                              child: IconButton(
                                padding: const EdgeInsets.all(12),
                                onPressed: () => _handleSync(context, ref),
                                icon: const Icon(
                                  Icons.sync_rounded,
                                  color: Colors.white,
                                ),
                                tooltip: 'Tarik Data Server',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // --- KPI CARDS GRID ---
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      _buildKpiCard(
                        'Total Sapi',
                        kpi['sapi'].toString(),
                        'Ekor',
                        Colors.teal,
                      ),
                      _buildKpiCard(
                        'Pendaftar',
                        kpi['mudhohi'].toString(),
                        'Orang',
                        Colors.blue,
                      ),
                      _buildKpiCard(
                        'Total Kupon',
                        kpi['kupon_total'].toString(),
                        'Tiket',
                        Colors.amber,
                      ),
                      _buildKpiCard(
                        'Selesai Scan',
                        '${kpi['kupon_scan']}/${kpi['kupon_total']}',
                        'Kupon',
                        Colors.purple,
                      ),
                    ],
                  ),
                ),

                // --- CHART SAPI (DONUT) ---
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'STATUS SAPI',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: Colors.grey,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        sumSapi == 0
                            ? _buildEmptyChartState()
                            : SizedBox(
                                height: 200,
                                child: PieChart(
                                  PieChartData(
                                    sectionsSpace: 4,
                                    centerSpaceRadius: 50,
                                    sections: [
                                      _buildPieSection(
                                        data['chart_sapi'][0].toDouble(),
                                        Colors.grey.shade400,
                                        'Tunggu',
                                      ),
                                      _buildPieSection(
                                        data['chart_sapi'][1].toDouble(),
                                        Colors.redAccent,
                                        'Potong',
                                      ),
                                      _buildPieSection(
                                        data['chart_sapi'][2].toDouble(),
                                        Colors.amber,
                                        'Kuliti',
                                      ),
                                      _buildPieSection(
                                        data['chart_sapi'][3].toDouble(),
                                        Colors.teal,
                                        'Selesai',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),

                // --- CHART KOMPOSISI KUPON (PIE) ---
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ).copyWith(bottom: 32),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'KOMPOSISI KUPON',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: Colors.grey,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        sumKategori == 0
                            ? _buildEmptyChartState()
                            : SizedBox(
                                height: 200,
                                child: PieChart(
                                  PieChartData(
                                    sectionsSpace: 2,
                                    centerSpaceRadius: 40,
                                    sections: [
                                      _buildPieSection(
                                        data['chart_kategori'][0].toDouble(),
                                        Colors.amber,
                                        'Umum',
                                      ),
                                      _buildPieSection(
                                        data['chart_kategori'][1].toDouble(),
                                        Colors.blueAccent,
                                        'Mudhohi',
                                      ),
                                      _buildPieSection(
                                        data['chart_kategori'][2].toDouble(),
                                        Colors.purpleAccent,
                                        'Panitia',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyChartState() {
    return const SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart_outline_rounded,
              size: 64,
              color: Colors.black12,
            ),
            SizedBox(height: 8),
            Text(
              'Belum ada data',
              style: TextStyle(
                color: Colors.black38,
                fontWeight: FontWeight.bold,
                fontFamily: 'ElMessiri',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard(
    String title,
    String value,
    String unit,
    MaterialColor color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: color.shade700,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  PieChartSectionData _buildPieSection(
    double value,
    Color color,
    String title,
  ) {
    return PieChartSectionData(
      color: color,
      value: value,
      title: value > 0 ? '${value.toInt()}' : '',
      radius: value > 0 ? 30 : 20,
      titleStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      badgeWidget: value > 0 ? _buildBadge(title) : null,
      badgePositionPercentageOffset: 1.4,
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  void _showLogoutModal(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (ctx) {
        bool isLoggingOut = false;
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Center(
                child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.redAccent.withValues(alpha: 0.2),
                          blurRadius: 50,
                          spreadRadius: 10,
                        ),
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.5),
                          blurRadius: 20,
                          spreadRadius: -5,
                          offset: const Offset(-5, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.redAccent.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.logout_rounded,
                            size: 40,
                            color: Colors.redAccent,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'KONFIRMASI LOGOUT',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            color: Colors.black54,
                            fontFamily: 'ElMessiri',
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Apakah Anda yakin ingin keluar dari aplikasi?\nData lokal yang belum disinkronkan mungkin hilang.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            height: 1.5,
                            fontFamily: 'ElMessiri',
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: isLoggingOut
                                    ? null
                                    : () => Navigator.pop(ctx),
                                child: Text(
                                  'Batal',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'ElMessiri',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: isLoggingOut
                                    ? null
                                    : () async {
                                        setModalState(
                                          () => isLoggingOut = true,
                                        );
                                        await ref
                                            .read(authServiceProvider)
                                            .logout();
                                        if (ctx.mounted) {
                                          Navigator.pop(ctx); // Tutup modal
                                          Navigator.pop(
                                            context,
                                          ); // Tutup drawer
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen(),
                                            ),
                                          );
                                        }
                                      },
                                child: isLoggingOut
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Ya, Keluar',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'ElMessiri',
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context, WidgetRef ref, ThemeData theme) {
    final userName = prefs.getString('user_name') ?? 'Panitia Qurban';
    final userPhone = prefs.getString('user_phone') ?? 'Belum ada nomor';
    final userAvatar = prefs.getString('user_avatar') ?? '';
    final initialName = userName.isNotEmpty ? userName[0].toUpperCase() : 'P';
    final baseUrl = ref.watch(serverUrlProvider);

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(5, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header Drawer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 60,
                bottom: 30,
                left: 24,
                right: 24,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.primaryColor, theme.primaryColorDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 2,
                      ),
                      image: userAvatar.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(
                                '$baseUrl/storage/$userAvatar',
                              ),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: userAvatar.isEmpty
                        ? Center(
                            child: Text(
                              initialName,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'ElMessiri',
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'ElMessiri',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    userPhone,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontFamily: 'ElMessiri',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Item Logout
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.redAccent,
                ),
              ),
              title: const Text(
                'Keluar / Logout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                  fontFamily: 'ElMessiri',
                ),
              ),
              onTap: () {
                _showLogoutModal(context, ref);
              },
            ),
            const Spacer(),

            // App Version
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      'Versi ${snapshot.data!.version}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ElMessiri',
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
