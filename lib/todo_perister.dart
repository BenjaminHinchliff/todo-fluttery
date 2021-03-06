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

  Todo toTodo() {
    return Todo(id: id, name: name, priority: priority, done: done);
  }

  static TodoDataModel fromTodo(Todo todo, int position) {
    return TodoDataModel(
      id: todo.id,
      name: todo.name,
      priority: todo.priority,
      done: todo.done,
      position: position,
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
  List<Todo> todos;

  TodoPersister();

  Future<int> updateTodo(Todo value) {
    final index = todos.indexWhere((e) => e.id == value.id);
    todos[index] = value;
    final model = TodoDataModel.fromTodo(value, index);
    return database
        .update('todos', model.toMap(), where: 'id = ?', whereArgs: [model.id]);
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

  Future<bool> add(Todo todo) async {
    final todoModel = TodoDataModel.fromTodo(todo, todos.length);
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
    await Future.wait(
        [updateTodo(todos[startIndex]), updateTodo(todos[endIndex])]);
  }

  // FIXME: address deletion position inaccuracies?
  Future<bool> delete(Todo todo) async {
    final del =
        await database.delete('todos', where: 'id = ?', whereArgs: [todo.id]);
    todos.remove(todo);
    return del != 0;
  }
}
