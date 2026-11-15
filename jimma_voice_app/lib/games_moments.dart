import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'main.dart';

class GamesTab extends StatefulWidget {
  final VoidCallback onUpd;
  const GamesTab({super.key, required this.onUpd});
  @override
  State<GamesTab> createState() => _GamesTabState();
}

class _GamesTabState extends State<GamesTab> {
  String _cat = 'Hot';
  final _cats = List<String>.of({'Latest', 'Hot', 'Slot', 'Fishing', 'Multi Player'});

  final _games = List<Map<String, dynamic>>.of({
    {'name': 'Jungle Hunt', 'cat': 'Hot', 'tag': 'HOT', 'c1': 0xFF1B4332, 'c2': 0xFF40916C, 'ic': '🦁🌴', 'syms': List<String>.of({'WILD', 'SCATTER', '🍍', '🍎', '🍉', '🫐', '👑'})},
    {'name': 'Ocean Hunt', 'cat': 'Fishing', 'tag': 'HOT', 'c1': 0xFF023E8A, 'c2': 0xFF0077B6, 'ic': '🐙🎰', 'syms': List<String>.of({'WILD', 'SCATTER', '🐙', '🦈', '🐡', '💎', '👑'})},
    {'name': 'Royal Battle', 'cat': 'Multi Player', 'tag': 'HOT', 'c1': 0xFF590D22, 'c2': 0xFFA4133C, 'ic': '👑⚔️', 'syms': List<String>.of({'WILD', 'SCATTER', '👑', '⚔️', '🛡️', '💎', '🔥'})},
    {'name': 'Garo Gems III', 'cat': 'Latest', 'tag': 'NEW', 'c1': 0xFF3C096C, 'c2': 0xFF7B2CBF, 'ic': '🏺💎', 'syms': List<String>.of({'WILD', 'SCATTER', '💎', '🏺', '🔮', '👑', '⭐'})},
    {'name': 'Fruit Party', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF004B23, 'c2': 0xFF38B000, 'ic': '🍓🍊', 'syms': List<String>.of({'WILD', 'SCATTER', '🍓', '🍊', '🍉', '🍇', '7️⃣'})},
    {'name': 'Fishing Tycoon', 'cat': 'Fishing', 'tag': 'HOT', 'c1': 0xFF03045E, 'c2': 0xFF0096C7, 'ic': '🦈⚓', 'syms': List<String>.of({'WILD', 'SCATTER', '🦈', '🐋', '⚓', '💰', '💎'})},
    {'name': 'Money Coming', 'cat': 'Slot', 'tag': 'NEW', 'c1': 0xFF7F5539, 'c2': 0xFFB08968, 'ic': '💵🎡', 'syms': List<String>.of({'WILD', 'SCATTER', '💵', '🪙', '💰', '🎡', '👑'})},
    {'name': 'The Monkey King', 'cat': 'Hot', 'tag': 'HOT', 'c1': 0xFF6A040F, 'c2': 0xFFD00000, 'ic': '🐒🔥', 'syms': List<String>.of({'WILD', 'SCATTER', '🐒', '🔥', '🍑', '👑', '💎'})},
    {'name': 'Blaze Of Fortune', 'cat': 'Latest', 'tag': 'NEW', 'c1': 0xFF9D0208, 'c2': 0xFFE85D04, 'ic': '🔥💎', 'syms': List<String>.of({'WILD', 'SCATTER', '🔥', '💎', '⚡', '👑', '🪙'})},
    {'name': 'Lucky Piggy', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF7209B7, 'c2': 0xFFF72585, 'ic': '🐷💰', 'syms': List<String>.of({'WILD', 'SCATTER', '🐷', '💰', '🪙', '🍀', '💎'})},
    {'name': 'Fortune Rabbit', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF800F2F, 'c2': 0xFFFF4D6D, 'ic': '🐰🧧', 'syms': List<String>.of({'WILD', 'SCATTER', '🐰', '🧧', '🪙', '🌸', '👑'})},
    {'name': 'Gates Of Olympus', 'cat': 'Hot', 'tag': 'HOT', 'c1': 0xFF1D3557, 'c2': 0xFF457B9D, 'ic': '⚡🏛️', 'syms': List<String>.of({'WILD', 'SCATTER', '⚡', '🏛️', '👑', '💎', '🔥'})},
    {'name': 'Lucky 77 Pro', 'cat': 'Slot', 'tag': 'NEW', 'c1': 0xFF370617, 'c2': 0xFF9D0208, 'ic': '7️⃣🔔', 'syms': List<String>.of({'WILD', 'SCATTER', '7️⃣', '🔔', '🍒', '💎', '🪙'})},
    {'name': 'Fortune Tiger', 'cat': 'Hot', 'tag': 'HOT', 'c1': 0xFF7F4F24, 'c2': 0xFFCA6702, 'ic': '🐯🪙', 'syms': List<String>.of({'WILD', 'SCATTER', '🐯', '🪙', '🧧', '💎', '👑'})},
    {'name': 'Roulette Royal', 'cat': 'Multi Player', 'tag': 'HOT', 'c1': 0xFF003049, 'c2': 0xFFD62828, 'ic': '🎡♠️', 'syms': List<String>.of({'WILD', 'SCATTER', '🎡', '♠️', '♥️', '♦️', '👑'})},
    {'name': 'Deep Sea', 'cat': 'Fishing', 'tag': 'NEW', 'c1': 0xFF001219, 'c2': 0xFF0A9396, 'ic': '🐋🧜‍♀️', 'syms': List<String>.of({'WILD', 'SCATTER', '🐋', '🐙', '🐚', '💎', '🪙'})},
    {'name': 'Color Game', 'cat': 'Multi Player', 'tag': 'HOT', 'c1': 0xFF240046, 'c2': 0xFF5A189A, 'ic': '🎲🎨', 'syms': List<String>.of({'WILD', 'SCATTER', '🔴', '🟢', '🟡', '🔵', '👑'})},
    {'name': 'World Goal 2026', 'cat': 'Multi Player', 'tag': 'NEW', 'c1': 0xFF081C15, 'c2': 0xFF2D6A4F, 'ic': '⚽🏆', 'syms': List<String>.of({'WILD', 'SCATTER', '⚽', '🏆', '🥇', '🔥', '👑'})},
    {'name': 'Sweet Bonanza', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF590D22, 'c2': 0xFFFF758F, 'ic': '🍭🍬', 'syms': List<String>.of({'WILD', 'SCATTER', '🍭', '🍬', '🍇', '🍉', '💎'})},
    {'name': 'Dragon Ball', 'cat': 'Latest', 'tag': 'NEW', 'c1': 0xFF540B0E, 'c2': 0xFFE09F3E, 'ic': '🐉🔮', 'syms': List<String>.of({'WILD', 'SCATTER', '🐉', '🔮', '🔥', '⭐', '👑'})},
    {'name': 'Super Ace', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF10002B, 'c2': 0xFF7B2CBF, 'ic': '🃏👑', 'syms': List<String>.of({'WILD', 'SCATTER', '🃏', '👑', '♠️', '💎', '🪙'})},
    {'name': 'Chicken Road', 'cat': 'Latest', 'tag': 'HOT', 'c1': 0xFF335C67, 'c2': 0xFFE09F3E, 'ic': '🐔🛣️', 'syms': List<String>.of({'WILD', 'SCATTER', '🐔', '🥚', '🔥', '💰', '👑'})},
    {'name': 'Teen Patti', 'cat': 'Multi Player', 'tag': 'HOT', 'c1': 0xFF1B4332, 'c2': 0xFF52B788, 'ic': '🎴💎', 'syms': List<String>.of({'WILD', 'SCATTER', '🎴', '♠️', '♥️', '💎', '👑'})},
    {'name': 'Ludo King Party', 'cat': 'Multi Player', 'tag': 'HOT', 'c1': 0xFF003566, 'c2': 0xFFFFC300, 'ic': '🎲👑', 'syms': List<String>.of({'WILD', 'SCATTER', '🎲', '👑', '🔴', '🟢', '🟡'})},
  });

