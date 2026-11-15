import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'games_moments.dart';
import 'me_pages.dart';
import 'task_settings_admin.dart';
void main() => runApp(const EthioVoiceApp());

class AppState {
  static bool isLoggedIn = false;
  static String userName = 'Ethio_User_${Random().nextInt(900) + 100}';
  static String userPhone = '';
  static String userId = '${Random().nextInt(8999999) + 1000000}';
  static int coins = 0;
  static double points = 0.0;
  static int vipLevel = 0;
  static int hostLv = 1;
  static int wealthLv = 1;
  static bool isCoinSeller = false;
  static bool isAgency = false;
  static String agencyName = '';
  static String agencyWhatsApp = '+251919108311';
  static int gamesPlayedToday = 0;
  static int roomMinutesToday = 0;
  static bool inviteClaimed = false;
  static String agencyStatus = 'None';
  static String pendingAgencyName = '';
  static String pendingNationalId = '';
  static bool msgBanner = true;
  static bool msgSound = true;
  static String lastBigWinner = 'Abdi so lucky & won 31x prize!';
  static Map<String, dynamic>? floatingRoom;

  static final Set<String> claimedTasks = <String>{};
  static final List<Map<String, String>> moments = <Map<String, String>>[
    {'user': 'Biftu_Oromia', 'tag': '#OromoCulture', 'text': 'Baga nagaan gara ኢትዮ-ድምጽ dhuftan! Barumsa fi tapha gaarii!', 'likes': '48', 'img': ''},
    {'user': 'Dawit_Finfinnee', 'tag': '#EthioVoice', 'text': 'Jungle Hunt 20 Lines irraa 31X mo\'adheera!', 'likes': '92', 'img': ''},
  ];
  static final List<Map<String, String>> chatMessages = <Map<String, String>>[
    {'sender': 'Ethio-Voice Official', 'type': 'text', 'content': 'Welcome! Enjoy 100% Free Chat, Live Rooms & 24 HD Games!', 'time': 'Now'},
  ];
  static final List<Map<String, String>> systemReceipts = <Map<String, String>>[
    {'type': 'bonus', 'title': 'Room Bomb Bonus', 'body': 'Congratulations on getting 500 coins in Room Bomb', 'time': '2026-11-15 10:30:00'},
  ];
  static final List<Map<String, String>> officialNotices = <Map<String, String>>[
    {'title': 'Welcome to Ethio-Voice!', 'body': 'Complete Daily 24h Tasks, host voice rooms & cash out via Payroll or Agency!', 'time': 'Now'},
  ];
  static final List<Map<String, String>> notifications = officialNotices;
static final List<Map<String, String>> pendingRecharges = <Map<String, String>>[];
  static bool hasProfanity(String text) {
    final t = text.toLowerCase();
    final bad = List<String>.of({'fuck', 'bitch', 'shit', 'dick', 'pussy', 'sex', 'porn', 'nude', 'sarmuta', 'sharmuta', 'qomata', 'bushti', 'fincaan', 'udaan', 'saluu', 'gadihee'});
    for (final w in bad) {
      if (t.contains(w)) return true;
    }
    return false;
  }
}

class EthioVoiceApp extends StatelessWidget {
  const EthioVoiceApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ኢትዮ-ድምጽ • Ethio-Voice',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B1120),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF0F172A), elevation: 0),
      ),
      home: AppState.isLoggedIn ? const MainShell() : const AuthGatePage(),
    );
  }
}

class AuthGatePage extends StatefulWidget {
  const AuthGatePage({super.key});
  @override
  State<AuthGatePage> createState() => _AuthGatePageState();
}

class _AuthGatePageState extends State<AuthGatePage> {
  bool _isSignUp = true;
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _refCtrl = TextEditingController();

