import 'dart:convert'; // Import dart:convert for JSON encoding/decoding
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({Key? key}) : super(key: key);

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<Map<String, dynamic>> _scores = [];

  @override
  void initState() {
    super.initState();
    _loadScores(); // Load scores when the widget initializes
  }

  Future<void> _loadScores() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? scoresJson = prefs.getStringList('scores');
    if (scoresJson != null) {
      setState(() {
        _scores = scoresJson
            .map<Map<String, dynamic>>((json) => jsonDecode(json))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: ListView.builder(
        itemCount: _scores.length,
        itemBuilder: (context, index) {
          final score = _scores[index];
          return ListTile(
            title: Text(score['name']),
            subtitle: Text('Score: ${score['score']}'),
          );
        },
      ),
    );
  }
}
