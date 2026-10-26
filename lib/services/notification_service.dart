import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/task.dart';

class NotificationService {
  static final plugin = FlutterLocalNotificationsPlugin();
  static Future<void> init() async { tz.initializeTimeZones(); const android = AndroidInitializationSettings('@drawable/ic_stat_notify'); await plugin.initialize(const InitializationSettings(android: android)); }
  static Future<void> schedule(Task task) async {
    if (task.startTime == null || task.text.trim().isEmpty) return;
    final p = task.startTime!.split(':'); final date = DateTime.tryParse(task.dateKey); if (date == null || p.length != 2) return;
    final when = tz.TZDateTime(tz.local, date.year, date.month, date.day, int.tryParse(p[0]) ?? 0, int.tryParse(p[1]) ?? 0); if (when.isBefore(tz.TZDateTime.now(tz.local))) return;
    await plugin.zonedSchedule(task.id.hashCode, task.text.trim(), 'حان وقت المهمة', when, const NotificationDetails(android: AndroidNotificationDetails('task_start', 'بداية المهام', channelDescription: 'تنبيهات بداية المهام', importance: Importance.high, priority: Priority.high)), androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }
  static Future<void> cancel(Task task) => plugin.cancel(task.id.hashCode);
}
