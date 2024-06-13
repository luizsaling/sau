import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../controllers/mood_controller.dart';
import '../models/mood.dart';

class MoodHistoryScreen extends StatelessWidget {
  final Database database;
  final MoodController _moodController;

  MoodHistoryScreen({Key? key, required this.database})
      : _moodController = MoodController(database),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de humor'),
      ),
      body: FutureBuilder<List<Mood>>(
        future: _moodController.getMoods(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading moods'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No moods recorded'));
          } else {
            final moods = snapshot.data!;
            return ListView.builder(
              itemCount: moods.length,
              itemBuilder: (context, index) {
                final mood = moods[index];
                return ListTile(
                  title: Text(mood.mood),
                  subtitle: Text(mood.date),
                );
              },
            );
          }
        },
      ),
    );
  }
}
