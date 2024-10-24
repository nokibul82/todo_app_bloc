import '../../models/todo_model.dart';

import '../../data/local_data_storage.dart';

class TodoRepository {
  TodoRepository({
    required LocalDataStorage storage,
  }) : _storage = storage;
  final LocalDataStorage _storage;

  Future<void> createTodo(TodoModel expense) =>
      _storage.saveTodo(expense);

  Future<void> deleteTodo(String id) => _storage.deleteTodo(id);

  Future<void> toggleIsCompleted(String id) => _storage.toggleIsCompleted(id);

  Stream<List<TodoModel?>> getAllTodos() => _storage.getTodo();
}
