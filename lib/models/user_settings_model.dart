class UserSettings {
  bool isDarkMode;
  bool notificationsEnabled;
  String language;

  UserSettings({
    this.isDarkMode = false,
    this.notificationsEnabled = true,
    this.language = 'en',
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      isDarkMode: json['isDarkMode'],
      notificationsEnabled: json['notificationsEnabled'],
      language: json['language'],
    );
  }

  Map<String, dynamic> toJson() => {
        'isDarkMode': isDarkMode,
        'notificationsEnabled': notificationsEnabled,
        'language': language,
      };
}
