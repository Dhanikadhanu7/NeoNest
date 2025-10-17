import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = "NeoNest MICA-CL";
  static const String apiBaseUrl = "https://your-api-url.com";

  // Colors
  static const Color primaryColor = Color(0xFF6A1B9A);
  static const Color accentColor = Colors.purpleAccent;
  static const Color backgroundColor = Color(0xFFF5F5F5);

  // Padding
  static const double defaultPadding = 16.0;

  // API Endpoints
  static const String monitorEndpoint = "/monitor";
  static const String historyEndpoint = "/history";
  static const String contextDataEndpoint = "/context";
  static const String audioEndpoint = "/audio";
  static const String settingsEndpoint = "/settings";
}
