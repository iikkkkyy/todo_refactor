import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../data/model/todo_model.dart';

//뭔가 hashcode쓰려고 import 하는데 이상하긴함..
import '../data/repository/todo_repository_impl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;


  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      // Update values in a Set
      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
      } else {
        _selectedDays.add(selectedDay);
      }
    });

    //TODO _selectedEvents 처리
    // _selectedEvents.value = _getEventsForDays(_selectedDays);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2010, 10, 16), // 달력 전체의 시작 날짜
            lastDay: DateTime.utc(2030, 3, 14), // 달력 전체의 마지막 날짜
            calendarFormat: _calendarFormat,
            //eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,

            //TODO _selectedDay => _selectedDays
            selectedDayPredicate: (day) => isSameDay(_selectedDay,day),

            //TODO select에 대한 event 표출
            onDaySelected: _onDaySelected,

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
              setState(() {
                _selectedDays.clear();
                // TODO _selectedEvent 처리
                // _selectedEvents.value = [];
              });
            },
          ),
          const SizedBox(height: 8.0),
          //TODO Event 표출 ListView 작성
        ],
      ),
    );
  }
}
