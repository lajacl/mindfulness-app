import 'package:flutter/material.dart';
import 'package:mindfulness_app/audio.dart';
import 'package:mindfulness_app/exercises.dart';
import 'package:mindfulness_app/home.dart';
import 'package:mindfulness_app/journal.dart';
import 'package:mindfulness_app/mood.dart';
import 'package:mindfulness_app/theme.dart';

void main() {
  runApp(const MindfulnessApp());
}

class MindfulnessApp extends StatelessWidget {
  const MindfulnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mindfulness App',
      theme: MindfulnessTheme.theme,
      home: const MainPage(title: 'Mindful Me'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final List<Widget> _pages;
  int _selectedIndex = 0;

  void _onPageChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      HomePage(goToPage: _onPageChange),
      const ExercisesPage(),
      const MoodPage(),
      const JournalPage(),
      const AudioPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        onTap: _onPageChange,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'Exercises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sentiment_very_satisfied),
            label: 'Mood Tracker',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Journal'),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Audio'),
        ],
      ),
    );
  }
}
