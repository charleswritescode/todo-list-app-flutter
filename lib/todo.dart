import 'package:todo_list/db/todo-database.dart';

class Todo {
  final int id;
  final String title;
  final String description;
  final bool done;
  final bool archived;
  final bool important;
  final int createdAt;

  Todo(this.id, this.title, this.description, this.done, this.archived, this.important, this.createdAt);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'title': title,
      'description': description,
      'done': done,
      'id': id,
      'archived': archived,
      'important': important,
      'created_at': createdAt
    };
    return map;
  }

  static Todo fromMap(Map<String, dynamic> result) {
    return Todo(result['id'],
        result['title'],
        result['description'],
        result['done'] == TRUE,
        result['archived'] == TRUE,
        result['important'] == TRUE,
        result['created_at']);
  }
}