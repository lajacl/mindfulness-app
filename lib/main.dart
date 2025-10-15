import 'package:flutter/material.dart';
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

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.psychology)),
              Tab(icon: Icon(Icons.sentiment_very_satisfied)),
              Tab(icon: Icon(Icons.article)),
              Tab(icon: Icon(Icons.music_note)),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            HomePage(tabController: _tabController),
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
