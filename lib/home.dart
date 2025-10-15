import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindfulness_app/data.dart';
import 'package:mindfulness_app/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final TabController tabController;
  const HomePage({super.key, required this.tabController});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, String> _message = {
    'text':
        'God has not given me a spirit of fear, but of power and of love and of a sound mind.',
    'verse': '2 Timothy 1:7',
  };
  Mood? _mood;
  String _journalEntry = '';

  String _getDate() {
    DateTime datetime = DateTime.now();
    return DateFormat('MMMM d, yyyy').format(datetime);
  }

  Future<void> _loadMood() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('mood')) {
      setState(() {
        _mood = Mood.values.byName(prefs.getString('mood')!);
      });
    }
  }

  Future<void> _updateMood(Mood? mood) async {
    final prefs = await SharedPreferences.getInstance();
    if (mood != null) {
      await prefs.setString('mood', mood.name);
    } else {
      await prefs.remove('mood');
    }
    setState(() {
      _mood = mood;
    });
  }

  Future<void> _loadJournalEntry() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('journalEntry')) {
      setState(() {
        _journalEntry = prefs.getString('journalEntry') ?? '';
      });
    }
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
                    padding: EdgeInsets.all(10),
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
              if (_mood == null)
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
                              onPressed: () => _updateMood(mood),
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
                      _mood!.icon,
                      size: screenWidth / 4,
                      color: _mood!.color,
                    ),
                    TextButton.icon(
                      label: Text(
                        _mood!.label,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      icon: Icon(Icons.edit, color: MindfulnessTheme.softGray),
                      iconAlignment: IconAlignment.end,
                      onPressed: () => _updateMood(null),
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
                  IconButton(
                    onPressed: () {
                      widget.tabController.animateTo(3);
                    },
                    icon: Icon(
                      _journalEntry.isEmpty ? Icons.post_add : Icons.edit_note,
                    ),
                  ),
                ],
              ),
              if (_journalEntry.isEmpty)
                Text(
                  'No entry for today yet.',
                  style: Theme.of(context).textTheme.bodySmall,
                )
              else
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        _journalEntry,
                        style: Theme.of(context).textTheme.bodySmall,
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
