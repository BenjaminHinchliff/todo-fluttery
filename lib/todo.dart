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
    return Center(
        child: Container(
      child: Card(
          child: Container(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
                child: Text(
              widget.name,
              style: const TextStyle(fontSize: 20),
            )),
            PopupMenuColorPanel(priority: widget.priority),
          ],
        ),
      )),
    ));
  }
}
