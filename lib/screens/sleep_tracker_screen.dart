import 'dart:async';
import 'package:flutter/material.dart';

class SleepTrackerScreen extends StatefulWidget {
  const SleepTrackerScreen({Key? key}) : super(key: key);

  @override
  State<SleepTrackerScreen> createState() => _SleepTrackerScreenState();
}

class _SleepTrackerScreenState extends State<SleepTrackerScreen> {
  List<Map<String, dynamic>> _logs = [];
  DateTime? _sleepStart;
  Timer? _timer;
  Duration _currentDuration = Duration.zero;

  void _startSleepLog() {
    setState(() {
      _sleepStart = DateTime.now();
      _currentDuration = Duration.zero;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          _currentDuration = DateTime.now().difference(_sleepStart!);
        });
      });
    });
  }

  void _stopSleepLog() {
    _timer?.cancel();
    setState(() {
      _logs.add({
        'start': _sleepStart,
        'end': DateTime.now(),
        'duration': _currentDuration,
      });
      _sleepStart = null;
      _currentDuration = Duration.zero;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String timerText =
        '${_currentDuration.inHours.toString().padLeft(2, '0')}:${(_currentDuration.inMinutes % 60).toString().padLeft(2, '0')}:${(_currentDuration.inSeconds % 60).toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep Tracker'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back Arrow
          onPressed: () => Navigator.pop(context),
        ),
      backgroundColor: const Color(0xFF6A1B9A),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: Icon(_sleepStart == null ? Icons.play_arrow : Icons.stop),
            label: Text(_sleepStart == null ? 'Start Sleep Log' : 'Stop Sleep Log'),
            onPressed: _sleepStart == null ? _startSleepLog : _stopSleepLog,
            style: ElevatedButton.styleFrom(
              backgroundColor: _sleepStart == null ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 20),
          if (_sleepStart != null)
            Text(
              'Tracking: $timerText',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final log = _logs[index];
                return ListTile(
                  title: Text('Sleep Log ${index + 1}'),
                  subtitle: Text(
                      'Start: ${log['start']}\nEnd: ${log['end']}\nDuration: ${log['duration'].inMinutes} min'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
