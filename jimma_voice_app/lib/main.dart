import 'dart:math';
import 'package:flutter/material.dart';
import 'rooms_games.dart';
import 'games_moments.dart';
import 'me_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const JimmaVoiceApp());
}

class AppState {
  static String userName = 'New Member';
  static String userId = '${1000000 + Random().nextInt(8999999)}';
  static int coins = 0;
  static double points = 0.0;
  static int wealthLv = 1;
  static int charmLv = 1;
  static int vipLevel = 0;
  static bool msgBanner = true;
  static bool msgSound = true;
  static bool msgVibrate = true;
  static String agencyStatus = 'None';
  static String pendingAgencyName = '';
  static String pendingNationalId = '';
  static List<Map<String, String>> pointHistory = List<Map<String, String>>.empty(growable: true);
  static List<Map<String, String>> notifications = List<Map<String, String>>.of({
    {'title': 'Welcome to ኢትዮ-ድምጽ (Ethio-Voice)', 'body': 'Celebrate Oromo & Ethiopian culture with HD voice rooms & games!', 'time': 'Now'}
  });
  static List<Map<String, String>> chatMessages = List<Map<String, String>>.of({
    {'sender': 'Ethio-Voice Support', 'type': 'text', 'content': 'Welcome! Chat is 100% Free. Share User IDs safely.', 'time': 'Now'}
  });
  static List<Map<String, String>> moments = List<Map<String, String>>.of({
    {'user': 'Ethio-Voice Official', 'tag': '#EthioVoice', 'text': 'Welcome to ኢትዮ-ድምጽ! Post photos & connect globally.', 'likes': '1'}
  });

  static bool hasProfanity(String text) {
    final t = text.toLowerCase();
    final bad = List<String>.of({'fuck', 'bitch', 'shit', 'asshole', 'bastard', 'idiot', 'stupid', 'slut', 'whore', 'gowwaa', 'sare', 'doqna', 'bushaa', 'sharmuxaa', 'xuraawaa', 'ግም', 'ውሻ', 'ደደብ'});
    return bad.any((w) => t.contains(w));
  }

  static void addNotif(BuildContext? ctx, String title, String body) {
    notifications.insert(0, {'title': title, 'body': body, 'time': 'Just now'});
    if (ctx != null && msgBanner) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(backgroundColor: Colors.teal.shade800, content: Text('🔔 $title: $body')));
    }
  }
}

class JimmaVoiceApp extends StatelessWidget {
  const JimmaVoiceApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ኢትዮ-ድምጽ • Ethio-Voice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: const Color(0xFF090D16), primaryColor: const Color(0xFFFFB703)),
      home: const MainNavScreen(),
    );
  }
}

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});
  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _idx = 0;
  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final pages = List<Widget>.of({
      RoomsTab(onUpd: _refresh),
      GamesTab(onUpd: _refresh),
      MomentsTab(onUpd: _refresh),
      MessagesTab(onUpd: _refresh),
      MeTab(onUpd: _refresh),
    });
    return Scaffold(
      body: pages.elementAt(_idx),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        onTap: (i) => setState(() => _idx = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF111827),
        selectedItemColor: const Color(0xFFFFB703),
        unselectedItemColor: Colors.white54,
        items: List<BottomNavigationBarItem>.of({
          const BottomNavigationBarItem(icon: Icon(Icons.mic_rounded), label: 'Room'),
          const BottomNavigationBarItem(icon: Icon(Icons.casino_rounded), label: 'Games'),
          const BottomNavigationBarItem(icon: Icon(Icons.explore_rounded), label: 'Moment'),
          const BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: 'Message'),
          const BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Me'),
        }),
      ),
    );
  }
}
