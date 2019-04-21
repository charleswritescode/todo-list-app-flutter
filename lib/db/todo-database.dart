import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/pair.dart';
import 'package:todo_list/todo.dart';

const int FALSE = 0;
const int TRUE = 1;

abstract class TodoDatabase {
  Future<List<Todo>> getUpcoming({bool includeDone = false});

  Future<List<Todo>> getArchived({bool includeDone = false});

  Future<List<Todo>> getImportant({bool includeDone = false});

  Future<void> insertTodo(Todo todo);

  Future<void> updateTodo(Todo todo);

  Future<void> deleteTodo(Todo todo);
}

class SQLiteTodoDatabase extends TodoDatabase {
  final String TODO_TABLE_NAME = 'todos';

  final List<Pair<String, String>> keys = [
    Pair(first: "id", second: "INTEGER PRIMARY KEY AUTOINCREMENT"),
    Pair(first: "title", second: "TEXT"),
    Pair(first: "description", second: "TEXT"),
    Pair(first: 'done', second: "INTEGER DEFAULT $FALSE"),
    Pair(first: 'archived', second: "INTEGER DEFAULT $FALSE"),
    Pair(first: 'important', second: "INTEGER DEFAULT $FALSE"),
    Pair(first: 'created_at', second: "INTEGER DEFAULT 0")
  ];

  Future<Database> _getDatabase() {
    return getDatabasesPath().then((path) => join(path, "app.db")).then(
        (dbFilePath) =>
            openDatabase(dbFilePath, version: 5, onCreate: (db, version) {
              _createTodoTable(db);
            }, onUpgrade: (db, oldVersion, newVersion) {
              _upgradeDB(db, oldVersion, newVersion);
            }));
  }

  @override
  Future<List<Todo>> getUpcoming({bool includeDone = false}) {
    String where = 'archived=?';
    List<dynamic> whereArgs = [FALSE];

    if (!includeDone) {
      where += ' AND done=?';
      whereArgs.add(FALSE);
    }

    return _getDatabase()
        .then((db) =>
            db.query(TODO_TABLE_NAME, where: where, whereArgs: whereArgs))
        .then((results) => List.generate(results.length, (index) {
              final result = results[index];
              print(result);
              return Todo.fromMap(result);
            }));
  }

  @override
  Future<void> deleteTodo(Todo todo) {
    return _getDatabase().then((db) =>
        db.delete(TODO_TABLE_NAME, where: "id=?", whereArgs: [todo.id]));
  }

  @override
  Future<void> insertTodo(Todo todo) {
    return _getDatabase()
        .then((db) => db.insert(TODO_TABLE_NAME, todo.toMap()));
  }

  @override
  Future<void> updateTodo(Todo todo) {
    return _getDatabase().then((db) => db.update(TODO_TABLE_NAME, todo.toMap(),
        where: "id=?", whereArgs: [todo.id]));
  }

  Future<void> _createTodoTable(Database db) {
    String keysString = keys.join(',');
    return db.execute("CREATE TABLE $TODO_TABLE_NAME ($keysString);");
  }

  void _upgradeDB(Database db, int oldVersion, int newVersion) async {
    switch (newVersion) {
      case 2:
        print("Updating to version 2");
        db.execute(
            "ALTER TABLE ${TODO_TABLE_NAME} ADD COLUMN done INTEGER DEFAULT $FALSE;");
        break;
      case 3:
        print("Updating to version 3");
        db.execute(
            "ALTER TABLE $TODO_TABLE_NAME ADD COLUMN archived INTEGER DEFAULT $FALSE;");
        break;
      case 4:
        print("Updating to version 4");
        db.execute(
            "ALTER TABLE $TODO_TABLE_NAME ADD COLUMN important INTEGER DEFAULT $FALSE;");
        break;
      case 5:
        print("Updating to version 5");
        await db.execute(
            "ALTER TABLE $TODO_TABLE_NAME ADD COLUMN created_at INTEGER DEFAULT 0;");
        List<Map<String, dynamic>> results = await db.query(TODO_TABLE_NAME);
        results.forEach((result) async {
          Map<String, dynamic> updatedMap = {};
          result.forEach((key, value) {
            updatedMap[key] = value;
          });
          updatedMap['created_at'] = result['id'];
          await updateTodo(Todo.fromMap(updatedMap));
        });
    }
  }

  @override
  Future<List<Todo>> getArchived({bool includeDone = false}) {
    String where = "archived=?";
    List<dynamic> whereArgs = [TRUE];

    if (!includeDone) {
      where += " AND done=?";
      whereArgs.add(FALSE);
    }

    return _getDatabase()
        .then((db) =>
            db.query(TODO_TABLE_NAME, where: where, whereArgs: whereArgs))
        .then((results) => List.generate(results.length, (index) {
              final result = results[index];
              print(result);
              return Todo.fromMap(result);
            }));
  }

  @override
  Future<List<Todo>> getImportant({bool includeDone = false}) {
    String where = "important=? and archived=?";
    List<dynamic> whereArgs = [TRUE, FALSE];

    if (!includeDone) {
      where += " AND done=?";
      whereArgs.add(FALSE);
    }

    return _getDatabase()
        .then((db) =>
            db.query(TODO_TABLE_NAME, where: where, whereArgs: whereArgs))
        .then((results) => List.generate(results.length, (index) {
              final result = results[index];
              print(result);
              return Todo.fromMap(result);
            }));
  }
}
