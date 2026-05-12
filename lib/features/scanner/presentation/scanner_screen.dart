import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk Haptic Feedback (Getar)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../data/scan_service.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  final MobileScannerController _cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  final TextEditingController _manualInputController = TextEditingController();

  bool _isProcessing = false;
  ScanResultModel? _scanResult;

  @override
  void dispose() {
    _cameraController.dispose();
    _manualInputController.dispose();
    super.dispose();
  }

  // Handle saat kamera ngebaca QR
  void _onDetect(BarcodeCapture capture) {
    if (_isProcessing) return; // Ignore jika sedang memproses

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      final String code = barcodes.first.rawValue!;
      _processScannedCode(code);
    }
  }

  // Handle submit dari tombol manual
  void _onSubmitManual() {
    if (_manualInputController.text.isEmpty) return;
    FocusScope.of(context).unfocus(); // Tutup keyboard
    _processScannedCode(_manualInputController.text);
  }

  // Proses logika dan panggil service
  Future<void> _processScannedCode(String code) async {
    setState(() {
      _isProcessing = true;
      _scanResult = null;
    });

    _cameraController.stop(); // Freeze kamera (mirip pause di js)
    HapticFeedback.vibrate(); // Getar di HP!

    final service = ref.read(scanServiceProvider);
    final result = await service.processCode(code);

    // Getar tambahan sesuai status
    if (result.status == 'success') {
      HapticFeedback.lightImpact();
    } else if (result.status == 'error') {
      HapticFeedback.heavyImpact();
    }

    setState(() {
      _scanResult = result;
      _manualInputController.clear();
    });
  }

  // Lanjut Scan
  void _resetScanner() {
    setState(() {
      _scanResult = null;
      _isProcessing = false;
    });
    _cameraController.start(); // Nyalakan kamera lagi
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Smart Scanner Qurban',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: _cameraController,
              builder: (context, state, child) {
                return Icon(
                  state.torchState == TorchState.on ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white,
                );
              },
            ),
            onPressed: () => _cameraController.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
            onPressed: () => _cameraController.switchCamera(),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 1. KAMERA BACKGROUND
          MobileScanner(
            controller: _cameraController,
            onDetect: _onDetect,
            errorBuilder: (context, error) => const Center(
              child: Text(
                'Gagal membuka kamera',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

          // 2. OVERLAY SCANNER MASK (Kotak bolong di tengah)
          _buildScannerOverlay(theme),

          // 3. INDIKATOR TITIK WARNA
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDotIndicator(Colors.pink, 'Panitia'),
                const SizedBox(width: 12),
                _buildDotIndicator(Colors.blue, 'Mudhohi'),
                const SizedBox(width: 12),
                _buildDotIndicator(Colors.teal, 'Mustahiq'),
              ],
            ),
          ),

          // 4. FORM MANUAL INPUT (Bottom)
          if (_scanResult == null)
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: _buildManualInput(theme),
            ),

          // 5. MODAL RESULT (Glassmorphism & Color Coded)
          if (_scanResult != null) _buildResultModal(theme),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay(ThemeData theme) {
    return Container(
      decoration: ShapeDecoration(
        shape: ScannerOverlayShape(
          borderColor: theme.primaryColor,
          borderRadius: 24,
          borderLength: 40,
          borderWidth: 8,
          cutOutSize: 280,
        ),
      ),
    );
  }

  Widget _buildDotIndicator(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildManualInput(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Kamera error? Input Manual:',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _manualInputController,
                  textCapitalization: TextCapitalization.characters,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    letterSpacing: 2,
                  ),
                  decoration: InputDecoration(
                    hintText: 'KODE-KUPON',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _isProcessing ? null : _onSubmitManual,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'GAS',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultModal(ThemeData theme) {
    // Tentukan Warna berdasarkan Status & Tipe
    Color bgColor = Colors.grey.shade900;
    Color shadowColor = Colors.transparent;
    IconData icon = Icons.check_circle_rounded;
    Color iconColor = Colors.white;

    if (_scanResult!.status == 'success') {
      if (_scanResult!.resultType == 'Panitia') {
        bgColor = Colors.pink.shade600;
        shadowColor = Colors.pink.withValues(alpha: 0.6);
      } else if (_scanResult!.resultType == 'Mudhohi') {
        bgColor = Colors.blue.shade600;
        shadowColor = Colors.blue.withValues(alpha: 0.6);
      } else {
        bgColor = Colors.teal.shade500;
        shadowColor = Colors.teal.withValues(alpha: 0.6);
      }
    } else if (_scanResult!.status == 'warning') {
      bgColor = Colors.amber.shade500;
      shadowColor = Colors.amber.withValues(alpha: 0.8);
      icon = Icons.warning_rounded;
    } else if (_scanResult!.status == 'error') {
      bgColor = Colors.grey.shade900;
      icon = Icons.cancel_rounded;
      iconColor = Colors.redAccent;
    }

    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: Colors.black.withValues(alpha: 0.6),
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(40),
                border: _scanResult!.status == 'error'
                    ? Border.all(
                        color: Colors.redAccent.withValues(alpha: 0.5),
                        width: 2,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 50,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ikon Status
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.4),
                        width: 2,
                      ),
                    ),
                    child: Icon(icon, size: 48, color: iconColor),
                  ),
                  const SizedBox(height: 24),

                  // Text Status Utama
                  Text(
                    _scanResult!.status == 'success'
                        ? 'BERHASIL'
                        : (_scanResult!.status == 'warning'
                              ? 'SUDAH DIAMBIL'
                              : 'DITOLAK'),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _scanResult!.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Info User (Kalau Ketemu)
                  if (_scanResult!.status != 'error') ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            child: Text(
                              _scanResult!.nama[0],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    _scanResult!.resultType.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _scanResult!.nama,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  _scanResult!.keterangan,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],

                  // Tombol Lanjut Scan
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _resetScanner,
                      icon: const Icon(
                        Icons.refresh_rounded,
                        color: Colors.black87,
                      ),
                      label: const Text(
                        'LANJUT SCAN',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// === CUSTOM CLIPPER UNTUK OVERLAY KAMERA WAK! ===
class ScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const ScannerOverlayShape({
    this.borderColor = Colors.white,
    this.borderWidth = 3.0,
    this.overlayColor = const Color(0x88000000), // Warna hitam semi transparan
    this.borderRadius = 0,
    this.borderLength = 0,
    this.cutOutSize = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path path = Path()..addRect(rect);
    rect = Rect.fromCenter(
      center: rect.center,
      width: cutOutSize,
      height: cutOutSize,
    );
    path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)));
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final width = rect.width;
    final borderWidthSize = width / 2;
    final borderLengthSize = borderLength > cutOutSize / 2 + borderWidthSize
        ? borderWidthSize / 2
        : borderLength;
    final cutOutRect = Rect.fromCenter(
      center: rect.center,
      width: cutOutSize,
      height: cutOutSize,
    );

    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final path = Path();
    // Kiri Atas
    path.moveTo(cutOutRect.left, cutOutRect.top + borderLengthSize);
    path.lineTo(cutOutRect.left, cutOutRect.top + borderRadius);
    path.quadraticBezierTo(
      cutOutRect.left,
      cutOutRect.top,
      cutOutRect.left + borderRadius,
      cutOutRect.top,
    );
    path.lineTo(cutOutRect.left + borderLengthSize, cutOutRect.top);

    // Kanan Atas
    path.moveTo(cutOutRect.right, cutOutRect.top + borderLengthSize);
    path.lineTo(cutOutRect.right, cutOutRect.top + borderRadius);
    path.quadraticBezierTo(
      cutOutRect.right,
      cutOutRect.top,
      cutOutRect.right - borderRadius,
      cutOutRect.top,
    );
    path.lineTo(cutOutRect.right - borderLengthSize, cutOutRect.top);

    // Kiri Bawah
    path.moveTo(cutOutRect.left, cutOutRect.bottom - borderLengthSize);
    path.lineTo(cutOutRect.left, cutOutRect.bottom - borderRadius);
    path.quadraticBezierTo(
      cutOutRect.left,
      cutOutRect.bottom,
      cutOutRect.left + borderRadius,
      cutOutRect.bottom,
    );
    path.lineTo(cutOutRect.left + borderLengthSize, cutOutRect.bottom);

    // Kanan Bawah
    path.moveTo(cutOutRect.right, cutOutRect.bottom - borderLengthSize);
    path.lineTo(cutOutRect.right, cutOutRect.bottom - borderRadius);
    path.quadraticBezierTo(
      cutOutRect.right,
      cutOutRect.bottom,
      cutOutRect.right - borderRadius,
      cutOutRect.bottom,
    );
    path.lineTo(cutOutRect.right - borderLengthSize, cutOutRect.bottom);

    canvas.drawPath(path, paint);
  }

  @override
  ShapeBorder scale(double t) => this;
}
