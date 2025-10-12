import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  String _getDate() {
    DateTime datetime = DateTime.now();
    return DateFormat('MMMM d, yyyy').format(datetime);
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
        ],
      ),
    );
  }
}
