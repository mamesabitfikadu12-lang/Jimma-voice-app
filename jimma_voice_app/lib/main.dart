import 'rooms_games.dart';
import 'games_moments.dart';
import 'me_pages.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  static String language = 'English';
  static bool msgBanner = true;
  static bool msgSound = true;
  static bool msgVibrate = true;
  static String agencyStatus = 'None'; // None, Pending, Approved
  static String pendingAgencyName = '';
  static String pendingNationalId = '';
  static List<Map<String, String>> pointHistory = [];
  static List<Map<String, String>> moments = [
    {
      'user': 'Jimma Voice Official',
      'tag': '#JimmaCoffeeCulture',
      'text': 'Welcome to Jimma Voice Chat Family! Celebrate Oromo & Ethiopian heritage with friends worldwide.',
      'likes': '128'
    },
    {
      'user': 'Oromia Cultural Hub',
      'tag': '#WorldCup2026',
      'text': 'Join our live voice rooms for music, coffee ceremonies, and global tournaments!',
      'likes': '94'
    },
  ];
}

class JimmaVoiceApp extends StatelessWidget {
  const JimmaVoiceApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jimma Voice Chat Family',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0F19),
        primaryColor: const Color(0xFFFFB703),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF111827),
          elevation: 0,
          centerTitle: true,
        ),
        cardColor: const Color(0xFF161E31),
      ),
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
    final pages = [
      RoomsTab(onUpd: _refresh),
      GamesTab(onUpd: _refresh),
      MomentsTab(onUpd: _refresh),
      MessagesTab(onUpd: _refresh),
      MeTab(onUpd: _refresh),
    ];
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

