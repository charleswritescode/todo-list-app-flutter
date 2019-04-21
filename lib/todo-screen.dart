import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_list/dismiss-background.dart';
import 'package:todo_list/db/todo-database.dart';
import 'package:todo_list/dismissable-list-item.dart';
import 'package:todo_list/empty-list-placeholder.dart';
import 'package:todo_list/navigation-drawer.dart';
import 'package:todo_list/todo-editor-screen.dart';
import 'package:todo_list/todo.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TodoState();
}

const int ACTION_SHOW_COMPLETED_TASKS = 0;
const int ACTION_HIDE_COMPLETED_TASKS = 1;

class TodoState extends State<TodoList> {
  StreamController<List<Todo>> todoListStreamController =
      StreamController.broadcast();

  List<Todo> _todoItems;
  TodoDatabase database = SQLiteTodoDatabase();
  String _sectionHeader = 'upcoming';

  bool _showCompletedTasks = false;

  List<ActionBarMenuItem> menuItems = [
    ActionBarMenuItem(
        ACTION_SHOW_COMPLETED_TASKS, null, "Show completed tasks"),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text("To-Done"),
            actions: <Widget>[
              PopupMenuButton<ActionBarMenuItem>(
                onSelected: (item) => onActionBarMenuItemSelected(item),
                itemBuilder: (context) {
                  return _buildPopupMenuItems(context);
                },
              )
            ],
          ),
          drawer: NavigationDrawer(
            currentTab: _sectionHeader,
            onTabSelected: (tab) => {_onNavigationDrawerTabSelected(tab: tab)},
          ),
          body: _buildBody(context),
          floatingActionButton: _buildFloatingActionButton(context),
        );
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    _todoItems = [];
    _retrieveUpcoming();
  }

  @override
  void dispose() {
    super.dispose();
    todoListStreamController.close();
  }

  /// To-do CRUD Actions
  void addTodo(
      {
        int id = -1,
        String title,
      String description,
      int index = -1,
      done = false,
      archived = false,
      important = false}) async {
    final todo = Todo(id == -1 ? DateTime.now().millisecondsSinceEpoch : id, title, description,
        done, archived, important);

    await database.insertTodo(todo);
    refreshList();
  }

  void _updateTodo(int id, String title, String description, bool done,
      bool archived, important) async {
    Todo newTodo = Todo(id, title, description, done, archived, important);
    await database.updateTodo(newTodo);

    _todoItems[_todoItems.indexWhere((test) => test.id == newTodo.id)] =
        newTodo;

    todoListStreamController.add(_todoItems);
  }

  void markArchived(todo, index, context, archived) async {
    Todo newTodo = Todo(todo.id, todo.title, todo.description, todo.done,
        archived, todo.important);
    await database.updateTodo(newTodo);

    refreshList();

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(archived ? "Archived" : "Unarchived"),
      action: SnackBarAction(
          label: "Undo",
          onPressed: () async {
            await database.updateTodo(todo);
            refreshList();
          }),
    ));
  }

  void deleteTodo(todo, index, context) async {
    await database.deleteTodo(todo);
    refreshList();

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Deleted"),
      action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            addTodo(
              id: todo.id,
                title: todo.title,
                description: todo.description,
                index: index,
                done: todo.done,
                archived: todo.archived);
          }),
    ));
  }

  void _changeTodoStatus(Todo todo, String status, dynamic value) async {
    bool done = status == 'done' ? value : todo.done;
    bool important = status == 'important' ? value : todo.important;

    print(status);

    Todo newTodo = Todo(
        todo.id, todo.title, todo.description, done, todo.archived, important);

    await database.updateTodo(newTodo);
    refreshList();
  }

  /// UI Rendering

  /// When a navigation drawer item is tapped this function is called
  _onNavigationDrawerTabSelected({String tab, bool force = false}) {
    if (!force && tab == _sectionHeader) {
      return;
    }
    switch (tab) {
      case "upcoming":
        _retrieveUpcoming();
        break;
      case "important":
        _retrieveImportant();

        break;
      case "archived":
        _retrieveArchived();
        break;
    }
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context)
              .push(MaterialPageRoute(
              builder: (context) => TodoEditor(
                database: database
              )));
          _onNavigationDrawerTabSelected(tab: _sectionHeader, force: true);

        });
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<List<Todo>>(
      stream: todoListStreamController.stream,
      builder: (context, stream) {
        if (stream.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          List<Todo> items = stream.data;
          return items.isEmpty
              ? EmptyListPlaceholder(
                  "Nothing in ${_sectionHeader.toUpperCase()}")
              : _buildTodoListView(context, items);
        }
      },
    );
  }

  Widget _buildTodoListView(BuildContext context, List<Todo> items) {
    return ListView.builder(
        itemCount: items.length + 1,
        itemBuilder: (context, index) => index == 0
            ? _buildListViewSectionHeader()
            : _buildTodoListItem(context, index - 1));
  }

  Widget _buildListViewSectionHeader() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          _sectionHeader.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _buildTodoListItem(BuildContext context, int index) {
    final todo = _todoItems[index];

    Widget archiveBackground = DismissBackground.archiveBackground;
    Widget unarchiveBackground = DismissBackground.unarchiveBackground;
    Widget deleteBackground = DismissBackground.deleteBackground;

    Widget background = todo.archived ? unarchiveBackground : archiveBackground;
    Widget secondaryBackground = deleteBackground;

    DismissDirection archiveDirection = DismissDirection.startToEnd;
    DismissDirection deleteDirection = DismissDirection.endToStart;

    return DismissibleListItem(
      todo: todo,
      background: background,
      secondaryBackground: secondaryBackground,
      onDismissed: (direction) {
        if (direction == deleteDirection) {
          deleteTodo(todo, index, context);
        } else if (direction == archiveDirection) {
          markArchived(todo, index, context, !todo.archived);
        }
      },
      onTap: (todo) async {
       await Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => TodoEditor(
                      database: database,
                      todo: todo,
                    )));
        _onNavigationDrawerTabSelected(tab: _sectionHeader, force: true);
      },
      onStatusChanged: (status, value) {
        _changeTodoStatus(todo, status, value);
      },
    );
  }

  /// Functions to retrieve to-dos

  _retrieveUpcoming() async {
    setState(() {
      _sectionHeader = "upcoming";
    });
    _todoItems = await database.getUpcoming(includeDone: _showCompletedTasks);
    todoListStreamController.add(_todoItems);
  }

  void _retrieveArchived() async {
    setState(() {
      _sectionHeader = "archived";
    });
    _todoItems = await database.getArchived(includeDone: _showCompletedTasks);
    todoListStreamController.add(_todoItems);
  }

  void _retrieveImportant() async {
    setState(() {
      _sectionHeader = "important";
    });
    _todoItems = await database.getImportant(includeDone: _showCompletedTasks);
    todoListStreamController.add(_todoItems);
  }

  onActionBarMenuItemSelected(ActionBarMenuItem item) {
    switch (item.id) {
      case ACTION_SHOW_COMPLETED_TASKS:
        setState(() {
          _showCompletedTasks = true;
        });
        refreshList();
        break;
      case ACTION_HIDE_COMPLETED_TASKS:
        setState(() {
          _showCompletedTasks = false;
        });
        refreshList();
        break;
    }
  }

  List<PopupMenuItem<ActionBarMenuItem>> _buildPopupMenuItems(
      BuildContext context) {
    List<PopupMenuItem<ActionBarMenuItem>> items = [];

    if (_showCompletedTasks) {
      final item = ActionBarMenuItem(
          ACTION_HIDE_COMPLETED_TASKS, null, "Hide completed tasks");
      items.add(PopupMenuItem<ActionBarMenuItem>(
        value: item,
        child: Text(item.title),
      ));
    } else {
      final item = ActionBarMenuItem(
          ACTION_SHOW_COMPLETED_TASKS, null, "Show completed tasks");
      items.add(PopupMenuItem<ActionBarMenuItem>(
        value: item,
        child: Text(item.title),
      ));
    }

    return items;
  }

  void onTodoUpdated(Todo todo) {
    int index = _todoItems.indexWhere((item) => item.id == todo.id);
    _todoItems[index] = todo;
    print(todo.toMap());
    todoListStreamController.add(_todoItems);
  }

  void refreshList() {
    _onNavigationDrawerTabSelected(tab: _sectionHeader, force: true);
  }
}

class ActionBarMenuItem {
  final int id;
  final IconData icon;
  final String title;

  ActionBarMenuItem(this.id, this.icon, this.title);
}
