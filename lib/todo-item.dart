import 'package:flutter/material.dart';
import 'package:todo_list/todo.dart';

class TodoListItem extends StatefulWidget {
  final Todo todo;
  final Function(Todo todo) onTap;
  final Function(String status, dynamic value) onStatusChanged;

  TodoListItem(this.todo, this.onTap, this.onStatusChanged);

  @override
  State<StatefulWidget> createState() {
    return TodoListItemState();
  }
}

class TodoListItemState extends State<TodoListItem> {

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 4, right: 16),
      leading: Checkbox(value: widget.todo.done, onChanged: (changed) {
        widget.onStatusChanged('done', changed);
        setState(()  {
        });
      }),
      trailing: GestureDetector(
        child: Icon(widget.todo.important ? Icons.star : Icons.star_border, color: Colors.orange,),
        onTap: () {
          widget.onStatusChanged('important', !widget.todo.important);
        },
      ),
      title: Text(widget.todo.title),
      subtitle: widget.todo.description.isEmpty ? null : Text(widget.todo.description, maxLines: 1,),
      onTap: () {
        widget.onTap(widget.todo);
      },
    );
  }

}
