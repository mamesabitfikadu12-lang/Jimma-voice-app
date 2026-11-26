import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'main.dart';

class GamesTab extends StatefulWidget {
  final VoidCallback onUpd;
  const GamesTab({super.key, required this.onUpd});
  @override
  State<GamesTab> createState() => _GamesTabState();
}

class _GamesTabState extends State<GamesTab> {
    @override
  void initState() {
    super.initState();
    _loadServerGames();
  }

    static const String _serverApi = 'https://api.mosabitshob.com';
  static const String _sudBase = 'https://sud.tech';

  Future<void> _loadServerGames() async {
    try {
      final res = await http.get(Uri.parse('$_serverApi/api/games')).timeout(const Duration(seconds: 8));
      if (res.statusCode == 200 && mounted) {
        final list = jsonDecode(res.body)['games'] as List?;
        if (list != null && list.isNotEmpty) {
          setState(() {
            _games = list.map<Map<String, dynamic>>((g) => {
              'name': g['name'] ?? '3D Game',
              'cat': g['cat'] ?? 'Hot',
              'tag': g['tag'] ?? 'HOT',
              'url': g['url'] ?? '',
              'c1': 0xFFF59E0B,
              'c2': 0xFFDC2626,
              'ic': '🎮',
              'sub': '3D',
            }).toList();
          });
        }
      }
    } catch (_) {}
  }

  String _cat = 'Hot';
  final _cats = const ['Hot', 'Board', 'Card', 'Party', 'Arcade', 'Sports'];

  List<Map<String, dynamic>> _games = [
    {'name': 'Ludo 3D', 'cat': 'Board', 'tag': 'HOT', 'url': '${_sudBase}1461227817776713818', 'c1': 0xFFF59E0B, 'c2': 0xFFEA580C, 'ic': '🎲', 'sub': '3D'},
    {'name': '8 Ball Pool 3D', 'cat': 'Sports', 'tag': 'HOT', 'url': '${_sudBase}1468180338417074177', 'c1': 0xFF0284C7, 'c2': 0xFF0369A1, 'ic': '🎱', 'sub': 'PRO'},
    {'name': 'Carrom Master', 'cat': 'Board', 'tag': 'HOT', 'url': '${_sudBase}1461228379255603251', 'c1': 0xFFD97706, 'c2': 0xFFB45309, 'ic': '🎯', 'sub': '3D'},
    {'name': 'Teen Patti Royal', 'cat': 'Card', 'tag': 'HOT', 'url': '${_sudBase}1461228465024925740', 'c1': 0xFFDC2626, 'c2': 0xFF991B1B, 'ic': '🃏', 'sub': 'VIP'},
    {'name': 'Texas Holdem Poker', 'cat': 'Card', 'tag': 'HOT', 'url': '${_sudBase}1461228436944060458', 'c1': 0xFF059669, 'c2': 0xFF065F46, 'ic': '♠️', 'sub': '3D'},
    {'name': 'UMO Party', 'cat': 'Card', 'tag': 'HOT', 'url': '${_sudBase}1461228410184400899', 'c1': 0xFF7C3AED, 'c2': 0xFF5B21B6, 'ic': '🎴', 'sub': 'FUN'},
    {'name': 'Domino Royal', 'cat': 'Board', 'tag': 'HOT', 'url': '${_sudBase}1461228492543754284', 'c1': 0xFF2563EB, 'c2': 0xFF1D4ED8, 'ic': '🁣', 'sub': 'TOP'},
    {'name': 'Super Football', 'cat': 'Sports', 'tag': 'HOT', 'url': '${_sudBase}1461228520020639789', 'c1': 0xFF16A34A, 'c2': 0xFF15803D, 'ic': '⚽', 'sub': 'LIVE'},
    {'name': 'Werewolf', 'cat': 'Party', 'tag': 'HOT', 'url': '${_sudBase}1472142559912517633', 'c1': 0xFF4F46E5, 'c2': 0xFF3730A3, 'ic': '🐺', 'sub': 'TOP'},
    {'name': 'Number Bomb', 'cat': 'Party', 'tag': 'HOT', 'url': '${_sudBase}1472142640866844673', 'c1': 0xFFEA580C, 'c2': 0xFFC2410C, 'ic': '💥', 'sub': 'HOT'},
  ];

