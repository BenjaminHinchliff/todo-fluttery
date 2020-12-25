import 'package:flutter/material.dart';

import 'todo.dart';
import 'add_todo.dart';
import 'todo_perister.dart';
import 'done_todos.dart';
import 'slide_right_route.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'Todos'),
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
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddTodoPage(persister: _persister),
    ));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: Icon(Icons.list),
              onPressed: () => Navigator.of(context).push(SlideLeftRoute(
                  builder: (context) => DoneTodosPage(persister: _persister))))
        ],
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
            children: _persister.todos.where((e) => !e.done).map((todoData) {
              final todo = TodoView(
                data: todoData,
                onUpdate: _persister.updateTodo,
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
                  if (direction == DismissDirection.startToEnd) {
                    todo.data.done = true;
                    await _persister.updateTodo(todo.data);
                  } else {
                    await _persister.delete(todo.data);
                  }
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
