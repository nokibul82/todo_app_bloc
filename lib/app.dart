import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/todo_list/todo_list_bloc.dart';
import '../theme/theme.dart';
import './pages/home_page.dart';
import './repositories/todo_repository.dart';

class App extends StatelessWidget {
  const App({super.key, required this.todoRepository});

  final TodoRepository todoRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: todoRepository,
      child: BlocProvider(
        create: (context) => TodoListBloc(
          repository: todoRepository,
        )..add(const TodoListSubscriptionRequested()),
        child: MaterialApp(
          home: const HomePage(),
          theme: AppTheme.theme,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
