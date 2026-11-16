import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
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
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Converted 10,000 Coins -> 9,000 Points!')));
  }

  @override
  Widget build(BuildContext context) {
    final list = _games.where((g) => g['cat'] == _cat || (_cat == 'Hot' && g['tag'] == 'HOT')).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Games • 🪙 ${AppState.coins}'),
        actions: List<Widget>.of({
          TextButton.icon(onPressed: _convertCoins, icon: const Icon(Icons.swap_horiz, color: Colors.tealAccent), label: const Text('Coins->Pts', style: TextStyle(color: Colors.tealAccent))),
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
  String _winBanner = '';
  int _winAmount = 0;
  List<String> _grid = List<String>.filled(15, '🍍');

  @override
  void initState() {
    super.initState();
    _fillRandomGrid();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..addListener(() {
      if (_spinning) setState(_fillRandomGrid);
    });
  }

    final AudioPlayer _sfxPlayer = AudioPlayer();

  Future<void> _playTierSfx(String tier) async {
    try {
      await _sfxPlayer.stop();
      if (tier == 'MEGA JACKPOT') {
        HapticFeedback.heavyImpact();
        await _sfxPlayer.play(AssetSource('sounds/jackpot.wav'));
      } else if (tier == 'BIG WIN') {
        HapticFeedback.heavyImpact();
        await _sfxPlayer.play(AssetSource('sounds/bigwin.wav'));
      } else if (tier == 'WIN') {
        HapticFeedback.mediumImpact();
        await _sfxPlayer.play(AssetSource('sounds/win.wav'));
      } else {
        HapticFeedback.lightImpact();
        await _sfxPlayer.play(AssetSource('sounds/spin.wav'));
      }
    } catch (_) {}
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
      setState(() { _status = 'Not enough Coins! Recharge first.'; _autoSpin = false; });
      return;
    }
    _playTierSfx('spin');
    setState(() { _spinning = true; _winBanner = ''; AppState.coins -= bet; AppState.gamesPlayedToday++; _status = 'Spinning 20 Lines...'; });
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
      if (roll < 38) {
        final winSym = syms.elementAt(2 + r.nextInt(syms.length - 2));
        _grid.setRange(5, 10, List<String>.of({winSym, 'WILD', winSym, 'WILD', winSym}));
        int mult = 2;
        String tier = 'WIN';
        if (roll < 5) {
          mult = 31;
          tier = 'MEGA JACKPOT';
        } else if (roll < 16) {
          mult = 8;
          tier = 'BIG WIN';
        } else {
          mult = 2 + r.nextInt(2);
          tier = 'WIN';
        }
        final prize = bet * mult;
        AppState.coins += prize;
        _winBanner = '$tier (${mult}X)';
        _winAmount = prize;
        _status = '$tier! +$prize Coins!';
        AppState.lastBigWinner = '${AppState.userName} won ${mult}x (+$prize Coins) in ${widget.game['name']}!';
        _playTierSfx(tier);
      } else {
        _winBanner = '';
        _status = 'Try Again! Spin for WILD & SCATTER!';
        _playTierSfx('lose');
      }
    });
    widget.onUpd();
    if (_winBanner.isNotEmpty && mounted) {
      await Future.delayed(const Duration(milliseconds: 1400));
      if (mounted) setState(() => _winBanner = '');
    }
    if (_autoSpin && mounted) {
      await Future.delayed(const Duration(milliseconds: 450));
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
          child: Stack(children: List<Widget>.of({
            Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List<Widget>.of({
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
            if (_winBanner.isNotEmpty)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: _winBanner.contains('MEGA') ? <Color>[const Color(0xFF7209B7), const Color(0xFFF72585)] : (_winBanner.contains('BIG') ? <Color>[const Color(0xFFD00000), const Color(0xFFFFB703)] : <Color>[const Color(0xFF007200), const Color(0xFF38B000)])),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.amber, width: 3),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: List<Widget>.of({
                    Text(_winBanner.contains('MEGA') ? '👑🔥🎰' : (_winBanner.contains('BIG') ? '🎉💰✨' : '🪙✨'), style: const TextStyle(fontSize: 34)),
                    Text(_winBanner, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white)),
                    Text('+🪙 $_winAmount', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.amber)),
                  })),
                ),
              ),
          })),
        ),
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
  final _picker = ImagePicker();
  String _filter = 'All';

  void _newPost() {
    final c = TextEditingController();
    String tag = '#EthioVoice';
    String? imgPath;
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (ctx) => StatefulBuilder(builder: (ctx, setB) => Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
      child: Column(mainAxisSize: MainAxisSize.min, children: List<Widget>.of({
        const Text('Share a Moment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        TextField(controller: c, maxLines: 3, decoration: const InputDecoration(hintText: 'Write something positive...')),
        Row(children: List<Widget>.of({
          TextButton.icon(onPressed: () async { final XFile? f = await _picker.pickImage(source: ImageSource.gallery); if (f != null) setB(() => imgPath = f.path); }, icon: const Icon(Icons.photo, color: Colors.amber), label: Text(imgPath == null ? 'Add Photo' : 'Photo Added')),
          const Spacer(),
          DropdownButton<String>(value: tag, items: List<String>.of({'#EthioVoice', '#OromoCulture', '#VoiceParty'}).map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(), onChanged: (v) => setB(() => tag = v ?? '#EthioVoice')),
        })),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 44)), onPressed: () {
          if (AppState.hasProfanity(c.text)) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('Abusive words are strictly prohibited!')));
            return;
          }
          if (c.text.trim().isNotEmpty || imgPath != null) {
            AppState.moments.insert(0, {'user': AppState.userName, 'tag': tag, 'text': c.text.trim(), 'likes': '1', 'img': imgPath ?? ''});
            setState(() {});
            Navigator.pop(ctx);
          }
        }, child: const Text('Post Moment')),
      })),
    )));
  }

  @override
  Widget build(BuildContext context) {
    final list = _filter == 'All' ? AppState.moments : AppState.moments.where((m) => m['tag'] == _filter).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Moments'), actions: List<Widget>.of({IconButton(icon: const Icon(Icons.add_a_photo, color: Colors.amber), onPressed: _newPost)})),
      body: Column(children: List<Widget>.of({
        Wrap(spacing: 8, children: List<String>.of({'All', '#EthioVoice', '#OromoCulture', '#VoiceParty'}).map((t) => ChoiceChip(label: Text(t), selected: _filter == t, onSelected: (_) => setState(() => _filter = t))).toList()),
        Expanded(child: ListView.builder(padding: const EdgeInsets.all(12), itemCount: list.length, itemBuilder: (_, i) {
          final m = list.elementAt(i);
          final img = m['img'] ?? '';
          return Card(margin: const EdgeInsets.only(bottom: 12), child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: List<Widget>.of({
            Row(children: List<Widget>.of({const CircleAvatar(backgroundColor: Colors.amber, child: Icon(Icons.person, color: Colors.black)), const SizedBox(width: 10), Text(m['user'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)), const Spacer(), Chip(label: Text(m['tag'] ?? '', style: const TextStyle(fontSize: 11)))})),
            if ((m['text'] ?? '').isNotEmpty) Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(m['text'] ?? '')),
            if (img.isNotEmpty && !kIsWeb) ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.file(File(img), height: 180, width: double.infinity, fit: BoxFit.cover)),
            Row(children: List<Widget>.of({
              IconButton(icon: const Icon(Icons.favorite, color: Colors.redAccent), onPressed: () => setState(() => m['likes'] = '${(int.tryParse(m['likes'] ?? '0') ?? 0) + 1}')),
              Text('${m['likes']} Likes'),
            })),
          }))));
        })),
      })),
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

  void _sendText() {
    final t = _msgCtrl.text.trim();
    if (t.isEmpty) return;
    if (AppState.hasProfanity(t)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('Abusive language is not allowed!')));
      return;
    }
    setState(() { AppState.chatMessages.add({'sender': AppState.userName, 'type': 'text', 'content': t, 'time': 'Now'}); _msgCtrl.clear(); });
  }

  Future<void> _sendPhoto() async {
    final XFile? f = await _picker.pickImage(source: ImageSource.gallery);
    if (f != null) setState(() => AppState.chatMessages.add({'sender': AppState.userName, 'type': 'image', 'content': f.path, 'time': 'Now'}));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3, child: Scaffold(
      appBar: AppBar(title: const Text('Messages'), bottom: const TabBar(isScrollable: true, tabs: <Tab>[Tab(text: 'Free Chat'), Tab(text: 'System Message'), Tab(text: 'Official Notification')])),
      body: TabBarView(children: List<Widget>.of({
        Column(children: List<Widget>.of({
          Expanded(child: ListView.builder(padding: const EdgeInsets.all(12), itemCount: AppState.chatMessages.length, itemBuilder: (_, i) {
            final m = AppState.chatMessages.elementAt(i);
            final isMe = m['sender'] == AppState.userName;
            return Align(alignment: isMe ? Alignment.centerRight : Alignment.centerLeft, child: Container(margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: isMe ? Colors.teal.shade800 : const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: List<Widget>.of({
              Text(m['sender'] ?? '', style: const TextStyle(fontSize: 10, color: Colors.amber)),
              if (m['type'] == 'image' && !kIsWeb) ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(File(m['content'] ?? ''), width: 170, height: 130, fit: BoxFit.cover)) else Text(m['content'] ?? ''),
            }))));
          })),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              color: const Color(0xFF111827),
              child: Row(children: List<Widget>.of({
                IconButton(icon: const Icon(Icons.photo, color: Colors.amber), onPressed: _sendPhoto),
                Expanded(child: TextField(controller: _msgCtrl, decoration: const InputDecoration(hintText: 'Free message or User ID...', border: InputBorder.none))),
                IconButton(icon: const Icon(Icons.send, color: Colors.tealAccent), onPressed: _sendText),
              })),
            ),
          ),
        })),
        ListView.builder(padding: const EdgeInsets.all(12), itemCount: AppState.systemReceipts.length, itemBuilder: (_, i) {
          final r = AppState.systemReceipts.elementAt(i);
          if (r['type'] == 'bonus') {
            return Card(color: const Color(0xFF1E293B), margin: const EdgeInsets.only(bottom: 12), child: ListTile(leading: const Icon(Icons.redeem, color: Colors.amber), title: Text(r['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text('${r['body']}\n${r['time']}')));
          }
                    return Card(
            color: const Color(0xFF1E293B),
            margin: const EdgeInsets.only(bottom: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.tealAccent.withOpacity(0.4))),
            child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: List<Widget>.of({
              const Text('Withdrawal received', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 6),
              Center(child: Text(r['amount'] ?? '', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.amber))),
              Center(child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3), decoration: BoxDecoration(color: Colors.green.withOpacity(0.25), borderRadius: BorderRadius.circular(10)), child: Text(r['status'] ?? 'Done', style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 12)))),
              const Divider(height: 20),
              Text('Order ID: ${r['orderId']}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
              Text('Applicant: ${r['applicant']}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
              Text('Method: ${r['method']}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
              Text('Application Time: ${r['appTime']}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
              Text('Notarize Time: ${r['notarizeTime']}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
              Text('Finish Time: ${r['finishTime']}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
              const SizedBox(height: 12),
              OutlinedButton(style: OutlinedButton.styleFrom(foregroundColor: Colors.tealAccent, side: const BorderSide(color: Colors.tealAccent), minimumSize: const Size(double.infinity, 40)), onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Official Payroll WhatsApp: +251919108311')));
              }, child: const Text('Contact payroll')),
            }))),
          );
        }),
        ListView.builder(padding: const EdgeInsets.all(12), itemCount: AppState.officialNotices.length, itemBuilder: (_, i) {
          final n = AppState.officialNotices.elementAt(i);
          return Card(color: const Color(0xFF1E293B), child: ListTile(leading: const Icon(Icons.campaign, color: Colors.amber), title: Text(n['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text('${n['body'] ?? ''}\n${n['time'] ?? ''}')));
        }),
      })),
    ));
  }
}

