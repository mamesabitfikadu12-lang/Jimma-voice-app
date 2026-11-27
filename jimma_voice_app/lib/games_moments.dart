import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'main.dart';

class GamesLobbyPage extends StatefulWidget {
  final VoidCallback onUpd;
  const GamesLobbyPage({super.key, required this.onUpd});
  @override
  State<GamesLobbyPage> createState() => _GamesLobbyPageState();
}

class _GamesLobbyPageState extends State<GamesLobbyPage> {
  String _cat = 'All';
  int _rounds = 0;
  bool _claimed = false;

  static const List<Map<String, dynamic>> _games = [
    {'name': 'TeenPattiPro', 'cat': 'Card', 'tag': 'PRO', 'c1': 0xFFB91C1C, 'c2': 0xFFF59E0B, 'icon': Icons.style},
    {'name': 'GreedyLion', 'cat': 'Wheel', 'tag': 'HOT', 'c1': 0xFFD97706, 'c2': 0xFF7C2D12, 'icon': Icons.pets},
    {'name': 'Lucky77', 'cat': 'Wheel', 'tag': 'HOT', 'c1': 0xFF7C3AED, 'c2': 0xFFEC4899, 'icon': Icons.casino},
    {'name': 'Lucky77 Pro', 'cat': 'Wheel', 'tag': 'PRO', 'c1': 0xFF991B1B, 'c2': 0xFFFACC15, 'icon': Icons.looks_one},
    {'name': 'GreedyKing', 'cat': 'Wheel', 'tag': 'HOT', 'c1': 0xFF15803D, 'c2': 0xFFF97316, 'icon': Icons.restaurant},
    {'name': 'TigerSlot', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFFDC2626, 'c2': 0xFFF59E0B, 'icon': Icons.grid_on},
    {'name': 'FruitParty', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFFBE185D, 'c2': 0xFF8B5CF6, 'icon': Icons.local_florist},
    {'name': 'MahjongSlot', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF047857, 'c2': 0xFF10B981, 'icon': Icons.grid_view},
    {'name': 'BigEater', 'cat': 'Wheel', 'tag': 'HOT', 'c1': 0xFF059669, 'c2': 0xFFEAB308, 'icon': Icons.fastfood},
    {'name': 'GreedyStar', 'cat': 'Wheel', 'tag': 'NEW', 'c1': 0xFF6D28D9, 'c2': 0xFF06B6D4, 'icon': Icons.star},
    {'name': 'GreedyBox', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFFB45309, 'c2': 0xFFFDE047, 'icon': Icons.inventory_2},
    {'name': 'PirateKing', 'cat': 'Fishing', 'tag': 'HOT', 'c1': 0xFF0369A1, 'c2': 0xFFF97316, 'icon': Icons.sailing},
    {'name': 'Gates Of Olympus', 'cat': 'Slot', 'tag': 'NEW', 'c1': 0xFF1D4ED8, 'c2': 0xFF38BDF8, 'icon': Icons.flash_on},
    {'name': 'Ocean Hunt', 'cat': 'Fishing', 'tag': 'HOT', 'c1': 0xFF0284C7, 'c2': 0xFF2DD4BF, 'icon': Icons.scuba_diving},
    {'name': 'Jungle Hunt', 'cat': 'Fishing', 'tag': 'HOT', 'c1': 0xFF166534, 'c2': 0xFFCA8A04, 'icon': Icons.forest},
    {'name': 'Garo Gems I', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFFB45309, 'c2': 0xFFF59E0B, 'icon': Icons.diamond},
    {'name': 'Garo Gems II', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF9A3412, 'c2': 0xFFFBBF24, 'icon': Icons.diamond},
    {'name': 'Garo Gems III', 'cat': 'Slot', 'tag': 'NEW', 'c1': 0xFF854D0E, 'c2': 0xFFFDE047, 'icon': Icons.diamond},
    {'name': 'Fishing Tycoon', 'cat': 'Fishing', 'tag': 'HOT', 'c1': 0xFF0E7490, 'c2': 0xFF10B981, 'icon': Icons.phishing},
    {'name': 'The Monkey King', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF991B1B, 'c2': 0xFFEAB308, 'icon': Icons.auto_awesome},
    {'name': 'Starlight Princess', 'cat': 'Slot', 'tag': 'NEW', 'c1': 0xFF7E22CE, 'c2': 0xFFF472B6, 'icon': Icons.auto_fix_high},
    {'name': 'Money Coming', 'cat': 'Slot', 'tag': 'NEW', 'c1': 0xFF15803D, 'c2': 0xFFFACC15, 'icon': Icons.attach_money},
    {'name': 'Roulette', 'cat': 'Wheel', 'tag': 'HOT', 'c1': 0xFF7F1D1D, 'c2': 0xFFD97706, 'icon': Icons.track_changes},
    {'name': 'Bounty Football', 'cat': 'Card', 'tag': 'NEW', 'c1': 0xFF065F46, 'c2': 0xFF3B82F6, 'icon': Icons.sports_soccer},
    {'name': 'Sweet Bonanza', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFFDB2777, 'c2': 0xFF9333EA, 'icon': Icons.cake},
    {'name': 'Dragon Ball', 'cat': 'Crash', 'tag': 'HOT', 'c1': 0xFF047857, 'c2': 0xFFF59E0B, 'icon': Icons.whatshot},
    {'name': 'Super Ace', 'cat': 'Card', 'tag': 'HOT', 'c1': 0xFFB91C1C, 'c2': 0xFF1E293B, 'icon': Icons.filter_frames},
    {'name': 'ChickenRoad', 'cat': 'Crash', 'tag': 'HOT', 'c1': 0xFFEA580C, 'c2': 0xFFFACC15, 'icon': Icons.directions_run},
    {'name': 'CosmoX', 'cat': 'Crash', 'tag': 'NEW', 'c1': 0xFF1E3A8A, 'c2': 0xFF38BDF8, 'icon': Icons.flight_takeoff},
    {'name': 'Ludo 3D', 'cat': 'Card', 'tag': 'MULTI', 'c1': 0xFF2563EB, 'c2': 0xFF16A34A, 'icon': Icons.sports_esports},
    {'name': 'CrashRocket', 'cat': 'Crash', 'tag': 'HOT', 'c1': 0xFF4338CA, 'c2': 0xFFEC4899, 'icon': Icons.rocket_launch},
    {'name': 'Dragon & Tiger 2', 'cat': 'Card', 'tag': 'HOT', 'c1': 0xFF1D4ED8, 'c2': 0xFFDC2626, 'icon': Icons.compare_arrows},
    {'name': 'Bounty Racing', 'cat': 'Crash', 'tag': 'HOT', 'c1': 0xFF6D28D9, 'c2': 0xFFF43F5E, 'icon': Icons.directions_car},
    {'name': 'Royal TeenPatti', 'cat': 'Card', 'tag': 'PRO', 'c1': 0xFF7F1D1D, 'c2': 0xFFFACC15, 'icon': Icons.workspace_premium},
    {'name': 'GoldFishing', 'cat': 'Fishing', 'tag': 'HOT', 'c1': 0xFF0284C7, 'c2': 0xFFF59E0B, 'icon': Icons.water},
    {'name': 'Crash Star', 'cat': 'Crash', 'tag': 'HOT', 'c1': 0xFF312E81, 'c2': 0xFF06B6D4, 'icon': Icons.rocket},
  ];

