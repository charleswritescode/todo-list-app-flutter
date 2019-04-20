import 'package:flutter/material.dart';
import 'package:todo_list/db/todo-database.dart';
import 'package:todo_list/todo-editor.dart';
import 'package:todo_list/todo.dart';

class TodoEditorScreen extends StatelessWidget {
  int _todoId;

  TodoDatabase _database;
  BuildContext context;
  String _todoTitle;
  String _todoDescription;
  bool newTodo;

  TodoEditorScreen(this._database, {Key key, Todo todo}) : super(key: key) {
    if (todo != null) {
      newTodo = false;
      _todoId = todo.id;
      _todoTitle = todo.title;
      _todoDescription = todo.description;
    } else {
      newTodo = true;
      _todoId = DateTime
          .now()
          .millisecondsSinceEpoch;
      _todoTitle = '';
      _todoDescription = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    context = context;
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        title: Text("Editor"),
      ),
      body: Padding(padding: EdgeInsets.all(16), child: TodoEditor(
        todoTitle: _todoTitle,
        todoDescription: _todoDescription,
        controller: TodoEditorController(onTitleChanged: (title) {
          _todoTitle = title;
        }, onDescriptionChanged: (description) {
          _todoDescription = description;
        }),
      ),),
    ), onWillPop: () {
      return Future<bool>(() async {
        Map<String,dynamic> result = {

        };

        Todo todo = Todo(_todoId, _todoTitle, _todoDescription, false, false, false);
        if(newTodo) {
          await _database.insertTodo(todo);
          result['action'] = 'new_todo';
          result['todo'] = todo;
          result['success'] = true;
        }
        else {
          print("Updating");
          await _database.updateTodo(todo);
          result['action'] = 'update_todo';
          result['todo'] = todo;
          result['success'] = true;
        }

        Navigator.of(context).pop(result);
        return false;
      });
    });
  }

}
