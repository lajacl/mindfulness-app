import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mindfulness_app/data.dart';
import 'package:mindfulness_app/database/repositories/mood_history_repository.dart';
import 'package:mindfulness_app/theme.dart';

import 'database/models/mood_entry.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  final MoodHistoryRepository _moodRepository = MoodHistoryRepository();
  MoodEntry? _currentMood;
  List<MoodEntry> _moodHistory = [];

  String _getDate() {
    DateTime datetime = DateTime.now();
    return DateFormat('MMMM d, yyyy').format(datetime);
  }

  Future<void> _updateMood(Mood? newMood) async {
    if (newMood == null) {
      await _moodRepository.deleteById(_currentMood!.id!);
      _currentMood = null;
    } else {
      MoodEntry nowMood = MoodEntry(
        date: DateTime.now().toUtc().toIso8601String(),
        mood: newMood.name,
      );
      await _moodRepository.add(nowMood);
    }
    _loadMoodData();
  }

  Future<void> _loadMoodData() async {
    List<MoodEntry> moodEntries = await _moodRepository.getAllByDateDesc();
    if (moodEntries.isNotEmpty &&
        DateUtils.isSameDay(
          DateTime.parse(moodEntries.first.date),
          DateTime.now(),
        )) {
      _currentMood = moodEntries.first;
      moodEntries.removeAt(0);
    }
    setState(() {
      _moodHistory = moodEntries;
    });
  }

  String _getFormattedDate(String entryDateTime) {
    DateTime dateTime = DateTime.parse(entryDateTime);
    return DateFormat('EEEE, MMMM d, yyyy h:mm a').format(dateTime.toLocal());
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _loadMoodData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(_getDate(), style: Theme.of(context).textTheme.headlineLarge),
          SizedBox(height: 10),
          if (_currentMood == null)
            Column(
              children: [
                Text(
                  'How are you?',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  Mood.values.byName(_currentMood!.mood).icon,
                  size: screenWidth / 4,
                  color: Mood.values.byName(_currentMood!.mood).color,
                ),
                TextButton.icon(
                  label: Text(
                    Mood.values.byName(_currentMood!.mood).label,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  icon: Icon(Icons.edit, color: MindfulnessTheme.softGray),
                  iconAlignment: IconAlignment.end,
                  onPressed: () => _updateMood(null),
                ),
              ],
            ),
          SizedBox(height: 50),
          Text('History', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 8),
          Expanded(
            child: _moodHistory.isNotEmpty
                ? Container(
                    color: MindfulnessTheme.offWhite,
                    child: ListView.separated(
                      itemCount: _moodHistory.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(
                            Mood.values.byName(_moodHistory[index].mood).icon,
                            size: 50,
                            color: Mood.values
                                .byName(_moodHistory[index].mood)
                                .color,
                          ),
                          title: Text(
                            _getFormattedDate(_moodHistory[index].date),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          subtitle: Text(
                            Mood.values.byName(_moodHistory[index].mood).label,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                    ),
                  )
                : Text(
                    'Nothing to see here yet.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
          ),
        ],
      ),
    );
  }
}
