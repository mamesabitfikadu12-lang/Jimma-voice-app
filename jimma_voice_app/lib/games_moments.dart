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
      setState(() => _reels = List.generate(3, (_) => _symbols[Random().nextInt(_symbols.length)]));
      if (ticks >= 12) {
        t.cancel();
        final win = Random().nextInt(100) < 35; // 35% Win, 65% App House Profit
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
            _reels = [_symbols[0], _symbols[1], _symbols[2]];
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
        padding: const EdgeInsets.all(14),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF78350F), Color(0xFF1E1B4B)]),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFFFB703), width: 2),
            ),
            child: Column(
              children: [
                Text(_selectedGame, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFFFFB703))),
                const Text('🔊 Sound & Vibration Active • Ethiopian & Oromo Heritage', style: TextStyle(fontSize: 11, color: Colors.white70)),
                const SizedBox(height: 14),
                Row(
                  children: _reels.map((s) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.amber)),
                      child: Center(child: Text(s, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [100, 500, 1000, 5000].map((b) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text('$b'),
                      selected: _bet == b,
                      selectedColor: Colors.amber,
                      labelStyle: TextStyle(color: _bet == b ? Colors.black : Colors.white),
                      onSelected: (_) => setState(() => _bet = b),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFB703), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 12)),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(_spinning ? 'Spinning...' : 'SPIN NOW ($_bet Coins)', style: const TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: _spin,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('All 12 Cultural & Global Games', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.95, crossAxisSpacing: 8, mainAxisSpacing: 8),
            itemCount: _gamesList.length,
            itemBuilder: (_, i) {
              final g = _gamesList[i];
              return InkWell(
                onTap: () {
                  SystemSound.play(SystemSoundType.click);
                  setState(() => _selectedGame = g[0] as String);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: (g[2] as Color).withOpacity(0.35), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white24)),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(g[1] as String, style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 6),
                    Text(g[0] as String, textAlign: TextAlign.center, maxLines: 2, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ]),
                ),
              );
            },
          ),
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
  final _postCtrl = TextEditingController();
  String _tag = '#JimmaCoffeeCulture';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Moments & Topics')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Wrap(spacing: 6, children: ['#WorldCup2026', '#JimmaCoffeeCulture', '#MakeNewFriends'].map((t) => ChoiceChip(
            label: Text(t),
            selected: _tag == t,
            onSelected: (_) => setState(() => _tag = t),
          )).toList()),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: TextField(controller: _postCtrl, decoration: const InputDecoration(hintText: 'Share a moment with Ethiopia & the world...', border: OutlineInputBorder()))),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: () {
              if (_postCtrl.text.trim().isNotEmpty) {
                setState(() {
                  AppState.moments.insert(0, {'user': AppState.userName, 'tag': _tag, 'text': _postCtrl.text.trim(), 'likes': '1'});
                  _postCtrl.clear();
                });
              }
            }, child: const Text('Post')),
          ]),
          const SizedBox(height: 12),
          ...AppState.moments.map((m) => Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              title: Text('${m['user']} • ${m['tag']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
              subtitle: Padding(padding: const EdgeInsets.only(top: 6), child: Text(m['text']!)),
              trailing: Text('❤️ ${m['likes']}'),
            ),
          )),
        ],
      ),
    );
  }
}

class MessagesTab extends StatelessWidget {
  final VoidCallback onUpd;
  const MessagesTab({super.key, required this.onUpd});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          Card(child: ListTile(leading: CircleAvatar(backgroundColor: Colors.amber, child: Icon(Icons.support_agent, color: Colors.black)), title: Text('Jimma Voice Official Support'), subtitle: Text('Welcome! Contact us anytime for Agency or Coin Seller help.'))),
          Card(child: ListTile(leading: CircleAvatar(backgroundColor: Colors.teal, child: Icon(Icons.campaign)), title: Text('System Announcements'), subtitle: Text('Celebrate Oromo & Ethiopian culture in global voice rooms!'))),
        ],
      ),
    );
  }
}
