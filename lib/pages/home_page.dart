import 'package:flutter/material.dart';

import '../extensions/extentions.dart';
import '../repositories/local_notification_repository.dart';
import '../widgets/todo_widget.dart';
import 'another_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    listenToNotifications();
    super.initState();
  }

  listenToNotifications() {
    print("listening to notification");
    LocalNotificationRepository.onClickNotification.stream.listen(
      (event) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return AnotherPage(payload: event);
          },
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TodoModel todo;
    return Scaffold(
      appBar: AppBar(
        title: const Text("TODO List"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TotalExpenseWidget(),
            // SizedBox(height: 14,),
            // ExpenseFilterWidget(),
            ElevatedButton(
                onPressed: () async {
                  await LocalNotificationRepository.showSimpleNotification(
                      title: "This is a simple notification",
                      body: "This is notification body",
                      payload: "this is notification payrolad");
                },
                child: const Text("Show simple notification")),
            const SizedBox(
              height: 14,
            ),
            ElevatedButton(
                onPressed: () async {
                  await LocalNotificationRepository.showPeriodicNotification(
                      title: "This is a Periodic notification",
                      body: "This is a periodic notification body",
                      payload: "this is notification payload");
                },
                child: const Text("Periodic notification")),
            const SizedBox(
              height: 14,
            ),
            ElevatedButton(
                onPressed: () async {
                  await LocalNotificationRepository.showScheduledNotification(
                      title: "This is a Scheduled notification",
                      body: "This is a Scheduled notification body",
                      payload: "this is Scheduled notification payload");
                },
                child: const Text("Scheduled notification")),
            const SizedBox(
              height: 14,
            ),
            TextButton(
                onPressed: () async {
                  await LocalNotificationRepository.cancel(2);
                },
                child: const Text("Close Periodic notification")),
            const SizedBox(
              height: 14,
            ),
            TodoWidget()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.showAddTodoSheet();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
