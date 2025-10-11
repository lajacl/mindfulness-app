import 'package:flutter/material.dart';
import 'package:mindfulness_app/data.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage>
    with TickerProviderStateMixin {
  Map<String, String>? _selectedItem;
  bool _videoSelected = false;
  bool _textSelected = false;
  final _playController = YoutubePlayerController();
  late TabController _nestedConrtoller;

  void _selectVideo(item) {
    setState(() {
      _selectedItem = item;
      _textSelected = false;
      _videoSelected = true;
      _playController.loadVideoById(videoId: item['videoId']);
    });
  }

  void _selectText(item) {
    setState(() {
      _selectedItem = item;
      _playController.stopVideo();
      _videoSelected = false;
      _textSelected = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _nestedConrtoller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _nestedConrtoller.dispose();
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
                          '${_selectedItem!['title']}\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(_selectedItem!['text']!),
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
              ListView.builder(
                itemCount: videoExercises.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(videoExercises[index]["title"]!),
                    trailing: Icon(Icons.play_circle_outline),
                    onTap: () => _selectVideo(videoExercises[index]),
                    selected: _videoSelected
                        ? videoExercises[index]['title'] ==
                              _selectedItem!['title']
                        : false,
                    selectedTileColor: Colors.cyan,
                  );
                },
              ),
              Material(
                child: ListView.builder(
                  itemCount: textExercises.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(textExercises[index]["title"]!),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () => _selectText(textExercises[index]),
                      selected: _textSelected
                          ? textExercises[index]['title'] ==
                                _selectedItem!['title']
                          : false,
                      selectedTileColor: Colors.cyan,
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
