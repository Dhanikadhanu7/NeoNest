// lib/screens/monitoring_screen.dart
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../utils/theme_manager.dart'; // ThemeManager import

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({Key? key}) : super(key: key);

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  bool _isAnalyzing = false;
  String _analysisResult = '';

  Uint8List? _fileBytes;
  String? _fileName;

  Map<String, dynamic> _contextData = {
    'Temperature': '28°C',
    'Humidity': '60%',
    'Light': '300 lux',
    'Sound Level': 'Normal',
  };

  final String backendUrl = "http://127.0.0.1:8000/cry/analyze";

  // Pick audio file
  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        withData: true, // important for web
      );

      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _fileBytes = result.files.single.bytes;
          _fileName = result.files.single.name;
          _analysisResult = 'File selected: $_fileName';
        });
      } else {
        setState(() {
          _analysisResult = 'No file selected';
        });
      }
    } catch (e) {
      setState(() {
        _analysisResult = 'Error picking file: $e';
      });
    }
  }

  // Send audio to backend and get prediction
  Future<void> _predict() async {
    if (_fileBytes == null || _fileName == null) {
      setState(() {
        _analysisResult = 'No audio file selected.';
      });
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _analysisResult = '';
    });

    try {
      var request = http.MultipartRequest('POST', Uri.parse(backendUrl));
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          _fileBytes!,
          filename: _fileName!,
        ),
      );

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonData = json.decode(responseData);

      if (jsonData["success"] == true) {
        setState(() {
          _isAnalyzing = false;
          _analysisResult =
              ' ${jsonData["result"]["emotion"]}';
        });
      } else {
        setState(() {
          _isAnalyzing = false;
          _analysisResult = 'Error predicting audio: ${jsonData["error"]}';
        });
      }
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
        _analysisResult = 'Error predicting audio: $e';
      });
    }
  }

  void _updateContextData() {
    setState(() {
      _contextData['Temperature'] = '${28 + (DateTime.now().second % 3)}°C';
      _contextData['Humidity'] = '${60 + (DateTime.now().second % 5)}%';
      _contextData['Light'] = '${300 + (DateTime.now().second % 50)} lux';
      _contextData['Sound Level'] =
          DateTime.now().second % 2 == 0 ? 'Quiet' : 'Normal';
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeManager>(context);
    final isDark = themeProvider.isDark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF3E5F5),
      appBar: AppBar(
        title: const Text('Monitoring Screen'),
        backgroundColor: const Color(0xFF6A1B9A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // File picker placeholder
            GestureDetector(
              onTap: _pickFile,
              child: Container(
                width: double.infinity,
                height: 120,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Tap to pick audio file',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Predict button
            ElevatedButton(
              onPressed: !_isAnalyzing ? _predict : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isAnalyzing
                    ? const Color.fromARGB(255, 246, 169, 222)
                    : const Color(0xFF6A1B9A),
                minimumSize: const Size(220, 60),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: _isAnalyzing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Analyze',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
            ),
            const SizedBox(height: 30),

            // Result area
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[850] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _analysisResult,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),

            // Context data
            Text(
              'Context Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : const Color(0xFF6A1B9A),
              ),
            ),
            const SizedBox(height: 10),
            ..._contextData.entries.map(
              (entry) => ListTile(
                leading: Icon(Icons.sensors,
                    color: isDark ? Colors.white70 : Colors.black87),
                title: Text(
                  entry.key,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                ),
                trailing: Text(
                  entry.value,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
