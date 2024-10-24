import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

import '../../models/todo_model.dart';
import '../../repositories/todo_repository.dart';
part 'todo_form_event.dart';
part 'todo_form_state.dart';

class TodoFormBloc extends Bloc<TodoFormEvent, TodoFormState> {
  TodoFormBloc({required TodoRepository repository, TodoModel? initialTodo})
      : _repository = repository,
        super(TodoFormState(
          date: DateTime.now(),
          initialTodo: initialTodo,
          title: initialTodo?.title,
          details: initialTodo?.details,
          isCompleted: false,
        )) {
    on<TodoTitleChanged>(_onTitleChanged);
    on<TodoDetailsChanged>(_onDetailslChanged);
    on<TodoDateChanged>(_onDateChanged);
    on<TodoCompletedChanged>(_onCompletedChanged);
    on<TodoSubmitted>(_onSubmitted);
  }
  final TodoRepository _repository;
  void _onTitleChanged(TodoTitleChanged event, Emitter<TodoFormState> emit) {
    emit(state.copyWith(title: event.title));
  }

  void _onDetailslChanged(
      TodoDetailsChanged event, Emitter<TodoFormState> emit) {
    emit(state.copyWith(details: event.details));
  }

  void _onCompletedChanged(
      TodoCompletedChanged event, Emitter<TodoFormState> emit) {
    emit(state.copyWith(isCompleted: event.isCompleted));
  }

  void _onDateChanged(TodoDateChanged event, Emitter<TodoFormState> emit) {
    emit(state.copyWith(date: event.date));
  }

  Future<void> _onSubmitted(
      TodoSubmitted event, Emitter<TodoFormState> emit) async {
    final todo = (state.initialTodo)?.copyWith(
            title: state.title!,
            details: state.details,
            date: state.date,
            isCompleted: state.isCompleted) ??
        TodoModel(
          id: const Uuid().v4(),
          title: state.title!,
          details: state.details,
          date: state.date,
          isCompleted: state.isCompleted,
        );

    emit(state.copyWith(status: TodoFormStatus.loading));

    try {
      await _repository.createTodo(todo);
      emit(state.copyWith(status: TodoFormStatus.success));
      emit(TodoFormState(date: DateTime.now()));
    } catch (e) {
      print("Creation failed:$e");
      emit(state.copyWith(status: TodoFormStatus.failure));
    }
  }
}