  void _submit() {
    final phone = _phoneCtrl.text.trim();
    final pass = _passCtrl.text.trim();
    if (phone.length < 6 || pass.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('Enter valid Phone/Email & Password (4+ chars)!')));
      return;
    }
    if (_isSignUp && _nameCtrl.text.trim().isNotEmpty && !AppState.hasProfanity(_nameCtrl.text)) {
      AppState.userName = _nameCtrl.text.trim();
    }
    AppState.userPhone = phone;
    if (_isSignUp && _refCtrl.text.trim().length >= 5) {
      AppState.coins += 500;
      AppState.inviteClaimed = true;
    }
    AppState.isLoggedIn = true;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainShell()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: <Color>[Color(0xFF064E3B), Color(0xFF0F172A), Color(0xFF090D16)])),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(children: List<Widget>.of({
                const CircleAvatar(radius: 42, backgroundColor: Colors.amber, child: Icon(Icons.graphic_eq, size: 46, color: Colors.black)),
                const SizedBox(height: 12),
                const Text('ኢትዮ-ድምጽ • Ethio-Voice', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.amber)),
                const Text('Live Voice Rooms • Education • 24 HD Games', style: TextStyle(fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.amber.withOpacity(0.5))),
                  child: Column(children: List<Widget>.of({
                    Row(children: List<Widget>.of({
                      Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _isSignUp ? Colors.amber : Colors.white10, foregroundColor: _isSignUp ? Colors.black : Colors.white), onPressed: () => setState(() => _isSignUp = true), child: const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold)))),
                      const SizedBox(width: 8),
                      Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: !_isSignUp ? Colors.tealAccent : Colors.white10, foregroundColor: !_isSignUp ? Colors.black : Colors.white), onPressed: () => setState(() => _isSignUp = false), child: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold)))),
                    })),
                    const SizedBox(height: 14),
                    if (_isSignUp) TextField(controller: _nameCtrl, decoration: const InputDecoration(prefixIcon: Icon(Icons.person, color: Colors.amber), labelText: 'Full Name / Nickname')),
                    TextField(controller: _phoneCtrl, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(prefixIcon: Icon(Icons.phone_android, color: Colors.tealAccent), labelText: 'Phone Number or Email')),
                    TextField(controller: _passCtrl, obscureText: true, decoration: const InputDecoration(prefixIcon: Icon(Icons.lock, color: Colors.amber), labelText: 'Password')),
                    if (_isSignUp) TextField(controller: _refCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(prefixIcon: Icon(Icons.card_giftcard, color: Colors.pinkAccent), labelText: 'Invite Code (Optional +500 Coins)')),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                      onPressed: _submit,
                      child: Text(_isSignUp ? 'Create Account & Enter' : 'Login to Ethio-Voice', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  })),
                ),
              })),
            ),
          ),
        ),
      ),
    );
  }
}


