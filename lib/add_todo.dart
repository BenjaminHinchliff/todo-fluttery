import 'package:flutter/material.dart';

import 'todo.dart';

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
                    hintText: 'Add Name',
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
