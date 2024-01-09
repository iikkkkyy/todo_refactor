import 'dart:collection';

import 'package:hive/hive.dart';
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
  Future<LinkedHashMap<DateTime, List<Event>>> getTodoEvents() async {
    // DB에서 투두 데이터 뽑기
    final kTodos = todos.values.toList();
    final kEvents = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    );

    for (final todo in kTodos) {
      // String형식의 date를 DateTime으로 변환
      final dateTime = DateTime.parse(todo.date);

      // 같은 날짜의 Event 목록 가져오기
      List<Event> eventsForDay = kEvents[dateTime] ?? [];

      // Event 생성 및 목록에 추가
      final event = Event(
        title: todo.title,
      );
      eventsForDay.add(event);

      kEvents[dateTime] = eventsForDay;
    }
    return kEvents;
  }
}
