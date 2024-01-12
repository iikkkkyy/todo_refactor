class Event {
  final int id;
  final String title;
  final String date;
  final bool isDone;


  @override
  String toString() => title;

  const Event({
    required this.id,
    required this.title,
    required this.date,
    required this.isDone,
  });
}
