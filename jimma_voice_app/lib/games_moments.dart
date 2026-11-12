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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not enough Coins! Recharge in Me > Coin Seller or Admin 2730.')));
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
        final win = Random().nextInt(100) < 35; // 35% Player Win, 65% App Profit
        if (win) {
          final pick = _symbols[Random().nextInt(_symbols.length)];
          final payout = _bet * 2;
          AppState.coins += payout;
          HapticFeedback.heavyImpact();
          SystemSound.play(SystemSoundType.alert);
          setState(() { _reels = [pick, pick, pick]; _spinning = false; });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('🎉 JACKPOT! Matched $pick (+$payout Coins)')));
        } else {
          setState(() { _reels = [_symbols, _symbols, _symbols]; _spinning = false; });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Close! Spin again to match 3 symbols!')));
        }
        widget.onUpd();
      }
    });
  }

  void _openGameModal(String title, String mode) {
    int pick = 0;
    String status = 'Select your choice & tap PLAY ($title)';
    bool busy = false;
    final options = mode == 'horse'
        ? ['🐎 Boorana', '🐎 Jimma', '🐎 Arsi', '🐎 Wallagga']
        : mode == 'wheel'
            ? ['🎯 2x Gold', '🌟 3x Crown', '💎 5x Palace', '👑 10x King']
            : mode == 'battle'
                ? ['⚔️ Warrior', '🛡️ Guardian', '🏹 Archer', '🦁 Lion King']
                : mode == 'fish'
                    ? ['🐟 Nile Perch', '🦈 Abay Shark', '🐢 Golden Turtle', '🐙 Treasure Chest']
                    : mode == 'dice'
                        ? ['🎲 Low (1-3)', '🎲 High (4-6)', '🎲 Lucky 6', '🎲 Double']
                        : ['⚽ Left Corner', '⚽ Center Shot', '⚽ Right Top', '⚽ Power Strike'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFFB703))),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ]),
              Text('Coins: ${AppState.coins} • Bet: $_bet Coins • 🔊 Sound Active', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 14),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2.5, crossAxisSpacing: 8, mainAxisSpacing: 8),
                itemCount: options.length,
                itemBuilder: (_, idx) => ChoiceChip(
                  label: Center(child: Text(options[idx], style: const TextStyle(fontWeight: FontWeight.bold))),
                  selected: pick == idx,
                  selectedColor: const Color(0xFFFFB703),
                  labelStyle: TextStyle(color: pick == idx ? Colors.black : Colors.white),
                  onSelected: (_) { SystemSound.play(SystemSoundType.click); setS(() => pick = idx); },
                ),
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
                child: Text(status, textAlign: TextAlign.center, style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFB703), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 14)),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(busy ? 'Playing...' : 'PLAY NOW ($_bet Coins)', style: const TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: busy ? null : () {
                    if (AppState.coins < _bet) {
                      setS(() => status = '❌ Not enough Coins! Recharge in Me tab.');
                      return;
                    }
                    setS(() { busy = true; AppState.coins -= _bet; status = '🎲 Action in progress...'; });
                    widget.onUpd();
                    SystemSound.play(SystemSoundType.click);
                    HapticFeedback.mediumImpact();
                    Future.delayed(const Duration(milliseconds: 900), () {
                      final winIdx = Random().nextInt(options.length);
                      final playerWins = (Random().nextInt(100) < 35) && (pick == winIdx || Random().nextBool());
                      if (playerWins) {
                        final prize = _bet * 2;
                        AppState.coins += prize;
                        HapticFeedback.heavyImpact();
                        SystemSound.play(SystemSoundType.alert);
                        setS(() { busy = false; status = '🎉 WINNER! ${options[pick]} won +$prize Coins!'; });
                      } else {
                        final actual = options[(pick + 1) % options.length];
                        setS(() { busy = false; status = 'Result: $actual won this round. Try again!'; });
                      }
                      widget.onUpd();
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
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
                const Text('Oromia & Abba Jifar Royal Slot', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFFFFB703))),
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
                  children:.map((b) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
OEF
sed -i '/Row(/,$d' jimma_voice_app/lib/games_moments.dart && cat << 'EOF' >> jimma_voice_app/lib/games_moments.dart
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
                  children:.map((b) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(label: Text('$b'), selected: _bet == b, selectedColor: Colors.amber, labelStyle: TextStyle(color: _bet == b ? Colors.black : Colors.white), onSelected: (_) => setState(() => _bet = b)),
                  )).toList(),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFB703), foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 12)),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(_spinning ? 'Spinning...' : 'SPIN NOW ($_bet Coins)', style: const TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: _spinSlot,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Tap Any Game Below to Play Live (12 Games)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                  if (g == 'slot') { _spinSlot(); } else { _openGameModal(g as String, g as String); }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: (g as Color).withOpacity(0.45), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.amber.withOpacity(0.4))),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(g as String, style: const TextStyle(fontSize: 22)),
                    const SizedBox(height: 6),
                    Text(g as String, textAlign: TextAlign.center, maxLines: 2, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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
          Wrap(spacing: 6, children: ['#WorldCup2026', '#JimmaCoffeeCulture', '#MakeNewFriends'].map((t) => ChoiceChip(label: Text(t), selected: _tag == t, onSelected: (_) => setState(() => _tag = t))).toList()),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: TextField(controller: _postCtrl, decoration: const InputDecoration(hintText: 'Share a moment with Ethiopia & the world...', border: OutlineInputBorder()))),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: () {
              if (_postCtrl.text.trim().isNotEmpty) {
                setState(() { AppState.moments.insert(0, {'user': AppState.userName, 'tag': _tag, 'text': _postCtrl.text.trim(), 'likes': '1'}); _postCtrl.clear(); });
              }
            }, child: const Text('Post')),
          ]),
          const SizedBox(height: 12),
          ...AppState.moments.map((m) => Card(margin: const EdgeInsets.only(bottom: 10), child: ListTile(title: Text('${m['user']} • ${m['tag']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)), subtitle: Padding(padding: const EdgeInsets.only(top: 6), child: Text(m['text']!)), trailing: Text('❤️ ${m['likes']}'))))),
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
      body: ListView(padding: const EdgeInsets.all(12), children: const [
        Card(child: ListTile(leading: CircleAvatar(backgroundColor: Colors.amber, child: Icon(Icons.support_agent, color: Colors.black)), title: Text('Jimma Voice Official Support'), subtitle: Text('Welcome! Contact us anytime for Agency or Coin Seller help.'))),
        Card(child: ListTile(leading: CircleAvatar(backgroundColor: Colors.teal, child: Icon(Icons.campaign)), title: Text('System Announcements'), subtitle: Text('Celebrate Oromo & Ethiopian culture in global voice rooms!'))),
      ]),
    );
  }
}
