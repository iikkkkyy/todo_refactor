import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todolist/di/di_setup.dart';
import 'package:todolist/routes.dart';
import 'package:hive_flutter/adapters.dart';
import 'data/hive/todo_hive_model.dart';
import 'package:intl/date_symbol_data_local.dart';


late Box<Todo> todos;

void main() async {
  diSetup();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  todos = await Hive.openBox<Todo>('todolist.db');

  // 언어 형식
  await initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0EB0BA)),
        scrollbarTheme: const ScrollbarThemeData().copyWith(
          thumbColor: MaterialStateProperty.all(Colors.black26)
        ),
        useMaterial3: true,
      ),
    );
  }
}

