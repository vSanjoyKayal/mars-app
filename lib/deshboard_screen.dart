import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme/app_styles.dart';


class ResultScreen extends StatefulWidget {
  final String url;
  const ResultScreen({super.key, required this.url});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String slug = "";
  String resultData = "Loading...";
  String missionName = "";
  String missionCode = "";
  String crewCount = "";
  String missionStatus = "";
  String missionDuration = "";
  String captainsMessage = "";
  String inFormation = ""; 

  @override
  void initState() {
    super.initState();
    extractSlugAndFetch();
  }

  void extractSlugAndFetch() {
    Uri uri = Uri.parse(widget.url);

    slug = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : "";

    if (slug.isEmpty && uri.pathSegments.length > 1) {
      slug = uri.pathSegments[uri.pathSegments.length - 2];
    }

    fetchData();
  }



  Future<void> fetchData() async {
    final apiUrl =
        "https://dev4work.com/thefirstonmars/wp-json/wp/v2/pages?slug=$slug";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.isNotEmpty) {
          final acf = data[0]['acf'];

          missionName = acf['mission_name'] ?? "";
          missionCode = acf['mission_code'] ?? "";
          crewCount = acf['crew_count'] ?? "";
          missionStatus = acf['mission_status'] ?? "";
          missionDuration = acf['mission_duration'] ?? "";
          captainsMessage = acf['captains_message'] ?? "";
          inFormation = acf['information'] ?? "";

          if (missionName.isEmpty) {
            _handleInvalidTicket("Invalid Ticket: Mission not found");
            return;
          }

          setState(() {
            resultData = missionName;
          });
        } else {
          _handleInvalidTicket("No data found");
        }
      } else {
        _handleInvalidTicket("Error: ${response.statusCode}");
      }
    } catch (e) {
      _handleInvalidTicket("Failed to load data");
    }
  }

  void _handleInvalidTicket(String message) {
    Navigator.pop(context);

    Future.delayed(const Duration(milliseconds: 200), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    });
  }

  void _showCaptainPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF010A1B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.75,
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(), // ✅ smooth scroll
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    const Text(
                      "CAPTAIN'S MESSAGE",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Audiowide',
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      captainsMessage.isNotEmpty
                          ? captainsMessage
                          : "No captain's message available",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          color: Colors.white70,
                          fontFamily: 'Audiowide',
                          fontSize: 16,
                          ),
                    ),

                    const SizedBox(height: 20),

                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E5FAF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "CLOSE",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFF010A1B),

        // ✅ APP BAR UPDATED
        appBar: AppBar(
          backgroundColor: const Color(0xFF010A1B),
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Image.asset(
            'assets/logo.png', // ✅ LOGO
            height: 40,
          ),

          // ✅ SETTINGS DROPDOWN
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.settings, color: Colors.white),
              onSelected: (value) async {
                if (value == "scan") {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove("scanned_url"); // ✅ clear saved ticket

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                        (route) => false,
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: "notifications",
                  child: Text("Notifications"),
                ),
                const PopupMenuItem(
                  value: "scan",
                  child: Row(
                    children: [
                      Icon(Icons.qr_code),
                      SizedBox(width: 10),
                      Text("Scan a new ticket"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        body: missionName.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "MISSION INFORMATION",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Audiowide',
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 16),
                /*
                Wrap(
                  spacing: 20,
                  runSpacing: 16,
                  children: [
                    _infoItem(missionName, missionCode),
                    _infoItem("LAUNCH DATE", "OCT 15, 2023"),
                    _infoItem("MISSION DURATION", "26-EARTH MONTHS"),
                    _infoItem("MISSION STATUS", missionStatus),
                    _infoItem("RETURN DATE", "DEC 15, 2027"),
                    _infoItem("CREW COUNT", crewCount),
                  ],
                ),
                */

                Column(
                  children: [
                    Row(
                      children: [

                        Expanded(child: _infoItem(missionName, missionCode)),
                        SizedBox(width: 25),
                        Expanded(child: _infoItem("LAUNCH DATE", "OCT 15, 2023")),
                        SizedBox(width: 35),
                        Expanded(child: _infoItem("MISSION DURATION", "26-EARTH MONTHS")),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [

                        Expanded(child: _infoItem("MISSION STATUS", missionStatus)),
                        SizedBox(width: 25),
                        Expanded(child: _infoItem("RETURN DATE", "DEC 15, 2027")),
                        SizedBox(width: 35),
                        Expanded(child: _infoItem("CREW COUNT", crewCount)),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 🔷 CAPTAIN CARD
                Container(
                  width: double.infinity,
                  height: 260,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                      image: AssetImage("assets/cap.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      /* color: Colors.black.withOpacity(0.4), */
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "CAPTAIN'S LOG",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 31,
                            fontFamily: 'Audiowide',
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Mission Status".toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Audiowide',
                              letterSpacing: 0
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          inFormation.toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontFamily: 'Audiowide',
                              letterSpacing: 0,
                              height: 0.8,

                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: _showCaptainPopup, // ✅ popup trigger
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E5FAF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "READ CAPTAIN'S MESSAGE",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Audiowide',
                                  letterSpacing: 0,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(child: _actionButton("EARTH VIEW")),
                    const SizedBox(width: 10),
                    Expanded(child: _actionButton("SPACE MAP")),
                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  "MISSION CONTROL HUB",
                  style:
                  TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 16),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: const [
                    _gridItem("DISTANCE & PROGRESS"),
                    _gridItem("ENVIRONMENTAL DATA"),
                    _gridItem("COMMUNICATION"),
                    _gridItem("SHIP TRACKER"),
                    _gridItem("WEEKLY SCHEDULE"),
                    _gridItem("SOLAR DATA GRAPH"),
                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  "SPACE HISTORY",
                  style:
                  TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border:
                    Border.all(color: Colors.white24),
                  ),
                  child: const Text(
                    "APRIL 15, 1912\n\nTHE TITANIC DISASTER...",
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "MARS COMMUNITY",
                  style:
                  TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border:
                    Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    children: [
                      Image.asset("assets/art.jpg"),
                      const SizedBox(height: 10),
                      const Text(
                        "FEATURED ART",
                        style: TextStyle(color: Colors.cyan),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        '"A HEART IN SPACE"',
                        style:
                        TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E5FAF),
                          borderRadius:
                          BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "SUBMIT YOURS",
                          style: TextStyle(
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),

        bottomNavigationBar: Container(
          height: 70,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF020E2A),
                Color(0xFF041C3C),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              // LEFT TEXT
              const Text(
                "Discord",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),

              // CENTER ICON BUTTON
              Container(
                width: 55,
                height: 55,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1E5FAF),
                      Color(0xFF0A2A4A),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
              ),

              // RIGHT TEXT
              const Text(
                "Store",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
}

// 🔧 HELPERS
/*
Widget _infoItem(String title, String value) {
  return SizedBox(
    width: 150,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style:
            const TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value,
            style:
            const TextStyle(color: Colors.cyan, fontSize: 14)),
      ],
    ),
  );
}
*/

Widget _infoItem(String title, String value) {
  return SizedBox(
    width: 120,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(), // ✅ uppercase title
          style: AppTextStyles.infoTitle,
        ),
        const SizedBox(height: 4),
        Text(
          value.toUpperCase(), // ✅ uppercase value
          style: AppTextStyles.infoValue,
        ),
      ],
    ),
  );
}

Widget _actionButton(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(
      color: const Color(0xFF0A2A4A),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}

class _gridItem extends StatelessWidget {
  final String text;
  const _gridItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }
}