part of 'todo_form_bloc.dart';

sealed class TodoFormEvent extends Equatable {
  const TodoFormEvent();

  @override
  List<Object> get props => [];
}

final class TodoTitleChanged extends TodoFormEvent{
  const TodoTitleChanged(this.title);
  final String title;

  @override
  List<Object> get props => [title];
}

final class TodoCompletedChanged extends TodoFormEvent{
  const TodoCompletedChanged(this.isCompleted);
  final bool isCompleted;

  @override
  List<Object> get props => [isCompleted];
}

final class TodoDateChanged extends TodoFormEvent{
  const TodoDateChanged(this.date);
  final DateTime date;

  @override
  List<Object> get props => [date];
}

final class TodoDetailsChanged extends TodoFormEvent{
  const TodoDetailsChanged(this.details);
  final String details;

  @override
  List<Object> get props => [details];
}

final class TodoSubmitted extends TodoFormEvent {
  const TodoSubmitted();
}