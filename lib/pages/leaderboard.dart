import 'package:appdev/pages/game.dart';
import 'package:appdev/pages/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:appdev/models/players.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({super.key});

  @override
  State<Leaderboard> createState() => LeaderboardState();
}

class LeaderboardState extends State<Leaderboard> {
  List<Player> users = [];
  String currentScoreType = 'Easy';

  @override
  void initState() {
    super.initState();
    Player.fetchData().then((data) {
      setState(() {
        users = data;
      });
    });
  }

  List<Widget> buildUserList() {
    // Sort users list based on the selected score type
    users.sort((a, b) {
      switch (currentScoreType) {
        case 'Easy':
          return b.easyScore.compareTo(a.easyScore);
        case 'Medium':
          return b.mediumScore.compareTo(a.mediumScore);
        case 'Hard':
          return b.hardScore.compareTo(a.hardScore);
        default:
          return 0;
      }
    });

    // Build list of ListTiles
    return users.map((user) {
      return ListTile(
        title: Text(user.username),
        subtitle: Text('${_getScore(user)}'),
      );
    }).toList();
  }

  String _getScore(Player user) {
    switch (currentScoreType) {
      case 'Easy':
        return '${user.easyScore}';
      case 'Medium':
        return '${user.mediumScore}';
      case 'Hard':
        return '${user.hardScore}';
      default:
        return '';
    }
  }

  // @override
  // void dispose() {
  //   Game._timer.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Menu()));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Leaderboard'),
        ),
        body: ListView(
          children: buildUserList(),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentScoreType = 'Easy';
                  });
                },
                child: Text('Easy'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentScoreType = 'Medium';
                  });
                },
                child: Text('Medium'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentScoreType = 'Hard';
                  });
                },
                child: Text('Hard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
