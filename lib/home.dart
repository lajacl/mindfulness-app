import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindfulness_app/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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

  @override
  void initState() {
    super.initState();
    _loadMood();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              _getDate(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(_message['text']!, style: TextStyle(fontSize: 18)),
                    Align(
                      alignment: AlignmentGeometry.bottomRight,
                      child: Text(
                        _message['verse']!,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_mood == null)
              Column(
                children: [
                  Text('How are you?', style: TextStyle(fontSize: 20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Icon(_mood!.icon, size: screenWidth / 4),
                  TextButton.icon(
                    label: Text(_mood!.label),
                    icon: Icon(Icons.edit),
                    iconAlignment: IconAlignment.end,
                    onPressed: () => _updateMood(null),
                  ),
                ],
              ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
