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

class RoomsTab extends StatefulWidget {
  final VoidCallback onUpd;
  const RoomsTab({super.key, required this.onUpd});
  @override
  State<RoomsTab> createState() => _RoomsTabState();
}

class _RoomsTabState extends State<RoomsTab> {
  String _country = 'All';
  final _countries = ['All', 'Ethiopia', 'Kenya', 'UAE', 'Saudi Arabia', 'USA', 'UK', 'Germany', 'South Africa', 'Nigeria', 'India', 'Global'];
  final _rooms = [
    {'title': 'Oromia & Jimma Coffee Lounge ☕', 'host': 'Abba Jifar Heritage', 'country': 'Ethiopia', 'users': '48', 'tag': 'Music & Culture'},
    {'title': 'Finfinnee Night Party 👑', 'host': 'Queen Selam', 'country': 'Ethiopia', 'users': '62', 'tag': 'Live PK'},
    {'title': 'Global Afro-Oromo Vibes 🌍', 'host': 'DJ Bekele', 'country': 'Global', 'users': '35', 'tag': 'Chill & Chat'},
    {'title': 'Dubai & Riyadh Habesha Room 🇦🇪', 'host': 'Nadia M.', 'country': 'UAE', 'users': '29', 'tag': 'Make Friends'},
    {'title': 'Nairobi East Africa Lounge 🇰🇪', 'host': 'Kiprop Live', 'country': 'Kenya', 'users': '19', 'tag': 'Dating & Fun'},
    {'title': 'London & USA Diaspora Hub 🇬🇧', 'host': 'Dawit T.', 'country': 'USA', 'users': '41', 'tag': 'World Cup 2026'},
  ];

