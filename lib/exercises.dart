import 'package:flutter/material.dart';
import 'package:mindfulness_app/data.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage>
    with TickerProviderStateMixin {
  Map<String, String>? _selectedItem;
  bool _textSelected = false;
  late TabController _nestedConrtoller;

  void _selectText(item) {
    setState(() {
      _textSelected = true;
      _selectedItem = item;
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
        _textSelected
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
                height: screenHeight * 0.25,
                fit: BoxFit.cover,
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
                  );
                },
              ),
              ListView.builder(
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
            ],
          ),
        ),
      ],
    );
  }
}
