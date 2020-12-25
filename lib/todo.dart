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

  String toString() {
    return "{id: $id, name: $name, priority: $priority}";
  }
}

class Todo extends StatefulWidget {
  Todo({@required this.data, this.onUpdate})
      : assert(data != null),
        super(key: ValueKey(data.id));

  final TodoData data;
  final Function(TodoData) onUpdate;

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

  _onUpdate() {
    if (widget.onUpdate != null) {
      widget.onUpdate(data);
    }
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
            _onUpdate();
          });
        },
      ),
      leading: Icon(Icons.unfold_more),
    ));
  }
}
