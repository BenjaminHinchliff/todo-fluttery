import 'package:flutter/material.dart';

import 'color_panel.dart';

enum TodoPriority {
  low,
  medium,
  high,
}

class Todo extends StatefulWidget {
  Todo({Key key, @required this.name, @required this.priority})
      : assert(name != null),
        assert(priority != null),
        super(key: key);

  final String name;
  final TodoPriority priority;

  @override
  State<StatefulWidget> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  TodoPriority priority;

  @override
  void initState() {
    priority = widget.priority;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      title: Text(widget.name),
      trailing: PopupMenuColorPanel(
        priority: priority,
        onSelected: (value) {
          setState(() {
            priority = value;
          });
        },
      ),
    ));
  }
}
