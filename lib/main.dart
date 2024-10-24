import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './repositories/local_notification_repository.dart';
import './repositories/todo_repository.dart';
import './app.dart';
import './data/local_data_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationRepository.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final storage =
      LocalDataStorage(preferences: await SharedPreferences.getInstance());
  final todoRepository = TodoRepository(storage: storage);
  runApp(App(todoRepository: todoRepository));
}
