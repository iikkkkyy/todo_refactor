import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todolist/ui/main_view_model.dart';
import 'package:provider/provider.dart';

import '../data/model/todo_model.dart';

//뭔가 hashcode쓰려고 import 하는데 이상하긴함..
import '../data/repository/todo_repository_impl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late MainViewModel mainViewModel;
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    mainViewModel = Provider.of<MainViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            focusedDay: mainViewModel.focusedDay,
            firstDay: DateTime.utc(2010, 10, 16),
            // 달력 전체의 시작 날짜
            lastDay: DateTime.utc(2030, 3, 14),
            // 달력 전체의 마지막 날짜
            calendarFormat: _calendarFormat,
            eventLoader: mainViewModel.getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: (day) =>
                mainViewModel.selectedDays.contains(day),

            //TODO select에 대한 event 표출
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
            child: Text('전체 초기화'),
            onPressed: () {
              mainViewModel.resetSelectedEvents();
            },
          ),
          const SizedBox(height: 8.0),
          //TODO Event 표출 ListView 작성
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: mainViewModel.selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context,index) {
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
                          onTap: () => print('${value[index]}'),
                          title: Text('asdfasdfasdf${value.length} ${index.bitLength}'),
                          // title: Text(mainViewModel.selectedEvents[index].toString()),
                        ),
                      );
                    }
                );
              },
            ),
          )

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          context.go('/add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