  void _openFullGame(Map<String, dynamic> g) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => FullScreenGameArena(game: g, onUpd: () { setState(() {}); widget.onUpd(); })));
  }

  void _convertCoins() {
    if (AppState.coins < 10000) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Min 10,000 Coins required to convert!')));
      return;
    }
    setState(() { AppState.coins -= 10000; AppState.points += 9000; });
    widget.onUpd();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Converted 10,000 Coins ➔ 9,000 Points!')));
  }

  @override
  Widget build(BuildContext context) {
    final list = _games.where((g) => g['cat'] == _cat || (_cat == 'Hot' && g['tag'] == 'HOT')).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Games • 🪙 ${AppState.coins}'),
        actions: List<Widget>.of({
          TextButton.icon(onPressed: _convertCoins, icon: const Icon(Icons.swap_horiz, color: Colors.tealAccent), label: const Text('Coins➔Pts', style: TextStyle(color: Colors.tealAccent))),
        }),
      ),
      body: Column(children: List<Widget>.of({
        SizedBox(
          height: 46,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: _cats.length,
            itemBuilder: (_, i) {
              final c = _cats.elementAt(i);
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(label: Text(c), selected: _cat == c, selectedColor: Colors.teal.shade700, onSelected: (_) => setState(() => _cat = c)),
              );
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.85),
            itemCount: list.length,
            itemBuilder: (_, i) {
              final g = list.elementAt(i);
              return InkWell(
                onTap: () => _openFullGame(g),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: <Color>[Color(g['c1'] as int), Color(g['c2'] as int)]),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.amber.withOpacity(0.65), width: 1.5),
                  ),
                  child: Stack(children: List<Widget>.of({
                    Positioned(top: 6, right: 6, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: g['tag'] == 'HOT' ? Colors.redAccent : Colors.green, borderRadius: BorderRadius.circular(8)), child: Text(g['tag'] as String, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)))),
                    Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: List<Widget>.of({
                      Text(g['ic'] as String, style: const TextStyle(fontSize: 32)),
                      const SizedBox(height: 8),
                      Text(g['name'] as String, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                    }))),
                  })),
                ),
              );
            },
          ),
        ),
      })),
    );
  }
}

