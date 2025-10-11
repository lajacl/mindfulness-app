import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage>
    with TickerProviderStateMixin {
  late TabController _nestedConrtoller;

  @override
  void initState() {
    super.initState();
    _nestedConrtoller = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _nestedConrtoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Image.asset('assets/images/mindful.jpg'),
        TabBar(
          controller: _nestedConrtoller,
          tabs: [
            Tab(icon: Icon(Icons.video_library), text: 'Video'),
            Tab(icon: Icon(Icons.library_books), text: 'Text'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _nestedConrtoller,
            children: [
              Tab(icon: Icon(Icons.video_library), text: 'Video', height: 100),
              ListView(),
            ],
          ),
        ),
      ],
    );
  }
}
