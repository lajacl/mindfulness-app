import 'package:flutter/material.dart';
import 'package:mindfulness_app/data.dart';
import 'package:mindfulness_app/theme.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage>
    with TickerProviderStateMixin {
  VideoExcercise? _selectedVideo;
  TextExcercise? _selectedText;
  bool _videoSelected = false;
  bool _textSelected = false;
  final _playController = YoutubePlayerController();
  late final TabController _nestedController;

  void _selectVideo(VideoExcercise item) {
    setState(() {
      _selectedVideo = item;
      _textSelected = false;
      _videoSelected = true;
      _playController.loadVideoById(videoId: item.youtubeId);
    });
  }

  void _selectText(TextExcercise item) {
    setState(() {
      _selectedText = item;
      _playController.stopVideo();
      _videoSelected = false;
      _textSelected = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _nestedController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _nestedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _videoSelected
            ? YoutubePlayer(controller: _playController)
            : _textSelected
            ? SizedBox(
                height: screenHeight * 0.25,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Text(
                          _selectedText!.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 10),
                        Text(
                          _selectedText!.text,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Image.asset(
                'assets/images/mindful.jpg',
                fit: BoxFit.cover,
                height: screenHeight * 0.25,
                width: MediaQuery.of(context).size.width,
                alignment: AlignmentGeometry.topCenter,
              ),
        TabBar(
          controller: _nestedController,
          tabs: [
            Tab(icon: Icon(Icons.video_library), text: 'Video'),
            Tab(icon: Icon(Icons.library_books), text: 'Text'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _nestedController,
            children: [
              Material(
                child: ListView.builder(
                  itemCount: videoExercises.length,
                  itemBuilder: (context, index) {
                    final videoExcercise = videoExercises[index];
                    return ListTile(
                      title: Text(
                        videoExcercise.title,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      trailing: Icon(
                        Icons.play_circle_outline,
                        color: MindfulnessTheme.mutedCoral,
                      ),
                      onTap: () => _selectVideo(videoExcercise),
                      selected: _videoSelected
                          ? videoExcercise.title == _selectedVideo?.title
                          : false,
                      selectedTileColor: MindfulnessTheme.softTeal,
                    );
                  },
                ),
              ),
              Material(
                child: ListView.builder(
                  itemCount: textExercises.length,
                  itemBuilder: (context, index) {
                    final textExercise = textExercises[index];
                    return ListTile(
                      title: Text(
                        textExercise.title,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: MindfulnessTheme.mutedCoral,
                      ),
                      onTap: () => _selectText(textExercise),
                      selected: _textSelected
                          ? textExercise.title == _selectedVideo?.title
                          : false,
                      selectedTileColor: MindfulnessTheme.softTeal,
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
