import 'package:sqflite/sqflite.dart';
import '../models/mood.dart';

class MoodMonitoringController {
  final Database _database;

  MoodMonitoringController(this._database);

  Future<void> recordMood(Mood mood) async {
    try {
      await _database.insert('sau', mood.toMap());
    } catch (e) {
      print('Erro ao registrar humor: $e');
    }
  }

  Future<List<Mood>> getAllMoods() async {
    try {
      final List<Map<String, dynamic>> rows = await _database.query('sau');
      return rows.map((row) => Mood.fromMap(row)).toList();
    } catch (e) {
      print('Erro ao obter todos os humores: $e');
      return [];
    }
  }

  Future<List<Mood>> getMoodsByDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      final List<Map<String, dynamic>> rows = await _database.rawQuery(
        'SELECT * FROM sau WHERE date BETWEEN ? AND ?',
        [startDate.toIso8601String(), endDate.toIso8601String()],
      );
      return rows.map((row) => Mood.fromMap(row)).toList();
    } catch (e) {
      print('Erro ao obter humores por intervalo de datas: $e');
      return [];
    }
  }

  Future<Map<String, int>> getMoodCountByDay(
      DateTime startDate, DateTime endDate) async {
    try {
      final List<Map<String, dynamic>> rows = await _database.rawQuery(
        'SELECT date, COUNT(*) AS count FROM sau WHERE date BETWEEN ? AND ? GROUP BY date',
        [startDate.toIso8601String(), endDate.toIso8601String()],
      );
      Map<String, int> moodCountByDay = {};
      rows.forEach((row) {
        moodCountByDay[row['date']] = row['count'];
      });
      return moodCountByDay;
    } catch (e) {
      print('Erro ao obter contagem de humores por dia: $e');
      return {};
    }
  }
}
