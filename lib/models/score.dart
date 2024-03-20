import 'dart:convert';

class Score {
  String name;
  int score;

  Score({required this.name, required this.score});

  Score.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        score = json['score'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'score': score,
      };

  String toJsonString() => jsonEncode(toJson());
}
