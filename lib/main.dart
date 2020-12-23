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
            'No Todos Currently',
            style: Theme.of(context).textTheme.bodyText1,
          ));
        } else {
          return ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              _todos.insert(newIndex, _todos.removeAt(oldIndex));
            },
            children: [
              for (final todo in _todos)
                Dismissible(
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
                )
            ],
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
