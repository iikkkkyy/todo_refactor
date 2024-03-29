import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todolist/ui/edit_todo.dart';
import 'package:todolist/main.dart';
import 'package:todolist/ui/main_view_model.dart';
import 'package:provider/provider.dart';
import 'package:todolist/ui/todo_settings.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 이미지 preload
    precacheImage(const AssetImage("assets/icons/Todo_Icon_success.png"), context);
    precacheImage(const AssetImage("assets/icons/Todo_Icon_fail.png"), context);
  }

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                    mainViewModel.getRemainedTodoImage(),
                    height: 40
                ),
                const SizedBox(
                  width: 7,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/icons/Todo_Icon2.svg'),
                    Text(
                      mainViewModel.getRemainedTodo(),
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              onPressed: () async {
                CalendarFormat? format = await showFormatDialog(context);
                setState(() {
                  if (format != null) {
                    _calendarFormat = format;
                  }
                });
              },
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(248, 248, 248, 100),
        // foregroundColor: const Color.fromRGBO(248, 248, 248, 100),
      ),
      body: Container(
        decoration:
            const BoxDecoration(color: Color.fromRGBO(248, 248, 248, 100)),
        child: Column(
          children: [
            TableCalendar<Event>(
              availableCalendarFormats: const {
                CalendarFormat.month: '월',
                CalendarFormat.week: '주',
              },
              locale: 'ko-KR',
              rowHeight: 55,
              daysOfWeekHeight: 20,

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
                formatButtonTextStyle:
                    const TextStyle(color: Colors.black, fontSize: 10),
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
                      color: Colors.grey.shade300, // 테두리 색상
                      width: 1.0, // 테두리 두께
                    ),
                    borderRadius:
                        BorderRadius.circular(13.0), // 테두리의 모서리 감마를 조절
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
                      color: Colors.grey.shade300, // 테두리 색상
                      width: 1.0, // 테두리 두께
                    ),
                    borderRadius:
                        BorderRadius.circular(13.0), // 테두리의 모서리 감마를 조절
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
                  return Container(
                    width: screenWidth * 0.9,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Todo List",
                                  style: TextStyle(fontSize: 20)),
                              IconButton(
                                onPressed: () async {
                                  // "일정을 삭제할까요?" 라는 메세지와 버튼이 있는 AlertDialog
                                  final nowTodoValues = todos.values
                                      .map((e) =>
                                          e.isDone == true ? e.key : null)
                                      .where((key) => key != null) // null 값 제거
                                      .toList();
                                  final matchingIds = nowTodoValues.where(
                                      (key) =>
                                          value.map((e) => e.id).contains(key));
                                  final matchingIdsIntList = matchingIds
                                      .map((key) => key as int)
                                      .toList();
                                  if (nowTodoValues.isNotEmpty &&
                                      value.map((e) => e.id).toList().any(
                                          (id) => nowTodoValues.contains(id))) {
                                    var result = await showDialog<bool>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                            '선택한 일정을 삭제할까요?',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                              },
                                              child: const Text("네"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                              child: const Text("아니요"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (result == true) {
                                      mainViewModel
                                          .deleteTodos(matchingIdsIntList);
                                    }
                                  }
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                        if (value.isEmpty)
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 19),
                                child: Text(
                                  "일정을 추가해보세요!",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 19),
                                child: Text(
                                  "날짜를 선택 시 추가된 일정을 확인할 수 있어요.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 35),
                            child: Scrollbar(
                              thickness: 3.0, // 스크롤 너비
                              radius: const Radius.circular(8.0), // 스크롤 라운딩
                              thumbVisibility: true, // 항상 보이기 여부
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
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 0),
                                            onTap: () async {
                                              print(
                                                  '${value[index]} ${value[index].id}');
                                              await mainViewModel
                                                  .tapIsDone(value[index].id);
                                            },
                                            leading: SizedBox(
                                              width: 300,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 0, 30),
                                                    child: Checkbox(
                                                      materialTapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      value:
                                                          value[index].isDone,
                                                      onChanged: (bool?
                                                          newValue) async {
                                                        await mainViewModel
                                                            .tapIsDone(
                                                                value[index]
                                                                    .id);
                                                      },
                                                      activeColor:
                                                          const Color.fromRGBO(
                                                              14, 176, 186, 1),
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${value[index]}',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: value[index]
                                                                    .isDone
                                                                ? Colors.grey
                                                                : Colors.black,
                                                            decoration: value[
                                                                        index]
                                                                    .isDone
                                                                ? TextDecoration
                                                                    .lineThrough
                                                                : TextDecoration
                                                                    .none,
                                                            decorationColor:
                                                                Colors.grey),
                                                      ),
                                                      Text(
                                                        '${value[index].date} (${mainViewModel.getDayOfWeek(value[index].date)})',
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color: value[index]
                                                                  .isDone
                                                              ? Colors.grey
                                                              : Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            trailing: value[index].isDone
                                                ? null
                                                : Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 10, 15),
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        await editTodoPage(
                                                            context,
                                                            value[index].id,
                                                            value[index].title,
                                                            value[index].date);
                                                        mainViewModel
                                                            .getTodoList();
                                                        mainViewModel
                                                            .updateEvents();
                                                      },
                                                      child: const Icon(
                                                          Icons.edit),
                                                    ),
                                                  )));
                                  }),
                            ),
                          ),
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
        shape: const CircleBorder(),
        backgroundColor: const Color.fromRGBO(14, 176, 186, 1),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
