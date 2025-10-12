import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  String _mood = "";

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
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              _getDate(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          if (_mood == 'Good')
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.sentiment_very_satisfied,
                    size: screenWidth / 3,
                  ),
                  onPressed: () => _updateMood('Good'),
                ),
                Text('Good'),
              ],
            )
          else if (_mood == 'Okay')
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.sentiment_neutral, size: screenWidth / 3),
                  onPressed: () => _updateMood('Okay'),
                ),
                Text('Okay'),
              ],
            )
          else if (_mood == 'Bad')
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.sentiment_very_dissatisfied,
                    size: screenWidth / 3,
                  ),
                  onPressed: () => _updateMood('Bad'),
                ),
                Text('Bad'),
              ],
            )
          else
            Column(
              children: [
                Text(
                  'How are you?',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.left,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.sentiment_very_satisfied,
                            size: screenWidth / 4,
                          ),
                          onPressed: () => _updateMood('Good'),
                        ),
                        Text('Good'),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.sentiment_neutral,
                            size: screenWidth / 4,
                          ),
                          onPressed: () => _updateMood('Okay'),
                        ),
                        Text('Okay'),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.sentiment_very_dissatisfied,
                            size: screenWidth / 4,
                          ),
                          onPressed: () => _updateMood('Bad'),
                        ),
                        Text('Bad'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
