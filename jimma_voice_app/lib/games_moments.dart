import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';

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

  final _gamesList = [
    ['Oromia & Abba Jifar Royal Slot', '☕🏰🐎', const Color(0xFFB45309), 'slot'],
    ['Oromo Horse Derby', '🐎🏆🎖️', const Color(0xFFBE123C), 'horse'],
    ['Finfinnee Lucky Wheel', '🎡🎯🌟', const Color(0xFF0F766E), 'wheel'],
    ['Royal Battle Arena', '⚔️👑🛡️', const Color(0xFF7C3AED), 'battle'],
    ['Fishing Tycoon Abay', '🐟🌊⚓', const Color(0xFF0284C7), 'fish'],
    ['Golden Lion Dice', '🎲🦁💛', const Color(0xFFA16207), 'dice'],
    ['World Cup 2026 Penalty', '⚽🥅🏆', const Color(0xFF047857), 'penalty'],
    ['Jungle Hunt Bale', '🦁🌲🏹', const Color(0xFF15803D), 'battle'],
    ['Jebena Coffee Fortune', '☕✨💰', const Color(0xFFD97706), 'wheel'],
    ['Abyssinian Treasure', '🏺👑💎', const Color(0xFF4338CA), 'fish'],
    ['Ludo Star Ethiopia', '🎲🏠🏅', const Color(0xFF9333EA), 'dice'],
    ['Domino Master', '🁣🁢🔥', const Color(0xFF334155), 'penalty'],
  ];

  void _spinSlot() {
    if (_spinning) return;
    if (AppState.coins < _bet) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not enough Coins! Recharge first.')));
      return;
    }
    setState(() { _spinning = true; AppState.coins -= _bet; });
    widget.onUpd();
    SystemSound.play(SystemSoundType.click);
    int ticks = 0;
    Timer.periodic(const Duration(milliseconds: 85), (t) {
      ticks++;
      SystemSound.play(SystemSoundType.click);
      setState(() => _reels = List.generate(3, (_) => _symbols[Random().nextInt(_symbols.length)]));
      if (ticks >= 12) {
        t.cancel();
        if (Random().nextInt(100) < 35) {
          final pick = _symbols[Random().nextInt(_symbols.length)];
          AppState.coins += _bet * 2;
          HapticFeedback.heavyImpact();
          SystemSound.play(SystemSoundType.alert);
          setState(() { _reels = [pick, pick, pick]; _spinning = false; });
        } else {
          setState(() { _reels = [_symbols[0], _symbols[1], _symbols[2]]; _spinning = false; });
        }
        widget.onUpd();
      }
    });
  }

  void _openGameModal(String title, String mode) {
    int pick = 0;
    String status = 'Select choice & tap PLAY';
    final opts = mode == 'horse' ? ['🐎 Boorana', '🐎 Jimma', '🐎 Arsi', '🐎 Wallagga']
        : mode == 'wheel' ? ['🎯 2x Gold', '🌟 3x Crown', '💎 5x Palace', '👑 10x King']
        : mode == 'battle' ? ['⚔️ Warrior', '🛡️ Guardian', '🏹 Archer', '🦁 Lion King']
        : mode == 'fish' ? ['🐟 Nile Perch', '🦈 Abay Shark', '🐢 Turtle', '🐙 Treasure']
        : mode == 'dice' ? ['🎲 Low 1-3', '🎲 High 4-6', '🎲 Lucky 6', '🎲 Double']
        : ['⚽ Left', '⚽ Center', '⚽ Right', '⚽ Power'];
    showModalBottomSheet(context: context, backgroundColor: const Color(0xFF0F172A), builder: (_) => StatefulBuilder(
      builder: (ctx, setS) => Padding(padding: const EdgeInsets.all(16), child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
        const SizedBox(height: 10),
        Wrap(spacing: 8, children: List.generate(opts.length, (i) => ChoiceChip(label: Text(opts[i]), selected: pick == i, onSelected: (_) => setS(() => pick = i)))),
        const SizedBox(height: 12),
        Text(status, style: const TextStyle(color: Colors.amber)),
        const SizedBox(height: 12),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black), onPressed: () {
          if (AppState.coins < _bet) { setS(() => status = 'Not enough Coins!'); return; }
          AppState.coins -= _bet;
          SystemSound.play(SystemSoundType.click);
          if (Random().nextInt(100) < 35) {
            AppState.coins += _bet * 2;
            setS(() => status = '🎉 WINNER! ${opts[pick]} won +${_bet * 2} Coins!');
          } else {
            setS(() => status = 'Try again! Next round could win!');
          }
          widget.onUpd();
        }, child: Text('PLAY NOW ($_bet Coins)')),
      ])),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Games • Coins: ${AppState.coins}')), body: ListView(padding: const EdgeInsets.all(14), children: [
      Card(color: const Color(0xFF78350F), child: Padding(padding: const EdgeInsets.all(14), child: Column(children: [
        const Text('Oromia & Abba Jifar Royal Slot', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
        const SizedBox(height: 10),
        Row(children: _reels.map((s) => Expanded(child: Card(color: Colors.black54, child: Padding(padding: const EdgeInsets.all(12), child: Center(child: Text(s, style: const TextStyle(fontSize: 12))))))).toList()),
        Wrap(spacing: 6, children: [100, 500, 1000].map((b) => ChoiceChip(label: Text('$b'), selected: _bet == b, onSelected: (_) => setState(() => _bet = b))).toList()),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black), onPressed: _spinSlot, child: Text('SPIN ($_bet Coins)')),
      ]))),
      const SizedBox(height: 12),
      GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8), itemCount: _gamesList.length, itemBuilder: (_, i) {
        final g = _gamesList[i];
        return InkWell(onTap: () => g[3] == 'slot' ? _spinSlot() : _openGameModal(g[0] as String, g[3] as String), child: Card(color: (g[2] as Color).withOpacity(0.45), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(g[1] as String, style: const TextStyle(fontSize: 22)), Text(g[0] as String, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11))])));
      }),
    ]));
  }
}

