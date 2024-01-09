import 'dart:collection';

import 'package:todolist/data/model/todo_model.dart';
import 'package:todolist/data/repository/todo_repository.dart';

class ToDoRepositoryImpl implements ToDoRepository{

  @override
  Future<LinkedHashMap<DateTime, List<Event>>> getTodoEvents() {
    // TODO: implement getTodoEvents
    throw UnimplementedError();
  }

}