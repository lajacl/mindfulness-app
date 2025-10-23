class MoodEntry {
  final int? id;
  final String date;
  final String mood;

  MoodEntry({this.id, required this.date, required this.mood});

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date,
    'mood': mood,
  };

  factory MoodEntry.fromMap(Map<String, dynamic> map) => MoodEntry(
    id: map['id'],
    date: map['date'],
    mood: map['mood'],
  );

  @override
  String toString() {
    return 'Mood(id: $id, date: $date, mood: $mood)';
  }
}