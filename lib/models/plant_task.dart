class PlantTask {
  final String id;
  final String title;
  final String time;
  final bool isCompleted;

  PlantTask({
    required this.id,
    required this.title,
    required this.time,
    required this.isCompleted,
  });

  factory PlantTask.fromJson(Map<String, dynamic> json) {
    return PlantTask(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      time: json['time'] ?? '',
      isCompleted: json['is_completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'time': time,
      'is_completed': isCompleted,
    };
  }
}