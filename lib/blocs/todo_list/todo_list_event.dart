part of 'todo_list_bloc.dart';

sealed class TodoListEvent extends Equatable {
  const TodoListEvent();
  @override
  List<Object> get props => [];
}

final class TodoListSubscriptionRequested extends TodoListEvent {
  const TodoListSubscriptionRequested();
}

final class TodoListTodoDeleted extends TodoListEvent {
  const TodoListTodoDeleted({required this.todo});
  final TodoModel todo;

  @override
  List<Object> get props => [todo];
}

final class TodoListIsCompletedChanged extends TodoListEvent {
  const TodoListIsCompletedChanged({required this.todo});
  final TodoModel todo;

  @override
  List<Object> get props => [todo];
}

final class TodoListTodoExpired extends TodoListEvent{
  const TodoListTodoExpired({required this.todo});
  final TodoModel todo;
}