class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _idx = 0;
  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final pages = List<Widget>.of({
      HomeTab(onUpd: _refresh),
      GamesTab(onUpd: _refresh),
      MomentsTab(onUpd: _refresh),
      MessagesTab(onUpd: _refresh),
      MeTab(onUpd: _refresh),
    });
    return Scaffold(
      body: Stack(children: List<Widget>.of({
        pages.elementAt(_idx),
        if (AppState.floatingRoom != null)
          Positioned(
            right: 12,
            bottom: 16,
            child: GestureDetector(
              onTap: () {
                final r = AppState.floatingRoom!;
                Navigator.push(context, MaterialPageRoute(builder: (_) => LiveVoiceRoomPage(room: r, onUpd: _refresh)));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: <Color>[Color(0xFF0077B6), Color(0xFF7209B7)]),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.amber, width: 2),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: List<Widget>.of({
                  const Icon(Icons.graphic_eq, color: Colors.tealAccent, size: 20),
                  const SizedBox(width: 6),
                  Text(AppState.floatingRoom!['title'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(width: 6),
                  InkWell(onTap: () => setState(() => AppState.floatingRoom = null), child: const Icon(Icons.close, size: 16, color: Colors.amber)),
                })),
              ),
            ),
          ),
      })),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _idx,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0F172A),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white54,
        onTap: (i) => setState(() => _idx = i),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_esports), label: 'Games'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Moments'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  final VoidCallback onUpd;
  const HomeTab({super.key, required this.onUpd});
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _rooms = List<Map<String, dynamic>>.of({
    {'title': 'Finfinnee Night Party & Education', 'host': 'Ethio_Host_1', 'mics': 9, 'users': 142, 'tag': 'Education', 'c1': 0xFF1E1B4B, 'c2': 0xFF581C87},
    {'title': 'Global Afro-Oromo Mega Stage', 'host': 'Oromo_Star', 'mics': 30, 'users': 485, 'tag': '30 Mics', 'c1': 0xFF064E3B, 'c2': 0xFF0F766E},
    {'title': 'Jimma Coffee & Tech Training', 'host': 'Biftu_Oromia', 'mics': 9, 'users': 96, 'tag': 'Training', 'c1': 0xFF7C2D12, 'c2': 0xFFB45309},
    {'title': 'Habesha 30-Seat Music & Quiz', 'host': 'Dawit_VIP', 'mics': 30, 'users': 310, 'tag': 'Party', 'c1': 0xFF4C0519, 'c2': 0xFF9F1239},
  });

  void _createRoom() {
    final c = TextEditingController();
    int micCount = 9;
    showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setD) => AlertDialog(
      title: const Text('Create Live Voice Room'),
      content: Column(mainAxisSize: MainAxisSize.min, children: List<Widget>.of({
        TextField(controller: c, decoration: const InputDecoration(labelText: 'Room Title (Education / Party)')),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List<Widget>.of({
          ChoiceChip(label: const Text('9 Mics'), selected: micCount == 9, onSelected: (_) => setD(() => micCount = 9)),
          ChoiceChip(label: const Text('30 Mics'), selected: micCount == 30, onSelected: (_) => setD(() => micCount = 30)),
        })),
      })),
      actions: List<Widget>.of({
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black), onPressed: () {
          if (c.text.trim().isNotEmpty && !AppState.hasProfanity(c.text)) {
            final nr = {'title': c.text.trim(), 'host': AppState.userName, 'mics': micCount, 'users': 1, 'tag': '$micCount Mics', 'c1': 0xFF1E3A8A, 'c2': 0xFF6D28D9};
            setState(() => _rooms.insert(0, nr));
            Navigator.pop(ctx);
            Navigator.push(context, MaterialPageRoute(builder: (_) => LiveVoiceRoomPage(room: nr, onUpd: widget.onUpd)));
          }
        }, child: const Text('Go Live')),
      }),
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ኢትዮ-ድምጽ • Ethio-Voice', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
        actions: List<Widget>.of({
          IconButton(icon: const Icon(Icons.assignment_turned_in, color: Colors.tealAccent), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskCenterPage(onUpd: widget.onUpd)))),
          IconButton(icon: const Icon(Icons.add_circle, color: Colors.amber), onPressed: _createRoom),
        }),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _rooms.length,
        itemBuilder: (_, i) {
          final r = _rooms.elementAt(i);
          return InkWell(
            onTap: () {
              AppState.floatingRoom = null;
              Navigator.push(context, MaterialPageRoute(builder: (_) => LiveVoiceRoomPage(room: r, onUpd: widget.onUpd)));
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: <Color>[Color(r['c1'] as int), Color(r['c2'] as int)]),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.withOpacity(0.45)),
              ),
              child: Row(children: List<Widget>.of({
                CircleAvatar(radius: 28, backgroundColor: Colors.amber, child: Text('${r['mics']}M', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: List<Widget>.of({
                  Text(r['title'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text('Host: ${r['host']} • ${r['tag']}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                }))),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(14)), child: Text('🔥 ${r['users']}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))),
              })),
            ),
          );
        },
      ),
    );
  }
}

