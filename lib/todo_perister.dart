import 'todo.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

// an assister class to manage order and persistent data of the app
class TodoPersister {
  static const tableName = 'todos';
  static const databaseName = 'todos_database.db';

  sql.Database database;
  List<TodoData> todos;

  TodoPersister();

  Future<int> updateTodo(int index) {
    var data = todos[index];
    data.position = index;
    return database
        .update('todos', data.toMap(), where: 'id = ?', whereArgs: [data.id]);
  }

  Future<int> updateTodoByValue(TodoData value) {
    return updateTodo(todos.indexOf(value));
  }

  Future<void> openAndLoadDatabase() async {
    database = await sql
        .openDatabase(path.join(await sql.getDatabasesPath(), databaseName),
            onCreate: (db, version) {
      return db.execute('''CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY,
            position INTEGER,
            name TEXT,
            priority INTEGER
          )''');
    }, version: 1);

    todos = (await database.query(tableName))
        .map((e) => TodoData.fromMap(e))
        .toList();
    todos.sort((a, b) => a.position.compareTo(b.position));
  }

  Future<bool> add(TodoData todo) async {
    todo.position = todos.length;
    final id = await database.insert('todos', todo.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.fail);
    if (id != -1) {
      todo.id = id;
      todos.add(todo);
      return true;
    } else {
      return false;
    }
  }

  void move(int startIndex, int endIndex) async {
    todos.insert(endIndex, todos.removeAt(startIndex));
    await Future.wait([updateTodo(startIndex), updateTodo(endIndex)]);
  }

  Future<bool> delete(TodoData todo) async {
    final del =
        await database.delete('todos', where: 'id = ?', whereArgs: [todo.id]);
    todos.remove(todo);
    return del != 0;
  }
}
