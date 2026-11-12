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
  static String userId = 'ID: ${100000 + Random().nextInt(899999)}';
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
  static List<Map<String, String>> pointHistory = [];
  static List<Map<String, String>> notifications = [
    {'title': 'Welcome to Jimma Voice Chat Family', 'body': 'Celebrate Oromo & Ethiopian culture with global voice rooms!', 'time': 'Now'}
  ];
  static List<Map<String, String>> chatMessages = [
    {'sender': 'Jimma Voice Support', 'type': 'text', 'content': 'Hello! Send text, voice note, or bank payment receipt photo here.', 'time': '11:30 PM'}
  ];
  static List<Map<String, String>> moments = [
    {'user': 'Jimma Voice Official', 'tag': '#JimmaCoffeeCulture', 'text': 'Welcome to Jimma Voice Chat Family!', 'likes': '128'},
  ];

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
      title: 'Jimma Voice Chat Family',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: const Color(0xFF0B0F19), primaryColor: const Color(0xFFFFB703), cardColor: const Color(0xFF161E31)),
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
    final pages = [RoomsTab(onUpd: _refresh), GamesTab(onUpd: _refresh), MomentsTab(onUpd: _refresh), MessagesTab(onUpd: _refresh), MeTab(onUpd: _refresh)];
    return Scaffold(
      body: pages[_idx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        onTap: (i) => setState(() => _idx = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF111827),
        selectedItemColor: const Color(0xFFFFB703),
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.mic_rounded), label: 'Room'),
          BottomNavigationBarItem(icon: Icon(Icons.casino_rounded), label: 'Games'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_rounded), label: 'Moment'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: 'Message'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Me'),
        ],
      ),
    );
  }
}
