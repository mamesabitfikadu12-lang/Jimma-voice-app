import 'dart:math';
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
  String _tab = 'Hot';
  int _rounds = 0;
  bool _claimed = false;

  static const List<Map<String, dynamic>> _games = [
    {'name': 'Ocean Hunt', 'cat': 'Fishing', 'tag': 'HOT', 'c1': 0xFF9333EA, 'c2': 0xFFF59E0B, 'c3': 0xFF3B82F6, 'em': '🐙', 'sub': '🎰'},
    {'name': 'Jungle Hunt', 'cat': 'Fishing', 'tag': 'HOT', 'c1': 0xFF15803D, 'c2': 0xFFEA580C, 'c3': 0xFFFACC15, 'em': '🦍', 'sub': '🌴'},
    {'name': 'Royal Battle', 'cat': 'Multi Player', 'tag': 'HOT', 'c1': 0xFFBE185D, 'c2': 0xFFFACC15, 'c3': 0xFF7E22CE, 'em': '🏆', 'sub': '♠️'},
    {'name': 'Ocean Hunt II', 'cat': 'Fishing', 'tag': 'NEW', 'c1': 0xFF7E22CE, 'c2': 0xFFEC4899, 'c3': 0xFF38BDF8, 'em': '🧜‍♀️', 'sub': '💎'},
    {'name': 'JungleDelight', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF166534, 'c2': 0xFFDC2626, 'c3': 0xFFFDE047, 'em': '🐒', 'sub': '🍉'},
    {'name': 'Garo Gems III', 'cat': 'Slot', 'tag': 'NEW', 'c1': 0xFFB45309, 'c2': 0xFFFACC15, 'c3': 0xFF78350F, 'em': '👑', 'sub': '💎'},
    {'name': 'GaroGemsII', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFFD97706, 'c2': 0xFFDC2626, 'c3': 0xFFFDE047, 'em': '🗿', 'sub': '💰'},
    {'name': 'Garo Gems I', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF92400E, 'c2': 0xFFF59E0B, 'c3': 0xFFFEF08A, 'em': '🦁', 'sub': '✨'},
    {'name': 'Fruit Party', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF2563EB, 'c2': 0xFFEF4444, 'c3': 0xFF22C55E, 'em': '🍓', 'sub': '🍊'},
    {'name': 'Bonanza Banana', 'cat': 'Slot', 'tag': 'NEW', 'c1': 0xFF15803D, 'c2': 0xFFEAB308, 'c3': 0xFF4ADE80, 'em': '🐵', 'sub': '🍌'},
    {'name': 'Fishing Tycoon', 'cat': 'Fishing', 'tag': 'HOT', 'c1': 0xFF0284C7, 'c2': 0xFFF59E0B, 'c3': 0xFF38BDF8, 'em': '🦈', 'sub': '🔫'},
    {'name': 'The Monkey King', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFFB91C1C, 'c2': 0xFFFACC15, 'c3': 0xFFF97316, 'em': '🐵', 'sub': '🔥'},
    {'name': 'Storm Joker', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF1E293B, 'c2': 0xFF10B981, 'c3': 0xFF6366F1, 'em': '🃏', 'sub': '⚡'},
    {'name': 'Fortune Rabbit', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF991B1B, 'c2': 0xFFF59E0B, 'c3': 0xFFFDE047, 'em': '🐰', 'sub': '🧧'},
    {'name': 'Gates Of Olympus', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF1D4ED8, 'c2': 0xFFFACC15, 'c3': 0xFF60A5FA, 'em': '⚡', 'sub': '🏛️'},
    {'name': 'Starlight Princess', 'cat': 'Slot', 'tag': 'NEW', 'c1': 0xFF0284C7, 'c2': 0xFFEC4899, 'c3': 0xFFFACC15, 'em': '👸', 'sub': '⭐'},
    {'name': 'Gems Sky', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF9333EA, 'c2': 0xFFF472B6, 'c3': 0xFFFDE047, 'em': '👑', 'sub': '💎'},
    {'name': 'Scratch Boxing', 'cat': 'Multi Player', 'tag': 'NEW', 'c1': 0xFF7F1D1D, 'c2': 0xFFEF4444, 'c3': 0xFFF59E0B, 'em': '🥊', 'sub': '🔥'},
    {'name': 'Money Coming', 'cat': 'Slot', 'tag': 'NEW', 'c1': 0xFF1E3A8A, 'c2': 0xFF22C55E, 'c3': 0xFFFACC15, 'em': '💵', 'sub': '💲'},
    {'name': 'Lucky77Pro', 'cat': 'Slot', 'tag': 'PRO', 'c1': 0xFF7E22CE, 'c2': 0xFFEF4444, 'c3': 0xFFFACC15, 'em': '7️⃣', 'sub': '🍒'},
    {'name': 'Crazy 777', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFFBE123C, 'c2': 0xFFF43F5E, 'c3': 0xFFFDE047, 'em': '7️⃣', 'sub': '💥'},
    {'name': 'Fortune Tiger', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFFB91C1C, 'c2': 0xFFF97316, 'c3': 0xFFFACC15, 'em': '🐯', 'sub': '🪙'},
    {'name': 'Roulette', 'cat': 'Multi Player', 'tag': 'HOT', 'c1': 0xFF14532D, 'c2': 0xFFD97706, 'c3': 0xFFDC2626, 'em': '🎡', 'sub': '🎯'},
    {'name': 'Star Fighter', 'cat': 'Multi Player', 'tag': 'HOT', 'c1': 0xFF1E1B4B, 'c2': 0xFFF97316, 'c3': 0xFF38BDF8, 'em': '✈️', 'sub': '🚀'},
    {'name': 'Mahjong', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF065F46, 'c2': 0xFFF59E0B, 'c3': 0xFF10B981, 'em': '🀄', 'sub': '🧧'},
    {'name': 'Royal Fishing', 'cat': 'Fishing', 'tag': 'HOT', 'c1': 0xFF0369A1, 'c2': 0xFFFACC15, 'c3': 0xFF2DD4BF, 'em': '🐡', 'sub': '👑'},
    {'name': 'Kraken III', 'cat': 'Fishing', 'tag': 'HOT', 'c1': 0xFF581C87, 'c2': 0xFFEC4899, 'c3': 0xFF3B82F6, 'em': '🐙', 'sub': '🌊'},
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
    final list = (_tab == 'Hot' || _tab == 'Latest') ? _games : _games.where((e) => e['cat'] == _tab).toList();
    return Scaffold(
      backgroundColor: const Color(0xFF0A241E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E332A),
        elevation: 0,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [Icon(Icons.sports_esports, color: Colors.amberAccent), SizedBox(width: 8), Text('Games', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20))],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(color: const Color(0xFF144538), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.amber)),
            child: Row(children: [const Icon(Icons.monetization_on, color: Colors.amber, size: 16), const SizedBox(width: 4), Text('${AppState.coins}', style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold, fontSize: 12))]),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 46,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  children: ['Latest', 'Hot', 'Slot', 'Fishing', 'Multi Player'].map((t) {
                    final sel = _tab == t;
                    return GestureDetector(
                      onTap: () => setState(() => _tab = t),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: sel ? const Color(0xFF1F6E58) : const Color(0xFF11382E),
                          borderRadius: BorderRadius.circular(20),
                          border: sel ? Border.all(color: const Color(0xFF4ADE80), width: 1.2) : null,
                        ),
                        child: Text(t, style: TextStyle(color: sel ? Colors.white : Colors.white70, fontWeight: sel ? FontWeight.bold : FontWeight.normal, fontSize: 13)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(10, 6, 10, 80),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.78, crossAxisSpacing: 9, mainAxisSpacing: 11),
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final g = list[i];
                    final tag = g['tag'] as String;
                    final ribColor = tag == 'NEW' ? const Color(0xFF22C55E) : (tag == 'PRO' ? const Color(0xFFD97706) : const Color(0xFFEF4444));
                    return GestureDetector(
                      onTap: () => _openWebGame(g['name'] as String),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(g['c1'] as int), Color(g['c2'] as int), Color(g['c3'] as int)]),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.7), width: 1.5),
                                    ),
                                  ),
                                  Positioned(top: -12, left: -12, child: Container(width: 55, height: 55, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.16)))),
                                  Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(g['em'] as String, style: const TextStyle(fontSize: 36)),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                          decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.amberAccent, width: 0.8)),
                                          child: Text((g['name'] as String).toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w900, color: Colors.amberAccent, letterSpacing: 0.4)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(bottom: 4, left: 6, child: Text(g['sub'] as String, style: const TextStyle(fontSize: 16))),
                                  Positioned(
                                    top: 7,
                                    right: -18,
                                    child: Transform.rotate(
                                      angle: pi / 4,
                                      child: Container(
                                        width: 64,
                                        padding: const EdgeInsets.symmetric(vertical: 2),
                                        color: ribColor,
                                        alignment: Alignment.center,
                                        child: Text(tag, style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w900, color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(g['name'] as String, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Colors.white)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            right: 12,
            bottom: 18,
            child: GestureDetector(
              onTap: () {
                if (_rounds >= 3 && !_claimed) {
                  AppState.coins += 8000;
                  _claimed = true;
                  widget.onUpd();
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('🎉 +8,000 Bonus Coins Claimed!')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Play 3 games to claim 8,000 Coins (${_rounds.clamp(0, 3)}/3)')));
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF16A34A), Color(0xFF15803D)]),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.amberAccent, width: 1.5),
                  boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 3))],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.monetization_on, color: Colors.amber, size: 15), SizedBox(width: 3), Text('8000', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.amberAccent, fontSize: 12))]),
                    Text(_claimed ? 'DONE ✅' : '${_rounds.clamp(0, 3)}/3', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11)),
                  ],
                ),
              ),
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
      backgroundColor: const Color(0xFF0A241E),
      appBar: AppBar(backgroundColor: const Color(0xFF0E332A), title: Text('🎮 ${widget.gameName}')),
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
