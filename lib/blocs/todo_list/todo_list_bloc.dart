import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app_link3_nokibul/repositories/local_notification_repository.dart';
import '../../models/todo_model.dart';
import '../../repositories/todo_repository.dart';

part 'todo_list_event.dart';
part 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  TodoListBloc({required TodoRepository repository})
      : _repository = repository,
        super(TodoListInitial()) {
    on<TodoListSubscriptionRequested>(_onSubscriptionRequested);
    on<TodoListTodoDeleted>(_onTodoDeleted);
    on<TodoListIsCompletedChanged>(_onIsCompletedChanged);
    on<TodoListTodoExpired>(_onTodoExpired);
  }

  final TodoRepository _repository;

  Future<void> _onSubscriptionRequested(
      TodoListSubscriptionRequested event, Emitter<TodoListState> emit) async {
    emit(state.copyWith(status: () => TodoListStatus.loading));
    final stream = _repository.getAllTodos();
    await emit.forEach<List<TodoModel?>>(
      stream,
      onData: (todos) => state.copyWith(
        status: () => TodoListStatus.success,
        todos: () => todos,
      ),
      onError: (error, stackTrace) =>
          state.copyWith(status: () => TodoListStatus.failure),
    );
  }

  Future<void> _onTodoDeleted(
      TodoListTodoDeleted event, Emitter<TodoListState> emit) async {
    await _repository.deleteTodo(event.todo.id);
  }

  Future<void> _onIsCompletedChanged(
      TodoListIsCompletedChanged event, Emitter<TodoListState> emit) async {
    await _repository.toggleIsCompleted(event.todo.id);
  }

  Future<void> _onTodoExpired(
      TodoListTodoExpired event, Emitter<void> emit) async {
    await LocalNotificationRepository.init();
    await LocalNotificationRepository.showSimpleNotification(
        title: event.todo.title,
        body: "${event.todo.title} is expired",
        payload: "${event.todo.title} payload");
  }
}
