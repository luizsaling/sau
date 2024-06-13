class Mood {
  final int id;
  final String mood;
  final String date;

  Mood({required this.id, required this.mood, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mood': mood,
      'date': date,
    };
  }

  factory Mood.fromMap(Map<String, dynamic> map) {
    return Mood(
      id: map['id'],
      mood: map['mood'],
      date: map['date'],
    );
  }
}