  void _openWebGame(String gameName) {
    setState(() => _rounds++);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _Html5WebSocketGameScreen(
          gameName: gameName,
          onCoinsUpdated: () {
            setState(() {});
            widget.onUpd();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _cat == 'All' ? _games : _games.where((e) => e['cat'] == _cat).toList();
    return Scaffold(
      backgroundColor: const Color(0xFF080D1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        title: Text('HTML5 Live Games (${_games.length})'),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFD97706), Color(0xFFF59E0B)]), borderRadius: BorderRadius.circular(20)),
            child: Row(children: [const Icon(Icons.monetization_on, color: Colors.black, size: 18), const SizedBox(width: 4), Text('${AppState.coins}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))]),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(12, 10, 12, 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: const LinearGradient(colors: [Color(0xFF1E1B4B), Color(0xFF7E22CE), Color(0xFFD97706)]), border: Border.all(color: Colors.amberAccent, width: 1.5)),
            child: Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber, size: 36),
                const SizedBox(width: 10),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('LIVE WEBSOCKET COMPETITION', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.amber, fontSize: 13)), Text('Open 3 HTML5 games -> +10,000 Coins!', style: TextStyle(fontSize: 11, color: Colors.white))])),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                  onPressed: () {
                    if (_rounds >= 3 && !_claimed) {
                      AppState.coins += 10000;
                      _claimed = true;
                      widget.onUpd();
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('🎉 +10,000 Coins Claimed!')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Progress: ${_rounds.clamp(0, 3)}/3')));
                    }
                  },
                  child: Text(_claimed ? 'Done ✅' : '${_rounds.clamp(0, 3)}/3'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: ['All', 'Wheel', 'Slot', 'Crash', 'Card', 'Fishing'].map((c) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(label: Text(c), selected: _cat == c, selectedColor: Colors.amber, labelStyle: TextStyle(color: _cat == c ? Colors.black : Colors.white, fontWeight: FontWeight.bold), onSelected: (_) => setState(() => _cat = c)),
              )).toList(),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.94, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemCount: list.length,
              itemBuilder: (_, i) {
                final g = list[i];
                return GestureDetector(
                  onTap: () => _openWebGame(g['name'] as String),
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(g['c1'] as int), Color(g['c2'] as int)]), border: Border.all(color: Colors.amberAccent, width: 1.5)),
                              child: Center(child: Icon(g['icon'] as IconData, size: 52, color: Colors.white)),
                            ),
                            Positioned(top: 6, right: 6, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(10)), child: Text(g['tag'] as String, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(g['name'] as String, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                    ],
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

class _Html5WebSocketGameScreen extends StatefulWidget {
  final String gameName;
  final VoidCallback onCoinsUpdated;
  const _Html5WebSocketGameScreen({required this.gameName, required this.onCoinsUpdated});
  @override
  State<_Html5WebSocketGameScreen> createState() => _Html5WebSocketGameScreenState();
}

class _Html5WebSocketGameScreenState extends State<_Html5WebSocketGameScreen> {
  late final WebViewController _ctrl;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final encoded = Uri.encodeComponent(widget.gameName);
    final url = 'https://mosabitshob.com{AppState.userId}&coins=${AppState.coins}';
    _ctrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('CoinBridge', onMessageReceived: (msg) {
        final updated = int.tryParse(msg.message);
        if (updated != null) {
          AppState.coins = updated;
          widget.onCoinsUpdated();
        }
      })
      ..setNavigationDelegate(NavigationDelegate(onPageFinished: (_) {
        if (mounted) setState(() => _loading = false);
      }))
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090E1A),
      appBar: AppBar(backgroundColor: const Color(0xFF1E1B4B), title: Text('🎮 ${widget.gameName}')),
      body: Stack(
        children: [
          WebViewWidget(controller: _ctrl),
          if (_loading) const Center(child: CircularProgressIndicator(color: Colors.amber)),
        ],
      ),
    );
  }
}

