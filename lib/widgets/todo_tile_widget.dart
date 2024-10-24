import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/todo_list/todo_list_bloc.dart';

import '../extensions/extentions.dart';

import 'package:intl/intl.dart';

import '../models/todo_model.dart';

class TodoTileWidget extends StatelessWidget {
  const TodoTileWidget({super.key, required this.todo});
  final TodoModel todo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final formattedDate = DateFormat('dd/MM/yyyy').format(todo.date);

    // final currency = NumberFormat.currency(symbol: '\$', decimalDigits: 0);
    // final price = currency.format(todo.amount);
    if (todo.date.isBefore(DateTime.now())) {
      context.read<TodoListBloc>().add(TodoListTodoExpired(todo: todo));
    }
    return Dismissible(
      key: ValueKey(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(16),
        color: colorScheme.error,
        child: Icon(Icons.delete, color: colorScheme.onError),
      ),
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
              title: const Text("Confirm"),
              message: const Text("Are you sure you wish to delete this item?"),
              actions: <CupertinoActionSheetAction>[
                CupertinoActionSheetAction(
                    isDestructiveAction: true,
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text("DELETE")),
                CupertinoActionSheetAction(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("CANCEL"),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        context.read<TodoListBloc>().add(TodoListTodoDeleted(todo: todo));
      },
      child: ListTile(
        onTap: () => context.showAddTodoSheet(todo: todo),
        leading: Icon(Icons.car_repair, color: colorScheme.surfaceTint),
        title: Text(todo.title, style: textTheme.titleMedium),
        subtitle: Text(
          formattedDate,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onBackground.withOpacity(0.5),
          ),
        ),
        trailing: Checkbox(
          value: todo.isCompleted,
          onChanged: (value) {
            context
                .read<TodoListBloc>()
                .add(TodoListIsCompletedChanged(todo: todo));
          },
        ),
      ),
    );
  }
}
