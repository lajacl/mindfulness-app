import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindfulness_app/data.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  Mood? _mood;

  String _getDate() {
    DateTime datetime = DateTime.now();
    return DateFormat('MMMM d, yyyy').format(datetime);
  }

  void _updateMood(mood) {
    setState(() {
      _mood = mood;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: Mood.values.map((mood) {
                    return Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.sentiment_very_satisfied,
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
                  icon: Icon(_mood!.icon, size: screenWidth / 3),
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
        ],
      ),
    );
  }
}
