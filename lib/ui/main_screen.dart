import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todolist/ui/main_view_model.dart';
import 'package:provider/provider.dart';

import '../data/model/todo_model.dart';

import 'add_todo.dart';

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
            locale: 'ko-KR',
            rowHeight: 55,

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

            //헤더 스타일 설정
            headerStyle: HeaderStyle(
              titleCentered: true,
              titleTextFormatter: (date, locale) =>
                  DateFormat.yMMM(locale).format(date),
              formatButtonVisible: false,
              titleTextStyle: const TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
              headerPadding: const EdgeInsets.symmetric(vertical: 4.0),
              leftChevronIcon: Container(
                padding: const EdgeInsets.all(5.0), // 테두리의 간격을 조절
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade200, // 테두리 색상
                    width: 1.0, // 테두리 두께
                  ),
                  borderRadius: BorderRadius.circular(13.0), // 테두리의 모서리 감마를 조절
                ),
                child: const Icon(
                  Icons.chevron_left_sharp,
                  color: Colors.black,
                  size: 30.0,
                ),
              ),
              rightChevronIcon: Container(
                padding: const EdgeInsets.all(5.0), // 테두리의 간격을 조절
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade200, // 테두리 색상
                    width: 1.0, // 테두리 두께
                  ),
                  borderRadius: BorderRadius.circular(13.0), // 테두리의 모서리 감마를 조절
                ),
                child: const Icon(
                  Icons.chevron_right_sharp,
                  color: Colors.black,
                  size: 30.0,
                ),
              ),
            ),

            calendarStyle: CalendarStyle(
              // 원 사이즈 변경
              cellMargin: const EdgeInsets.all(12),

              // defaultTextStyle: const TextStyle(fontWeight: FontWeight.bold),
              // weekendTextStyle: const TextStyle(fontWeight: FontWeight.bold),
              todayTextStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              selectedTextStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),

              //marker 스타일
              markersMaxCount: 3,
              markerSize: 5,
              markerMargin:
                  const EdgeInsets.symmetric(horizontal: 1, vertical: 7),
              markerDecoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF0EB0BA),
                    width: 1.3,
                  )),

              todayDecoration: const BoxDecoration(
                color: Color(0x800EB0BA),
                shape: BoxShape.circle,
                // borderRadius: BorderRadius.all(Radius.circular(16)),
              ),

              //선택된 버튼에 대한 스타일
              selectedDecoration: const BoxDecoration(
                color: Color(0xFF0EB0BA),
                shape: BoxShape.circle,
                // borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  mainViewModel.resetSelectedEvents();
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.restart_alt_rounded,
                      color: Colors.black87,
                      size: 20,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '선택초기화',
                      style: TextStyle(
                        color: Colors.black87,
                        decoration: TextDecoration.underline,
                        fontSize: 12,
                        decorationStyle: TextDecorationStyle.solid,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ],
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
                          trailing: value[index].isDone
                              ? GestureDetector(
                                  onTap: () async {
                                    await mainViewModel
                                        .deleteTodo(value[index].id);
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
