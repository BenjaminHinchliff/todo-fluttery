import 'package:flutter/material.dart';
import 'package:todo/todo.dart';

import 'todo_perister.dart';

class DoneTodosPage extends StatelessWidget {
  final TodoPersister persister;

  DoneTodosPage({@required this.persister}) : assert(persister != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Completed Todos')),
      body: DoneTodosView(persister: persister),
    );
  }
}

class DoneTodosView extends StatelessWidget {
  final TodoPersister persister;

  DoneTodosView({@required this.persister}) : assert(persister != null);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: persister.todos
          .where((e) => e.done)
          .map((e) => TodoView(data: e))
          .toList(),
    );
  }
}
