class Plant {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final String wateringSchedule;
  final String light;
  final String temperature;
  final String humidity;

  Plant({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.wateringSchedule,
    required this.light,
    required this.temperature,
    required this.humidity,
  });

  // Konversi dari JSON (REST API / Database) ke objek Dart
  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['image_url'] ?? '',
      wateringSchedule: json['watering_schedule'] ?? '',
      light: json['light'] ?? '',
      temperature: json['temperature'] ?? '',
      humidity: json['humidity'] ?? '',
    );
  }

  // Konversi dari objek Dart ke Map/JSON (untuk Create/Update Database)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'image_url': imageUrl,
      'watering_schedule': wateringSchedule,
      'light': light,
      'temperature': temperature,
      'humidity': humidity,
    };
  }
}