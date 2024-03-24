import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  Player? loggedInUser;

  void setLoggedInUser(Player user) {
    loggedInUser = user;
    notifyListeners();
  }
}

class Player {
  final String username;
  final int easyScore;
  final int mediumScore;
  final int hardScore;

  Player({
    required this.username,
    required this.easyScore,
    required this.mediumScore,
    required this.hardScore,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      username: json['Username'],
      easyScore: json['Easy'],
      mediumScore: json['Medium'],
      hardScore: json['Hard'],
    );
  }

  static Future<List<Player>> fetchData() async {
    final Uri uri = Uri.parse(
        'https://script.google.com/macros/s/AKfycby4o7tzoVTP1FDQUPq8GJEQQFTfFGsGn3UQEEZttDxDeCV0lupWYKQZvis7UKswh-Q7nA/exec');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        print('Data added successfully');
        List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((data) => Player.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  static Future<void> addUserData(
      String username, int easyScore, int mediumScore, int hardScore) async {
    final Uri uri = Uri.parse(
        'https://script.google.com/macros/s/AKfycby4o7tzoVTP1FDQUPq8GJEQQFTfFGsGn3UQEEZttDxDeCV0lupWYKQZvis7UKswh-Q7nA/exec');
    final Map<String, dynamic> data = {
      'Username': username,
      'Easy': easyScore.toString(),
      'Medium': mediumScore.toString(),
      'Hard': hardScore.toString(),
    };

    try {
      final response = await http.post(uri, body: data);
      if (response.statusCode == 302) {
        // Manually handle redirection
        final redirectUri = response.headers['location'];
        if (redirectUri != null) {
          final redirectResponse =
              await http.post(Uri.parse(redirectUri!), body: data);
          if (redirectResponse.statusCode == 405) {
            print('Data added successfully');
          } else {
            throw Exception(
                'Failed to add data after redirection. Status code: ${redirectResponse.statusCode}, Body: ${redirectResponse.body}');
          }
        } else {
          throw Exception('Redirect location not provided in response headers');
        }
      } else if (response.statusCode == 200) {
        print('Data added successfully');
      } else {
        throw Exception(
            'Failed to add data. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to add data: $e');
    }
  }
}
