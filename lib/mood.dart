import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mindfulness_app/data.dart';
import 'package:mindfulness_app/database/models/mood_entry.dart';
import 'package:mindfulness_app/database/repositories/mood_history_repository.dart';
import 'package:mindfulness_app/theme.dart';
import 'package:pie_chart/pie_chart.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  final MoodHistoryRepository _moodRepository = MoodHistoryRepository();
  MoodEntry? _currentMood;
  List<MoodEntry> _moodHistory = [];
  List<Map<String, dynamic>> _countMapList = [];

  String _getDateToday() {
    DateTime datetime = DateTime.now();
    return DateFormat('MMMM d, yyyy').format(datetime);
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
    } else {
      _currentMood = null;
    }
    setState(() {
      _moodHistory = moodEntries;
    });
  }

  String _getFormattedDate(String entryDateTime) {
    DateTime dateTime = DateTime.parse(entryDateTime);
    return DateFormat('EEEE, MMMM d, yyyy h:mm a').format(dateTime.toLocal());
  }

  Future<void> _saveMood(Mood newMood) async {
    MoodEntry updatedMood = MoodEntry(
      date: DateTime.now().toUtc().toIso8601String(),
      mood: newMood.name,
    );
    await _moodRepository.save(updatedMood);
    _loadMoodData();
  }

  Future<void> _deleteMood() async {
    await _moodRepository.deleteById(_currentMood!.id!);
    _loadMoodData();
  }

  Future<void> _loadChartData() async {
    _countMapList = await _moodRepository.getCountByMood();
  }

  Map<String, double> _buildPieChart() {
    Map<String, double> countMap = {};
    for (var mood in Mood.values) {
      for (var item in _countMapList) {
        if (item['mood'] == mood.name) {
          countMap['${mood.name} (${item['count']})'] = item['count']
              .toDouble();
          break;
        }
      }
    }
    return countMap;
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _loadMoodData();
    _loadChartData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 10,
        children: <Widget>[
          Text(
            _getDateToday(),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
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
                Hero(
                  tag: 'mood',
                  child: Icon(
                    Mood.values.byName(_currentMood!.mood).icon,
                    size: screenWidth / 4,
                    color: Mood.values.byName(_currentMood!.mood).color,
                  ),
                ),
                TextButton.icon(
                  label: Text(
                    Mood.values.byName(_currentMood!.mood).label,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  icon: Icon(Icons.edit, color: MindfulnessTheme.softGray),
                  iconAlignment: IconAlignment.end,
                  onPressed: () => _deleteMood(),
                ),
              ],
            ),
          SizedBox(height: 30),
          Text('History', style: Theme.of(context).textTheme.titleMedium),
          if (_countMapList.isNotEmpty)
            PieChart(
              dataMap: _buildPieChart(),
              chartLegendSpacing: 20,
              chartRadius: screenWidth / 3,
              colorList: [
                MindfulnessTheme.softTeal,
                MindfulnessTheme.skyBlue,
                MindfulnessTheme.mutedCoral,
              ],
              chartValuesOptions: ChartValuesOptions(
                showChartValuesInPercentage: true,
              ),
            ),
          SizedBox(height: 10),
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
