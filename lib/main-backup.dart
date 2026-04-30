import 'package:flutter/material.dart';
import 'scanner_screen.dart';
import 'deshboard_screen.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key
  }); // ✅ modern syntax

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

// ✅ StatefulWidget (correct)
class HomePage extends StatefulWidget {
  const HomePage({
    super.key
  });

  @override
  State < HomePage > createState() => _HomePageState();
}

// ✅ State class (VERY IMPORTANT)
class _HomePageState extends State < HomePage > {
  String scannedUrl = ""; // ✅ store scanned result

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
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
          color: Colors.black, // ✅ fallback background color
          image: DecorationImage(
            image: AssetImage("assets/home-bg.png"), // ✅ your background image
            fit: BoxFit.cover, // cover full screen
            alignment: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Your Journey To Mars Begins Here".toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Audiowide',
                  fontSize: 35,
                  height: 1,
                  fontWeight: FontWeight.normal,
                  color: Colors.white, // ✅ important for visibility
                ),
              ),
              const SizedBox(height: 20),
              // First Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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

                        // 🌌 Gradient Background
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFD9D9D9).withOpacity(0.30), // ✅ correct
                            Color(0xFFD9D9D9).withOpacity(0.30),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),

                      ),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "SCAN YOUR TICKET",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Audiowide',
                              fontSize: 14,
                              letterSpacing: 0,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 0),

                          Container(
                            padding: const EdgeInsets.all(12),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  "assets/qr.png", // ✅ your QR image
                                  width: 140,
                                  height: 140,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // const SizedBox(width: 16),

                ],
              ),
              // Second Button
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /*
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
                                                    */
                  GestureDetector(
                    onTap: () async {
                      final Uri url = Uri.parse(
                        'https://dev4work.com/thefirstonmars/trip7hge34/',
                      );

                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication, // 👉 opens in browser
                        );
                      }
                    },
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9).withOpacity(0.30),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "BUY TICKET",
                            style: TextStyle(
                              fontFamily: 'Audiowide',
                              color: Colors.white,
                              fontSize: 14,
                              letterSpacing: 0,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                              image: const DecorationImage(
                                image: AssetImage("assets/ticket.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )



                ],
              ),

              /*
                                    const SizedBox(height: 20),

                                    Text(
                                      scannedUrl.isEmpty
                                          ? "No ticket scanned"
                                          : "Scanned URL:\n$scannedUrl",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.white), // ✅ visible text
                                    ),
                                    */

            ],
          ),
        ),
      ),

    );
  }
}