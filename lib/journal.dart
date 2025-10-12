import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  late final TextEditingController _textController;

  String _getDate() {
    DateTime datetime = DateTime.now();
    return DateFormat('MMMM d, yyyy').format(datetime);
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            _getDate(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            textAlign: TextAlign.center,
          ),
          Text(
            'Journal Entry:',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: EditableText(
                    minLines: 5,
                    maxLines: 20,
                    controller: _textController,
                    focusNode: FocusNode(),
                    style: TextStyle(color: Colors.black),
                    cursorColor: Colors.tealAccent,
                    backgroundCursorColor: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: AlignmentGeometry.bottomRight,
                child: ElevatedButton(onPressed: null, child: Text('Save')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
