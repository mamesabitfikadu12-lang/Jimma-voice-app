import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'games_moments.dart';
import 'me_pages.dart';
import 'task_settings_admin.dart';

void main() => runApp(const EthioVoiceApp());

class AppState {
  static String userName = 'Ethio_User_${Random().nextInt(900) + 100}';
  static String userId = '${Random().nextInt(8999999) + 1000000}';
  static int coins = 0;
  static double points = 0.0;
  static int vipLevel = 0;
  static int wealthLv = 1;
  static int gamesPlayedToday = 0;
  static int roomMinutesToday = 0;
  static bool inviteClaimed = false;
  static String agencyStatus = 'None';
  static String pendingAgencyName = '';
  static String pendingNationalId = '';
  static bool msgBanner = true;
  static bool msgSound = true;
  static Map<String, dynamic>? floatingRoom;

  static final Set<String> claimedTasks = <String>{};
  static final List<Map<String, String>> moments = <Map<String, String>>[
    {'user': 'Biftu_Oromia', 'tag': '#OromoCulture', 'text': 'Baga nagaan gara ኢትዮ-ድምጽ dhuftan! Barumsa fi tapha gaarii!', 'likes': '48', 'img': ''},
    {'user': 'Dawit_Finfinnee', 'tag': '#EthioVoice', 'text': 'Jungle Hunt 20 Lines irraa 5X mo\'adheera!', 'likes': '92', 'img': ''},
  ];
  static final List<Map<String, String>> chatMessages = <Map<String, String>>[
    {'sender': 'Ethio-Voice Official', 'type': 'text', 'content': 'Welcome! Enjoy 100% Free Chat, Live Rooms & 24 HD Games!', 'time': 'Now'},
  ];
  static final List<Map<String, String>> notifications = <Map<String, String>>[
    {'title': 'Daily 24h Tasks Ready', 'body': 'Complete Daily Tasks & Host Mic Tasks every 24 hours for free Coins & Points!'},
  ];

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
      home: const MainShell(),
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
  final _chatCtrl = TextEditingController();
  final List<String> _logs = List<String>.of({
    '🔔 System: Welcome to the live education & voice chat room! Respectful language only.',
    '📢 Announcement: Tap Minimize anytime to do Daily Tasks while listening!',
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
  }  void _openQuickInRoomGame() {
    showModalBottomSheet(context: context, backgroundColor: const Color(0xFF111827), builder: (ctx) => Padding(
      padding: const EdgeInsets.all(16),
      child: Column(mainAxisSize: MainAxisSize.min, children: List<Widget>.of({
        Text('🎮 Quick In-Room Mini Games • 🪙 ${AppState.coins}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber)),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List<Widget>.of({
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black), onPressed: () {
            if (AppState.coins >= 100) {
              final win = Random().nextBool();
              setState(() {
                AppState.coins += win ? 100 : -100;
                _logs.add(win ? '🎲 ${AppState.userName} won +200 Coins in Lucky Dice!' : '🎲 ${AppState.userName} rolled Lucky Dice — Try Again!');
              });
              widget.onUpd();
              Navigator.pop(ctx);
            }
          }, child: const Text('🎲 Lucky Dice (100)')),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black), onPressed: () {
            if (AppState.coins >= 500) {
              final win = Random().nextInt(100) < 40;
              setState(() {
                AppState.coins += win ? 1000 : -500;
                _logs.add(win ? '🎡 ${AppState.userName} hit 3X (+1,500 Coins) on Quick Wheel!' : '🎡 ${AppState.userName} spun Quick Wheel — Try Again!');
              });
              widget.onUpd();
              Navigator.pop(ctx);
            }
          }, child: const Text('🎡 Quick Wheel (500)')),
        })),
      })),
    ));
  }

  void _sendGiftSheet() {
    final gifts = List<Map<String, dynamic>>.of({
      {'name': '☕ Jebena Coffee', 'cost': 100},
      {'name': '🌹 Oromo Rose', 'cost': 500},
      {'name': '🦁 Abyssinia Lion', 'cost': 2000},
      {'name': '🏰 Abba Jifar Palace', 'cost': 10000},
    });
    showModalBottomSheet(context: context, backgroundColor: const Color(0xFF111827), builder: (ctx) => Padding(
      padding: const EdgeInsets.all(14),
      child: Column(mainAxisSize: MainAxisSize.min, children: List<Widget>.of({
        Text('Send Gift • 🪙 ${AppState.coins}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
        const SizedBox(height: 10),
        Wrap(spacing: 10, runSpacing: 10, children: gifts.map((g) => ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E293B), foregroundColor: Colors.white),
          onPressed: () {
            final cost = g['cost'] as int;
            if (AppState.coins >= cost) {
              setState(() {
                AppState.coins -= cost;
                AppState.points += cost * 0.7;
                _logs.add('🎁 ${AppState.userName} sent ${g['name']} (🪙 $cost) to ${widget.room['host']}!');
              });
              widget.onUpd();
              Navigator.pop(ctx);
            }
          },
          child: Text('${g['name']} (${g['cost']})'),
        )).toList()),
      })),
    ));
  }
  @override
  Widget build(BuildContext context) {
    final is30 = _micCount == 30;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: <Color>[Color(widget.room['c1'] as int), Color(widget.room['c2'] as int), const Color(0xFF090D16)])),
        child: SafeArea(
          child: Column(children: List<Widget>.of({
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
            SizedBox(
              height: is30 ? 275 : 220,
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                itemCount: _micCount,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: is30 ? 6 : 3, crossAxisSpacing: 6, mainAxisSpacing: 6, childAspectRatio: is30 ? 0.82 : 1.15),
                itemBuilder: (_, i) {
                  final seatNum = i + 1;
                  final isHost = seatNum == 1;
                  final isMine = _mySeat == seatNum;
                  return InkWell(
                    onTap: () => setState(() => _mySeat = isMine ? 0 : seatNum),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: List<Widget>.of({
                      CircleAvatar(
                        radius: is30 ? 16 : 22,
                        backgroundColor: isHost || isMine ? Colors.amber : Colors.white12,
                        child: Icon(isHost || isMine ? Icons.mic : Icons.chair_alt, size: is30 ? 15 : 20, color: isHost || isMine ? Colors.black : Colors.amber),
                      ),
                      const SizedBox(height: 2),
                      Text(isHost ? (widget.room['host'] as String) : (isMine ? AppState.userName : '$seatNum'), overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 9, color: Colors.white)),
                    })),
                  );
                },
              ),
            ),
            Expanded(
              child: Stack(children: List<Widget>.of({
                ListView.builder(
                  padding: const EdgeInsets.only(left: 12, right: 72, top: 6, bottom: 6),
                  itemCount: _logs.length,
                  itemBuilder: (_, i) => Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(10)),
                    child: Text(_logs.elementAt(i), style: const TextStyle(fontSize: 12, color: Colors.white)),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Column(children: List<Widget>.of({
                    InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskCenterPage(onUpd: () { setState(() {}); widget.onUpd(); }))),
                      child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.teal.shade700, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.amber)), child: const Column(children: <Widget>[Icon(Icons.task_alt, color: Colors.amber, size: 22), Text('Task', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))])),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _openQuickInRoomGame,
                      child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.purple.shade800, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.amber)), child: const Column(children: <Widget>[Text('🎰', style: TextStyle(fontSize: 18)), Text('Play', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))])),
                    ),
                  })),
                ),
              })),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              color: Colors.black54,
              child: Row(children: List<Widget>.of({
                Expanded(child: TextField(controller: _chatCtrl, decoration: const InputDecoration(hintText: 'Say Hello...', isDense: true, border: InputBorder.none))),
                IconButton(icon: const Icon(Icons.send, color: Colors.tealAccent), onPressed: () {
                  if (_chatCtrl.text.trim().isNotEmpty && !AppState.hasProfanity(_chatCtrl.text)) {
                    setState(() { _logs.add('💬 ${AppState.userName}: ${_chatCtrl.text.trim()}'); _chatCtrl.clear(); });
                  }
                }),
                IconButton(icon: Icon(_muted ? Icons.mic_off : Icons.mic, color: _muted ? Colors.redAccent : Colors.white), onPressed: () => setState(() => _muted = !_muted)),
                IconButton(icon: const Icon(Icons.sports_esports, color: Colors.purpleAccent), onPressed: _openQuickInRoomGame),
                IconButton(icon: const Icon(Icons.card_giftcard, color: Colors.amber), onPressed: _sendGiftSheet),
              })),
            ),
          })),
        ),
      ),
    );
  }
}

