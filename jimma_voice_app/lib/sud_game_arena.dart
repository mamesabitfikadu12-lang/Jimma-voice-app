import 'package:flutter/material.dart';
import 'package:sud_mgp_flutter/sud_mgp.dart';
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

class SudGameOverlaySheet extends StatefulWidget {
  final String roomId;
  final String gameName;
  final int mgId;
  final VoidCallback onUpd;
  const SudGameOverlaySheet({super.key, required this.roomId, required this.gameName, required this.mgId, required this.onUpd});

  @override
  State<SudGameOverlaySheet> createState() => _SudGameOverlaySheetState();
}

class _SudGameOverlaySheetState extends State<SudGameOverlaySheet> {
  SudFSMMGDecorator? _decorator;
  SudFSTAPP? _appInstance;
  bool _loading = true;
  String _err = '';

  @override
  void initState() {
    super.initState();
    _initSudGame();
  }

  Future<void> _initSudGame() async {
    try {
      final cfg = SudInitSDKParamModel()
        ..appId = SudConfig.appId
        ..appKey = SudConfig.appKey
        ..isTestEnv = true;
      await SudMGP.initSDK(cfg);

      _decorator = SudFSMMGDecorator();
      final loadModel = SudLoadMGParamModel()
        ..userId = AppState.userId
        ..roomId = widget.roomId
        ..code = 'ethio_${AppState.userId}'
        ..mgId = widget.mgId
        ..language = 'en-US'
        ..authorizationSecret = '';

      _appInstance = await SudMGP.loadMG(loadModel, _decorator!);
      if (mounted) setState(() => _loading = false);
    } catch (e) {
      if (mounted) setState(() { _loading = false; _err = e.toString(); });
    }
  }

  @override
  void dispose() {
    if (_appInstance != null) {
      SudMGP.destroyMG(_appInstance!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.74,
      decoration: const BoxDecoration(
        color: Color(0xFF0B1120),
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        border: Border(top: BorderSide(color: Colors.amber, width: 2)),
      ),
      child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
            Text('🎮 ${widget.gameName} • 🪙 ${AppState.coins}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 14)),
            const Text('🎙️ Voice Active', style: TextStyle(fontSize: 11, color: Colors.tealAccent)),
            IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
          ]),
        ),
        Expanded(
          child: _loading
              ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[CircularProgressIndicator(color: Colors.amber), SizedBox(height: 10), Text('Loading Official Sud.Tech Game...', style: TextStyle(color: Colors.white70))]))
              : (_err.isNotEmpty
                  ? Center(child: Padding(padding: const EdgeInsets.all(16), child: Text('Game Info: $_err', textAlign: TextAlign.center, style: const TextStyle(color: Colors.amber))))
                  : const SizedBox.expand()),
        ),
      ]),
    );
  }
}

