import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskStore {
  static const _tasksKey = 'daily_schedule_tasks_v1';
  static const _sectionsKey = 'daily_schedule_sections_v1';
  static List<Task> tasks = [];
  static Map<String, bool> sections = {'unset': true, 'completed': false, 'incomplete': false};
  static Future<void> load() async { final p = await SharedPreferences.getInstance(); tasks = Task.decode(p.getString(_tasksKey)); final saved = p.getStringList(_sectionsKey); if (saved != null) for (final item in saved) { final parts = item.split('='); if (parts.length == 2) sections[parts[0]] = parts[1] == 'true'; } }
  static Future<void> save() async { final p = await SharedPreferences.getInstance(); await p.setString(_tasksKey, Task.encode(tasks)); await p.setStringList(_sectionsKey, sections.entries.map((e) => '${e.key}=${e.value}').toList()); }
  static List<Task> forDate(String key) => tasks.where((t) => t.dateKey == key || (t.dailyRepeat && t.dateKey.compareTo(key) <= 0)).toList();
  static Future<void> upsert(Task task) async { final i = tasks.indexWhere((x) => x.id == task.id); if (i == -1) tasks.add(task); else tasks[i] = task; await save(); }
  static Future<void> remove(Task task) async { tasks.removeWhere((x) => x.id == task.id); await save(); }
}
