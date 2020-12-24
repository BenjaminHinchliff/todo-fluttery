import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import 'todo.dart';
import 'add_todo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'Todo App'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoData> _todos = [];
  Future<Database> database;

  void _addTodo(BuildContext context) async {
    final TodoData todo = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddTodoPage(database: database)));
    if (todo != null) {
      setState(() {
        _todos.add(todo);
      });
    }
  }

  Future<Database> _openDatabase() async {
    return openDatabase(
        path.join(await getDatabasesPath(), 'todos_database.db'),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE todos(id INTEGER PRIMARY KEY, name TEXT, priority INTEGER)");
    }, version: 1);
  }

  void _loadSavedTodos() async {
    final db = await database;
    final mapData = await db.query('todos');

    setState(() {
      final data = mapData.map((e) => TodoData.fromMap(e));
      _todos.addAll(data);
    });
  }

  @override
  void initState() {
    database = _openDatabase();
    _loadSavedTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: (() {
        if (_todos.isEmpty) {
          return Center(
              child: Text(
            'No Todos Currently',
            style: Theme.of(context).textTheme.bodyText1,
          ));
        } else {
          return ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                _todos.insert(newIndex, _todos.removeAt(oldIndex));
              });
            },
            children: _todos.map((todoData) {
              final todo = Todo(
                data: todoData,
                onUpdate: (newData) async {
                  final db = await database;
                  await db.update('todos', newData.toMap(),
                      where: 'id = ?', whereArgs: [newData.id]);
                },
              );
              return Dismissible(
                key: todo.key,
                background: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.filled(
                          2,
                          Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                          )),
                    )),
                child: todo,
                onDismissed: (direction) {
                  setState(() {
                    _todos.remove(todo);
                  });
                },
              );
            }).toList(),
          );
        }
      })(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodo(context);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
