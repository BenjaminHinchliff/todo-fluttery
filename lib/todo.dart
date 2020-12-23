import 'package:flutter/material.dart';

import 'color_panel.dart';

enum TodoPriority {
  low,
  medium,
  high,
}

class Todo extends StatelessWidget {
  Todo({Key key, @required this.name, @required this.priority})
      : assert(name != null),
        assert(priority != null),
        super(key: key);

  final String name;
  final TodoPriority priority;

  final Map<TodoPriority, Color> priorityColors = const {
    TodoPriority.low: Colors.blue,
    TodoPriority.medium: Colors.yellow,
    TodoPriority.high: Colors.red,
  };

  final Map<TodoPriority, String> priorityStrings = const {
    TodoPriority.low: "Low",
    TodoPriority.medium: "Medium",
    TodoPriority.high: "High"
  };

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
              name,
              style: const TextStyle(fontSize: 20),
            )),
            PopupMenuButton(
              itemBuilder: (BuildContext context) => TodoPriority.values
                  .map((e) => PopupMenuItem(
                      value: e,
                      child: Row(
                        children: [
                          Expanded(child: Text(priorityStrings[e])),
                          ColorPanel(color: priorityColors[e])
                        ],
                      )))
                  .toList(),
              child: ColorPanel(color: priorityColors[priority]),
            ),
          ],
        ),
      )),
    ));
  }
}
