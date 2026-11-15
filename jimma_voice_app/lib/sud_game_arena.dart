import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';

class SudConfig {
  static const String appId = '2122085803670614016';
  static const String appKey = 'r0atcn5dzznbzhyck15suif0a3ynmjv9';

  static final List<Map<String, dynamic>> games = <Map<String, dynamic>>[
    {'name': 'Ludo Party', 'mgId': '1468180338417074177', 'ic': '🎲👑', 'c1': 0xFF003566, 'c2': 0xFFFFC300},
    {'name': 'Domino Classic', 'mgId': '1537330258004504578', 'ic': '🁣✨', 'c1': 0xFF1D3557, 'c2': 0xFF457B9D},
    {'name': 'Liars Dice', 'mgId': '1490944604005199873', 'ic': '🎲🦊', 'c1': 0xFF590D22, 'c2': 0xFFA4133C},
    {'name': 'Bumper Blaster', 'mgId': '1461227817776713818', 'ic': '💥🏎️', 'c1': 0xFF7209B7, 'c2': 0xFFF72585},
    {'name': 'Knife Challenge', 'mgId': '1461228379255603251', 'ic': '🗡️🎯', 'c1': 0xFF9D0208, 'c2': 0xFFE85D04},
    {'name': 'Reversi Master', 'mgId': '1461297789198663710', 'ic': '⚫⚪', 'c1': 0xFF1B4332, 'c2': 0xFF40916C},
    {'name': 'Speed Skating', 'mgId': '1468090257126719572', 'ic': '⛸️⚡', 'c1': 0xFF023E8A, 'c2': 0xFF0096C7},
    {'name': 'Minesweeper', 'mgId': '1468434401847222273', 'ic': '💣🚩', 'c1': 0xFF335C67, 'c2': 0xFFE09F3E},
    {'name': 'Number Runner', 'mgId': '1468434637562912769', 'ic': '🔢🏃', 'c1': 0xFF3C096C, 'c2': 0xFF7B2CBF},
    {'name': 'Rock Paper Scissors', 'mgId': '1468434723902660610', 'ic': '✊✌️', 'c1': 0xFF800F2F, 'c2': 0xFFFF4D6D},
    {'name': 'Hello Friend', 'mgId': '1490944230389182466', 'ic': '👋💖', 'c1': 0xFF004B23, 'c2': 0xFF38B000},
    {'name': 'Gobang Board', 'mgId': '1676069429630722049', 'ic': '♟️🏆', 'c1': 0xFF7F4F24, 'c2': 0xFFCA6702},
  ];
}

class SudGameOverlaySheet extends StatefulWidget {
  final String roomId;
  final String gameName;
  final String mgId;
  final VoidCallback onUpd;
  const SudGameOverlaySheet({super.key, required this.roomId, required this.gameName, required this.mgId, required this.onUpd});

  @override
  State<SudGameOverlaySheet> createState() => _SudGameOverlaySheetState();
}

class _SudGameOverlaySheetState extends State<SudGameOverlaySheet> {
  int _bet = 500;
  String _matchStatus = 'Ready to Play • 🎙️ Voice Mic Active';
  bool _playing = false;

  Future<void> _playMatch() async {
    if (_playing) return;
    if (AppState.coins < _bet) {
      setState(() => _matchStatus = 'Not enough Coins! Recharge first.');
      return;
    }
    HapticFeedback.mediumImpact();
    setState(() {
      _playing = true;
      AppState.coins -= _bet;
      AppState.gamesPlayedToday++;
      _matchStatus = 'Matching players in Room...';
    });
    widget.onUpd();
    await Future.delayed(const Duration(milliseconds: 1200));
    final win = Random().nextInt(100) < 45;
    final prize = _bet * 2;
    setState(() {
      _playing = false;
      if (win) {
        AppState.coins += prize;
        AppState.lastBigWinner = '${AppState.userName} won +$prize Coins in ${widget.gameName}!';
        _matchStatus = '🏆 VICTORY! +$prize Coins won!';
        HapticFeedback.heavyImpact();
      } else {
        _matchStatus = 'Good game! Tap Play Again to rematch!';
      }
    });
    widget.onUpd();
  }

  @override
  Widget build(BuildContext context) {
    final liveUrl = 'https://sud.tech{SudConfig.appId}&mg_id=${widget.mgId}&room_id=${Uri.encodeComponent(widget.roomId)}&user_id=${AppState.userId}';
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        color: Color(0xFF0B1120),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: Colors.amber, width: 2)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
          Text('🎮 ${widget.gameName} • 🪙 ${AppState.coins}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 15)),
          IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
        ]),
        Text('Sud.Tech MGID: ${widget.mgId} • Room: ${widget.roomId}', style: const TextStyle(fontSize: 11, color: Colors.white60)),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.tealAccent.withOpacity(0.4))),
          child: Text(_matchStatus, textAlign: TextAlign.center, style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 13.5)),
        ),
        const SizedBox(height: 12),
        Wrap(spacing: 8, children: <int>[100, 500, 1000, 5000].map((b) => ChoiceChip(
          label: Text('🪙 $b'),
          selected: _bet == b,
          selectedColor: Colors.amber,
          labelStyle: TextStyle(color: _bet == b ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
          onSelected: (_) => setState(() => _bet = b),
        )).toList()),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
          onPressed: _playing ? null : _playMatch,
          icon: const Icon(Icons.sports_esports),
          label: Text(_playing ? 'Playing...' : 'Play Match (Bet 🪙 $_bet)', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ),
        TextButton.icon(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: liveUrl));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sud.Tech Live Room Game URL Copied!')));
          },
          icon: const Icon(Icons.copy, size: 16, color: Colors.white70),
          label: const Text('Copy Sud.Tech Web Arena Link', style: TextStyle(fontSize: 11, color: Colors.white70)),
        ),
      ]),
    );
  }
}
