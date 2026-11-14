import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'main.dart';
import 'api_service.dart';

class GamesTab extends StatefulWidget {
  final VoidCallback onUpd;
  const GamesTab({super.key, required this.onUpd});
  @override
  State<GamesTab> createState() => _GamesTabState();
}

class _GamesTabState extends State<GamesTab> {
  String _cat = 'Hot';
  int _bet = 100;
  final _cats = List<String>.of({'Latest', 'Hot', 'Slot', 'Fishing', 'Multi Player'});
  final _bets = List<int>.of({100, 500, 1000, 5000, 10000});

  final _allGames = List<Map<String, dynamic>>.of({
    {'name': 'Ocean Hunt', 'icon': '🐙🎰', 'cat': 'Hot', 'tag': 'HOT', 'col': 0xFF7C3AED},
    {'name': 'Jungle Hunt', 'icon': '🦁🌴', 'cat': 'Hot', 'tag': 'HOT', 'col': 0xFFB45309},
    {'name': 'Royal Battle', 'icon': '👑⚔️', 'cat': 'Multi Player', 'tag': 'HOT', 'col': 0xFFBE123C},
    {'name': 'Garo Gems III', 'icon': '🏺💎', 'cat': 'Slot', 'tag': 'NEW', 'col': 0xFFD97706},
    {'name': 'Fruit Party', 'icon': '🍓🍊', 'cat': 'Slot', 'tag': 'HOT', 'col': 0xFF0284C7},
    {'name': 'Fishing Tycoon', 'icon': '🦈⚓', 'cat': 'Fishing', 'tag': 'HOT', 'col': 0xFF0F766E},
    {'name': 'Money Coming', 'icon': '💵🎰', 'cat': 'Slot', 'tag': 'NEW', 'col': 0xFF15803D},
    {'name': 'The Monkey King', 'icon': '🐵👑', 'cat': 'Hot', 'tag': 'HOT', 'col': 0xFFDC2626},
    {'name': 'Blaze Of Fortune', 'icon': '🔥🏮', 'cat': 'Latest', 'tag': 'NEW', 'col': 0xFF9A3412},
    {'name': 'Lucky Piggy', 'icon': '🐷💰', 'cat': 'Slot', 'tag': 'NEW', 'col': 0xFFA16207},
    {'name': 'Fortune Rabbit', 'icon': '🐰🧧', 'cat': 'Latest', 'tag': 'NEW', 'col': 0xFFDB2777},
    {'name': 'Gates Of Olympus', 'icon': '⚡🏛️', 'cat': 'Hot', 'tag': 'NEW', 'col': 0xFF1D4ED8},
    {'name': 'Lucky 77 Pro', 'icon': '7️⃣🍒', 'cat': 'Slot', 'tag': 'PRO', 'col': 0xFF991B1B},
    {'name': 'Fortune Tiger', 'icon': '🐯🪙', 'cat': 'Hot', 'tag': 'HOT', 'col': 0xFFB45309},
    {'name': 'Roulette Royal', 'icon': '🎡🎯', 'cat': 'Multi Player', 'tag': 'HOT', 'col': 0xFF065F46},
    {'name': 'Deep Sea', 'icon': '🐟🌊', 'cat': 'Fishing', 'tag': 'HOT', 'col': 0xFF0369A1},
    {'name': 'Color Game', 'icon': '🎲🎨', 'cat': 'Multi Player', 'tag': 'HOT', 'col': 0xFF6D28D9},
    {'name': 'World Goal 2026', 'icon': '⚽🥅', 'cat': 'Multi Player', 'tag': 'HOT', 'col': 0xFF047857},
    {'name': 'Sweet Bonanza', 'icon': '🍭🍬', 'cat': 'Slot', 'tag': 'HOT', 'col': 0xFFBE185D},
    {'name': 'Dragon Ball', 'icon': '🐉🔮', 'cat': 'Latest', 'tag': 'NEW', 'col': 0xFF15803D},
    {'name': 'Super Ace', 'icon': '🃏👑', 'cat': 'Slot', 'tag': 'HOT', 'col': 0xFF4D7C0F},
    {'name': 'Chicken Road', 'icon': '🐔🛣️', 'cat': 'Latest', 'tag': 'NEW', 'col': 0xFF374151},
    {'name': 'Teen Patti', 'icon': '♠️♥️', 'cat': 'Multi Player', 'tag': 'HOT', 'col': 0xFF1E3A8A},
    {'name': 'Ludo King Party', 'icon': '🎲🏆', 'cat': 'Multi Player', 'tag': 'HOT', 'col': 0xFF0F766E},
  });

