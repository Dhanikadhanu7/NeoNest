import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, String>> _history = [
    {
      'entry': 'Cry: Hunger - 2025-07-16 14:30',
      'context': 'Temp: 28°C, Humidity: 60%, Light: 300 lux, Sound: Normal'
    },
    {
      'entry': 'Cry: Pain - 2025-07-15 09:20',
      'context': 'Temp: 27°C, Humidity: 62%, Light: 250 lux, Sound: Quiet'
    },
    {
      'entry': 'Cry: Sleepy - 2025-07-14 21:10',
      'context': 'Temp: 29°C, Humidity: 58%, Light: 100 lux, Sound: Normal'
    },
  ];

  String _searchQuery = '';
  String _filterEmotion = '';
  String _filterDate = '';

  List<Map<String, String>> get _filteredHistory {
    return _history.where((entry) {
      final matchesSearch = _searchQuery.isEmpty ||
          entry['entry']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          entry['context']!.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesEmotion =
          _filterEmotion.isEmpty || entry['entry']!.contains(_filterEmotion);
      final matchesDate =
          _filterDate.isEmpty || entry['entry']!.contains(_filterDate);
      return matchesSearch && matchesEmotion && matchesDate;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cry History',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFF6A1B9A), // Deep Purple
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: _filteredHistory.isEmpty
          ? const Center(child: Text('No history found.'))
          : ListView.builder(
              itemCount: _filteredHistory.length,
              itemBuilder: (context, index) {
                final item = _filteredHistory[index];
                return Dismissible(
                  key: Key(item['entry']!),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      _history.remove(item);
                    });
                  },
                  child: ListTile(
                    title: Text(item['entry']!),
                    subtitle: Text(item['context']!),
                  ),
                );
              },
            ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    TextEditingController _searchController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Search History'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search by anything (emotion, date, context)',
              filled: true,
              fillColor: Color(0xFFEDE7F6), // Light purple
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Search'),
              onPressed: () {
                setState(() {
                  _searchQuery = _searchController.text;
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    TextEditingController _emotionController = TextEditingController();
    TextEditingController _dateController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Filter History'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _emotionController,
                decoration: const InputDecoration(
                  labelText: 'Filter by Emotion',
                  filled: true,
                  fillColor: Color(0xFFEDE7F6), // Light purple
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Filter by Date (YYYY-MM-DD)',
                  filled: true,
                  fillColor: Color(0xFFEDE7F6), // Light purple
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Apply'),
              onPressed: () {
                setState(() {
                  _filterEmotion = _emotionController.text;
                  _filterDate = _dateController.text;
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
