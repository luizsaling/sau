import 'dart:convert';
import 'package:http/http.dart' as http;

class CounselingService {
  final String apiUrl = "https://api.betterhelp.com/v1/";

  Future<List<dynamic>> getCounselors() async {
    final response = await http.get(Uri.parse('${apiUrl}counselors'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar conselheiros');
    }
  }

  Future<dynamic> scheduleSession(
      String counselorId, String userId, String datetime) async {
    final response = await http.post(
      Uri.parse('${apiUrl}sessions'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'counselorId': counselorId,
        'userId': userId,
        'datetime': datetime,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao agendar sessão');
    }
  }
}
