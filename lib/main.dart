import 'package:flutter/material.dart';

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
  List<Todo> _todos = [];

  void _addTodo(BuildContext context) async {
    final Todo todo = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddTodoPage()));
    if (todo != null) {
      setState(() {
        _todos.add(todo);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [IconButton(icon: const Icon(Icons.list), onPressed: null)],
      ),
      body: (() {
        if (_todos.isEmpty) {
          return Center(
              child: Text(
            "No Todos Currently",
            style: Theme.of(context).textTheme.bodyText1,
          ));
        } else {
          return ListView(
            children: _todos,
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
