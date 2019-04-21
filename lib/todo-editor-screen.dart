import 'package:flutter/material.dart';
import 'package:todo_list/db/todo-database.dart';
import 'package:todo_list/todo.dart';

class TodoEditor extends StatefulWidget {
  final TodoDatabase database;
  final Todo todo;

  const TodoEditor({Key key, this.database, this.todo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TodoEditorState(database, todo: todo);
  }
}

class TodoEditorState extends State<TodoEditor> {
  int _todoId;

  TodoDatabase _database;
  BuildContext context;

  String _todoTitle;
  String _todoDescription;
  bool _done;
  bool _archived;
  bool _important;
  int _createdAt;

  bool newTodo;

  TodoEditorState(this._database, {Todo todo}){
    if (todo != null) {
      newTodo = false;
      _todoId = todo.id;
      _todoTitle = todo.title;
      _todoDescription = todo.description;
      _done = todo.done;
      _archived = todo.archived;
      _important = todo.important;
      _createdAt = todo.createdAt;
    } else {
      newTodo = true;
      _todoId = DateTime.now().millisecondsSinceEpoch;
      _todoTitle = '';
      _todoDescription = '';
      _done = false;
      _archived = false;
      _important = false;
      _createdAt = DateTime.now().millisecondsSinceEpoch;
    }
  }

  @override
  Widget build(BuildContext context) {
    context = context;
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Editor"),
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: TextEditingController(text: _todoTitle),
                      onChanged: (text) {
                        _todoTitle = text;
                      },
                      decoration: InputDecoration(
                          hintText: "Title", border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      controller: TextEditingController(text: _todoDescription),
                      onChanged: (text) {
                        _todoDescription = text;
                      },
                      decoration: InputDecoration(
                          hintText: "Description", border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: _done,
                          onChanged: (changed) {
                            setState(() {
                              _done = changed;
                            });
                          },
                        ),
                        Text("Done")
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: _important,
                          onChanged: (changed) {
                            setState(() {
                              _important = changed;
                            });
                          },
                        ),
                        Text("Important")
                      ],
                    )
                  ],
                )),
          ),
        ),
        onWillPop: () {
          return Future<bool>(() async {
            Map<String, dynamic> result = {};

            Todo todo = Todo(_todoId, _todoTitle, _todoDescription, _done,
                _archived, _important, _createdAt);
            if (newTodo) {
              await _database.insertTodo(todo);
              result['action'] = 'new_todo';
              result['todo'] = todo;
              result['success'] = true;
            } else {
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
