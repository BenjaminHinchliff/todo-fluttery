import 'package:flutter/material.dart';

import 'color_panel.dart';

enum TodoPriority {
  low,
  medium,
  high,
}

class TodoData {
  int id;
  final String name;
  TodoPriority priority;

  TodoData({this.id, @required this.name, @required this.priority})
      : assert(name != null),
        assert(priority != null);

  Map<String, dynamic> toMap() {
    var map = {
      'name': name,
      'priority': priority.index,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  String toString() {
    return "{id: $id, name: $name, priority: $priority}";
  }

  static TodoData fromMap(Map<String, dynamic> map) {
    return TodoData(
      id: map['id'],
      name: map['name'],
      priority: TodoPriority.values[map['priority']],
    );
  }
}

class Todo extends StatefulWidget {
  Todo({@required this.data})
      : assert(data != null),
        super(key: ValueKey(data.id));

  final TodoData data;

  @override
  State<StatefulWidget> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  TodoData data;

  @override
  void initState() {
    data = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      key: widget.key,
      title: Text(data.name),
      trailing: PopupMenuColorPanel(
        priority: data.priority,
        onSelected: (value) {
          setState(() {
            data.priority = value;
          });
        },
      ),
      leading: Icon(Icons.unfold_more),
    ));
  }
}
