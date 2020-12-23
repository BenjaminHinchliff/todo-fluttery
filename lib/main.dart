import 'package:flutter/material.dart';

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
  final nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
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
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (!states.contains(MaterialState.pressed))
                          return Theme.of(context).colorScheme.primaryVariant;
                        return null; // Use the component's default.
                      },
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      print(nameController.text);
                    }
                  },
                  child: Text("Add")))
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
                  controller: nameController,
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
          return Navigator.push(context, MaterialPageRoute(builder: (context) {
            return AddTodoPage();
          }));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
