import 'package:flutter/material.dart';
import 'deshboard_screen.dart';

class NotificationScreen extends StatelessWidget {
  final String url;

  const NotificationScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/home-bg.png"),
            fit: BoxFit.cover,
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // 🔔 Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none,
                color: Colors.white,
                size: 40,
              ),
            ),

            const SizedBox(height: 30),

            // 🔤 Text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "WOULD YOU LIKE TO RECEIVE MISSION UPDATES?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Audiowide',
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ✅ YES BUTTON
            GestureDetector(
              onTap: () {
                // 👉 You can enable notification logic here later

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultScreen(url: url),
                  ),
                );
              },
              child: Container(
                width: 250,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF1E5EFF),
                      Color(0xFF0A1B3F),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "YES",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Audiowide',
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ❌ NO BUTTON
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultScreen(url: url),
                  ),
                );
              },
              child: Container(
                width: 250,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "NO",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Audiowide',
                    color: Colors.white,
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