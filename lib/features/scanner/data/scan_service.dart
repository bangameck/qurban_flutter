import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/database_service.dart';
import '../../../core/models/kupon_model.dart';
import '../../../main.dart';
import '../../auth/data/auth_service.dart'; // Import untuk serverUrlProvider

// 1. MODEL DATA (Wajib ada di sini kalau file ditimpa semua)
class ScanResultModel {
  final String status; // 'success', 'warning', 'error'
  final String message;
  final String resultType; // 'Panitia', 'Mudhohi', 'Mustahiq'
  final String nama;
  final String keterangan; // Jabatan / Tipe Qurban / Sesi

  ScanResultModel({
    required this.status,
    required this.message,
    this.resultType = '',
    this.nama = '',
    this.keterangan = '',
  });
}

class ScanService {
  final String baseUrl;
  ScanService(this.baseUrl);

  // Fungsi utama memproses kode dari UI (Hybrid Mode)
  Future<ScanResultModel> processCode(String code) async {
    final cleanCode = code.trim().toUpperCase();
    final isar = DatabaseService.isar;
    final token = prefs.getString(AppConstants.tokenKey);

    // --- STEP 1: VALIDASI LOKAL ---
    // Cek dulu di Isar, ada gak kuponnya?
    final kupon = await isar.kuponModels
        .where()
        .kodeUnikEqualTo(cleanCode)
        .findFirst();

    if (kupon == null) {
      return ScanResultModel(
        status: 'error',
        message: 'KODE TIDAK DIKENALI! Pastikan sudah Sinkronisasi data.',
      );
    }

    if (kupon.isScanned) {
      return ScanResultModel(
        status: 'warning',
        message: 'KUPON SUDAH DIGUNAKAN!',
        resultType: kupon.tipe ?? 'Umum',
        nama: kupon.nama ?? 'Fulan',
        keterangan: kupon.keterangan ?? '',
      );
    }

    // --- STEP 2: TRY REAL-TIME UPDATE KE SERVER ---
    bool isSyncedSuccess = false;
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/scan-kupon'),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'kode_unik': cleanCode}),
          )
          .timeout(
            const Duration(seconds: 5),
          ); // Kita naikin jadi 5 detik biar lebih sabar

      if (response.statusCode == 200) {
        isSyncedSuccess = true;
      } else {
        // CCTV: Kalau server jawab tapi bukan 200 (misal 500 atau 404)
        print('Server Error: ${response.statusCode}');
        print('Server Body: ${response.body}');
      }
    } catch (e) {
      // CCTV: Kalau koneksi gagal total (RTO atau salah IP)
      print('Koneksi Gagal/Timeout: $e');
      isSyncedSuccess = false;
    }

    // --- STEP 3: UPDATE STATUS DI LOKAL ISAR ---
    await isar.writeTxn(() async {
      kupon.isScanned = true;
      // Jika server gagal diupdate, tandai needSync biar nanti di-push otomatis
      kupon.needSync = !isSyncedSuccess;
      await isar.kuponModels.put(kupon);
    });

    return ScanResultModel(
      status: 'success',
      message: isSyncedSuccess
          ? 'BERHASIL! (Server Real-time)'
          : 'BERHASIL! (Disimpan Offline)',
      resultType: kupon.tipe ?? 'Umum',
      nama: kupon.nama ?? 'Fulan',
      keterangan: kupon.keterangan ?? '',
    );
  }
}

// 2. PROVIDER (Menerima baseUrl dari serverUrlProvider)
final scanServiceProvider = Provider((ref) {
  final baseUrl = ref.watch(serverUrlProvider);
  return ScanService(baseUrl);
});
