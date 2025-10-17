class CryEvent {
  final DateTime timestamp;
  final String emotion; // pain, hunger, discomfort
  final double confidence; // ML model confidence

  CryEvent({
    required this.timestamp,
    required this.emotion,
    required this.confidence,
  });

  factory CryEvent.fromJson(Map<String, dynamic> json) {
    return CryEvent(
      timestamp: DateTime.parse(json['timestamp']),
      emotion: json['emotion'],
      confidence: json['confidence'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'emotion': emotion,
        'confidence': confidence,
      };
}
