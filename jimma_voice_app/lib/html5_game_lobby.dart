import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'main.dart';

class Html5GameLobbyPage extends StatefulWidget {
  final VoidCallback onBalanceChanged;
  const Html5GameLobbyPage({super.key, required this.onBalanceChanged});

  @override
  State<Html5GameLobbyPage> createState() => _Html5GameLobbyPageState();
}

class _Html5GameLobbyPageState extends State<Html5GameLobbyPage> {
  String _selectedCat = 'Hot';
  final Random _rng = Random();

  final List<Map<String, dynamic>> _games = <Map<String, dynamic>>[
    <String, dynamic>{'title': 'Ocean Hunt', 'cat': 'Fishing', 'tag': 'HOT', 'c1': 0xFF8E24AA, 'c2': 0xFF311B92, 'icon': Icons.tsunami},
    <String, dynamic>{'title': 'Jungle Hunt', 'cat': 'Hot', 'tag': 'HOT', 'c1': 0xFF43A047, 'c2': 0xFF1B5E20, 'icon': Icons.forest},
    <String, dynamic>{'title': 'Royal Battle', 'cat': 'Multi Player', 'tag': 'HOT', 'c1': 0xFFE53935, 'c2': 0xFF880E4F, 'icon': Icons.emoji_events},
    <String, dynamic>{'title': 'Ocean Hunt II', 'cat': 'Fishing', 'tag': 'NEW', 'c1': 0xFF1E88E5, 'c2': 0xFF0D47A1, 'icon': Icons.waves},
    <String, dynamic>{'title': 'Jungle Delight', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF2E7D32, 'c2': 0xFF33691E, 'icon': Icons.pets},
    <String, dynamic>{'title': 'Garo Gems III', 'cat': 'Slot', 'tag': 'NEW', 'c1': 0xFFFFB300, 'c2': 0xFFE65100, 'icon': Icons.diamond},
    <String, dynamic>{'title': 'Garo Gems II', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFFFB8C00, 'c2': 0xFFBF360C, 'icon': Icons.auto_awesome},
    <String, dynamic>{'title': 'Garo Gems I', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFFF4511E, 'c2': 0xFF8E0000, 'icon': Icons.stars},
    <String, dynamic>{'title': 'Fruit Party', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF7CB342, 'c2': 0xFF2E7D32, 'icon': Icons.local_florist},
    <String, dynamic>{'title': 'Fishing Tycoon', 'cat': 'Fishing', 'tag': 'HOT', 'c1': 0xFF039BE5, 'c2': 0xFF01579B, 'icon': Icons.sailing},
    <String, dynamic>{'title': 'The Monkey King', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFFD32F2F, 'c2': 0xFF4A0007, 'icon': Icons.whatshot},
    <String, dynamic>{'title': 'Blaze Of Fortune', 'cat': 'Latest', 'tag': 'NEW', 'c1': 0xFFFFA000, 'c2': 0xFF6D4C41, 'icon': Icons.local_fire_department},
    <String, dynamic>{'title': 'Bonanza Banana', 'cat': 'Latest', 'tag': 'NEW', 'c1': 0xFFC0CA33, 'c2': 0xFF558B2F, 'icon': Icons.eco},
    <String, dynamic>{'title': 'Lucky Piggy', 'cat': 'Latest', 'tag': 'NEW', 'c1': 0xFFD81B60, 'c2': 0xFF4A148C, 'icon': Icons.savings},
    <String, dynamic>{'title': 'Fortune Rabbit', 'cat': 'Latest', 'tag': 'NEW', 'c1': 0xFFEC407A, 'c2': 0xFF880E4F, 'icon': Icons.cruelty_free},
    <String, dynamic>{'title': 'Storm Joker', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF6A1B9A, 'c2': 0xFF1A237E, 'icon': Icons.theater_comedy},
    <String, dynamic>{'title': 'Gates Of Olympus', 'cat': 'Slot', 'tag': 'NEW', 'c1': 0xFF5E35B1, 'c2': 0xFF1A237E, 'icon': Icons.bolt},
    <String, dynamic>{'title': 'Starlight Princess', 'cat': 'Latest', 'tag': 'NEW', 'c1': 0xFF3949AB, 'c2': 0xFF4A148C, 'icon': Icons.auto_fix_high},
    <String, dynamic>{'title': 'Gems Sky', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF8E24AA, 'c2': 0xFF311B92, 'icon': Icons.castle},
    <String, dynamic>{'title': 'Scratch Boxing', 'cat': 'Latest', 'tag': 'NEW', 'c1': 0xFFC62828, 'c2': 0xFF212121, 'icon': Icons.sports_mma},
    <String, dynamic>{'title': 'Money Coming', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF2E7D32, 'c2': 0xFF004D40, 'icon': Icons.monetization_on},
    <String, dynamic>{'title': 'Super Ace', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFFAD1457, 'c2': 0xFF311B92, 'icon': Icons.style},
    <String, dynamic>{'title': 'Aztec Magic', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF6D4C41, 'c2': 0xFF3E2723, 'icon': Icons.account_balance},
    <String, dynamic>{'title': 'Chicken Road', 'cat': 'Latest', 'tag': 'NEW', 'c1': 0xFFF57C00, 'c2': 0xFFBF360C, 'icon': Icons.directions_run},
    <String, dynamic>{'title': 'CosmoX', 'cat': 'Latest', 'tag': 'NEW', 'c1': 0xFF1565C0, 'c2': 0xFF000051, 'icon': Icons.rocket_launch},
    <String, dynamic>{'title': 'Kraken III', 'cat': 'Fishing', 'tag': 'HOT', 'c1': 0xFF00695C, 'c2': 0xFF00251A, 'icon': Icons.water},
    <String, dynamic>{'title': 'Fishing Star', 'cat': 'Fishing', 'tag': 'HOT', 'c1': 0xFF0277BD, 'c2': 0xFF002F6C, 'icon': Icons.anchor},
    <String, dynamic>{'title': 'Teen Patti', 'cat': 'Multi Player', 'tag': 'HOT', 'c1': 0xFF00897B, 'c2': 0xFF004D40, 'icon': Icons.style},
    <String, dynamic>{'title': 'Magic Slot', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF4527A0, 'c2': 0xFF12005E, 'icon': Icons.flare},
    <String, dynamic>{'title': 'Crazy Gems', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFFD84315, 'c2': 0xFF4E342E, 'icon': Icons.hexagon},
    <String, dynamic>{'title': 'Sphinx Legend', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFFEF6C00, 'c2': 0xFF4E342E, 'icon': Icons.temple_hindu},
    <String, dynamic>{'title': 'Ludo King', 'cat': 'Multi Player', 'tag': 'HOT', 'c1': 0xFF1976D2, 'c2': 0xFF0D47A1, 'icon': Icons.casino},
    <String, dynamic>{'title': 'Roulette', 'cat': 'Multi Player', 'tag': 'HOT', 'c1': 0xFF388E3C, 'c2': 0xFF1B5E20, 'icon': Icons.motion_photos_on},
    <String, dynamic>{'title': 'Mahjong Ways', 'cat': 'Slot', 'tag': 'HOT', 'c1': 0xFF9E9D24, 'c2': 0xFF33691E, 'icon': Icons.grid_on},
    <String, dynamic>{'title': 'Bounty Football', 'cat': 'Multi Player', 'tag': 'NEW', 'c1': 0xFF2E7D32, 'c2': 0xFF003300, 'icon': Icons.sports_soccer},
    <String, dynamic>{'title': 'Deep Sea', 'cat': 'Fishing', 'tag': 'HOT', 'c1': 0xFF00838F, 'c2': 0xFF00363A, 'icon': Icons.scuba_diving},
  ];

