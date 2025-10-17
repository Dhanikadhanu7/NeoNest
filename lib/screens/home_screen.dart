import 'package:flutter/material.dart';
import 'monitoring_screen.dart';
import 'history_screen.dart';
import 'chatbot_screen.dart';
import 'lullaby_player_screen.dart';
import 'sleep_tracker_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: const Color(0xFF6A1B9A),
      appBar: AppBar(title: const Text('NeoNest')),
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(context, 'Start Monitoring', const MonitoringScreen()),
            const SizedBox(height: 16),
            _buildButton(context, 'View History', const HistoryScreen()),
            const SizedBox(height: 16),
            _buildButton(context, 'Parent Chatbot', const ChatbotScreen()),
            const SizedBox(height: 16),
            _buildButton(context, 'Lullaby Player', const LullabyPlayerScreen()),
            const SizedBox(height: 16),
            _buildButton(context, 'Sleep Tracker', const SleepTrackerScreen()),
            const SizedBox(height: 16),
            _buildButton(context, 'Settings', const SettingsScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, Widget screen) {
    return SizedBox(
      width: 260,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        },
        child: Text(title, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
