import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindfulness_app/data.dart';
import 'package:mindfulness_app/main.dart';
import 'package:mindfulness_app/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  Mood? _mood;
  final List<Mood> _moodHistory = [];

  String _getDate() {
    DateTime datetime = DateTime.now();
    return DateFormat('MMMM d, yyyy').format(datetime);
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

  String _getMockDate(int daysPast) {
    DateTime datetime = DateTime.now().subtract(Duration(days: daysPast));
    return DateFormat('MMMM d, yyyy').format(datetime);
  }

  Future<void> _loadMoodData() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('moodHistory')) {
      List<String> moodList = [
        'good',
        'good',
        'good',
        'okay',
        'bad',
        'bad',
        'okay',
        'okay',
        'good',
        'good',
        'bad',
        'good',
        'bad',
        'okay',
      ];
      await prefs.setStringList('moodHistory', moodList);
    }
    List<String>? moodNameList = prefs.getStringList('moodHistory');
    setState(() {
      if (prefs.containsKey('mood')) {
        _mood = Mood.values.byName(prefs.getString('mood')!);
      }
      moodNameList?.forEach((mood) {
        _moodHistory.add(Mood.values.byName(mood));
      });
    });
  }

  @override
  void initState() {
    super.initState();
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
          if (_mood == null)
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
                Icon(_mood!.icon, size: screenWidth / 4, color: _mood!.color),
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
          Text('History', style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 8),
          Expanded(
            child: Container(
              color: MindfulnessTheme.offWhite,
              child: ListView.separated(
                itemCount: _moodHistory.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      _moodHistory[index].icon,
                      size: 50,
                      color: _moodHistory[index].color,
                    ),
                    title: Text(
                      _getMockDate(index + 1),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      _moodHistory[index].label,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