class MomentsTab extends StatefulWidget {
  final VoidCallback onUpd;
  const MomentsTab({super.key, required this.onUpd});
  @override
  State<MomentsTab> createState() => _MomentsTabState();
}
class _MomentsTabState extends State<MomentsTab> {
  final _c = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Moments')), body: ListView(padding: const EdgeInsets.all(14), children: [
      Row(children: [Expanded(child: TextField(controller: _c, decoration: const InputDecoration(hintText: 'Post moment...'))), ElevatedButton(onPressed: () { if (_c.text.isNotEmpty) { setState(() { AppState.moments.insert(0, {'user': AppState.userName, 'tag': '#JimmaCoffeeCulture', 'text': _c.text, 'likes': '1'}); _c.clear(); }); } }, child: const Text('Post'))]),
      ...AppState.moments.map((m) => Card(child: ListTile(title: Text('${m['user']} • ${m['tag']}'), subtitle: Text(m['text']!), trailing: Text('❤️ ${m['likes']}')))),
    ]));
  }
}

class MessagesTab extends StatefulWidget {
  final VoidCallback onUpd;
  const MessagesTab({super.key, required this.onUpd});
  @override
  State<MessagesTab> createState() => _MessagesTabState();
}
class _MessagesTabState extends State<MessagesTab> {
  final _msgCtrl = TextEditingController();
  bool _recording = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: const Text('Messages & Notifications'), bottom: const TabBar(tabs: [Tab(text: 'Chat (Text • Voice • Photo)'), Tab(text: 'Notifications')])),
        body: TabBarView(children: [
          Column(children: [
            Expanded(child: ListView.builder(padding: const EdgeInsets.all(12), itemCount: AppState.chatMessages.length, itemBuilder: (_, i) {
              final m = AppState.chatMessages[i];
              final isMe = m['sender'] == AppState.userName;
              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Card(
                  color: isMe ? const Color(0xFF78350F) : const Color(0xFF1E293B),
                  child: Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${m['sender']} • ${m['time']}', style: const TextStyle(fontSize: 10, color: Colors.amber)),
                    const SizedBox(height: 4),
                    if (m['type'] == 'voice') Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.play_circle_fill, color: Colors.greenAccent), const SizedBox(width: 6), Text(m['content']!)])
                    else if (m['type'] == 'image') Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.receipt_long, size: 36, color: Colors.cyanAccent), Text(m['content']!)])
                    else Text(m['content']!),
                  ])),
                ),
              );
            })),
            Container(padding: const EdgeInsets.all(8), color: const Color(0xFF111827), child: Row(children: [
              IconButton(icon: const Icon(Icons.photo_camera, color: Colors.cyanAccent), tooltip: 'Send Photo / Payment Receipt', onPressed: () {
                setState(() => AppState.chatMessages.add({'sender': AppState.userName, 'type': 'image', 'content': '📷 Attached Photo / Bank Payment Receipt (Verified)', 'time': 'Now'}));
                SystemSound.play(SystemSoundType.click);
              }),
              IconButton(icon: Icon(_recording ? Icons.stop_circle : Icons.mic, color: _recording ? Colors.red : Colors.amber), tooltip: 'Send Voice Note', onPressed: () {
                setState(() {
                  if (!_recording) { _recording = true; } else {
                    _recording = false;
                    AppState.chatMessages.add({'sender': AppState.userName, 'type': 'voice', 'content': '🎤 Voice Message (0:06 sec) - Tap to Play', 'time': 'Now'});
                    SystemSound.play(SystemSoundType.click);
                  }
                });
              }),
              Expanded(child: TextField(controller: _msgCtrl, decoration: InputDecoration(hintText: _recording ? 'Recording voice... tap mic to send' : 'Write message...', border: InputBorder.none))),
              IconButton(icon: const Icon(Icons.send, color: Colors.amber), onPressed: () {
                if (_msgCtrl.text.trim().isNotEmpty) {
                  setState(() { AppState.chatMessages.add({'sender': AppState.userName, 'type': 'text', 'content': _msgCtrl.text.trim(), 'time': 'Now'}); _msgCtrl.clear(); });
                }
              }),
            ])),
          ]),
          ListView.builder(padding: const EdgeInsets.all(12), itemCount: AppState.notifications.length, itemBuilder: (_, i) {
            final n = AppState.notifications[i];
            return Card(child: ListTile(leading: const Icon(Icons.notifications_active, color: Colors.amber), title: Text(n['title']!), subtitle: Text(n['body']!), trailing: Text(n['time']!, style: const TextStyle(fontSize: 10))));
          }),
        ]),
      ),
    );
  }
}
