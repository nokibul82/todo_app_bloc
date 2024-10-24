part of 'todo_list_bloc.dart';

enum TodoListStatus { initial, loading, success, failure }

final class TodoListState extends Equatable {
  const TodoListState({
    this.todos = const [],
    this.status = TodoListStatus.initial,
  });
  final List<TodoModel?> todos;
  final TodoListStatus status;

  TodoListState copyWith({
    TodoListStatus Function()? status,
    List<TodoModel?> Function()? todos,
  }) {
    return TodoListState(
      todos: todos != null ? todos() : this.todos,
      status: status != null ? status() : this.status,
    );
  }

  factory TodoListState.initial() => const TodoListState();

  @override
  List<Object?> get props => [todos, status];
}

final class TodoListInitial extends TodoListState {}
