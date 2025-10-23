class JournalEntry {
  final int? id;
  final String date;
  final String entry;

  JournalEntry({this.id, required this.date, required this.entry});

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date,
    'entry': entry,
  };

  factory JournalEntry.fromMap(Map<String, dynamic> map) => JournalEntry(
    id: map['id'],
    date: map['date'],
    entry: map['entry'],
  );

  @override
  String toString() {
    return 'JournalEntry(id: $id, date: $date, entry: $entry)';
  }
}