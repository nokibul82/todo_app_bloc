part of 'todo_form_bloc.dart';

enum TodoFormStatus { initial, loading, success, failure }

final class TodoFormState extends Equatable {
  const TodoFormState(
      {this.title,
      this.details,
      required this.date,
      this.isCompleted = false,
      this.status = TodoFormStatus.initial,
      this.initialTodo});
  final String? title;
  final String? details;
  final DateTime date;
  final bool isCompleted;
  final TodoFormStatus? status;
  final TodoModel? initialTodo;

  TodoFormState copyWith(
      {String? title,
      String? details,
      DateTime? date,
      bool? isCompleted,
      TodoFormStatus? status,
      TodoModel? initialExpense}) {
    return TodoFormState(
        title: title ?? this.title,
        details: details ?? this.details,
        date: date ?? this.date,
        isCompleted: isCompleted ?? this.isCompleted,
        status: status ?? this.status,
        initialTodo: initialTodo ?? this.initialTodo);
  }

  @override
  List<Object?> get props =>
      [title, details, date, isCompleted, status, initialTodo];

  bool get isFormValid => (title != null && title != "");
}
