import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindfulness_app/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  late final TextEditingController _textController;
  String _journalEntry = '';
  bool _isEditing = false;
  bool _canSubmit = false;

  String _getDate() {
    DateTime datetime = DateTime.now();
    return DateFormat('MMMM d, yyyy').format(datetime);
  }

  Future<void> _loadEntry() async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('journalEntry');
    if (prefs.containsKey('journalEntry')) {
      setState(() {
        _textController.text = prefs.getString('journalEntry') ?? '';
        _journalEntry = _textController.text;
      });
    }
  }

  Future<void> _saveEntry() async {
    String trimmedText = _textController.text.trim();
    if (trimmedText.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('journalEntry', trimmedText);
    setState(() {
      _journalEntry = trimmedText;
      _isEditing = false;
    });
  }

  void _editEntry() {
    setState(() {
      if (_textController.text.trim().isNotEmpty) _canSubmit = true;
      _isEditing = true;
    });
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _textController.text = _journalEntry;
    });
  }

  void _onTextChanged(value) {
    if (!_isEditing) _isEditing = true;
    if (_canSubmit != value.trim().isNotEmpty) {
      setState(() {
        _canSubmit = value.trim().isNotEmpty;
      });
    }
  }

  Future<void> _showAlertDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Action'),
          content: const Text(
            'Are you sure you want to delete the journal entry?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              onPressed: () {
                _deleteEntry();
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteEntry() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('journalEntry');
    setState(() {
      _canSubmit = false;
      _journalEntry = '';
      _textController.text = _journalEntry;
    });
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _loadEntry();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
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
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Journal Entry:',
                style: Theme.of(context).textTheme.titleSmall,
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
                  borderRadius: BorderRadius.all(Radius.circular(4)),
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
                Row(
                  mainAxisAlignment: _journalEntry.isNotEmpty
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.end,
                  children: [
                    if (_journalEntry.isNotEmpty)
                      TextButton(onPressed: _cancelEdit, child: Text('Cancel')),
                    ElevatedButton(
                      onPressed: _canSubmit ? () => _saveEntry() : null,
                      child: Text('Save'),
                    ),
                  ],
                )
              else
                Align(
                  alignment: AlignmentGeometry.bottomLeft,
                  child: TextButton(
                    onPressed: () => _showAlertDialog(context),
                    child: Text('Delete'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
