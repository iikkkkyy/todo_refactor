import 'dart:collection';

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:todolist/data/hive/todo_hive_model.dart';
import 'package:todolist/data/model/todo_model.dart';
import 'package:todolist/data/repository/todo_repository.dart';
import 'package:todolist/main.dart';

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

//hashCode 정의
class ToDoRepositoryImpl implements ToDoRepository {
  //isSameDay 정의
  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return false;
    }
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Future<void> deleteTodo(int key) async {
    await todos.delete(key);
  }

  @override
  Future<void> tapIsDone(int key) async {
    Todo todo = todos.values.firstWhere((element) => element.key == key);
    todo.isDone = !todo.isDone;
    await todo.save();
  }

  @override
  Future<void> editTodo(int key, String newTitle, String dateTime) async {
    // TODO: implement editTodo
    Todo todo = todos.values.firstWhere((element) => element.key == key);
    todo.title = newTitle;
    todo.date = dateTime;
    await todo.save();
  }

  @override
  Future<LinkedHashMap<DateTime, List<Event>>> getTodoEvents() async {
    // DB에서 투두 데이터 뽑기
    final kTodos = todos.values.toList();
    final kEvents = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    );

    for (final todo in kTodos) {
      // String형식의 date를 DateTime으로 변환
      // .utc로 인해 add 투두 오류 수정
      final dateTime = DateFormat('yyyy-MM-dd').parse(todo.date);

      // 같은 날짜의 Event 목록 가져오기
      List<Event> eventsForDay = kEvents[dateTime] ?? [];

      // Event 생성 및 목록에 추가
      final event = Event(
        title: todo.title,
        date: todo.date,
        isDone: todo.isDone,
        id: todo.key,
      );
      eventsForDay.add(event);

      kEvents[dateTime] = eventsForDay;
    }
    return kEvents;
  }


}
