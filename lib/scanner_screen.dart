import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_screen.dart';

class ScannerScreen extends StatefulWidget {
  final Function(String) onScan;

  const ScannerScreen({super.key, required this.onScan});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();

  bool isNavigating = false; // ✅ prevent multiple redirects

  // ✅ SAVE URL
  Future<void> _saveUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("scanned_url", url);
  }

  // 🔥 Handle navigation (COMMON)
  Future<void> _handleNavigation(String code) async {
    if (isNavigating) return; // 🚫 block duplicate

    isNavigating = true;

    await _saveUrl(code);

    widget.onScan(code);

    _controller.stop(); // 🔥 stop camera scanning

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationScreen(url: code),
      ),
    );
  }

  // 🔥 Pick image and scan QR
  Future<void> _scanFromImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image =
    await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    try {
      // 🛑 Stop camera before analyzing image
      await _controller.stop();

      final BarcodeCapture? result =
      await _controller.analyzeImage(image.path);

      if (result != null && result.barcodes.isNotEmpty) {
        for (final barcode in result.barcodes) {
          final String? code = barcode.rawValue;

          if (code != null && code.isNotEmpty) {
            await _handleNavigation(code);
            return;
          }
        }
      }

      // ❌ No valid QR
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No QR code found in image")),
      );

      // ▶️ Restart camera after failure
      await _controller.start();

    } catch (e) {
      print("Scan error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to scan image")),
      );

      await _controller.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Ticket"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage("assets/home-bg.png"),
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // 🔹 Scanner
            Expanded(
              child: MobileScanner(
                controller: _controller, // ✅ attach controller
                onDetect: (barcodeCapture) async {
                  final List<Barcode> barcodes =
                      barcodeCapture.barcodes;

                  for (final barcode in barcodes) {
                    final String? code = barcode.rawValue;

                    if (code != null) {
                      await _handleNavigation(code);
                      break;
                    }
                  }
                },
              ),
            ),

            // 🔹 Browse Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: _scanFromImage,
                child: Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF010A1B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Browse QR Image",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}