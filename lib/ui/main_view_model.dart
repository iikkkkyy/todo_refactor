import 'package:flutter/material.dart';
import 'package:todolist/data/repository/todo_repository.dart';

class MainViewModel extends ChangeNotifier {
  final ToDoRepository _repository;

  MainViewModel({
    required ToDoRepository repository,
  }) : _repository = repository;


}