class FullScreenGameArena extends StatefulWidget {
  final Map<String, dynamic> game;
  final VoidCallback onUpd;
  const FullScreenGameArena({super.key, required this.game, required this.onUpd});
  @override
  State<FullScreenGameArena> createState() => _FullScreenGameArenaState();
}

class _FullScreenGameArenaState extends State<FullScreenGameArena> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final _bets = List<int>.of({100, 500, 1000, 5000, 10000, 50000});
  int _betIdx = 0;
  bool _spinning = false;
  bool _autoSpin = false;
  bool _turbo = false;
  String _status = 'BET LINES: 20 • Tap SPIN!';
  List<String> _grid = List<String>.filled(15, '🍍');

  @override
  void initState() {
    super.initState();
    _fillRandomGrid();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..addListener(() {
      if (_spinning) setState(_fillRandomGrid);
    });
  }

  void _fillRandomGrid() {
    final syms = widget.game['syms'] as List<String>;
    final r = Random();
    _grid = List<String>.generate(15, (_) => syms.elementAt(r.nextInt(syms.length)));
  }

  @override
  void dispose() {
    _autoSpin = false;
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _spin() async {
    final bet = _bets.elementAt(_betIdx);
    if (_spinning) return;
    if (AppState.coins < bet) {
      setState(() { _status = '⚠️ Not enough Coins! Recharge first.'; _autoSpin = false; });
      return;
    }
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.click);
    setState(() { _spinning = true; AppState.coins -= bet; AppState.gamesPlayedToday++; _status = '🎰 Spinning 20 Lines...'; });
    widget.onUpd();
    _ctrl.repeat();
    await Future.delayed(Duration(milliseconds: _turbo ? 650 : 1250));
    _ctrl.stop();
    final r = Random();
    final syms = widget.game['syms'] as List<String>;
    final roll = r.nextInt(100);
    setState(() {
      _spinning = false;
      _fillRandomGrid();
      if (roll < 36) {
        final winSym = syms.elementAt(2 + r.nextInt(syms.length - 2));
        _grid[5] = winSym; _grid[6] = 'WILD'; _grid[7] = winSym; _grid[8] = 'WILD'; _grid[9] = winSym;
        final mult = roll < 8 ? 5 : (roll < 20 ? 3 : 2);
        final prize = bet * mult;
        AppState.coins += prize;
        _status = '🎉 BIG WIN (${mult}X)! +$prize Coins!';
        HapticFeedback.heavyImpact();
      } else {
        _status = 'Try Again! Spin for WILD & SCATTER!';
      }
    });
    widget.onUpd();
    if (_autoSpin && mounted) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (_autoSpin && mounted) _spin();
    }
  }

  Widget _buildCell(String sym) {
    if (sym == 'WILD') {
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(gradient: const LinearGradient(colors: <Color>[Color(0xFFFFB703), Color(0xFFFB8500)]), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white, width: 1.5)),
        child: const Text('WILD', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF3E1F00))),
      );
    }
    if (sym == 'SCATTER') {
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(gradient: const LinearGradient(colors: <Color>[Color(0xFF7209B7), Color(0xFFF72585)]), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.amber, width: 1.5)),
        child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[Text('👑', style: TextStyle(fontSize: 18)), Text('SCATTER', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.amber))]),
      );
    }
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.35), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white12)),
      child: Text(sym, style: const TextStyle(fontSize: 28)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c1 = Color(widget.game['c1'] as int);
    final c2 = Color(widget.game['c2'] as int);
    final bet = _bets.elementAt(_betIdx);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: <Color>[c1, c2, const Color(0xFF081C15)])),
        child: SafeArea(
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List<Widget>.of({
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List<Widget>.of({
                IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white), onPressed: () { _autoSpin = false; Navigator.pop(context); }),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.amber, width: 1.5)),
                  child: Row(children: List<Widget>.of({const Text('🪙 ', style: TextStyle(fontSize: 16)), Text('${AppState.coins}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber))})),
                ),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(10)), child: Text(widget.game['name'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black))),
              })),
            ),
            Column(children: List<Widget>.of({
              Text('${widget.game['ic']} ${widget.game['name']} • HD 20 LINES', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.amber)),
              const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.55), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.amber, width: 2.5)),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 15,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, crossAxisSpacing: 5, mainAxisSpacing: 5, childAspectRatio: 0.92),
                  itemBuilder: (_, i) => _buildCell(_grid.elementAt(i)),
                ),
              ),
              const SizedBox(height: 10),
              Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6), decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.tealAccent.withOpacity(0.5))), child: Text(_status, style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 13))),
            })),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.75), borderRadius: const BorderRadius.vertical(top: Radius.circular(22)), border: const Border(top: BorderSide(color: Colors.amber, width: 1.5))),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List<Widget>.of({
                InkWell(
                  onTap: () { setState(() => _autoSpin = !_autoSpin); if (_autoSpin) _spin(); },
                  child: CircleAvatar(radius: 24, backgroundColor: _autoSpin ? Colors.redAccent : Colors.orange.shade800, child: Text(_autoSpin ? 'STOP' : 'AUTO', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white))),
                ),
                Column(children: List<Widget>.of({
                  Text('SINGLE LINE: ${(bet / 20).toStringAsFixed(0)}   BET LINES: 20', style: const TextStyle(fontSize: 9, color: Colors.amber, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(children: List<Widget>.of({
                    InkWell(onTap: () => setState(() { if (_betIdx > 0) _betIdx--; }), child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.remove, size: 18, color: Colors.black))),
                    Container(width: 78, alignment: Alignment.center, child: Text('$bet', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))),
                    InkWell(onTap: () => setState(() { if (_betIdx < _bets.length - 1) _betIdx++; }), child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.add, size: 18, color: Colors.black))),
                    const SizedBox(width: 6),
                    InkWell(onTap: () => setState(() => _turbo = !_turbo), child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6), decoration: BoxDecoration(color: _turbo ? Colors.tealAccent : Colors.amber.shade700, borderRadius: BorderRadius.circular(8)), child: Text(_turbo ? '2.0X' : '1.0X', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)))),
                  })),
                })),
                InkWell(
                  onTap: _spinning ? null : _spin,
                  child: Container(
                    width: 66, height: 66,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: <Color>[Color(0xFF38B000), Color(0xFF007200)]), border: Border.all(color: Colors.amber, width: 3)),
                    child: Text(_spinning ? '...' : 'SPIN', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
                  ),
                ),
              })),
            ),
          })),
        ),
      ),
    );
  }
}
