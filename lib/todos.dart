import 'package:flutter/material.dart';
import 'package:todo/todo_perister.dart';

import 'todo.dart';

class TodosView extends StatelessWidget {
  final TodoPersister persister;
  final void Function(int, int) onReorder;
  final void Function(Todo todo, DismissDirection) onDismissed;

  TodosView(
      {@required this.persister,
      @required this.onReorder,
      @required this.onDismissed})
      : assert(persister != null),
        assert(onReorder != null),
        assert(onDismissed != null);

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      onReorder: onReorder,
      children: persister.todos.where((e) => !e.done).map((todoData) {
        final todo = TodoView(
          data: todoData,
          onUpdate: persister.updateTodo,
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
          onDismissed: (direction) => onDismissed(todo.data, direction),
        );
      }).toList(),
    );
  }
}
