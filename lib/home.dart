import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindfulness_app/data.dart';
import 'package:mindfulness_app/database/models/journal_entry.dart';
import 'package:mindfulness_app/database/models/mood_entry.dart';
import 'package:mindfulness_app/database/repositories/journal_repository.dart';
import 'package:mindfulness_app/database/repositories/mood_history_repository.dart';
import 'package:mindfulness_app/theme.dart';

class HomePage extends StatefulWidget {
  final TabController tabController;
  const HomePage({super.key, required this.tabController});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MoodHistoryRepository _moodRepository = MoodHistoryRepository();
  final JournalRepository _journalRepository = JournalRepository();
  final Map<String, String> _message = {
    'text':
        'God has not given me a spirit of fear, but of power and of love and of a sound mind.',
    'verse': '2 Timothy 1:7',
  };
  MoodEntry? _moodEntry;
  String _journalEntry = '';

  String _getDate() {
    DateTime datetime = DateTime.now();
    return DateFormat('MMMM d, yyyy').format(datetime);
  }

  Future<void> _loadMood() async {
    MoodEntry? moodToday = await _moodRepository.getFirstWhereDateToday();
    setState(() {
      _moodEntry = moodToday;
    });
  }

  Future<void> _saveMood(Mood newMood) async {
    MoodEntry updatedMood = MoodEntry(
      date: DateTime.now().toUtc().toIso8601String(),
      mood: newMood.name,
    );
    await _moodRepository.save(updatedMood);
    _loadMood();
  }

  Future<void> _deleteMood() async {
    await _moodRepository.deleteById(_moodEntry!.id!);
    _loadMood();
  }

  Future<void> _loadJournalEntry() async {
    JournalEntry? entryToday = await _journalRepository
        .getFirstWhereDateToday();
    setState(() {
      _journalEntry = entryToday?.entry ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMood();
    _loadJournalEntry();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                _getDate(),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(4),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          _message['text']!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Align(
                          alignment: AlignmentGeometry.bottomRight,
                          child: Text(
                            _message['verse']!,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              if (_moodEntry == null)
                Column(
                  children: [
                    Text(
                      'How are you?',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: Mood.values.map((mood) {
                        return Column(
                          children: [
                            IconButton(
                              icon: Icon(
                                mood.icon,
                                size: screenWidth / (Mood.values.length + 1),
                                color: mood.color,
                              ),
                              onPressed: () => _saveMood(mood),
                            ),
                            Text(
                              mood.label,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Icon(
                      Mood.values.byName(_moodEntry!.mood).icon,
                      size: screenWidth / 4,
                      color: Mood.values.byName(_moodEntry!.mood).color,
                    ),
                    TextButton.icon(
                      label: Text(
                        Mood.values.byName(_moodEntry!.mood)!.label,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      icon: Icon(Icons.edit, color: MindfulnessTheme.softGray),
                      iconAlignment: IconAlignment.end,
                      onPressed: () => _deleteMood(),
                    ),
                  ],
                ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Journal Entry:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  if (_journalEntry.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        widget.tabController.animateTo(3);
                      },
                      icon: Icon(Icons.edit_note),
                    ),
                ],
              ),
              SizedBox(height: 20),
              if (_journalEntry.isEmpty)
                Column(
                  children: [
                    Text(
                      'No entry for today yet. Add one.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    IconButton(
                      onPressed: () {
                        widget.tabController.animateTo(3);
                      },
                      icon: Icon(Icons.post_add),
                      iconSize: 100,
                      color: MindfulnessTheme.softGray,
                    ),
                  ],
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(4),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          _journalEntry,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
