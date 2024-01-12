import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todolist/main.dart';
import 'package:todolist/ui/main_view_model.dart';
import 'package:provider/provider.dart';

import '../data/model/todo_model.dart';

import 'add_todo.dart';

//뭔가 hashcode쓰려고 import 하는데 이상하긴함..
import '../data/repository/todo_repository_impl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late MainViewModel mainViewModel;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _firstFlag = true;

  @override
  Widget build(BuildContext context) {
    mainViewModel = Provider.of<MainViewModel>(context);
    if (_firstFlag) {
      mainViewModel.selectedDays.add(DateTime.now());
      _firstFlag = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            focusedDay: mainViewModel.focusedDay,
            firstDay: DateTime(2010, 10, 16),
            // 달력 전체의 시작 날짜
            lastDay: DateTime(2030, 3, 14),
            // 달력 전체의 마지막 날짜
            calendarFormat: _calendarFormat,
            eventLoader: mainViewModel.getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: (day) =>
                mainViewModel.selectedDays.contains(day),
            onDaySelected: mainViewModel.onDaySelected,

            // Month / 2 weeks / week 전환 기능
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          ElevatedButton(
            child: const Text('전체 초기화'),
            onPressed: () {
              mainViewModel.resetSelectedEvents();
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: mainViewModel.selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          onTap: () async {
                            print('${value[index]} ${value[index].id}');
                            await mainViewModel.tapIsDone(value[index].id);
                          },
                          leading: value[index].isDone
                              ? const Icon(Icons.check_circle,
                                  color: Colors.green)
                              : const Icon(Icons.check_circle_outline),
                          title: Text(
                            '${value[index]}',
                            style: TextStyle(
                                color: value[index].isDone
                                    ? Colors.grey
                                    : Colors.black),
                          ),
                          subtitle: Text('${value[index].date}',
                              style: TextStyle(
                                  color: value[index].isDone
                                      ? Colors.grey
                                      : Colors.black)),
                          trailing: value[index].isDone ? GestureDetector(
                            onTap: () async {
                              await mainViewModel.deleteTodo(value[index].id);
                            },
                            child: const Icon(Icons.delete_forever),
                          )
                              : null,
                          // title: Text(mainViewModel.selectedEvents[index].toString()),
                        ),
                      );
                    });
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 클릭 시 addTodo 함수를 호출하여 화면 띄우기
          await addTodo(context);
          mainViewModel.getTodoList();
          mainViewModel.updateEvents();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
