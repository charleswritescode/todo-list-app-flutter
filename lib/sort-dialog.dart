import 'package:flutter/material.dart';
import 'package:todo_list/triple.dart';

class SortDialog extends SimpleDialog {

  static List<Triple<String, String, IconData>> items = [
    Triple<String, String, IconData>(first: "Alphabetically", second: "title", third: Icons.sort_by_alpha),
    Triple<String, String, IconData>(first: "Creation date", second: "created_at", third: Icons.date_range),
    Triple<String, String, IconData>(first: "Done", second: "done", third: Icons.done),
    Triple<String, String, IconData>(first: "Importance", second: "important", third: Icons.star),
  ];

  SortDialog(BuildContext context) : super(
      title: Text("Sort by"),

      children: items.map((triple) => ListTile(
        onTap: () {
          Navigator.of(context).pop(triple);
        },
        leading: Icon(triple.third),
        title: Text(triple.first),
      )).toList());
}
