import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todolist/data/model/todo_model.dart';
import 'package:todolist/data/repository/todo_repository.dart';

class MainViewModel extends ChangeNotifier {
  final ToDoRepository _repository;

  DateTime _focusedDay = DateTime.now().toUtc();
  DateTime? _selectedDay;
  List<Event>? _selectedEvents;
  //TODO 뭔가 이상함
  LinkedHashMap<DateTime, List<Event>> _events = LinkedHashMap<DateTime, List<Event>>(); // 초기화

  //Main State 적용 실패... => getter 사용
  get focusedDay => _focusedDay;
  get selectedDay => _selectedDay;
  get selectedEvents => _selectedEvents;
  get onDaySelected => _onDaySelected;
  get events => _events;
  get getEventsForDay => _getEventsForDay;

  final _debounce = Debounce(const Duration(milliseconds: 500));

  MainViewModel({
    required ToDoRepository repository,
  }) : _repository = repository {
    getTodoList();
  }

  _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      notifyListeners();
    }
    _selectedEvents = _events[_selectedDay]??[];
    notifyListeners();
  }

  List<Event> _getEventsForDay(DateTime day) {

    return _events[day] ?? [];
  }

  //TODO 뭔가 이상함
  Future<void> getTodoList() async {
    _events = await _repository.getTodoEvents();
    notifyListeners();
  }
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
