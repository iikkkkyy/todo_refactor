import 'package:get_it/get_it.dart';
import 'package:todolist/data/repository/todo_repository.dart';
import 'package:todolist/data/repository/todo_repository_impl.dart';
import 'package:todolist/ui/main_view_model.dart';

final getIt = GetIt.instance;

void diSetup() {
  getIt.registerSingleton<ToDoRepository>(ToDoRepositoryImpl());
  getIt.registerFactory(() => MainViewModel(repository: getIt()));
}