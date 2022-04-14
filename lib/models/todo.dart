// To parse this JSON data, do
//
//     final todo = todoFromMap(jsonString);

import 'dart:convert';

class Todo {
  Todo({
    required this.name,
    this.isComplete = false,
    this.id,
  });

  String name;
  bool isComplete;
  String? id;

  factory Todo.fromJson(String str) => Todo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Todo.fromMap(Map<String, dynamic> json) => Todo(
        name: json["name"],
        isComplete: json["isComplete"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "isComplete": isComplete,
        "id": id,
      };
}
