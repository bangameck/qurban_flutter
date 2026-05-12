import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_service.dart';
import '../../../core/utils/premium_alert.dart';
import '../../../main.dart'; // import prefs
import '../../dashboard/presentation/dashboard_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  Future<void> _handleLogin() async {
    if (_phoneController.text.isEmpty || _passwordController.text.isEmpty) {
      PremiumAlert.showError(context, 'Nomor HP dan Password wajib diisi!');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      final success = await authService.login(
        _phoneController.text.trim(),
        _passwordController.text.trim(),
      );

      if (success && mounted) {
        PremiumAlert.showSuccess(context, 'Alhamdulillah, Login Berhasil!');

        // Pindah ke Dashboard dan hapus LoginScreen dari history (biar gak bisa di-back)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        PremiumAlert.showError(
          context,
          e.toString().replaceAll('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // DIALOG UNTUK GANTI IP SERVER
  void _showServerConfigDialog(String currentUrl) {
    final urlController = TextEditingController(text: currentUrl);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.dns_rounded, color: Colors.blueAccent),
            SizedBox(width: 8),
            Text(
              'Konfigurasi Server',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Masukkan IP Server lokal atau URL Hosting aplikasi Anda.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                hintText: 'http://192.168...',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              final newUrl = urlController.text.trim();
              if (newUrl.isNotEmpty) {
                // Simpan ke HP
                await prefs.setString('server_url', newUrl);
                // Update State Provider Riverpod
                ref.read(serverUrlProvider.notifier).updateUrl(newUrl);
                // Refresh provider settings & ping
                ref.invalidate(pingProvider);
                ref.invalidate(appSettingsProvider);

                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsAsync = ref.watch(appSettingsProvider);
    final pingAsync = ref.watch(pingProvider);
    final currentUrl = ref.watch(serverUrlProvider);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- TAMPILAN LOGO + DOT SERVER ---
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  settingsAsync.when(
                    data: (data) => Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: theme.primaryColor.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          '${ref.watch(serverUrlProvider)}${data['logo_path']}',
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 100,
                                width: 100,
                                color: theme.primaryColor.withValues(
                                  alpha: 0.1,
                                ),
                                child: Icon(
                                  Icons.qr_code_scanner_rounded,
                                  size: 48,
                                  color: theme.primaryColor,
                                ),
                              ),
                        ),
                      ),
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stackTrace) => Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.broken_image_rounded,
                        size: 48,
                        color: Colors.red.shade300,
                      ),
                    ),
                  ),

                  // 🔴/🟢 DOT INDICATOR
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () {
                        // Cek status Ping untuk aksi berbeda
                        pingAsync.when(
                          data: (ms) {
                            // Kalau connect (Hijau diklik) -> Tampil Latency
                            PremiumAlert.showSuccess(
                              context,
                              'Terhubung ke Server! Latency: ${ms}ms',
                            );
                          },
                          loading: () {}, // Do nothing
                          error: (error, stackTrace) {
                            // Kalau disconnect (Merah diklik) -> Buka Dialog IP
                            _showServerConfigDialog(currentUrl);
                          },
                        );
                      },
                      child: pingAsync.when(
                        data: (_) =>
                            _buildDot(Colors.greenAccent), // Server Nyala!
                        loading: () =>
                            _buildDot(Colors.amber), // Loading ngeping...
                        error: (error, stackTrace) =>
                            _buildDot(Colors.redAccent), // Server Mati!
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              Text(
                settingsAsync.maybeWhen(
                  data: (d) => d['app_name'],
                  orElse: () => 'Qurban Scanner',
                ),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${_getGreeting()}, Panitia!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(height: 32),

              // --- FORM LOGIN (SAMA SEPERTI SEBELUMNYA) ---
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withValues(alpha: 0.05),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Nomor HP / WA',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      enabled: !_isLoading,
                      decoration: const InputDecoration(
                        hintText: 'Contoh: 0812345...',
                        prefixIcon: Icon(Icons.phone_android_rounded),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      enabled: !_isLoading,
                      onFieldSubmitted: (_) => _handleLogin(),
                      decoration: InputDecoration(
                        hintText: 'Masukkan password...',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey.shade500,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Masuk',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Desain Bundaran Dot Ping
  Widget _buildDot(Color color) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}
