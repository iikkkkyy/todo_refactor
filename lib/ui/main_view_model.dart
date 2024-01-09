import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todolist/data/repository/todo_repository.dart';

class MainViewModel extends ChangeNotifier {
  final ToDoRepository _repository;

  MainViewModel({
    required ToDoRepository repository,
  }) : _repository = repository;




}



class Debounce {
  final Duration duration;
  Timer? _timer;

  Debounce(this.duration);

  void onEvent(void Function() callback) {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    _timer = Timer(duration, () => callback());
  }
}