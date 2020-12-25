import 'package:flutter/material.dart';
import 'package:todo/todos.dart';

import 'todo.dart';
import 'add_todo_page.dart';
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
          return TodosView(
              persister: _persister,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  _persister.move(oldIndex, newIndex);
                });
              },
              onDismissed: (todo, direction) async {
                if (direction == DismissDirection.startToEnd) {
                  todo.done = true;
                  await _persister.updateTodo(todo);
                } else {
                  await _persister.delete(todo);
                }
                setState(() {});
              });
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
