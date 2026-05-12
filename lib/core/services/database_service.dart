import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/kupon_model.dart';

class DatabaseService {
  static late Isar isar;

  // Dipanggil sekali saat aplikasi dijalankan (di main.dart)
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [KuponModelSchema],
      directory: dir.path,
      name: 'qurban_db', // Nama file database lokal
    );
  }
}
