import 'package:flutter/material.dart';
import 'scanner_screen.dart';
import 'deshboard_screen.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String scannedUrl = "";
  final ScrollController _scrollController = ScrollController();
  bool isScrolled = false;


  Future<void> _checkSavedSession() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedUrl = prefs.getString("scanned_url");

    if (savedUrl != null && savedUrl.isNotEmpty) {
      // ⏳ Small delay to avoid context issues
      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(url: savedUrl),
          ),
        );
      });
    }
  }


  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && !isScrolled) {
        setState(() {
          isScrolled = true;
        });
      } else if (_scrollController.offset <= 50 && isScrolled) {
        setState(() {
          isScrolled = false;
        });
      }
    });

    _checkSavedSession(); // ✅ ADDED

    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && !isScrolled) {
        setState(() {
          isScrolled = true;
        });
      } else if (_scrollController.offset <= 50 && isScrolled) {
        setState(() {
          isScrolled = false;
        });
      }
    });



  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: isScrolled
            ? Color(0xFF010A1B)
            : Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(
          'assets/logo.png',
          height: 40,
        ),
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

            // 🔼 SCROLLABLE CONTENT
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 140),
                      Text(
                        "Your Journey To Mars Begins Here".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Audiowide',
                          fontSize: 35,
                          height: 1,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔹 SCAN BUTTON
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScannerScreen(
                                onScan: (result) {
                                  setState(() {
                                    scannedUrl = result;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 200,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFD9D9D9).withOpacity(0.30),
                                const Color(0xFFD9D9D9).withOpacity(0.30),
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                "SCAN YOUR TICKET",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Audiowide',
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Image.asset(
                                "assets/qr.png",
                                width: 140,
                                height: 140,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // 🔹 BUY BUTTON
                      GestureDetector(
                        onTap: () async {
                          final Uri url = Uri.parse(
                            'https://dev4work.com/thefirstonmars/trip7hge34/',
                          );

                          await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        child: Container(
                          width: 200,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9).withOpacity(0.30),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                "BUY TICKET",
                                style: TextStyle(
                                  fontFamily: 'Audiowide',
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 110,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/ticket.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultScreen(
                                url:
                                'https://dev4work.com/thefirstonmars/trip7hge34/',
                              ),
                            ),
                          );
                        },
                        child: const Text("View Details"),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 🔽 FIXED FOOTER
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: Colors.black.withOpacity(0.3),
                  child: const Text(
                    "If user already has ticket → scan QR → proceed\nIf not → go to website purchase page",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Audiowide',
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.5,
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