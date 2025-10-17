import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/theme_manager.dart';
import '../utils/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  // 📧 Send Feedback
  Future<void> _sendFeedback() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@yourapp.com',
      query: 'subject=App Feedback&body=Hi, I want to share feedback...',
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  // 📄 Open User Guide (PDF link)
  Future<void> _openUserGuide() async {
    final Uri guideUri = Uri.parse("https://yourwebsite.com/userguide.pdf");
    if (await canLaunchUrl(guideUri)) {
      await launchUrl(guideUri, mode: LaunchMode.externalApplication);
    }
  }

  // 🌍 Open Privacy Policy
  Future<void> _openPrivacyPolicy() async {
    final Uri url = Uri.parse("https://yourwebsite.com/privacy");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  // 🌍 Open Terms of Service
  Future<void> _openTerms() async {
    final Uri url = Uri.parse("https://yourwebsite.com/terms");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  // ⭐ Rate App
  Future<void> _rateApp() async {
    final Uri url = Uri.parse(
        "https://play.google.com/store/apps/details?id=com.example.app"); // Replace with your app ID
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  // 📤 Share App
  Future<void> _shareApp() async {
    final Uri url = Uri.parse(
        "https://play.google.com/store/apps/details?id=com.example.app"); // Replace with your app link
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  // 🔄 Reset Preferences (dummy for now)
  void _resetPreferences() {
    setState(() {
      _notificationsEnabled = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Preferences reset to default")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeManager>(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.translate('settings') ?? "Settings"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFF6A1B9A),
      ),
      body: ListView(
        children: [
          // 1. 🌙 Dark Mode
          SwitchListTile(
            title: Text(localizations?.translate('dark_mode') ?? "Dark Mode"),
            value: themeProvider.isDark,
            onChanged: (bool value) {
              themeProvider.toggleTheme();
            },
            secondary: const Icon(Icons.brightness_6),
          ),
          // 2. 🔔 Notifications
          SwitchListTile(
            title:
                Text(localizations?.translate('notifications') ?? "Notifications"),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            secondary: const Icon(Icons.notifications),
          ),
          // 3. 📖 User Guide
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text("User Guide"),
            onTap: _openUserGuide,
          ),
          // 4. 📝 Feedback
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text("Send Feedback"),
            onTap: _sendFeedback,
          ),
          // 5. ℹ️ About App
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("About App"),
            subtitle: const Text("Version 1.0.0"),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Pretend World",
                applicationVersion: "1.0.0",
                applicationLegalese: "© 2025 Your Company",
              );
            },
          ),
          // 6. 🔒 Privacy Policy
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text("Privacy Policy"),
            onTap: _openPrivacyPolicy,
          ),
          // 7. 📜 Terms of Service
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text("Terms of Service"),
            onTap: _openTerms,
          ),
          // 8. ⭐ Rate Us
          ListTile(
            leading: const Icon(Icons.star_rate),
            title: const Text("Rate Us"),
            onTap: _rateApp,
          ),
          // 9. 📤 Share App
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text("Share App"),
            onTap: _shareApp,
          ),
          // 10. 🔄 Reset Preferences
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text("Reset Preferences"),
            onTap: _resetPreferences,
          ),
        ],
      ),
    );
  }
}
