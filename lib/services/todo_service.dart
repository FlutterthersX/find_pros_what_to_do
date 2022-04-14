import 'dart:convert';

import 'package:what_to_do/models/todo.dart';

import 'package:http/http.dart' as http;

class TodoService {
  Future<List<Todo>> getAllTodo() async {
    var request = http.Request(
        'GET', Uri.parse('https://docker-compose.prohelika.net/api/todo'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return (json.decode(await response.stream.bytesToString()) as List)
          .map((json) => Todo.fromMap(json))
          .toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<Todo> getTodo(String id) async {
    var request = http.Request(
        'GET', Uri.parse('https://docker-compose.prohelika.net/api/todo/$id'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return Todo.fromJson(await response.stream.bytesToString());
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<Todo> createTodo(String name) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse('https://docker-compose.prohelika.net/api/todo'));
    request.body = json.encode({"name": name});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      return Todo.fromJson(await response.stream.bytesToString());
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<void> updateTodo(Todo todo) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('PUT',
        Uri.parse('https://docker-compose.prohelika.net/api/todo/${todo.id}'));
    request.body = todo.toJson();
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 204) {
      return;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<void> deleteTodo(String id) async {
    var request = http.Request('DELETE',
        Uri.parse('https://docker-compose.prohelika.net/api/todo/$id'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 204) {
      return;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
