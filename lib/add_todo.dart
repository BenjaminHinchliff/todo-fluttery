import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'todo.dart';
import 'color_panel.dart';

class AddTodoPage extends StatefulWidget {
  AddTodoPage({Key key}) : super(key: key);

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
                    Navigator.of(context).pop(
                        Todo(name: _nameController.text, priority: _priority));
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