  void _openLiveRoom(Map<String, String> r) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            children: [
              AppBar(title: Text(r['title']!), automaticallyImplyLeading: false, actions: [
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx))
              ]),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text('👑 Abba Jifar Royal Palace Theme • 8 Mic Seats Open', style: TextStyle(color: Colors.amber)),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 12, crossAxisSpacing: 12),
                  itemCount: 8,
                  itemBuilder: (_, i) => Container(
                    decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.amber.withOpacity(0.4))),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(i == 0 ? Icons.record_voice_over : Icons.mic_none, color: i == 0 ? Colors.amber : Colors.white54),
                      const SizedBox(height: 4),
                      Text(i == 0 ? 'Host' : 'Seat ${i + 1}', style: const TextStyle(fontSize: 11)),
                    ]),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                color: const Color(0xFF1E293B),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                      icon: const Icon(Icons.card_giftcard),
                      label: const Text('Send Jebena Gift (100)'),
                      onPressed: () {
                        if (AppState.coins >= 100) {
                          AppState.coins -= 100;
                          AppState.wealthLv = (AppState.wealthLv + 1).clamp(1, 30);
                          SystemSound.play(SystemSoundType.click);
                          widget.onUpd();
                          setS(() {});
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('☕ Sent Oromo Jebena Coffee Gift! Wealth XP +100')));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Insufficient Coins! Recharge in Me > Wallet')));
                        }
                      },
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.casino),
                      label: const Text('Mini Slot'),
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _country == 'All' ? _rooms : _rooms.where((r) => r['country'] == _country).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Jimma Voice Chat Family')),
      body: Column(
        children: [
          SizedBox(
            height: 46,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              itemCount: _countries.length,
              itemBuilder: (_, i) {
                final c = _countries[i];
                final sel = c == _country;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(c),
                    selected: sel,
                    selectedColor: const Color(0xFFFFB703),
                    labelStyle: TextStyle(color: sel ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
                    onSelected: (_) => setState(() => _country = c),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final r = filtered[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    leading: const CircleAvatar(backgroundColor: Color(0xFFFFB703), child: Icon(Icons.graphic_eq, color: Colors.black)),
                    title: Text(r['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${r['host']} • ${r['country']} • ${r['tag']}'),
                    trailing: Chip(label: Text('🔥 ${r['users']}'), backgroundColor: Colors.teal.shade800),
                    onTap: () => _openLiveRoom(r),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GamesTab extends StatefulWidget {
  final VoidCallback onUpd;
  const GamesTab({super.key, required this.onUpd});
  @override
  State<GamesTab> createState() => _GamesTabState();
}

class _GamesTabState extends State<GamesTab> {
  final _symbols = ['☕ Jebena', '🏰 Palace', '🐎 Oromo Horse', '🪑 Royal Stool', '🦁 Lion', '💎 Diamond'];
  List<String> _reels = ['☕ Jebena', '🏰 Palace', '🐎 Oromo Horse'];
  int _bet = 100;
  bool _spinning = false;
  String _selectedGame = 'Oromia & Abba Jifar Royal Slot';

  final _gamesList = [
    ['Oromia & Abba Jifar Royal Slot', '☕🏰🐎', Color(0xFFB45309)],
    ['Royal Battle Arena', '⚔️👑🛡️', Color(0xFF7C3AED)],
    ['Fishing Tycoon Abay', '🐟🌊⚓', Color(0xFF0284C7)],
    ['Jungle Hunt Bale', '🦁🌲🏹', Color(0xFF15803D)],
    ['Oromo Horse Derby', '🐎🏆🎖️', Color(0xFFBE123C)],
    ['Jebena Coffee Fortune', '☕✨💰', Color(0xFFD97706)],
    ['Abyssinian Treasure', '🏺👑💎', Color(0xFF4338CA)],
    ['Finfinnee Lucky Wheel', '🎡🎯🌟', Color(0xFF0F766E)],
    ['Ludo Star Ethiopia', '🎲🏠🏅', Color(0xFF9333EA)],
    ['Domino Master', '🁣🁢🔥', Color(0xFF334155)],
    ['Golden Lion Dice', '🎲🦁💛', Color(0xFFA16207)],
    ['World Cup 2026 Penalty', '⚽🥅🏆', Color(0xFF047857)],
  ];

  void _spin() {
    if (_spinning) return;
    if (AppState.coins < _bet) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not enough Coins! Please Recharge first.')));
      return;
    }
    setState(() {
      _spinning = true;
      AppState.coins -= _bet;
    });
    widget.onUpd();
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.lightImpact();

    int ticks = 0;
    Timer.periodic(const Duration(milliseconds: 90), (t) {
      ticks++;
      SystemSound.play(SystemSoundType.click);
      setState(() {
        _reels = List.generate(3, (_) => _symbols[Random().nextInt(_symbols.length)]);
      });
      if (ticks >= 12) {
        t.cancel();
        final win = Random().nextInt(100) < 35; // 35% Player Win, 65% App House Profit
        if (win) {
          final pick = _symbols[Random().nextInt(_symbols.length)];
          final payout = _bet * 2;
          AppState.coins += payout;
          HapticFeedback.heavyImpact();
          SystemSound.play(SystemSoundType.alert);
          setState(() {
            _reels = [pick, pick, pick];
            _spinning = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('🎉 JACKPOT! Matched $pick (+$payout Coins)')));
        } else {
          setState(() {
            _reels = [_symbols, _symbols, _symbols];
            _spinning = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Try again! Next spin could hit the Royal Palace!')));
        }
        widget.onUpd();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Games • Coins: ${AppState.coins}')),
      body: ListView(
EOFcat << 'EOF' > jimma_voice_app/lib/rooms_games.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';

class RoomsTab extends StatefulWidget {
  final VoidCallback onUpd;
  const RoomsTab({super.key, required this.onUpd});
  @override
  State<RoomsTab> createState() => _RoomsTabState();
}

class _RoomsTabState extends State<RoomsTab> {
  String _country = 'All';
  final _countries = ['All', 'Ethiopia', 'Kenya', 'UAE', 'Saudi Arabia', 'USA', 'UK', 'Germany', 'South Africa', 'Nigeria', 'India', 'Global'];
  final _rooms = [
    {'title': 'Oromia & Jimma Coffee Lounge ☕', 'host': 'Abba Jifar Heritage', 'country': 'Ethiopia', 'users': '48', 'tag': 'Music & Culture'},
    {'title': 'Finfinnee Night Party 👑', 'host': 'Queen Selam', 'country': 'Ethiopia', 'users': '62', 'tag': 'Live PK'},
    {'title': 'Global Afro-Oromo Vibes 🌍', 'host': 'DJ Bekele', 'country': 'Global', 'users': '35', 'tag': 'Chill & Chat'},
    {'title': 'Dubai & Riyadh Habesha Room 🇦🇪', 'host': 'Nadia M.', 'country': 'UAE', 'users': '29', 'tag': 'Make Friends'},
    {'title': 'Nairobi East Africa Lounge 🇰🇪', 'host': 'Kiprop Live', 'country': 'Kenya', 'users': '19', 'tag': 'Dating & Fun'},
    {'title': 'London & USA Diaspora Hub 🇬🇧', 'host': 'Dawit T.', 'country': 'USA', 'users': '41', 'tag': 'World Cup 2026'},
  ];

  void _openLiveRoom(Map<String, String> r) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            children: [
              AppBar(title: Text(r['title']!), automaticallyImplyLeading: false, actions: [
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx))
              ]),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text('👑 Abba Jifar Royal Palace Theme • 8 Mic Seats Open', style: TextStyle(color: Colors.amber)),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 12, crossAxisSpacing: 12),
                  itemCount: 8,
                  itemBuilder: (_, i) => Container(
                    decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.amber.withOpacity(0.4))),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(i == 0 ? Icons.record_voice_over : Icons.mic_none, color: i == 0 ? Colors.amber : Colors.white54),
                      const SizedBox(height: 4),
                      Text(i == 0 ? 'Host' : 'Seat ${i + 1}', style: const TextStyle(fontSize: 11)),
                    ]),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                color: const Color(0xFF1E293B),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                  icon: const Icon(Icons.card_giftcard),
                  label: const Text('Send Jebena Gift (100 Coins)'),
                  onPressed: () {
                    if (AppState.coins >= 100) {
                      AppState.coins -= 100;
                      AppState.wealthLv = (AppState.wealthLv + 1).clamp(1, 30);
                      SystemSound.play(SystemSoundType.click);
                      widget.onUpd();
                      setS(() {});
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('☕ Sent Oromo Jebena Coffee Gift! Wealth XP +100')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Insufficient Coins! Recharge in Me > Wallet')));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _country == 'All' ? _rooms : _rooms.where((r) => r['country'] == _country).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Jimma Voice Chat Family')),
      body: Column(
        children: [
          SizedBox(
            height: 46,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              itemCount: _countries.length,
              itemBuilder: (_, i) {
                final c = _countries[i];
                final sel = c == _country;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(c),
                    selected: sel,
                    selectedColor: const Color(0xFFFFB703),
                    labelStyle: TextStyle(color: sel ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
                    onSelected: (_) => setState(() => _country = c),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final r = filtered[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    leading: const CircleAvatar(backgroundColor: Color(0xFFFFB703), child: Icon(Icons.graphic_eq, color: Colors.black)),
                    title: Text(r['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${r['host']} • ${r['country']} • ${r['tag']}'),
                    trailing: Chip(label: Text('🔥 ${r['users']}'), backgroundColor: Colors.teal.shade800),
                    onTap: () => _openLiveRoom(r),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
