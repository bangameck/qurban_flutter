import 'package:flutter/material.dart';

class PremiumAlert {
  // 1. STYLE DYNAMIC ISLAND (Untuk Success)
  // Muncul melayang di atas layar, membulat, dan hilang otomatis
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.greenAccent),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ElMessiri', // Pakai font kebanggaan kita
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        // Trik ngedorong snackbar ke atas (Dynamic Island Vibe)
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 130,
          left: 40,
          right: 40,
        ),
        elevation: 10,
        duration: const Duration(seconds: 3), // Hilang dalam 3 detik
      ),
    );
  }

  // 2. STYLE TOAST ERROR (Harus di-close manual)
  // Muncul di bawah, warna merah, ada tombol TUTUP
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'ElMessiri',
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(20),
        // Durasi dibikin super lama biar nunggu user klik close
        duration: const Duration(days: 1),
        action: SnackBarAction(
          label: 'TUTUP',
          textColor: Colors.yellowAccent,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
