import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:neo_nest/screens/splash_screen.dart';
import 'package:neo_nest/screens/login_screen.dart';
import 'package:neo_nest/screens/home_screen.dart'; // replace with your actual home screen
import 'package:provider/provider.dart';
import 'utils/theme_manager.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: const NeoNestApp(),
    ),
  );
}

class NeoNestApp extends StatelessWidget {
  const NeoNestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeManager>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NeoNest',
      theme: themeProvider.isDark ? ThemeData.dark() : ThemeData.light(),

      supportedLocales: const [
        Locale('en', ''), // Only English
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ✅ Use routes for navigation
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
