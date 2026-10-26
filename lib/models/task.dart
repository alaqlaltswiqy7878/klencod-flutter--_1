import 'dart:convert';

enum TaskStatus { unset, completed, incomplete }

class Task {
  final String id;
  final String dateKey;
  String text;
  String? startTime;
  int colorValue;
  TaskStatus status;
  bool dailyRepeat;

  Task({required this.id, required this.dateKey, this.text = '', this.startTime, this.colorValue = 0xFFE8F0FE, this.status = TaskStatus.unset, this.dailyRepeat = false});

  Map<String, dynamic> toJson() => {'id': id, 'dateKey': dateKey, 'text': text, 'startTime': startTime, 'colorValue': colorValue, 'status': status.name, 'dailyRepeat': dailyRepeat};
  factory Task.fromJson(Map<String, dynamic> j) => Task(id: '${j['id'] ?? DateTime.now().microsecondsSinceEpoch}', dateKey: '${j['dateKey'] ?? ''}', text: '${j['text'] ?? ''}', startTime: j['startTime'] as String?, colorValue: (j['colorValue'] as num?)?.toInt() ?? 0xFFE8F0FE, status: TaskStatus.values.firstWhere((x) => x.name == j['status'], orElse: () => TaskStatus.unset), dailyRepeat: j['dailyRepeat'] == true);
  static String encode(List<Task> items) => jsonEncode(items.map((x) => x.toJson()).toList());
  static List<Task> decode(String? raw) { if (raw == null || raw.isEmpty) return []; try { final list = jsonDecode(raw) as List; return list.map((x) => Task.fromJson(Map<String, dynamic>.from(x))).toList(); } catch (_) { return []; } }
}
