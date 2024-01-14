import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

Future<CalendarFormat?> showFormatDialog(BuildContext context) async {
  CalendarFormat? selectedFormat;

  double screenWidth = MediaQuery.of(context).size.width;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
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
                  'Todo 설정',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                child: const Text('주단위 보기'),
                onPressed: () {
                  selectedFormat = CalendarFormat.week;
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('월단위 보기'),
                onPressed: () {
                  selectedFormat = CalendarFormat.month;
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // 닫기
                    },
                    child: const Text('닫기'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );

  return selectedFormat;
}
