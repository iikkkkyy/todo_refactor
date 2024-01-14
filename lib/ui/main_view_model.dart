import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todolist/data/model/todo_model.dart';
import 'package:todolist/data/repository/todo_repository.dart';

import '../data/repository/todo_repository_impl.dart';

class MainViewModel extends ChangeNotifier {
  final ToDoRepository _repository;

  DateTime _focusedDay = DateTime.now();

  // DateTime? _selectedDay;
  final ValueNotifier<List<Event>> _selectedEvents = ValueNotifier([]);

  var _events = LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
  ); // 초기화

  //Main State 적용 실패... => getter 사용
  get focusedDay => _focusedDay;

  // get selectedDay => _selectedDay;

  get selectedEvents => _selectedEvents;

  get onDaySelected => _onDaySelected;

  get events => _events;

  get getEventsForDay => _getEventsForDay;

  final _debounce = Debounce(const Duration(milliseconds: 200));

  MainViewModel({
    required ToDoRepository repository,
  }) : _repository = repository {
    _selectedEvents.value = _getEventsForDays(selectedDays);
    getTodoList();
    notifyListeners();
  }

  Future<void> deleteTodo(int key) async {
    await _repository.deleteTodo(key);
    getTodoList();
    updateEvents();
  }

  Future<void> editTodo(int key, String newTitle, String dateTime) async {
    await _repository.editTodo(key, newTitle, dateTime);
    getTodoList();
    updateEvents();
  }

  Future<void> tapIsDone(int key) async {
    await _repository.tapIsDone(key);
    getTodoList();
    updateEvents();
  }

  void updateEvents() {
    _selectedEvents.value = _getEventsForDays(selectedDays);
    notifyListeners();
  }

  _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    print('???');
    _focusedDay = focusedDay;
    // Update values in a Set
    if (selectedDays.contains(selectedDay)) {
      selectedDays.remove(selectedDay);
    } else {
      selectedDays.add(selectedDay);
    }
    _selectedEvents.value = _getEventsForDays(selectedDays);
    notifyListeners();
  }

  final Set<DateTime> selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  final Set<DateTime> tempSelectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  List<Event> _getEventsForDays(Set<DateTime> days) {
    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  Future<void> getTodoList() async {
    _debounce.onEvent(() async {
      _events = await _repository.getTodoEvents();
      updateEvents();
    });
  }

  resetSelectedEvents() {
    selectedDays.clear();
    _selectedEvents.value = [];
    // _events.addAll(_kEventSource);
    notifyListeners();
  }
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

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
