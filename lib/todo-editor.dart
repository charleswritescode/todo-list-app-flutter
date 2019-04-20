import 'package:flutter/material.dart';
import 'package:todo_list/todo.dart';

class TodoEditor extends StatelessWidget {

  String todoTitle;
  String todoDescription;
  final TodoEditorController controller;

  TodoEditor({this.todoTitle, this.todoDescription, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: TextEditingController(text: todoTitle),
              onChanged: (text) {
                todoTitle = text;
                controller.onTitleChanged(text);
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
              controller: TextEditingController(text: todoDescription),
              onChanged: (text) {
                todoDescription = text;
                controller.onDescriptionChanged(text);
              },
              decoration: InputDecoration(
                  hintText: "Description", border: OutlineInputBorder()),
            )
          ],
        ));
  }

}

class TodoEditorController {
  final Function(String title) onTitleChanged;
  final Function(String description) onDescriptionChanged;

  TodoEditorController({this.onTitleChanged, this.onDescriptionChanged});
}