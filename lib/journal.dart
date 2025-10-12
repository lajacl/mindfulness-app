import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  late final TextEditingController _textController;
  bool _isEditing = false;
  bool _canSubmit = false;

  String _getDate() {
    DateTime datetime = DateTime.now();
    return DateFormat('MMMM d, yyyy').format(datetime);
  }

  void _saveEntry() {
    setState(() {
      if (_textController.text.trim().isEmpty) return;
      _isEditing = false;
    });
  }

  void _editEntry() {
    setState(() {
      _isEditing = true;
    });
  }

  void _onTextChanged(value) {
    if (_canSubmit != value.trim().isNotEmpty) {
      setState(() {
        _canSubmit = value.trim().isNotEmpty;
      });
    }
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
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Journal Entry:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (_textController.text.isNotEmpty && !_isEditing)
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editEntry(),
                ),
            ],
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
                    readOnly: _textController.text.isNotEmpty && !_isEditing,
                    onChanged: (value) => _onTextChanged(value),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (_textController.text.isEmpty || _isEditing)
                Align(
                  alignment: AlignmentGeometry.bottomRight,
                  child: ElevatedButton(
                    onPressed: _canSubmit ? () => _saveEntry() : null,
                    child: Text('Save'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
