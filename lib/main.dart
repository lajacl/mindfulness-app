import 'package:flutter/material.dart';
import 'package:mindfulness_app/home.dart';
import 'package:mindfulness_app/exercises.dart';
import 'package:mindfulness_app/journal.dart';
import 'package:mindfulness_app/mood.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mindfulness App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MindfulPage(title: 'Mindful Me'),
    );
  }
}

class MindfulPage extends StatefulWidget {
  const MindfulPage({super.key, required this.title});

  final String title;

  @override
  State<MindfulPage> createState() => _MindfulPageState();
}

class _MindfulPageState extends State<MindfulPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.psychology)),
              Tab(icon: Icon(Icons.sentiment_very_satisfied)),
              Tab(icon: Icon(Icons.edit_note)),
              Tab(icon: Icon(Icons.music_note)),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: TabBarView(
          children: [
            HomePage(),
            ExercisesPage(),
            MoodPage(),
            JournalPage(),
            Tab(icon: Icon(Icons.music_note, size: 200)),
          ],
        ),
      ),
    );
  }
}