  void _launchInteractiveGame(Map<String, dynamic> game) {
    final List<String> symbols = <String>['💎', '👑', '🔥', '⚡', '🍀', '🎯'];
    int bet = 100;
    bool spinning = false;
    List<String> reels = <String>['💎', '👑', '💎'];
    String statusMsg = 'Tap SPIN to play ${game['title']}!';
    Timer? spinTimer;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) {
          void startSpin() {
            if (spinning) return;
            if (AppState.coins < bet) {
              setD(() => statusMsg = 'Not enough coins! Please recharge.');
              return;
            }
            setState(() => AppState.coins -= bet);
            widget.onBalanceChanged();
            setD(() {
              spinning = true;
              statusMsg = 'Spinning...';
            });

            int ticks = 0;
            spinTimer?.cancel();
            spinTimer = Timer.periodic(const Duration(milliseconds: 90), (t) {
              ticks++;
              setD(() {
                reels = <String>[
                  symbols[_rng.nextInt(symbols.length)],
                  symbols[_rng.nextInt(symbols.length)],
                  symbols[_rng.nextInt(symbols.length)],
                ];
              });
              if (ticks >= 14) {
                t.cancel();
                final bool isJackpot = _rng.nextInt(10) == 0;
                final bool isWin = isJackpot || _rng.nextBool();
                if (isJackpot) {
                  reels = <String>['👑', '👑', '👑'];
                } else if (isWin) {
                  final s = symbols[_rng.nextInt(symbols.length)];
                  reels = <String>[s, s, symbols[(_rng.nextInt(symbols.length - 1) + 1) % symbols.length]];
                }
                final int prize = isJackpot ? bet * 5 : (isWin ? bet * 2 : 0);
                if (prize > 0) {
                  setState(() => AppState.coins += prize);
                  widget.onBalanceChanged();
                }
                setD(() {
                  spinning = false;
                  statusMsg = isJackpot
                      ? '🏆 MEGA JACKPOT! +$prize Coins!'
                      : (isWin ? '🎉 YOU WON +$prize Coins!' : 'No match! Try again.');
                });
              }
            });
          }

          return AlertDialog(
            backgroundColor: const Color(0xFF0F1A24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            title: Row(children: <Widget>[
              Icon(game['icon'] as IconData, color: Colors.amber),
              const SizedBox(width: 8),
              Expanded(child: Text(game['title'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            ]),
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text('🪙 Balance: ${AppState.coins}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.amber, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: reels.map((s) => Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)),
                    child: Text(s, style: const TextStyle(fontSize: 30)),
                  )).toList(),
                ),
              ),
              const SizedBox(height: 10),
              Text(statusMsg, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.tealAccent, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                children: List<int>.of(<int>{50, 100, 500, 1000}).map((amt) => ChoiceChip(
                  label: Text('$amt'),
                  selected: bet == amt,
                  onSelected: spinning ? null : (_) => setD(() => bet = amt),
                )).toList(),
              ),
            ]),
            actions: <Widget>[
              TextButton(
                onPressed: spinning
                    ? null
                    : () {
                        spinTimer?.cancel();
                        Navigator.pop(ctx);
                      },
                child: const Text('Close'),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: spinning ? null : startSpin,
                icon: const Icon(Icons.play_arrow, color: Colors.black),
                label: Text(spinning ? 'Spinning...' : 'SPIN ($bet)', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = <String>['Latest', 'Hot', 'Slot', 'Fishing', 'Multi Player'];
    final visible = _selectedCat == 'Hot'
        ? _games
        : _games.where((g) => g['cat'] == _selectedCat).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0A1412),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1F1B),
        title: const Text('🎮 Games Lobby', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Chip(
              backgroundColor: Colors.amber,
              label: Text('🪙 ${AppState.coins}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: Column(children: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.amber.withOpacity(0.45)),
          ),
          child: const Row(children: <Widget>[
            Icon(Icons.verified_user, color: Colors.amber, size: 16),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Entertainment Only: Virtual coins for voice room gifts & casual games.',
                style: TextStyle(fontSize: 10.5, color: Colors.white70),
              ),
            ),
          ]),
        ),
        SizedBox(
          height: 44,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            itemCount: categories.length,
            itemBuilder: (_, i) {
              final cat = categories[i];
              final active = _selectedCat == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  selectedColor: Colors.tealAccent,
                  backgroundColor: Colors.white10,
                  label: Text(cat, style: TextStyle(color: active ? Colors.black : Colors.white70, fontWeight: FontWeight.bold, fontSize: 12)),
                  selected: active,
                  onSelected: (_) => setState(() => _selectedCat = cat),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: visible.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (_, i) {
              final g = visible[i];
              final isNew = g['tag'] == 'NEW';
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _launchInteractiveGame(g),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: Stack(children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: <Color>[Color(g['c1'] as int), Color(g['c2'] as int)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.amber.withOpacity(0.65), width: 1.5),
                            boxShadow: <BoxShadow>[
                              BoxShadow(color: Color(g['c1'] as int).withOpacity(0.35), blurRadius: 6, offset: const Offset(0, 3)),
                            ],
                          ),
                          child: Icon(g['icon'] as IconData, size: 44, color: Colors.amber),
                        ),
                        Positioned(
                          top: 5,
                          right: 5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isNew ? Colors.greenAccent.shade700 : Colors.redAccent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(g['tag'] as String, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      g['title'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
