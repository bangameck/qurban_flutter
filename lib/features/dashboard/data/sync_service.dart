import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/models/kupon_model.dart';
import '../../../core/services/database_service.dart';
import '../../../main.dart';
import '../../auth/data/auth_service.dart';

class SyncService {
  final String baseUrl;
  SyncService(this.baseUrl);

  // --- FUNGSI PUSH DATA (LOKAL -> SERVER) ---
  Future<int> pushData() async {
    final token = prefs.getString(AppConstants.tokenKey);
    final isar = DatabaseService.isar;

    // PERBAIKAN: Gunakan .filter() karena needSync tidak di-index
    final offlineKupon = await isar.kuponModels
        .filter()
        .needSyncEqualTo(true)
        .findAll();

    if (offlineKupon.isEmpty) return 0;

    developer.log(
      'Mengirim ${offlineKupon.length} data offline ke server...',
      name: 'SyncService',
    );

    final List<Map<String, dynamic>> payload = offlineKupon
        .map((k) => {'kode': k.kodeUnik, 'waktu': DateTime.now().toString()})
        .toList();

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/sync/push'), // Menggunakan this.baseUrl
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'data': payload}),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        await isar.writeTxn(() async {
          for (var kupon in offlineKupon) {
            kupon.needSync = false;
            await isar.kuponModels.put(kupon);
          }
        });
        return offlineKupon.length;
      } else {
        developer.log('Push Gagal: ${response.body}', name: 'SyncService');
        throw Exception('Gagal mengirim data offline ke server');
      }
    } catch (e) {
      developer.log('Error Push: $e', name: 'SyncService');
      throw Exception('Masalah koneksi saat kirim data offline');
    }
  }

  // --- FUNGSI PULL DATA (SERVER -> LOKAL) ---
  Future<Map<String, dynamic>> pullData({
    Function(double progress, String message)? onProgress,
  }) async {
    final token = prefs.getString(AppConstants.tokenKey);
    final isar = DatabaseService.isar;

    try {
      onProgress?.call(0.1, 'Menghubungkan ke server...');

      final response = await http
          .get(
            Uri.parse('$baseUrl/api/sync/kupon'),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        onProgress?.call(0.3, 'Mengunduh data selesai...');

        final data = jsonDecode(response.body);
        final List kuponList = data['data'];
        final int total = kuponList.length;
        int addedOrUpdated = 0;

        if (total == 0) {
          onProgress?.call(1.0, 'Kupon sudah up-to-date!');
          return {'success': true, 'message': 'Kupon sudah up-to-date!'};
        }

        await isar.writeTxn(() async {
          for (int i = 0; i < total; i++) {
            final item = kuponList[i];
            final String kodeUnik = item['kode_unik'];

            final localData = await isar.kuponModels
                .where()
                .kodeUnikEqualTo(kodeUnik)
                .findFirst();

            // Jangan timpa kalau lagi nunggu sync (Offline Scan)
            if (localData != null && localData.needSync == true) continue;

            final kupon = KuponModel()
              ..id = localData?.id ?? Isar.autoIncrement
              ..kodeUnik = kodeUnik
              ..nama = item['nama']
              ..tipe = item['tipe']
              ..keterangan = item['keterangan']
              ..isScanned = item['status_pengambilan'] == 'Sudah'
              ..needSync = false;

            await isar.kuponModels.put(kupon);
            addedOrUpdated++;

            if (i % 10 == 0 || i == total - 1) {
              double currentProgress = 0.3 + (0.7 * ((i + 1) / total));
              onProgress?.call(
                currentProgress,
                'Sinkron ${i + 1} / $total kupon...',
              );
            }
          }
        });

        onProgress?.call(1.0, 'Selesai!');
        return {
          'success': true,
          'message': 'Berhasil sinkron $addedOrUpdated data.',
        };
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('Error Pull: $e', name: 'SyncService');
      throw Exception('Offline - Ketuk Indikator Status & Ubah IP Server');
    }
  }
}

final syncServiceProvider = Provider((ref) {
  final baseUrl = ref.watch(serverUrlProvider);
  return SyncService(baseUrl);
});
