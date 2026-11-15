import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';

class SudConfig {
  static const String appId = '2122085803670614016';
  static const String appKey = 'r0atcn5dzznbzhyck15suif0a3ynmjv9';

  static final List<Map<String, dynamic>> games = <Map<String, dynamic>>[
    {'name': 'Ludo Party', 'mgId': 1468180338417074177, 'ic': '🎲👑', 'c1': 0xFF003566, 'c2': 0xFFFFC300},
    {'name': 'Domino Classic', 'mgId': 1537330258004504578, 'ic': '🁣✨', 'c1': 0xFF1D3557, 'c2': 0xFF457B9D},
    {'name': 'Liars Dice', 'mgId': 1490944604005199873, 'ic': '🎲🦊', 'c1': 0xFF590D22, 'c2': 0xFFA4133C},
    {'name': 'Bumper Blaster', 'mgId': 1461227817776713818, 'ic': '💥🏎️', 'c1': 0xFF7209B7, 'c2': 0xFFF72585},
    {'name': 'Knife Challenge', 'mgId': 1461228379255603251, 'ic': '🗡️🎯', 'c1': 0xFF9D0208, 'c2': 0xFFE85D04},
    {'name': 'Reversi Master', 'mgId': 1461297789198663710, 'ic': '⚫⚪', 'c1': 0xFF1B4332, 'c2': 0xFF40916C},
    {'name': 'Speed Skating', 'mgId': 1468090257126719572, 'ic': '⛸️⚡', 'c1': 0xFF023E8A, 'c2': 0xFF0096C7},
    {'name': 'Minesweeper', 'mgId': 1468434401847222273, 'ic': '💣🚩', 'c1': 0xFF335C67, 'c2': 0xFFE09F3E},
    {'name': 'Number Runner', 'mgId': 1468434637562912769, 'ic': '🔢🏃', 'c1': 0xFF3C096C, 'c2': 0xFF7B2CBF},
    {'name': 'Rock Paper Scissors', 'mgId': 1468434723902660610, 'ic': '✊✌️', 'c1': 0xFF800F2F, 'c2': 0xFFFF4D6D},
    {'name': 'Hello Friend', 'mgId': 1490944230389182466, 'ic': '👋💖', 'c1': 0xFF004B23, 'c2': 0xFF38B000},
    {'name': 'Gobang Board', 'mgId': 1676069429630722049, 'ic': '♟️🏆', 'c1': 0xFF7F4F24, 'c2': 0xFFCA6702},
  ];
}

class SudGameOverlaySheet extends StatelessWidget {
  final String roomId;
  final String gameName;
  final int mgId;
  final VoidCallback onUpd;
  const SudGameOverlaySheet({super.key, required this.roomId, required this.gameName, required this.mgId, required this.onUpd});

  Future<void> _launchSudGame(BuildContext context) async {
    final url = Uri.parse('https://sud.tech{SudConfig.appId}&mg_id=$mgId&room_id=${Uri.encodeComponent(roomId)}&user_id=${AppState.userId}&code=ethio_${AppState.userId}&lang=en-US');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppWebView);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF0B1120),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: Colors.amber, width: 2)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
          Text('🎮 $gameName • Official Sud.Tech', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 15)),
          IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
        ]),
        const SizedBox(height: 10),
        Text('Room: $roomId • Player ID: ${AppState.userId}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
        const SizedBox(height: 6),
        const Text('🎙️ Your Voice Room Mic stays active in background while playing!', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.tealAccent)),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
          onPressed: () => _launchSudGame(context),
          icon: const Icon(Icons.play_arrow_rounded, size: 28),
          label: Text('Launch $gameName Now', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 10),
      ]),
    );
  }
}
