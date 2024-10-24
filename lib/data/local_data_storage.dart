import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_link3_nokibul/models/todo_model.dart';

class LocalDataStorage {
  final SharedPreferences _preferences;

  LocalDataStorage({required SharedPreferences preferences})
      : _preferences = preferences {
    _initialize();
  }
  final _controller = BehaviorSubject<List<TodoModel?>>.seeded(const []);
  static const expenseCollectionKey = "expense_collection_key";
  void _initialize() {
    final expensesJson = _preferences.getString(expenseCollectionKey);
    if (expensesJson != null) {
      final expenseList = List<dynamic>.from(jsonDecode(expensesJson) as List);
      final expenses = expenseList.map((e) => TodoModel.fromJson(e)).toList();
      _controller.add(expenses);
    } else {
      _controller.add(const []);
    }
  }

  Future<void> saveTodo(TodoModel todo) async {
    final expenses = [..._controller.value];
    final expenseIndex =
        expenses.indexWhere((currentExpense) => currentExpense?.id == todo.id);
    if (expenseIndex >= 0) {
      expenses[expenseIndex] = todo;
    } else {
      expenses.add(todo);
    }
    _controller.add(expenses);
    await _preferences.setString(expenseCollectionKey, jsonEncode(expenses));
  }

  Future<void> deleteTodo(String id) async {
    final expenses = [..._controller.value];
    final expenseIndex =
        expenses.indexWhere((currentExpense) => currentExpense?.id == id);
    print("expenseIndex: $expenseIndex");
    if (expenseIndex == -1) {
      throw Exception("No expense found");
    } else {
      expenses.removeAt(expenseIndex);
      _controller.add(expenses);
      _preferences.setString(expenseCollectionKey, jsonEncode(expenses));
    }
  }

  Future<void> toggleIsCompleted(String id) async {
    final todos = [..._controller.value];
    final todoIndex = todos.indexWhere((currentTodo) => currentTodo?.id == id);
    print("todoIndex: $todoIndex");
    if (todoIndex == -1) {
      throw Exception("No expense found");
    } else {
      var currentTodo = todos[todoIndex];
      todos[todoIndex] = TodoModel(
          id: currentTodo!.id,
          title: currentTodo.title,
          details: currentTodo.details,
          date: currentTodo.date,
          isCompleted: currentTodo.isCompleted ? false : true);
      _controller.add(todos);
      _preferences.setString(expenseCollectionKey, jsonEncode(todos));
    }
  }

  Stream<List<TodoModel?>> getTodo() => _controller.asBroadcastStream();
}
