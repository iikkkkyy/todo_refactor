import 'dart:collection';

import '../model/todo_model.dart';

abstract interface class ToDoRepository {
  Future<LinkedHashMap<DateTime, List<Event>>> getTodoEvents();
  // Future<Event> updateTodoEvents();
  Future<void> deleteTodo(int key) async{}
  Future<void> tapIsDone(int key) async{}
}