class MomentsTab extends StatefulWidget {
  final VoidCallback onUpd;
  const MomentsTab({super.key, required this.onUpd});
  @override
  State<MomentsTab> createState() => _MomentsTabState();
}

class _MomentsTabState extends State<MomentsTab> {
  final Set<String> _following = {'100031'};
  final List<Map<String, String>> _friends = [
    {'id': '100031', 'name': 'Selena 🇪🇹', 'msg': 'I am in the voice room! Join now 🎙️'},
    {'id': '616161', 'name': 'YAMAÇ [SVIP 4]', 'msg': 'S-Host • Sending Super Rockets 🚀'},
    {'id': '122238', 'name': 'Cute Kiran', 'msg': 'Come join my party at 9pm tonight!'},
  ];

  void _openPrivateChat(String name, String id) {
    final ctrl = TextEditingController();
    final history = <String>['Nice to see you!', 'How about chatting in my voice chat room?'];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSt) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 14, right: 14, top: 14),
          child: SizedBox(
            height: 360,
            child: Column(
              children: [
                Text('💬 Private Chat • $name (ID: $id)', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                const Divider(),
                Expanded(child: ListView(children: history.map((m) => Card(color: const Color(0xFF1E293B), child: Padding(padding: const EdgeInsets.all(10), child: Text(m)))).toList())),
                Row(
                  children: [
                    Expanded(child: TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'Send Message...'))),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.amber),
                      onPressed: () {
                        if (ctrl.text.trim().isEmpty) return;
                        setSt(() { history.add('Me: ${ctrl.text.trim()}'); ctrl.clear(); });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090E1A),
      appBar: AppBar(backgroundColor: const Color(0xFF1E1B4B), title: const Text('Friends • Follow & Private Chat')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: _friends.map((u) {
          final isFol = _following.contains(u['id']);
          return Card(
            color: const Color(0xFF1E293B),
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.amber, child: Icon(Icons.person, color: Colors.black)),
              title: Text('${u['name']} (ID: ${u['id']})', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(u['msg']!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(icon: const Icon(Icons.chat, color: Colors.cyanAccent), onPressed: () => _openPrivateChat(u['name']!, u['id']!)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: isFol ? Colors.grey : Colors.amber, foregroundColor: Colors.black),
                    onPressed: () => setState(() => isFol ? _following.remove(u['id']) : _following.add(u['id']!)),
                    child: Text(isFol ? 'Following' : '+ Follow'),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
