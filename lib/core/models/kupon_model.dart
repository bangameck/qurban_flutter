import 'package:isar/isar.dart';

part 'kupon_model.g.dart'; // Nama file generator Isar

@collection
class KuponModel {
  Id id = Isar.autoIncrement;

  // Index biar nyarinya ngebut! replace: true biar kalau sinkron ulang datanya ketimpa, gak duplikat
  @Index(unique: true, replace: true)
  String? kodeUnik;

  String? nama;

  String? tipe; // Panitia, Mudhohi, Mustahiq

  String? keterangan; // Jabatan, Sesi, dll

  bool isScanned = false; // true kalau statusnya 'Sudah'

  // FLAG OFFLINE SYNC (Kunci buat sinkronisasi!)
  // Kalau panitia nge-scan pas gak ada internet, ini jadi true.
  // Nanti pas internet nyala, data yang needSync = true bakal ditembak ke server.
  bool needSync = false;
}
