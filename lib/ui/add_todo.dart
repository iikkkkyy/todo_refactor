import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/data/hive/todo_hive_model.dart';
import 'package:todolist/ui/main_screen.dart';

import '../main.dart';

Future addTodo(BuildContext context, ) async {
  DateTime date = DateTime.now();
  String format = DateFormat('yyyy-MM-dd').format(date);

  final _textController = TextEditingController();

  // 화면의 가로 너비
  double screenWidth = MediaQuery.of(context).size.width;

  // 화면의 세로 높이
  double screenHeight = MediaQuery.of(context).size.height;

  await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          width: screenWidth * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(2, 7),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              ),
            ],
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Title(
                color: Colors.black,
                child: const Text(
                  'Todo 작성',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _textController,
                maxLines: null,
                maxLength: 50,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: '할일을 입력하세요',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 15.0),
              Container(
                height: 70.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            var selectedDay = await showDatePicker(
                              context: context,
                              initialDate: date,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(date.year + 10),
                            );

                            // if 'CANCEL' => null
                            if (selectedDay == null) return;

                            // if 'OK' => DateTime
                            setState(() {
                              date = selectedDay;
                              format =
                                  DateFormat('yyyy-MM-dd').format(selectedDay);
                            });
                          },
                          icon: const Icon(Icons.calendar_month_outlined),
                        ),
                        Text("${format}")
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () async {
                      Navigator.of(context).pop(); // 닫기
                    },
                    icon: const Icon(Icons.cancel_outlined),
                  ),
                  IconButton(
                    onPressed: () async {
                      // "일정을 추가할까요?" 라는 메세지와 버튼이 있는 AlertDialog
                      var result = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('일정을 추가할까요?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                child: Text("네"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: Text("아니요"),
                              ),
                            ],
                          );
                        },
                      );

                      if (result == true) {
                        await todos.add(Todo(
                          title: _textController.text,
                          date: DateFormat('yyyy-MM-dd').format(date),
                          isDone: false,
                        ));
                        Navigator.of(context).pop(); // 닫기
                      }
                    },
                    icon: const Icon(Icons.done),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
