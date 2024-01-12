import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:todolist/main.dart';

import '../data/hive/todo_hive_model.dart';

var date = DateTime.now();
String format = DateFormat('yyyy-MM-dd').format(date);

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo 작성'),
        actions: [
          IconButton(
            onPressed: () async {
              await todos.add(Todo(
                title: _textController.text,
                date: DateFormat('yyyy-MM-dd').format(date),
                isDone: false,
              ));

              if (mounted) {
                context.go('/');
              }
            },
            icon: const Icon(Icons.done),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: '할일을 입력하세요',
                  filled: true,
                  fillColor: Colors.white70),
            ),
            Container(
              height: 70.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      var selectedDay = await showDatePicker(
                          context: context,
                          initialDate: date,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(date.year + 10));

                      // if 'CANCEL' => null
                      if (selectedDay == null) return;
                      // if 'OK' => DateTime
                      setState(() {
                        date = selectedDay;
                        format = DateFormat('yyyy-MM-dd').format(selectedDay);
                      });
                    },
                    icon: Icon(Icons.calendar_month_outlined),
                  ),
                  Text("$format")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
