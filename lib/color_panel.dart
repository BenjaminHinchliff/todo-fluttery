import 'package:flutter/material.dart';

import 'todo.dart';

class ColorPanel extends StatelessWidget {
  ColorPanel({Key key, this.color}) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: color,
          ),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      height: 25,
      width: 25,
    );
  }
}

class PopupMenuColorPanel extends StatelessWidget {
  PopupMenuColorPanel({Key key, this.priority, this.onSelected})
      : super(key: key);

  final TodoPriority priority;
  final Function(TodoPriority) onSelected;

  final Map<TodoPriority, Color> priorityColors = const {
    TodoPriority.low: Colors.blue,
    TodoPriority.medium: Colors.yellow,
    TodoPriority.high: Colors.red,
  };

  final Map<TodoPriority, String> priorityStrings = const {
    TodoPriority.low: 'Low',
    TodoPriority.medium: 'Medium',
    TodoPriority.high: 'High'
  };

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
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
      onSelected: onSelected,
      child: ColorPanel(color: priorityColors[priority]),
    );
  }
}
