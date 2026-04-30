import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mission_model.dart';

class ApiService {

  static Future<MissionModel?> fetchMission(String slug) async {

    final apiUrl =
        'https://dev4work.com/thefirstonmars/wp-json/wp/v2/pages?slug=$slug';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {

      final data = json.decode(response.body);

      if (data.isNotEmpty) {
        return MissionModel.fromJson(data[0]['acf']);
      }
    }

    return null;
  }
}