  void _openGameDialog(Map<String, dynamic> g) {
    final reels = List<String>.of({'💎', '👑', '🪙'});
    String msg = 'Select Bet (100 - 10,000) & Tap SPIN!';
    bool spinning = false;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setG) => SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List<Widget>.of({
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List<Widget>.of({
                  Text('${g['icon']} ${g['name']}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.amber)),
                  Text('🪙 ${AppState.coins}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                })),
                const SizedBox(height: 12),
                Row(children: reels.map((r) => Expanded(child: Card(color: Colors.black54, child: Padding(padding: const EdgeInsets.all(14), child: Center(child: Text(r, style: const TextStyle(fontSize: 26))))))).toList()),
                const SizedBox(height: 8),
                Wrap(spacing: 6, children: _bets.map((b) => ChoiceChip(label: Text('$b'), selected: _bet == b, onSelected: (_) => setG(() => _bet = b))).toList()),
                const SizedBox(height: 8),
                Text(msg, style: const TextStyle(color: Colors.tealAccent, fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 46)),
                  onPressed: spinning ? null : () async {
                    if (AppState.coins < _bet) { setG(() => msg = 'Not enough Coins! Recharge first.'); return; }
                    setG(() { spinning = true; AppState.coins -= _bet; msg = 'Spinning... 🎵'; });
                    SystemSound.play(SystemSoundType.click);
                    HapticFeedback.lightImpact();
                    widget.onUpd();
                    await Future.delayed(const Duration(milliseconds: 550));
                    // 65% Galii Appichaa eeguuf carraan mo'achuu 35%
                    if (Random().nextInt(100) < 35) {
                      final sym = List<String>.of({'💎', '👑', '🪙', '🦁', '☕'}).elementAt(Random().nextInt(5));
                      final win = _bet * 2;
                      SystemSound.play(SystemSoundType.alert);
                      HapticFeedback.heavyImpact();
                      setG(() {
                        AppState.coins += win;
                        reels[0] = sym; reels[1] = sym; reels[2] = sym;
                        spinning = false;
                        msg = '🎉 BIG WIN! +$win Coins!';
                      });
                    } else {
                      setG(() {
                        reels[0] = '💎'; reels[1] = '🦁'; reels[2] = '🪙';
                        spinning = false;
                        msg = 'Try again! Next spin could hit Jackpot!';
                      });
                    }
                    widget.onUpd();
                  },
                  child: Text('PLAY / SPIN ($_bet Coins)', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              }),
            ),
          ),
        ),
      ),
    );
  }

  void _convertCoinsToPoints() {
    final ctrl = TextEditingController(text: '10000');
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Convert Won Coins ➔ Points'),
      content: TextField(controller: ctrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Coins Amount (10,000 Coins = 9,000 Pts)')),
      actions: List<Widget>.of({
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: () {
          final c = int.tryParse(ctrl.text) ?? 0;
          if (c >= 1000 && AppState.coins >= c) {
            setState(() { AppState.coins -= c; AppState.points += (c * 0.90); });
            widget.onUpd();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Converted $c Coins to ${(c * 0.90).toStringAsFixed(0)} Points!')));
          }
        }, child: const Text('Convert')),
      }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final list = _cat == 'Hot' ? _allGames : _allGames.where((g) => g['cat'] == _cat).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Games • 🪙 ${AppState.coins}'),
        actions: List<Widget>.of({
          TextButton.icon(onPressed: _convertCoinsToPoints, icon: const Icon(Icons.swap_horiz, color: Colors.tealAccent), label: const Text('Coins➔Pts', style: TextStyle(color: Colors.tealAccent, fontSize: 12))),
        }),
      ),
      body: Column(
        children: List<Widget>.of({
          SizedBox(
            height: 46,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              itemCount: _cats.length,
              itemBuilder: (_, i) {
                final c = _cats.elementAt(i);
                final sel = c == _cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(label: Text(c), selected: sel, selectedColor: Colors.tealAccent.shade700, onSelected: (_) => setState(() => _cat = c)),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 0.85),
              itemCount: list.length,
              itemBuilder: (_, i) {
                final g = list.elementAt(i);
                return InkWell(
                  onTap: () => _openGameDialog(g),
                  child: Container(
                    decoration: BoxDecoration(color: Color(g['col'] as int).withOpacity(0.55), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.white24)),
                    child: Stack(
                      children: List<Widget>.of({                        Positioned(top: 4, right: 4, child: Container(padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2), decoration: BoxDecoration(color: g['tag'] == 'HOT' ? Colors.red : Colors.green, borderRadius: BorderRadius.circular(6)), child: Text(g['tag'] as String, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)))),
                        Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: List<Widget>.of({
                          Text(g['icon'] as String, style: const TextStyle(fontSize: 28)),
                          const SizedBox(height: 6),
                          Text(g['name'] as String, textAlign: TextAlign.center, maxLines: 2, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        }))),
                      }),
                    ),
                  ),
                );
              },
            ),
          ),
        }),
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
  final _c = TextEditingController();
  final _picker = ImagePicker();
  String? _imgPath;

  Future<void> _pickImg() async {
    final XFile? f = await _picker.pickImage(source: ImageSource.gallery);
    if (f != null) setState(() => _imgPath = f.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Moments (Free Post & Photo)')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: List<Widget>.of({
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(children: List<Widget>.of({
                Row(children: List<Widget>.of({
                  IconButton(icon: const Icon(Icons.add_a_photo, color: Colors.amber), onPressed: _pickImg),
                  Expanded(child: TextField(controller: _c, decoration: const InputDecoration(hintText: 'Share photo or text (Free)...', border: InputBorder.none))),
                  ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black), onPressed: () {
                    if (_c.text.trim().isNotEmpty || _imgPath != null) {
                      setState(() {
                        AppState.moments.insert(0, {'user': AppState.userName, 'tag': '#EthioVoice', 'text': _c.text.trim().isEmpty ? '📷 Shared a Photo' : _c.text.trim(), 'image': _imgPath ?? '', 'likes': '1'});
                        _c.clear(); _imgPath = null;
                      });
                    }
                  }, child: const Text('Post')),
                })),
                if (_imgPath != null) const Text('✅ Photo ready to post!', style: TextStyle(color: Colors.greenAccent, fontSize: 12)),
              })),
            ),
          ),
          ...AppState.moments.map((m) {
            final p = m['image'] ?? '';
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: List<Widget>.of({
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List<Widget>.of({Text('${m['user']} • ${m['tag']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)), Text('❤️ ${m['likes']}')})),
                  const SizedBox(height: 6),
                  Text(m['text'] ?? ''),
                  if (p.isNotEmpty && !kIsWeb) Padding(padding: const EdgeInsets.only(top: 8), child: Image.file(File(p), height: 180, width: double.infinity, fit: BoxFit.cover)),
                })),
              ),
            );
          }),
        }),
      ),
    );
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
  final _picker = ImagePicker();

  Future<void> _sendPhoto() async {
    final XFile? f = await _picker.pickImage(source: ImageSource.gallery);
    if (f != null) {
      setState(() => AppState.chatMessages.add({'sender': AppState.userName, 'type': 'image', 'content': '📷 Payment Receipt / Photo Sent', 'image': f.path, 'time': 'Now'}));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Free Chat & ID Coin Trade')),
      body: SafeArea(
        top: false,
        child: Column(children: List<Widget>.of({
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: AppState.chatMessages.length,
              itemBuilder: (_, i) {
                final m = AppState.chatMessages.elementAt(i);
                final p = m['image'] ?? '';
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: List<Widget>.of({
                      Text('${m['sender']} • ${m['time']}', style: const TextStyle(fontSize: 11, color: Colors.amber)),
                      const SizedBox(height: 4),
                      Text(m['content'] ?? ''),
                      if (p.isNotEmpty && !kIsWeb) Padding(padding: const EdgeInsets.only(top: 6), child: Image.file(File(p), height: 140, fit: BoxFit.cover)),
                    })),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(children: List<Widget>.of({
              IconButton(icon: const Icon(Icons.photo, color: Colors.cyanAccent), onPressed: _sendPhoto),
              Expanded(child: TextField(controller: _msgCtrl, decoration: const InputDecoration(hintText: 'Send User ID / Free Text...'))),
              IconButton(icon: const Icon(Icons.send, color: Colors.amber), onPressed: () {
                if (_msgCtrl.text.trim().isNotEmpty) {
                  setState(() { AppState.chatMessages.add({'sender': AppState.userName, 'type': 'text', 'content': _msgCtrl.text.trim(), 'time': 'Now'}); _msgCtrl.clear(); });
                }
              }),
            })),
          ),
        })),
      ),
    );
  }
}

