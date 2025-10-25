import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindfulness_app/database/models/journal_entry.dart';
import 'package:mindfulness_app/database/repositories/journal_repository.dart';
import 'package:mindfulness_app/theme.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final JournalRepository _journalRepository = JournalRepository();
  final TextEditingController _textController = TextEditingController();
  final PageController _pageController = PageController();

  List<JournalEntry> _entryList = [];
  String _currentEntry = '';
  bool _isEditing = false;
  bool _canSubmit = false;

  String _getFormattedDate(String entryDateTime) {
    DateTime dateTime = DateTime.parse(entryDateTime);
    return DateFormat('MMMM d, yyyy\nh:mm a').format(dateTime.toLocal());
  }

  Future<void> _loadJournalData() async {
    List<JournalEntry> journalEntries = await _journalRepository
        .getAllByDateDesc();
    if (journalEntries.isEmpty ||
        (journalEntries.isNotEmpty &&
            !DateUtils.isSameDay(
              DateTime.parse(journalEntries.first.date),
              DateTime.now(),
            ))) {
      journalEntries.insert(
        0,
        JournalEntry(
          id: null,
          date: DateTime.now().toUtc().toIso8601String(),
          entry: '',
        ),
      );
    }
    setState(() {
      _entryList = journalEntries;
      _textController.text = _currentEntry =
          _entryList[_pageController.initialPage].entry;
    });
  }

  Future<void> _saveEntry(JournalEntry entry) async {
    String trimmedText = _textController.text.trim();
    if (trimmedText.isEmpty || (trimmedText == _currentEntry)) return;
    JournalEntry updatedEntry = JournalEntry(
      id: entry.id,
      date: entry.date,
      entry: trimmedText,
    );
    await _journalRepository.save(updatedEntry);
    _isEditing = false;
    _loadJournalData();
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
      _textController.text = _currentEntry;
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

  Future<void> _showAlertDialog(
    BuildContext context,
    JournalEntry entry,
  ) async {
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
                _deleteEntry(entry);
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteEntry(JournalEntry entry) async {
    await _journalRepository.deleteById(entry.id!);
    setState(() {
      _canSubmit = false;
    });
    _loadJournalData();
  }

  void _updatePageState(index) {
    setState(() {
      _textController.text = _currentEntry = _entryList[index].entry;
      if (_pageController.page == 0 && _currentEntry.isEmpty) {
        _isEditing = true;
      } else {
        _isEditing = false;
      }
    });
  }

  bool _hasPreviousPage(int index) {
    return index < (_entryList.length - 1);
  }

  bool _hasNextPage(int index) {
    return index > 0;
  }

  @override
  void initState() {
    super.initState();
    _loadJournalData();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      child: PageView.builder(
        controller: _pageController,
        reverse: true,
        itemCount: _entryList.length,
        onPageChanged: _updatePageState,
        itemBuilder: (BuildContext context, int index) {
          final journalEntry = _entryList[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Opacity(
                    opacity: _hasPreviousPage(index) ? 1 : 0,
                    child: IconButton(
                      onPressed: _hasPreviousPage(index)
                          ? () => _pageController.nextPage(
                              duration: Duration(milliseconds: 250),
                              curve: Curves.linear,
                            )
                          : null,
                      icon: Icon(Icons.arrow_circle_left),
                      iconSize: 50,
                      color: MindfulnessTheme.softTeal,
                      disabledColor: MindfulnessTheme.softGray,
                    ),
                  ),
                  Text(
                    _getFormattedDate(journalEntry.date),
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  Opacity(
                    opacity: _hasNextPage(index) ? 1 : 0,
                    child: IconButton(
                      onPressed: _hasNextPage(index)
                          ? () => _pageController.previousPage(
                              duration: Duration(milliseconds: 250),
                              curve: Curves.linear,
                            )
                          : null,
                      icon: Icon(Icons.arrow_circle_right),
                      iconSize: 50,
                      color: MindfulnessTheme.softTeal,
                      disabledColor: MindfulnessTheme.softGray,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Journal Entry:',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        if (_textController.text.isNotEmpty && !_isEditing)
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: MindfulnessTheme.softGray,
                            ),
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
                              readOnly:
                                  _textController.text.isNotEmpty &&
                                  !_isEditing,
                              onChanged: (value) => _onTextChanged(value),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        if (_textController.text.isEmpty || _isEditing)
                          Row(
                            mainAxisAlignment: journalEntry.entry.isNotEmpty
                                ? MainAxisAlignment.spaceBetween
                                : MainAxisAlignment.end,
                            children: [
                              if (journalEntry.entry.isNotEmpty)
                                TextButton(
                                  onPressed: _cancelEdit,
                                  child: Text('Cancel'),
                                ),
                              ElevatedButton(
                                onPressed: _canSubmit
                                    ? () => _saveEntry(journalEntry)
                                    : null,
                                child: Text('Save'),
                              ),
                            ],
                          )
                        else
                          Align(
                            alignment: AlignmentGeometry.bottomLeft,
                            child: TextButton(
                              onPressed: () =>
                                  _showAlertDialog(context, journalEntry),
                              child: Text('Delete'),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
