import 'package:flutter/material.dart';
import 'package:mindfulness_app/data.dart';
import 'package:mindfulness_app/theme.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> with TickerProviderStateMixin {
  late final TabController _nestedTabsController;

  String _getTitle(String fileName) {
    return fileName.split('.')[0].replaceAll('_', ' ');
  }

  @override
  void initState() {
    super.initState();
    _nestedTabsController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _nestedTabsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Image.asset(
          'assets/images/mindful.jpg',
          fit: BoxFit.cover,
          height: screenHeight * 0.25,
          width: MediaQuery.of(context).size.width,
          alignment: AlignmentGeometry.topCenter,
        ),
        TabBar(
          controller: _nestedTabsController,
          tabs: [
            Tab(icon: Icon(Icons.hearing), text: 'Sound'),
            Tab(icon: Icon(Icons.library_music), text: 'Music'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _nestedTabsController,
            children: [
              Material(
                child: ListView.builder(
                  itemCount: videoExercises.length,
                  itemBuilder: (context, index) {
                    final soundFile = soundFiles[index];
                    return ListTile(
                      title: Text(
                        _getTitle(soundFile),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      trailing: Icon(
                        Icons.play_circle_outline,
                        color: MindfulnessTheme.mutedCoral,
                      ),
                      onTap: null,
                    );
                  },
                ),
              ),
              Material(
                child: ListView.builder(
                  itemCount: musicFiles.length,
                  itemBuilder: (context, index) {
                    final musicFile = musicFiles[index];
                    return ListTile(
                      title: Text(
                        _getTitle(musicFile),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      trailing: Icon(
                        Icons.play_circle_outline,
                        color: MindfulnessTheme.mutedCoral,
                      ),
                      onTap: null,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
