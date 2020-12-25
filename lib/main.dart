import 'package:flutter/material.dart';

import 'todo.dart';
import 'add_todo.dart';
import 'todo_perister.dart';

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
  TodoPersister _persister = TodoPersister();

  @override
  void initState() {
    asyncInit();
    super.initState();
  }

  void asyncInit() async {
    await _persister.openAndLoadDatabase();
    setState(() {});
  }

  void _addTodo(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddTodoPage(persister: _persister)));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: (() {
        if (_persister.todos?.isEmpty ?? true) {
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
                _persister.move(oldIndex, newIndex);
              });
            },
            children: _persister.todos.map((todoData) {
              final todo = Todo(
                data: todoData,
                onUpdate: _persister.updateTodoByValue,
              );
              return Dismissible(
                key: todo.key,
                child: todo,
                background: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.green,
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.done, color: Colors.white),
                ),
                secondaryBackground: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.delete_forever, color: Colors.white),
                ),
                onDismissed: (direction) async {
                  await _persister.delete(todo.data);

                  setState(() {});
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