class LiveVoiceRoomPage extends StatefulWidget {
  final Map<String, dynamic> room;
  final VoidCallback onUpd;
  const LiveVoiceRoomPage({super.key, required this.room, required this.onUpd});
  @override
  State<LiveVoiceRoomPage> createState() => _LiveVoiceRoomPageState();
}

class _LiveVoiceRoomPageState extends State<LiveVoiceRoomPage> {
  late int _micCount;
  int _mySeat = 0;
  bool _muted = false;
  bool _voiceOn = true;
  String _logFilter = 'All';
  final _chatCtrl = TextEditingController();
  final List<Map<String, String>> _logs = List<Map<String, String>>.of({
    {'type': 'Room', 'text': '🔔 System: Welcome to the voice chat room! Please follow these rules:\n1. Use respectful language; inappropriate remarks are prohibited.\n2. Violators may be warned, muted, or banned.'},
    {'type': 'Room', 'text': '📢 Announcement: Game play & daily tasks active! Tap Minimize anytime to do tasks.'},
  });

  @override
  void initState() {
    super.initState();
    _micCount = widget.room['mics'] as int? ?? 9;
    AppState.roomMinutesToday += 5;
  }

  void _minimizeRoom() {
    AppState.floatingRoom = widget.room;
    widget.onUpd();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.teal, content: Text('🎙️ Room minimized! Audio active while you complete Daily Tasks!')));
  }

      void _openQuickInRoomGame() {
    final webGames = List<Map<String, String>>.of({
      {'name': 'Ludo King Party (HTML5)', 'ic': '🎲👑', 'url': 'https://html5games.com'},
      {'name': 'Domino Classic (HTML5)', 'ic': '🁣✨', 'url': 'https://html5games.com'},
      {'name': 'Carrom Pool (HTML5)', 'ic': '🎯🏆', 'url': 'https://html5games.com'},
      {'name': 'Chess Master (HTML5)', 'ic': '♟️👑', 'url': 'https://html5games.com'},
    });
    showModalBottomSheet(context: context, backgroundColor: const Color(0xFF0F172A), builder: (ctx) => Padding(
      padding: const EdgeInsets.all(14),
      child: Column(mainAxisSize: MainAxisSize.min, children: List<Widget>.of({
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List<Widget>.of({
          Text('🎮 In-Room Party Games • 🪙 ${AppState.coins}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.amber)),
          const Text('🎙️ Voice Active', style: TextStyle(fontSize: 11, color: Colors.tealAccent)),
        })),
        const SizedBox(height: 10),
        ...webGames.map((wg) => Card(
          color: const Color(0xFF1E293B),
          child: ListTile(
            leading: Text(wg['ic']!, style: const TextStyle(fontSize: 26)),
            title: Text(wg['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            subtitle: const Text('Play inside Voice Room without closing Mic', style: TextStyle(fontSize: 11, color: Colors.white60)),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black),
              onPressed: () {
                Navigator.pop(ctx);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => WebViewMiniGameSheet(title: wg['name']!, gameUrl: wg['url']!, onUpd: () { setState(() {}); widget.onUpd(); }),
                );
              },
              child: const Text('Play', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        )),
      })),
    ));
  }



  void _openBasicTools() {
    final tools = List<Map<String, dynamic>>.of({
      {'ic': Icons.volume_up, 'name': _voiceOn ? 'Voice On' : 'Voice Off'},
      {'ic': Icons.share, 'name': 'Share'},
      {'ic': Icons.music_note, 'name': 'Music'},
      {'ic': Icons.settings, 'name': 'Room Settings'},
      {'ic': Icons.admin_panel_settings, 'name': 'Room Admin'},
      {'ic': Icons.lock, 'name': 'Set Password'},
      {'ic': Icons.mic, 'name': 'Open all mic'},
      {'ic': Icons.mic_off, 'name': 'Close all mic'},
      {'ic': Icons.redeem, 'name': 'Red Packet'},
      {'ic': Icons.backpack, 'name': 'Backpack'},
      {'ic': Icons.auto_awesome, 'name': 'Effect Setting'},
      {'ic': Icons.bolt, 'name': 'PK'},
    });
    showModalBottomSheet(context: context, backgroundColor: const Color(0xFF0F172A), builder: (ctx) => Padding(
      padding: const EdgeInsets.all(16),
      child: Column(mainAxisSize: MainAxisSize.min, children: List<Widget>.of({
        const Text('Basic Tools', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tools.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 12, childAspectRatio: 1.0),
          itemBuilder: (_, i) {
            final t = tools.elementAt(i);
            return InkWell(
              onTap: () {
                Navigator.pop(ctx);
                setState(() {
                  if (i == 0) _voiceOn = !_voiceOn;
                  _logs.add({'type': 'Room', 'text': '🛠️ ${t['name']} activated by ${AppState.userName}'});
                });
              },
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: List<Widget>.of({
                Icon(t['ic'] as IconData, color: Colors.white, size: 26),
                const SizedBox(height: 6),
                Text(t['name'] as String, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10.5, color: Colors.white70)),
              })),
            );
          },
        ),
      })),
    ));
  }
  void _sendGiftSheet() {
    String cat = 'Hot';
    String target = 'All';
    int qty = 1;
    int selectedIdx = 0;

    final Map<String, List<Map<String, dynamic>>> catalog = {
      'Anniversary': List<Map<String, dynamic>>.of({
        {'ic': '🎂', 'name': 'Birthday Hala', 'cost': 500},
        {'ic': '🎉', 'name': 'Party Confetti', 'cost': 1000},
        {'ic': '🥂', 'name': 'Golden Toast', 'cost': 5000},
        {'ic': '👑', 'name': 'Anniversary Crown', 'cost': 50000},
      }),
      'Hot': List<Map<String, dynamic>>.of({
        {'ic': '🧧', 'name': 'Lucky Bag', 'cost': 100},
        {'ic': '🐘', 'name': 'HalaElephant', 'cost': 100},
        {'ic': '💖', 'name': 'Heart', 'cost': 100},
        {'ic': '🔦', 'name': 'Light Stick', 'cost': 200},
        {'ic': '🍹', 'name': 'Beverage', 'cost': 300},
        {'ic': '🍦', 'name': 'Ice Cream', 'cost': 500},
        {'ic': '📿', 'name': 'Pendant', 'cost': 750},
        {'ic': '🎤', 'name': 'Mic', 'cost': 1000},
        {'ic': '☕', 'name': 'Coffee', 'cost': 1500},
        {'ic': '🥁', 'name': 'Drum', 'cost': 2000},
        {'ic': '💄', 'name': 'Lipstick', 'cost': 3000},
        {'ic': '🪄', 'name': 'Magic Carpet', 'cost': 4500},
        {'ic': '🦄', 'name': 'Bouncy Pony', 'cost': 6000},
        {'ic': '👑', 'name': 'Crown', 'cost': 10000},
        {'ic': '🔫', 'name': 'Money Gun', 'cost': 30000},
        {'ic': '💍', 'name': 'Emerald Ring', 'cost': 48000},
        {'ic': '🐱', 'name': 'Cup Cat', 'cost': 58000},
        {'ic': '🏰', 'name': 'Castle Feast', 'cost': 100000},
        {'ic': '🏎️', 'name': 'Golden Sports Car', 'cost': 250000},
        {'ic': '❄️', 'name': 'Ice Castle', 'cost': 500000},
        {'ic': '👼', 'name': 'Heavenly King', 'cost': 600000},
        {'ic': '🐘', 'name': 'Treasure Elephant', 'cost': 700000},
        {'ic': '🚘', 'name': 'Blitz Maserati', 'cost': 888888},
      }),
      'Lucky': List<Map<String, dynamic>>.of({
        {'ic': '🍭', 'name': 'Lollipop', 'cost': 10},
        {'ic': '🍾', 'name': 'Hala Champagne', 'cost': 10},
        {'ic': '🐚', 'name': 'Capiz', 'cost': 20},
        {'ic': '🧸', 'name': 'Teddy Bear', 'cost': 50},
        {'ic': '⭐', 'name': 'Star', 'cost': 50},
        {'ic': '🍺', 'name': 'Beer', 'cost': 70},
        {'ic': '🪙', 'name': 'Gold Bar', 'cost': 100},
        {'ic': '🎧', 'name': 'Headphones', 'cost': 2000},
        {'ic': '🪔', 'name': 'Magic Lamp', 'cost': 5000},
        {'ic': '⏳', 'name': 'Hourglass', 'cost': 5000},
        {'ic': '🪄', 'name': 'Magic Wand', 'cost': 10000},
      }),
      'Luxury': List<Map<String, dynamic>>.of({
        {'ic': '🚢', 'name': 'Titanic', 'cost': 1000000},
        {'ic': '🌃', 'name': 'Sky Romance', 'cost': 1299999},
        {'ic': '🥂', 'name': 'Champagne Night', 'cost': 1399999},
        {'ic': '💞', 'name': 'Sweet Confession', 'cost': 1699999},
        {'ic': '🌹', 'name': 'Rose Sprite', 'cost': 1999999},
        {'ic': '🚀', 'name': 'Love Rocket', 'cost': 2000000},
        {'ic': '🎈', 'name': 'Hot Air Balloon', 'cost': 2000000},
        {'ic': '🛳️', 'name': 'Aircraft Carrier', 'cost': 3000000},
        {'ic': '🪑', 'name': 'Golden Throne King', 'cost': 4000000},
        {'ic': '🏯', 'name': 'Dream Castle', 'cost': 4000000},
        {'ic': '🧑‍🚀', 'name': 'Astro-Heart', 'cost': 4999999},
      }),
      'Intimacy': List<Map<String, dynamic>>.of({
        {'ic': '💗', 'name': 'Intimate Heart', 'cost': 188},
        {'ic': '🌹', 'name': 'Intimate Rose', 'cost': 18888},
        {'ic': '🕊️', 'name': 'CP Bird', 'cost': 19999},
        {'ic': '💍', 'name': 'CP Ring', 'cost': 79999},
        {'ic': '🎀', 'name': 'Intimate Cable', 'cost': 288888},
        {'ic': '🌍', 'name': 'CP Global', 'cost': 999999},
      }),
    };

    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: const Color(0xFF0B1120), builder: (ctx) => StatefulBuilder(builder: (ctx, setG) {
      final list = catalog[cat] ?? catalog['Hot']!;
      if (selectedIdx >= list.length) selectedIdx = 0;
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Column(mainAxisSize: MainAxisSize.min, children: List<Widget>.of({
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List<Widget>.of({
            Text('Recipient: $target', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12)),
            Wrap(spacing: 6, children: List<String>.of({'All', 'Host', 'Self'}).map((t) => ChoiceChip(
              label: Text(t, style: const TextStyle(fontSize: 10)),
              selected: target == t,
              selectedColor: Colors.tealAccent,
              labelStyle: TextStyle(color: target == t ? Colors.black : Colors.white),
              onSelected: (_) => setG(() => target = t),
            )).toList()),
          })),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: catalog.keys.map((c) => Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ChoiceChip(label: Text(c, style: const TextStyle(fontSize: 11)), selected: cat == c, selectedColor: Colors.amber, labelStyle: TextStyle(color: cat == c ? Colors.black : Colors.white, fontWeight: FontWeight.bold), onSelected: (_) => setG(() { cat = c; selectedIdx = 0; })),
            )).toList()),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 215,
            child: GridView.builder(
              itemCount: list.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 6, mainAxisSpacing: 6, childAspectRatio: 0.85),
              itemBuilder: (_, i) {
                final g = list.elementAt(i);
                final sel = selectedIdx == i;
                return InkWell(
                  onTap: () => setG(() => selectedIdx = i),
                  child: Container(
                    decoration: BoxDecoration(color: sel ? Colors.teal.withOpacity(0.3) : const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12), border: Border.all(color: sel ? Colors.tealAccent : Colors.white12, width: sel ? 2 : 1)),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: List<Widget>.of({
                      Text(g['ic'] as String, style: const TextStyle(fontSize: 24)),
                      Text(g['name'] as String, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text('🪙 ${g['cost']}', style: const TextStyle(fontSize: 9.5, color: Colors.amber)),
                    })),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(children: List<Widget>.of({
            Text('🪙 ${AppState.coins} >', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 14)),
            const Spacer(),
            DropdownButton<int>(value: qty, items: List<int>.of({1, 5, 10, 99}).map((q) => DropdownMenuItem(value: q, child: Text('x$q'))).toList(), onChanged: (v) => setG(() => qty = v ?? 1)),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
              onPressed: () {
                final g = list.elementAt(selectedIdx);
                final total = (g['cost'] as int) * qty;
                if (AppState.coins >= total) {
                  SystemSound.play(SystemSoundType.click);
                  HapticFeedback.heavyImpact();
                  setState(() {
                    AppState.coins -= total;
                    AppState.points += total * 0.7;
                    _logs.add({'type': 'Room', 'text': '🎁 ${AppState.userName} sent ${g['ic']} ${g['name']} x$qty (🪙 $total) to $target!'});
                  });
                  widget.onUpd();
                  Navigator.pop(ctx);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('Not enough Coins! Recharge first.')));
                }
              },
              child: const Text('Send', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          })),
        })),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    final is30 = _micCount == 30;
    final filteredLogs = _logFilter == 'All' ? _logs : _logs.where((l) => l['type'] == _logFilter).toList();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: <Color>[Color(widget.room['c1'] as int), Color(widget.room['c2'] as int), const Color(0xFF090D16)])),
        child: SafeArea(
          child: Column(children: List<Widget>.of({
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Row(children: List<Widget>.of({
                CircleAvatar(backgroundColor: Colors.amber, child: Text((widget.room['host'] as String).substring(0, 1), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                const SizedBox(width: 8),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: List<Widget>.of({
                  Text(widget.room['title'] as String, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text('ID:${AppState.userId} • $_micCount Seats Mode', style: const TextStyle(fontSize: 10, color: Colors.amber)),
                }))),
                TextButton(
                  onPressed: () => setState(() => _micCount = is30 ? 9 : 30),
                  child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(10)), child: Text(is30 ? '9 Mics' : '30 Mics', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black))),
                ),
                IconButton(tooltip: 'Minimize Room & Do Tasks', icon: const Icon(Icons.picture_in_picture_alt, color: Colors.tealAccent), onPressed: _minimizeRoom),
                IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () { AppState.floatingRoom = null; widget.onUpd(); Navigator.pop(context); }),
              })),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(gradient: const LinearGradient(colors: <Color>[Color(0xFF1B4332), Color(0xFF7F4F24)]), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.amber)),
              child: Row(children: List<Widget>.of({
                Expanded(child: Text('🎰 ${AppState.lastBigWinner}', overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white))),
                const SizedBox(width: 6),
                InkWell(onTap: _openQuickInRoomGame, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(10)), child: const Text('Play >', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)))),
              })),
            ),
            SizedBox(
              height: is30 ? 255 : 205,
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                itemCount: _micCount,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: is30 ? 6 : 3, crossAxisSpacing: 6, mainAxisSpacing: 6, childAspectRatio: is30 ? 0.85 : 1.18),
                itemBuilder: (_, i) {
                  final seatNum = i + 1;
                  final isHost = seatNum == 1;
                  final isMine = _mySeat == seatNum;
                  return InkWell(
                    onTap: () => setState(() => _mySeat = isMine ? 0 : seatNum),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: List<Widget>.of({
                      CircleAvatar(
                        radius: is30 ? 15 : 21,
                        backgroundColor: isHost || isMine ? Colors.amber : Colors.white12,
                        child: Icon(isHost || isMine ? Icons.mic : Icons.chair_alt, size: is30 ? 14 : 19, color: isHost || isMine ? Colors.black : Colors.amber),
                      ),
                      const SizedBox(height: 2),
                      Text(isHost ? (widget.room['host'] as String) : (isMine ? AppState.userName : '$seatNum'), overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 9, color: Colors.white)),
                    })),
                  );
                },
              ),
            ),
            Expanded(
              child: Row(children: List<Widget>.of({
                Column(mainAxisAlignment: MainAxisAlignment.center, children: List<String>.of({'All', 'Room', 'Chat'}).map((f) => InkWell(
                  onTap: () => setState(() => _logFilter = f),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    decoration: BoxDecoration(color: _logFilter == f ? Colors.tealAccent : Colors.black45, borderRadius: BorderRadius.circular(8)),
                    child: Text(f, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _logFilter == f ? Colors.black : Colors.white70)),
                  ),
                )).toList()),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    itemCount: filteredLogs.length,
                    itemBuilder: (_, i) => Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(10)),
                      child: Text(filteredLogs.elementAt(i)['text'] ?? '', style: const TextStyle(fontSize: 11.5, color: Colors.white)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Column(mainAxisAlignment: MainAxisAlignment.end, children: List<Widget>.of({
                    InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskCenterPage(onUpd: () { setState(() {}); widget.onUpd(); }))),
                      child: Container(padding: const EdgeInsets.all(7), decoration: BoxDecoration(color: Colors.teal.shade700, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.amber)), child: const Column(children: <Widget>[Icon(Icons.task_alt, color: Colors.amber, size: 20), Text('Task', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold))])),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _openQuickInRoomGame,
                      child: Container(padding: const EdgeInsets.all(7), decoration: BoxDecoration(color: Colors.purple.shade800, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.amber)), child: const Column(children: <Widget>[Text('🎰', style: TextStyle(fontSize: 16)), Text('Play', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold))])),
                    ),
                    const SizedBox(height: 8),
                  })),
                ),
              })),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              color: Colors.black54,
              child: Row(children: List<Widget>.of({
                Expanded(child: TextField(controller: _chatCtrl, decoration: const InputDecoration(hintText: 'Say Hello...', isDense: true, border: InputBorder.none))),
                IconButton(icon: const Icon(Icons.send, color: Colors.tealAccent, size: 20), onPressed: () {
                  if (_chatCtrl.text.trim().isNotEmpty && !AppState.hasProfanity(_chatCtrl.text)) {
                    setState(() { _logs.add({'type': 'Chat', 'text': '💬 ${AppState.userName}: ${_chatCtrl.text.trim()}'}); _chatCtrl.clear(); });
                  }
                }),
                IconButton(icon: Icon(_muted ? Icons.mic_off : Icons.mic, color: _muted ? Colors.redAccent : Colors.white, size: 20), onPressed: () => setState(() => _muted = !_muted)),
                IconButton(icon: const Icon(Icons.sports_esports, color: Colors.purpleAccent, size: 22), onPressed: _openQuickInRoomGame),
                IconButton(icon: const Icon(Icons.card_giftcard, color: Colors.amber, size: 22), onPressed: _sendGiftSheet),
                IconButton(icon: const Icon(Icons.grid_view_rounded, color: Colors.white70, size: 22), onPressed: _openBasicTools),
              })),
            ),
          })),
        ),
      ),
    );
  }
}
