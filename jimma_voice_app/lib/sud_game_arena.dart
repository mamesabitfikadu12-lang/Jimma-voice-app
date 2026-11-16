import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
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
  final AudioPlayer _player = AudioPlayer();
  int _bet = 500;
  bool _inRound = false;
  int _playerScore = 0;
  int _botScore = 0;
  int _movesLeft = 3;
  int _targetIndex = 4;
  String _status = 'Select Bet & Tap Start Game to Play!';
  List<int> _revealed = <int>[];

  Future<void> _playSfx(String file) async {
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/$file'));
    } catch (_) {}
  }

  void _startRound() {
    if (AppState.coins < _bet) {
      setState(() => _status = 'Not enough Coins! Recharge first.');
      return;
    }
    HapticFeedback.mediumImpact();
    _playSfx('spin.wav');
    setState(() {
      AppState.coins -= _bet;
      AppState.gamesPlayedToday++;
      _inRound = true;
      _playerScore = 0;
      _botScore = 0;
      _movesLeft = 3;
      _revealed = <int>[];
      _targetIndex = Random().nextInt(9);
      _status = 'Tap glowing targets / tiles (3 Moves)!';
    });
    widget.onUpd();
  }

  void _tapTile(int idx) {
    if (!_inRound || _movesLeft <= 0) return;
    HapticFeedback.lightImpact();
    _playSfx('spin.wav');
    final hit = idx == _targetIndex || Random().nextInt(100) < 48;
    final pts = hit ? (25 + Random().nextInt(30)) : (5 + Random().nextInt(12));
    final botPts = 15 + Random().nextInt(28);
    setState(() {
      _movesLeft--;
      _playerScore += pts;
      _botScore += botPts;
      _revealed.add(idx);
      _targetIndex = Random().nextInt(9);
      if (_movesLeft == 0) {
        _inRound = false;
        if (_playerScore >= _botScore) {
          final prize = _bet * 2;
          AppState.coins += prize;
          AppState.lastBigWinner = '${AppState.userName} won +$prize Coins in ${widget.gameName}!';
          _status = '🏆 YOU WON! ($_playerScore vs $_botScore) • +$prize Coins!';
          HapticFeedback.heavyImpact();
          _playSfx('bigwin.wav');
        } else {
          _status = 'Opponent won ($_playerScore vs $_botScore). Tap Play Again!';
        }
      } else {
        _status = hit ? '💥 GREAT HIT! +$pts pts • $_movesLeft moves left' : 'Hit +$pts pts • $_movesLeft moves left';
      }
    });
    widget.onUpd();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final liveUrl = 'https://sud.tech{SudConfig.appId}&mg_id=${widget.mgId}&room_id=${Uri.encodeComponent(widget.roomId)}&user_id=${AppState.userId}';
    return Container(
      padding: const EdgeInsets.all(16),
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
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12)),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
            Text('You: $_playerScore', style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 14)),
            Text('Moves: $_movesLeft', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 14)),
            Text('Rival: $_botScore', style: const TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold, fontSize: 14)),
          ]),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 185,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 9,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 1.55),
            itemBuilder: (_, i) {
              final isTarget = _inRound && i == _targetIndex;
              final isDone = _revealed.contains(i);
              return InkWell(
                onTap: () => _tapTile(i),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isTarget
                          ? <Color>[Colors.amber, Colors.deepOrange]
                          : isDone
                              ? <Color>[const Color(0xFF0D9488), const Color(0xFF115E59)]
                              : <Color>[const Color(0xFF1E293B), const Color(0xFF0F172A)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isTarget ? Colors.white : Colors.amber.withOpacity(0.45), width: isTarget ? 2 : 1),
                  ),
                  child: Center(
                    child: Text(
                      isTarget ? '🎯 TAP!' : (isDone ? '💥 HIT' : '⚡'),
                      style: TextStyle(fontSize: isTarget ? 15 : 18, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(_status, textAlign: TextAlign.center, style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 10),
        Wrap(spacing: 8, children: <int>[100, 500, 1000, 5000].map((b) => ChoiceChip(
          label: Text('🪙 $b'),
          selected: _bet == b,
          selectedColor: Colors.amber,
          labelStyle: TextStyle(color: _bet == b ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
          onSelected: _inRound ? null : (_) => setState(() => _bet = b),
        )).toList()),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 46), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
          onPressed: _inRound ? null : _startRound,
          icon: const Icon(Icons.sports_esports),
          label: Text(_inRound ? 'Tap the Glowing Targets Above!' : 'Start Game (Bet 🪙 $_bet)', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ),
        TextButton.icon(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: liveUrl));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sud.Tech Live Room Game URL Copied!')));
          },
          icon: const Icon(Icons.copy, size: 15, color: Colors.white60),
          label: const Text('Copy Sud.Tech Web Arena Link', style: TextStyle(fontSize: 11, color: Colors.white60)),
        ),
      ]),
    );
  }
}
