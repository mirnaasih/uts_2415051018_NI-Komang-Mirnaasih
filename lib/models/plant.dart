class Plant {
  final dynamic id;
  final String name;
  final String category;
  final String wateringSchedule;
  final String light;
  final String temperature;
  final String humidity;
  final String imageUrl;
  bool isFavorite; 

  Plant({
    required this.id,
    required this.name,
    required this.category,
    required this.wateringSchedule,
    required this.light,
    required this.temperature,
    required this.humidity,
    required this.imageUrl,
    this.isFavorite = false,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'],
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      wateringSchedule: json['watering_schedule'] ?? '',
      light: json['light'] ?? '',
      temperature: json['temperature'] ?? '18-25°C',
      humidity: json['humidity'] ?? '60-70%',
      imageUrl: json['image_url'] ?? '',
      isFavorite: json['is_favorite'] ?? false, 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'watering_schedule': wateringSchedule,
      'light': light,
      'temperature': temperature,
      'humidity': humidity,
      'image_url': imageUrl,
      'is_favorite': isFavorite, 
    };
  }
}