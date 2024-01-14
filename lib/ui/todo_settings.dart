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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 54,),
                  Expanded(
                    child: Title(
                      color: Colors.black,
                      child: const Text(
                        'Todo 설정',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // 닫기
                    },
                    icon: const Icon(Icons.close), // 아이콘을 적절히 변경하세요
                  ),
                ],
              ),
              TextButton(
                child: Text('주 단위 보기', style: TextStyle(color: Colors.grey.shade800)),
                onPressed: () {
                  selectedFormat = CalendarFormat.week;
                  Navigator.pop(context);
                },
              ),
              Container(
                width: 301,
                height: 1,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(color: Color(0xFFF3F3F3)),
              ),
              TextButton(
                child: Text('월 단위 보기', style: TextStyle(color: Colors.grey.shade800)),
                onPressed: () {
                  selectedFormat = CalendarFormat.month;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );

  return selectedFormat;
}