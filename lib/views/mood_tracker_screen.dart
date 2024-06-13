import 'package:flutter/material.dart';
import '../controllers/mood_controller.dart';
import 'package:sqflite/sqflite.dart';

class MoodTrackerScreen extends StatelessWidget {
  final MoodController _moodController;
  final Database database;

  MoodTrackerScreen({Key? key, required this.database})
      : _moodController = MoodController(database),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rastreador de Humor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Como você está se sentindo hoje?',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 5,
              children: MoodController.emojiMap.keys.map((mood) {
                return ElevatedButton(
                  onPressed: () async {
                    await _moodController.redirectAfterMoodRegistered(
                        context, mood);
                  },
                  child: Text(MoodController.emojiMap[mood]!),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
