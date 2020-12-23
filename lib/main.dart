import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'todo.dart';

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

class AddTodoPage extends StatefulWidget {
  AddTodoPage({Key key}) : super(key: key);

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Todo'),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 10, top: 10, bottom: 10),
              child: IconButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Navigator.of(context).pop(Todo(
                        name: _nameController.text,
                        priority: TodoPriority.low));
                  }
                },
                icon: Icon(Icons.done),
              ))
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Add Name",
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  controller: _nameController,
                ),
              ],
            )),
      ),
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
