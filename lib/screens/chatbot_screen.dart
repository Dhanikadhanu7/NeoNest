import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Import your ApiService

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<String> _messages = [];
  final TextEditingController _controller = TextEditingController();

  // Updated to handle static ApiService properly
  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    String userMessage = _controller.text.trim();
    setState(() {
      _messages.add('Parent: $userMessage');
      _messages.add('NeoNest Bot: Typing...');
    });
    _controller.clear();

    try {
      // Call static method directly
      String botReply = await ApiService.sendChatMessage(userMessage);

      setState(() {
        _messages.removeLast(); // Remove "Typing..."
        _messages.add(botReply);
      });
    } catch (e) {
      setState(() {
        _messages.removeLast();
        _messages.add('NeoNest Bot: Error contacting server.');
      });
    }
  }

  void _startVoiceInput() {
    setState(() {
      _messages.add('🎤 Voice recorded: "Sample voice text."');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Chatbot'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFF6A1B9A),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_messages[index]),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Type your message...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.mic, color: Color(0xFF6A1B9A)),
              onPressed: _startVoiceInput,
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Color(0xFF6A1B9A)),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
