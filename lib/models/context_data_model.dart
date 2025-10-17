class ContextData {
  final double temperature;
  final double humidity;
  final double noiseLevel;
  final String environment; // e.g., calm, noisy, hot, cold

  ContextData({
    required this.temperature,
    required this.humidity,
    required this.noiseLevel,
    required this.environment,
  });

  factory ContextData.fromJson(Map<String, dynamic> json) {
    return ContextData(
      temperature: json['temperature'].toDouble(),
      humidity: json['humidity'].toDouble(),
      noiseLevel: json['noiseLevel'].toDouble(),
      environment: json['environment'],
    );
  }

  Map<String, dynamic> toJson() => {
        'temperature': temperature,
        'humidity': humidity,
        'noiseLevel': noiseLevel,
        'environment': environment,
      };
}
