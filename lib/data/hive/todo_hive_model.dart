import 'package:hive/hive.dart';

part 'todo_hive_model.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String date;

  @HiveField(3)
  bool isDone;

  Todo({
    required this.title,
    required this.date,
    required this.isDone,
  });
}