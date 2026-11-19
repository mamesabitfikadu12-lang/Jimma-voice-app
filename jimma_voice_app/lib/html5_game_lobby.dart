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

  final List<Map<String, dynamic>> _games = <Map<String, dynamic>>[
    <String, dynamic>{'title': 'Ocean Hunt', 'cat': 'Fishing', 'tag': 'HOT', 'color': 0xFF6A1B9A, 'icon': Icons.tsunami},
    <String, dynamic>{'title': 'Jungle Hunt', 'cat': 'Hot', 'tag': 'HOT', 'color': 0xFF2E7D32, 'icon': Icons.forest},
    <String, dynamic>{'title': 'Royal Battle', 'cat': 'Multi Player', 'tag': 'HOT', 'color': 0xFFC62828, 'icon': Icons.emoji_events},
    <String, dynamic>{'title': 'Ocean Hunt II', 'cat': 'Fishing', 'tag': 'NEW', 'color': 0xFF1565C0, 'icon': Icons.waves},
    <String, dynamic>{'title': 'Jungle Delight', 'cat': 'Slot', 'tag': 'HOT', 'color': 0xFF388E3C, 'icon': Icons.pets},
    <String, dynamic>{'title': 'Garo Gems III', 'cat': 'Slot', 'tag': 'NEW', 'color': 0xFFF57F17, 'icon': Icons.diamond},
    <String, dynamic>{'title': 'Garo Gems II', 'cat': 'Slot', 'tag': 'HOT', 'color': 0xFFE65100, 'icon': Icons.auto_awesome},
    <String, dynamic>{'title': 'Garo Gems I', 'cat': 'Slot', 'tag': 'HOT', 'color': 0xFFD84315, 'icon': Icons.stars},
    <String, dynamic>{'title': 'Fruit Party', 'cat': 'Slot', 'tag': 'HOT', 'color': 0xFF558B2F, 'icon': Icons.local_florist},
    <String, dynamic>{'title': 'Fishing Tycoon', 'cat': 'Fishing', 'tag': 'HOT', 'color': 0xFF0277BD, 'icon': Icons.sailing},
    <String, dynamic>{'title': 'The Monkey King', 'cat': 'Slot', 'tag': 'HOT', 'color': 0xFFB71C1C, 'icon': Icons.whatshot},
    <String, dynamic>{'title': 'Blaze Of Fortune', 'cat': 'Latest', 'tag': 'NEW', 'color': 0xFFFF8F00, 'icon': Icons.local_fire_department},
    <String, dynamic>{'title': 'Bonanza Banana', 'cat': 'Latest', 'tag': 'NEW', 'color': 0xFF9E9D24, 'icon': Icons.eco},
    <String, dynamic>{'title': 'Lucky Piggy', 'cat': 'Latest', 'tag': 'NEW', 'color': 0xFFAD1457, 'icon': Icons.savings},
    <String, dynamic>{'title': 'Fortune Rabbit', 'cat': 'Latest', 'tag': 'NEW', 'color': 0xFFC2185B, 'icon': Icons.cruelty_free},
    <String, dynamic>{'title': 'Storm Joker', 'cat': 'Slot', 'tag': 'HOT', 'color': 0xFF4A148C, 'icon': Icons.theater_comedy},
    <String, dynamic>{'title': 'Gates Of Olympus', 'cat': 'Slot', 'tag': 'NEW', 'color': 0xFF4527A0, 'icon': Icons.bolt},
    <String, dynamic>{'title': 'Starlight Princess', 'cat': 'Latest', 'tag': 'NEW', 'color': 0xFF283593, 'icon': Icons.auto_fix_high},
    <String, dynamic>{'title': 'Gems Sky', 'cat': 'Slot', 'tag': 'HOT', 'color': 0xFF6A1B9A, 'icon': Icons.castle},
    <String, dynamic>{'title': 'Scratch Boxing', 'cat': 'Latest', 'tag': 'NEW', 'color': 0xFFB71C1C, 'icon': Icons.sports_mma},
    <String, dynamic>{'title': 'Money Coming', 'cat': 'Slot', 'tag': 'HOT', 'color': 0xFF1B5E20, 'icon': Icons.monetization_on},
    <String, dynamic>{'title': 'Super Ace', 'cat': 'Slot', 'tag': 'HOT', 'color': 0xFF880E4F, 'icon': Icons.style},
    <String, dynamic>{'title': 'Aztec Magic Bonanza', 'cat': 'Slot', 'tag': 'HOT', 'color': 0xFF4E342E, 'icon': Icons.account_balance},
    <String, dynamic>{'title': 'Chicken Road', 'cat': 'Latest', 'tag': 'NEW', 'color': 0xFFEF6C00, 'icon': Icons.directions_run},
    <String, dynamic>{'title': 'CosmoX', 'cat': 'Latest', 'tag': 'NEW', 'color': 0xFF0D47A1, 'icon': Icons.rocket_launch},
    <String, dynamic>{'title': 'Kraken III', 'cat': 'Fishing', 'tag': 'HOT', 'color': 0xFF004D40, 'icon': Icons.water},
    <String, dynamic>{'title': 'Fishing Star', 'cat': 'Fishing', 'tag': 'HOT', 'color': 0xFF01579B, 'icon': Icons.anchor},
    <String, dynamic>{'title': 'Teen Patti', 'cat': 'Multi Player', 'tag': 'HOT', 'color': 0xFF00695C, 'icon': Icons.style},
    <String, dynamic>{'title': 'Magic Slot', 'cat': 'Slot', 'tag': 'HOT', 'color': 0xFF311B92, 'icon': Icons.flare},
    <String, dynamic>{'title': 'Crazy Gems', 'cat': 'Slot', 'tag': 'HOT', 'color': 0xFFBF360C, 'icon': Icons.hexagon},
    <String, dynamic>{'title': 'Sphinx Legend', 'cat': 'Slot', 'tag': 'HOT', 'color': 0xFFE65100, 'icon': Icons.temple_hindu},
    <String, dynamic>{'title': 'Ludo King', 'cat': 'Multi Player', 'tag': 'HOT', 'color': 0xFF1565C0, 'icon': Icons.casino},
    <String, dynamic>{'title': 'Roulette', 'cat': 'Multi Player', 'tag': 'HOT', 'color': 0xFF2E7D32, 'icon': Icons.motion_photos_on},
    <String, dynamic>{'title': 'Mahjong Ways', 'cat': 'Slot', 'tag': 'HOT', 'color': 0xFF827717, 'icon': Icons.grid_on},
    <String, dynamic>{'title': 'Bounty Football', 'cat': 'Multi Player', 'tag': 'NEW', 'color': 0xFF1B5E20, 'icon': Icons.sports_soccer},
    <String, dynamic>{'title': 'Deep Sea', 'cat': 'Fishing', 'tag': 'HOT', 'color': 0xFF006064, 'icon': Icons.scuba_diving},
  ];

  void _launchHtml5Game(Map<String, dynamic> game) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        int bet = 100;
        String statusMsg = 'Ready to play ${game['title']} with Virtual Coins!';
        return StatefulBuilder(
          builder: (ctx, setD) => AlertDialog(
            backgroundColor: const Color(0xFF101928),
            title: Row(children: <Widget>[
              Icon(game['icon'] as IconData, color: Colors.amber),
              const SizedBox(width: 8),
              Expanded(child: Text(game['title'] as String, style: const TextStyle(fontSize: 16))),
            ]),
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text('Your Coins: ${AppState.coins}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(statusMsg, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.white70)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                children: List<int>.of(<int>{50, 100, 500, 1000}).map((amt) => ChoiceChip(
                  label: Text('$amt Coins'),
                  selected: bet == amt,
                  onSelected: (_) => setD(() => bet = amt),
                )).toList(),
              ),
            ]),
            actions: <Widget>[
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () {
                  if (AppState.coins < bet) {
                    setD(() => statusMsg = 'Not enough coins! Please recharge.');
                    return;
                  }
                  final won = DateTime.now().millisecond % 2 == 0;
                  setState(() {
                    if (won) {
                      AppState.coins += bet;
                    } else {
                      AppState.coins -= bet;
                    }
                  });
                  widget.onBalanceChanged();
                  setD(() => statusMsg = won ? '🎉 YOU WON +${bet * 2} Virtual Coins!' : 'Try again! -$bet Coins');
                },
                child: const Text('Play Round', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
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
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.amber.withOpacity(0.5)),
          ),
          child: const Row(children: <Widget>[
            Icon(Icons.verified_user, color: Colors.amber, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Entertainment Only: In-app Coins & Points are virtual items for voice room gifts and casual games.',
                style: TextStyle(fontSize: 11, color: Colors.white70),
              ),
            ),
          ]),
        ),
        SizedBox(
          height: 46,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            itemCount: categories.length,
            itemBuilder: (_, i) {
              final cat = categories[i];
              final active = _selectedCat == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  selectedColor: Colors.tealAccent,
                  backgroundColor: Colors.white10,
                  label: Text(cat, style: TextStyle(color: active ? Colors.black : Colors.white70, fontWeight: FontWeight.bold)),
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
              crossAxisSpacing: 8,
              mainAxisSpacing: 10,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (_, i) {
              final g = visible[i];
              final isNew = g['tag'] == 'NEW';
              return InkWell(
                onTap: () => _launchHtml5Game(g),
                child: Column(children: <Widget>[
                  Expanded(
                    child: Stack(children: <Widget>[
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[Color(g['color'] as int), Colors.black87],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.amber.withOpacity(0.5)),
                        ),
                        child: Icon(g['icon'] as IconData, size: 42, color: Colors.amber),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
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
                  const SizedBox(height: 4),
                  Text(g['title'] as String, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ]),
              );
            },
          ),
        ),
      ]),
    );
  }
}
