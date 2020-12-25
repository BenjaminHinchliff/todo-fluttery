import 'package:flutter/cupertino.dart';

import 'todo.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class TodoDataModel {
  TodoDataModel(
      {this.id,
      @required this.position,
      @required this.name,
      @required this.priority,
      @required this.done})
      : assert(position != null),
        assert(name != null),
        assert(priority != null),
        assert(done != null);

  int id;
  int position;
  String name;
  TodoPriority priority;
  bool done;

  TodoData toTodo() {
    return TodoData(
      id: id,
      name: name,
      priority: priority,
    );
  }

  static TodoDataModel fromTodo(TodoData todo, int position, bool done) {
    return TodoDataModel(
      id: todo.id,
      name: todo.name,
      priority: todo.priority,
      position: position,
      done: done,
    );
  }

  Map<String, dynamic> toMap() {
    var map = {
      'id': id,
      'position': position,
      'name': name,
      'priority': priority.index,
      'done': done ? 1 : 0,
    };
    return map;
  }

  static TodoDataModel fromMap(Map<String, dynamic> map) {
    return TodoDataModel(
      id: map['id'],
      position: map['position'],
      name: map['name'],
      priority: TodoPriority.values[map['priority']],
      done: map['done'] == 1,
    );
  }
}

// an assister class to manage order and persistent data of the app
class TodoPersister {
  static const tableName = 'todos';
  static const databaseName = 'todos_database.db';

  sql.Database database;
  List<TodoData> todos;

  TodoPersister();

  Future<int> updateTodo(int index) {
    var data = todos[index];
    final model = TodoDataModel.fromTodo(data, index, false);
    return database
        .update('todos', model.toMap(), where: 'id = ?', whereArgs: [data.id]);
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
            position INTEGER NOT NULL,
            name TEXT NOT NULL,
            priority INTEGER NOT NULL,
            done BOOLEAN NOT NULL CHECK (done IN (0,1))
          )''');
    }, version: 1);

    final todoRaw = await database.query(tableName);
    final todoModels = todoRaw.map((e) => TodoDataModel.fromMap(e)).toList();
    todoModels.sort((a, b) => a.position.compareTo(b.position));
    todos = todoModels.map((e) => e.toTodo()).toList();
  }

  Future<bool> add(TodoData todo) async {
    final todoModel = TodoDataModel.fromTodo(todo, todos.length, false);
    final id = await database.insert('todos', todoModel.toMap(),
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
