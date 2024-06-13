import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import '../models/mood.dart';

class MoodController {
  final Database database;
  MoodController(this.database);

  static const Map<String, String> emojiMap = {
    'feliz': '😊',
    'triste': '😢',
    'zangado': '😡',
    'surpreso': '😯',
    'calmo': '😌',
  };

  Future<int> addMood(String mood) async {
    String emoji = emojiMap[mood.toLowerCase()] ?? '😐';
    Mood newMood = Mood(id: 0, mood: emoji, date: DateTime.now().toString());

    try {
      return await database.insert('moods', newMood.toMap()..remove('id'));
    } catch (e) {
      if (e is DatabaseException && e.isUniqueConstraintError()) {
        print('Erro: Restrição UNIQUE falhou.');
        return -1;
      } else {
        rethrow;
      }
    }
  }

  Future<void> redirectAfterMoodRegistered(
      BuildContext context, String selectedEmoji) async {
    await addMood(selectedEmoji);

    Navigator.pushNamed(context, '/mood_history_screen');
  }

  Future<List<Mood>> getMoods() async {
    try {
      final List<Map<String, dynamic>> maps = await database.query('moods');
      return List.generate(maps.length, (i) {
        return Mood.fromMap(maps[i]);
      });
    } catch (e) {
      print('Erro ao obter humores: $e');
      return [];
    }
  }
}
