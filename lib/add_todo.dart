import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'todo.dart';
import 'color_panel.dart';

class AddTodoPage extends StatefulWidget {
  AddTodoPage({Key key, @required this.database})
      : assert(database != null),
        super(key: key);

  final Future<Database> database;

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  TodoPriority _priority = TodoPriority.low;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<int> _insertTodo(TodoData todo) async {
    final db = await widget.database;
    return db.insert('todos', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Todo'),
        actions: [
          IconButton(
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                var data =
                    TodoData(name: _nameController.text, priority: _priority);
                data.id = await _insertTodo(data);
                Navigator.of(context).pop(Todo(data: data));
              }
            },
            icon: Icon(Icons.done),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Add Name',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                        controller: _nameController,
                      )),
                ),
                PopupMenuColorPanel(
                  priority: _priority,
                  onSelected: (value) {
                    setState(() {
                      _priority = value;
                    });
                  },
                )
              ],
            )),
      ),
    );
  }
}
