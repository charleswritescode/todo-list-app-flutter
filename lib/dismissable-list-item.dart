
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/dismiss-background.dart';
import 'package:todo_list/todo-item.dart';
import 'package:todo_list/todo.dart';

class DismissibleListItem extends StatelessWidget {

  final Todo todo;
  final Widget background;
  final Widget secondaryBackground;

  final Function(DismissDirection direction) onDismissed;
  final Function(Todo todo) onTap;
  final Function(String status, dynamic value) onStatusChanged;

  DismissibleListItem({this.todo,
      this.background,
      this.secondaryBackground,
      this.onDismissed,
      this.onTap,
  this.onStatusChanged});


  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Dismissible(
          dragStartBehavior: DragStartBehavior.start,
          secondaryBackground: secondaryBackground,
          background: background,
          key: Key(todo.id.toString()),
          child: TodoListItem(todo, onTap, onStatusChanged),
          onDismissed: onDismissed,
        ),
        Divider()
      ],
    );
  }

}