  void _openFullGame(Map<String, dynamic> g) {
    final raw = (g['url'] ?? '') as String;
    final sep = raw.contains('?') ? '&' : '?';
    final fullUrl = '$raw${sep}uid=${AppState.userId}&coins=${AppState.coins}&app_id=2125623090652110848';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Real3DWebGameScreen(
          title: (g['name'] ?? '3D Game') as String,
          url: fullUrl,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final list = _games.where((g) => g['cat'] == _cat || (_cat == 'Hot' && g['tag'] == 'HOT')).toList();
    return Scaffold(
      backgroundColor: const Color(0xFF071A17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B2923),
        title: Row(
          children: [
            const Text('🎮 Games', style: TextStyle(fontWeight: FontWeight.w900)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber),
              ),
              child: Text('🪙 ${AppState.coins}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              itemCount: _cats.length,
              itemBuilder: (_, i) {
                final c = _cats[i];
                final sel = _cat == c;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(c, style: TextStyle(color: sel ? Colors.black : Colors.white70, fontWeight: FontWeight.bold)),
                    selected: sel,
                    selectedColor: const Color(0xFF34D399),
                    backgroundColor: const Color(0xFF123830),
                    onSelected: (_) => setState(() => _cat = c),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 9,
                mainAxisSpacing: 11,
                childAspectRatio: 0.78,
              ),
              itemCount: list.length,
              itemBuilder: (_, i) {
                final g = list[i];
                final c1 = Color(g['c1'] as int);
                final c2 = Color(g['c2'] as int);
                final tag = g['tag'] as String;
                return InkWell(
                  onTap: () => _openFullGame(g),
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: RadialGradient(
                              center: const Alignment(-0.3, -0.4),
                              radius: 1.2,
                              colors: [c1, c2, const Color(0xFF090D16)],
                            ),
                            border: Border.all(color: Colors.amberAccent.withOpacity(0.75), width: 1.8),
                            boxShadow: [BoxShadow(color: c1.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 3))],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Stack(
                              children: [
                                Positioned(
                                  right: -6,
                                  bottom: 14,
                                  child: Text(g['sub'] as String, style: TextStyle(fontSize: 36, color: Colors.white.withOpacity(0.28))),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 14),
                                    child: Text(
                                      g['ic'] as String,
                                      style: const TextStyle(
                                        fontSize: 44,
                                        shadows: [Shadow(color: Colors.black87, blurRadius: 10, offset: Offset(0, 4))],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 4,
                                  left: 4,
                                  right: 4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFB45309)]),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.yellowAccent, width: 0.8),
                                    ),
                                    child: Text(
                                      (g['name'] as String).toUpperCase(),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.3),
                                    ),
                                  ),
                                ),
                                if (tag.isNotEmpty)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: tag == 'NEW' ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10)),
                                      ),
                                      child: Text(tag, style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w900, color: Colors.white)),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        g['name'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
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
class FullScreenGameArena extends StatefulWidget {
  final Map<String, dynamic> game;
  final VoidCallback onUpd;
  const FullScreenGameArena({super.key, required this.game, required this.onUpd});
  @override
  State<FullScreenGameArena> createState() => _FullScreenGameArenaState();
}

class _FullScreenGameArenaState extends State<FullScreenGameArena> with SingleTickerProviderStateMixin {
    late AnimationController _ctrl;
  final List<int> _bets = List.of(<int>[50, 100, 500, 1000, 5000]);
  int _betIdx = 1;
  bool _spinning = false;
  bool _autoSpin = false;
  bool _turbo = false;
  String _winBanner = '';
  int _winAmount = 0;
  int _jackpotPool = 3712871;
  String _activeMult = '1x';
  List<String> _grid = List<String>.filled(15, '🦁');
  final AudioPlayer _sfxPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _fillRandomGrid();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 850))
      ..addListener(() {
        if (_spinning) setState(() => _fillRandomGrid());
      });
  }

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
    _grid = List<String>.generate(15, (_) => syms[r.nextInt(syms.length)]);
    final mults = ['1x', '2x', '3x', '5x', '15x', 'x512', 'x1024'];
    _activeMult = mults[r.nextInt(mults.length)];
  }

  @override
  void dispose() {
    _autoSpin = false;
    _ctrl.dispose();
    _sfxPlayer.dispose();
    super.dispose();
  }

  Future<void> _spin() async {
    final bet = _bets[_betIdx];
    if (_spinning) return;
    if (AppState.coins < bet) {
      setState(() => _autoSpin = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.red, content: Text('Not enough Coins! Recharge first.')),
      );
      return;
    }
    _playTierSfx('spin');
    setState(() {
      _spinning = true;
      _winBanner = '';
      _winAmount = 0;
      AppState.coins -= bet;
      _jackpotPool += (bet * 3);
      AppState.gamesPlayedToday++;
    });
    widget.onUpd();
    _ctrl.repeat();
    await Future.delayed(Duration(milliseconds: _turbo ? 550 : 1100));
    _ctrl.stop();

    final r = Random();
    final syms = widget.game['syms'] as List<String>;
    final roll = r.nextInt(100);
    setState(() {
      _spinning = false;
      _fillRandomGrid();
      if (roll < 42) {
        final winSym = syms[2 + r.nextInt(syms.length - 2)];
        _grid.setRange(5, 10, [winSym, 'WILD', winSym, 'WILD', winSym]);
        int mult = 2;
        String tier = 'WIN';
        if (roll < 5) {
          mult = 25;
          tier = 'MEGA JACKPOT';
          _activeMult = '15x';
        } else if (roll < 16) {
          mult = 8;
          tier = 'BIG WIN';
          _activeMult = '5x';
        } else {
          mult = 2 + r.nextInt(3);
          tier = 'WIN';
          _activeMult = '${mult}x';
        }
        final prize = bet * mult;
        AppState.coins += prize;
        _winBanner = '$tier (${mult}X)';
        _winAmount = prize;
        AppState.lastBigWinner = '${AppState.userName} won ${mult}X (+$prize Coins) in ${widget.game['name']}!';
        _playTierSfx(tier);
      } else {
        _winBanner = '';
        _activeMult = '1x';
      }
    });
    widget.onUpd();
    if (_winBanner.isNotEmpty && mounted) {
      await Future.delayed(const Duration(milliseconds: 1300));
      if (mounted) setState(() => _winBanner = '');
    }
    if (_autoSpin && mounted) {
      await Future.delayed(const Duration(milliseconds: 400));
      if (_autoSpin && mounted) _spin();
    }
  }
  Widget _buildCell(String sym) {
    final isWild = sym == 'WILD';
    final isScatter = sym == 'SCATTER';
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isWild
              ? [const Color(0xFFFDE047), const Color(0xFFEA580C)]
              : isScatter
                  ? [const Color(0xFFEC4899), const Color(0xFF7E22CE)]
                  : [const Color(0xFF1E293B).withOpacity(0.85), const Color(0xFF0F172A).withOpacity(0.95)],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isWild || isScatter ? Colors.amberAccent : Colors.amber.withOpacity(0.35), width: 1.4),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: isWild
          ? const Text('WILD', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF450A0A)))
          : isScatter
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('👑', style: TextStyle(fontSize: 18)),
                    Text('BONUS', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.white)),
                  ],
                )
              : Text(sym, style: const TextStyle(fontSize: 28)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c1 = Color(widget.game['c1'] as int);
    final c2 = Color(widget.game['c2'] as int);
    final bet = _bets[_betIdx];
    final mode = widget.game['mode'] as String? ?? 'jungle';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [c1, c2, const Color(0xFF050811)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                          onPressed: () {
                            _autoSpin = false;
                            Navigator.pop(context);
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.amber, width: 1.5),
                          ),
                          child: Row(
                            children: [
                              const Text('🪙 ', style: TextStyle(fontSize: 16)),
                              Text('${AppState.coins}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.amber)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            mode == 'gems' ? 'MULT: $_activeMult' : '15 LINES',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.amberAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFF78350F), Color(0xFFB45309), Color(0xFF78350F)]),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.yellowAccent, width: 2),
                          boxShadow: const [BoxShadow(color: Colors.black87, blurRadius: 10)],
                        ),
                        child: Column(
                          children: [
                            Text(
                              '👑 ${widget.game['name'].toString().toUpperCase()} JACKPOT',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.yellowAccent, letterSpacing: 1),
                            ),
                            Text(
                              '$_jackpotPool',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (mode == 'monkey' || mode == 'gems')
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: ['x1', 'x2', 'x5', '15x', 'x512'].map((m) {
                              final active = _activeMult == m;
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                decoration: BoxDecoration(
                                  color: active ? Colors.amber : Colors.black54,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.amberAccent),
                                ),
                                child: Text(
                                  m,
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: active ? Colors.black : Colors.amberAccent),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F1108).withOpacity(0.88),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFF59E0B), width: 3),
                          boxShadow: const [BoxShadow(color: Colors.black87, blurRadius: 14)],
                        ),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 15,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                            childAspectRatio: 0.92,
                          ),
                          itemBuilder: (_, i) => _buildCell(_grid[i]),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.amber.withOpacity(0.5)),
                        ),
                        child: Text(
                          'WIN: 🪙 $_winAmount',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.amberAccent),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.82),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                      border: Border.all(color: Colors.amber.withOpacity(0.45)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() => _autoSpin = !_autoSpin);
                            if (_autoSpin) _spin();
                          },
                          child: CircleAvatar(
                            radius: 23,
                            backgroundColor: _autoSpin ? Colors.redAccent : Colors.orange.shade800,
                            child: const Icon(Icons.autorenew, color: Colors.white),
                          ),
                        ),
                        Column(
                          children: [
                            const Text('TOTAL BET', style: TextStyle(fontSize: 10, color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () => setState(() { if (_betIdx > 0) _betIdx--; }),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(8)),
                                    child: const Text('-', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                Container(
                                  width: 72,
                                  alignment: Alignment.center,
                                  child: Text('🪙 $bet', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.amber)),
                                ),
                                InkWell(
                                  onTap: () => setState(() { if (_betIdx < _bets.length - 1) _betIdx++; }),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(8)),
                                    child: const Text('+', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                InkWell(
                                  onTap: () => setState(() => _turbo = !_turbo),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: _turbo ? Colors.amber : Colors.white12,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.flash_on, size: 18, color: _turbo ? Colors.black : Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: _spinning ? null : _spin,
                          child: Container(
                            width: 68,
                            height: 68,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(colors: [Color(0xFF4ADE80), Color(0xFF15803D)]),
                              border: Border.all(color: Colors.yellowAccent, width: 3),
                              boxShadow: [BoxShadow(color: Colors.greenAccent.withOpacity(0.5), blurRadius: 12)],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_spinning ? '...' : 'SPIN', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.white)),
                                const Text('AUTO', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.yellowAccent)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (_winBanner.isNotEmpty)
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFDC2626)]),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.yellowAccent, width: 3),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('👑🏆👑', style: TextStyle(fontSize: 32)),
                        Text(_winBanner, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
                        Text('+🪙 $_winAmount', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.yellowAccent)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setM) => Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Share a Moment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextField(controller: c, maxLines: 3, decoration: const InputDecoration(hintText: 'Write something positive...')),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () async {
                      final XFile? f = await _picker.pickImage(source: ImageSource.gallery);
                      if (f != null) setM(() => imgPath = f.path);
                    },
                    icon: const Icon(Icons.photo, color: Colors.amber),
                    label: Text(imgPath == null ? 'Add Photo' : 'Photo Ready ✓'),
                  ),
                  const Spacer(),
                  DropdownButton<String>(
                    value: tag,
                    items: const ['#EthioVoice', '#OromoCulture', '#VoiceParty']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setM(() => tag = v ?? '#EthioVoice'),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 46),
                ),
                onPressed: () {
                  if (AppState.hasProfanity(c.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(backgroundColor: Colors.red, content: Text('Abusive language is not allowed.')),
                    );
                    return;
                  }
                  if (c.text.trim().isNotEmpty || imgPath != null) {
                    AppState.moments.insert(0, {
                      'user': AppState.userName,
                      'tag': tag,
                      'text': c.text.trim(),
                      'likes': '1',
                      'img': imgPath ?? '',
                    });
                    setState(() {});
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Post Moment'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filter == 'All' ? AppState.moments : AppState.moments.where((m) => m['tag'] == _filter).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moments'),
        actions: [IconButton(icon: const Icon(Icons.add_a_photo, color: Colors.amber), onPressed: _newPost)],
      ),
      body: Column(
        children: [
          Wrap(
            spacing: 8,
            children: ['All', '#EthioVoice', '#OromoCulture', '#VoiceParty']
                .map((t) => ChoiceChip(
                      label: Text(t),
                      selected: _filter == t,
                      selectedColor: Colors.amber,
                      onSelected: (_) => setState(() => _filter = t),
                    ))
                .toList(),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: list.length,
              itemBuilder: (_, i) {
                final m = list[i];
                final img = m['img'] ?? '';
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(backgroundColor: Colors.amber, child: Icon(Icons.person, color: Colors.black)),
                            const SizedBox(width: 8),
                            Text(m['user'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const Spacer(),
                            Text(m['tag'] ?? '', style: const TextStyle(color: Colors.tealAccent, fontSize: 12)),
                          ],
                        ),
                        if ((m['text'] ?? '').toString().isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text((m['text'] ?? '').toString()),
                        ],
                        if (img.toString().isNotEmpty && !kIsWeb) ...[
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(File(img), height: 170, width: double.infinity, fit: BoxFit.cover),
                          ),
                        ],
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.favorite, color: Colors.redAccent),
                              onPressed: () => setState(() => m['likes'] = '${(int.tryParse((m['likes'] ?? '0').toString()) ?? 0) + 1}'),

                            ),
                            Text('${m['likes'] ?? 0}'),
                          ],
                        ),
                      ],
                    ),
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

