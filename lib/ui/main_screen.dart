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

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    mainViewModel = Provider.of<MainViewModel>(context);
    if (_firstFlag) {
      mainViewModel.selectedDays.add(DateTime.now());
      _firstFlag = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        backgroundColor: Color.fromRGBO(248, 248, 248, 100),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color.fromRGBO(248, 248, 248, 100)),
        child: Column(
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
                  return Container(
                    height: screenHeight * 0.25,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
                          child: Text("Todo List", style: TextStyle(fontSize: 20)),
                        ),
                        SizedBox(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.25,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: value.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 4.0,
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                                    onTap: () async {
                                      print('${value[index]} ${value[index].id}');
                                      await mainViewModel.tapIsDone(value[index].id);
                                    },
                                    leading: SizedBox(
                                      width: 200,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                                            child: Checkbox(
                                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              value: value[index].isDone,
                                              onChanged: (bool? newValue) async {
                                                await mainViewModel.tapIsDone(value[index].id);
                                              },
                                              activeColor: const Color.fromRGBO(14, 176, 186, 1),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('${value[index]}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: value[index].isDone ? Colors.grey : Colors.black,
                                                ),
                                              ),
                                              Text('${value[index].date}',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: value[index].isDone ? Colors.grey : Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    trailing: value[index].isDone
                                        ? GestureDetector(

                                      onTap: () async {
                                        await mainViewModel.deleteTodo(value[index].id);
                                      },
                                      child: const Icon(Icons.delete_forever),
                                    )
                                        : null,
                                  )
                                );
                              }),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
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
