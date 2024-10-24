import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/todo_form/todo_form_bloc.dart';
import '../../repositories/todo_repository.dart';
import '../../models/todo_model.dart';

import '../widgets/add_todo_sheet_widget.dart';

extension AppX on BuildContext {
  Future<void> showAddTodoSheet({TodoModel? todo}){
    return showModalBottomSheet(
      context: this,
      showDragHandle: true,
      enableDrag: true,
      isScrollControlled: true,
      builder: (context) => BlocProvider(
        create: (context) => TodoFormBloc(
          initialTodo: todo,
          repository: read<TodoRepository>(),
        ),
        child: const AddTodoSheetWidget(),
      ),
    );
}
}