class ChatTab extends StatefulWidget {
  final VoidCallback onUpd;
  const ChatTab({super.key, required this.onUpd});
  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final _msgCtrl = TextEditingController();
  final _picker = ImagePicker();

  void _sendText() {
    final t = _msgCtrl.text.trim();
    if (t.isEmpty) return;
    if (AppState.hasProfanity(t)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.red, content: Text('Abusive language is blocked.')),
      );
      return;
    }
    setState(() {
      AppState.chatMessages.add({'sender': AppState.userName, 'type': 'text', 'content': t, 'time': 'Now'});
    });
    _msgCtrl.clear();
  }

  Future<void> _sendPhoto() async {
    final XFile? f = await _picker.pickImage(source: ImageSource.gallery);
    if (f != null) {
      setState(() {
        AppState.chatMessages.add({'sender': AppState.userName, 'type': 'image', 'content': f.path, 'time': 'Now'});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Messages'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [Tab(text: 'Free Chat'), Tab(text: 'Payroll Receipts'), Tab(text: 'System Notice')],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: AppState.chatMessages.length,
                    itemBuilder: (_, i) {
                      final m = AppState.chatMessages[i];
                      final isMe = m['sender'] == AppState.userName;
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isMe ? const Color(0xFF065F46) : const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m['sender'] ?? '', style: const TextStyle(fontSize: 10, color: Colors.amber)),
                              if (m['type'] == 'image' && !kIsWeb)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child:Image.file(File((m['content'] ?? '').toString()), width: 150, height: 120, fit: BoxFit.cover),
                                )
                              else
                                Text(m['content'] ?? ''),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    color: const Color(0xFF111827),
                    child: Row(
                      children: [
                        IconButton(icon: const Icon(Icons.photo, color: Colors.amber), onPressed: _sendPhoto),
                        Expanded(
                          child: TextField(
                            controller: _msgCtrl,
                            decoration: const InputDecoration(hintText: 'Free message...', isDense: true),
                          ),
                        ),
                        IconButton(icon: const Icon(Icons.send, color: Colors.tealAccent), onPressed: _sendText),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: AppState.systemReceipts.length,
              itemBuilder: (_, i) {
                final r = AppState.systemReceipts[i];
                return Card(
                  color: const Color(0xFF1E293B),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.receipt_long, color: Colors.tealAccent),
                    title: Text('${r['type'] ?? 'Receipt'} • ${r['amount'] ?? ''}'),
                    subtitle: Text('Order ID: ${r['orderId'] ?? ''}'),
                  ),
                );
              },
            ),
            ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: AppState.officialNotices.length,
              itemBuilder: (_, i) {
                final n = AppState.officialNotices[i];
                return Card(
                  color: const Color(0xFF1E293B),
                  child: ListTile(
                    leading: const Icon(Icons.campaign, color: Colors.amber),
                    title: Text(n['title'] ?? ''),
                    subtitle: Text(n['body'] ?? ''),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  }
  class MessagesTab extends ChatTab {
  const MessagesTab({super.key, required super.onUpd});
}
class Real3DWebGameScreen extends StatefulWidget {
  final String title;
  final String url;
  const Real3DWebGameScreen({super.key, required this.title, required this.url});
  @override
  State<Real3DWebGameScreen> createState() => _Real3DWebGameScreenState();
}

class _Real3DWebGameScreenState extends State<Real3DWebGameScreen> {
  late final WebViewController _webCtrl;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _webCtrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF050811))
      ..setNavigationDelegate(
        NavigationDelegate(onPageFinished: (_) { if (mounted) setState(() => _loading = false); }),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050811),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B2923),
        title: Text('🎮 ${widget.title} (3D)'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => _webCtrl.reload()),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _webCtrl),
          if (_loading)
            const Center(child: CircularProgressIndicator(color: Colors.amber)),
        ],
      ),
    );
  }
}
