import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindfulness_app/data.dart';
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
        'okay',
        'bad',
        'bad',
        'okay',
        'okay',
        'good',
        'good',
        'bad',
        'good',
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
          Text(
            _getDate(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          if (_mood == null)
            Column(
              children: [
                Text('How are you?', style: TextStyle(fontSize: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: Mood.values.map((mood) {
                    return Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            mood.icon,
                            size: screenWidth / (Mood.values.length + 1),
                          ),
                          onPressed: () => _updateMood(mood),
                        ),
                        Text(mood.label),
                      ],
                    );
                  }).toList(),
                ),
              ],
            )
          else
            Column(
              children: [
                IconButton(
                  icon: Icon(_mood!.icon, size: screenWidth / 4),
                  onPressed: () => _updateMood(null),
                ),
                TextButton.icon(
                  label: Text(_mood!.label),
                  icon: Icon(Icons.edit),
                  iconAlignment: IconAlignment.end,
                  onPressed: () => _updateMood(null),
                ),
              ],
            ),
          SizedBox(height: 20),
          Text(
            'History',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _moodHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(_moodHistory[index].icon, size: 50),
                  title: Text(_getMockDate(index + 1)),
                  subtitle: Text(_moodHistory[index].label),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            ),
          ),
        ],
      ),
    );
  }
}
