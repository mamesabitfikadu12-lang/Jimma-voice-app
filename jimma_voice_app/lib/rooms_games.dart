import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'main.dart';
import 'api_service.dart';

class RoomsTab extends StatefulWidget {
  final VoidCallback onUpd;
  const RoomsTab({super.key, required this.onUpd});
  @override
  State<RoomsTab> createState() => _RoomsTabState();
}

class _RoomsTabState extends State<RoomsTab> {
  static const int zegoAppID = 1984661954;
  static const String zegoAppSign = '9622d13c976d8545df95eb0baceb5c540087650f952ddb4b633b35d3199ea2f5';

  String _country = 'All';
  final _countries = List<String>.of({'All', 'Ethiopia', 'Kenya', 'UAE', 'Saudi Arabia', 'USA', 'UK', 'Germany', 'Nigeria'});
  final _rooms = List<Map<String, String>>.of({
    {'id': 'room_jimma_1', 'title': 'Oromia & Jimma Coffee Lounge ☕', 'host': 'Abba Jifar Heritage', 'country': 'Ethiopia', 'tag': 'Live PK'},
    {'id': 'room_finfinnee_2', 'title': 'Finfinnee Night Party 🎶', 'host': 'Queen Selam', 'country': 'Ethiopia', 'tag': 'Music'},
    {'id': 'room_global_3', 'title': 'Global Afro-Oromo Vibes 🌍', 'host': 'DJ Bekele', 'country': 'Global', 'tag': 'Chill & Chat'},
    {'id': 'room_dubai_4', 'title': 'Dubai & Riyadh Habesha Room 🇦🇪', 'host': 'Nadia M.', 'country': 'UAE', 'tag': 'Make Friends'},
    {'id': 'room_kenya_5', 'title': 'Nairobi East Africa Lounge 🇰🇪', 'host': 'Kiprop Live', 'country': 'Kenya', 'tag': 'Dating'},
    {'id': 'room_usa_6', 'title': 'London & USA Diaspora Hub 🇺🇸', 'host': 'Dawit T.', 'country': 'USA', 'tag': 'World Cup 2026'},
  });

  void _openRoomMiniGame(BuildContext context, StateSetter setRoomS, List<String> roomMsgs) {
    int bet = 100;
    final bets = List<int>.of({100, 500, 1000, 5000, 10000});
    final symbols = List<String>.of({'☕ Jebena', '🏰 Palace', '🐎 Horse', '👑 Crown', '💎 Gem'});
    List<String> reels = List<String>.of({'☕ Jebena', '🏰 Palace', '🐎 Horse'});
    String status = 'Select bet (100 - 10,000) & SPIN!';

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setG) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List<Widget>.of({
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List<Widget>.of({
                const Text('🎮 Live Room Royal Slot', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber)),
                Text('🪙 ${AppState.coins}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
              })),
              const SizedBox(height: 10),
              Row(children: reels.map((s) => Expanded(child: Card(color: Colors.black54, child: Padding(padding: const EdgeInsets.all(10), child: Center(child: Text(s, style: const TextStyle(fontSize: 12))))))).toList()),
              const SizedBox(height: 8),
              Wrap(spacing: 6, children: bets.map((b) => ChoiceChip(label: Text('$b'), selected: bet == b, onSelected: (_) => setG(() => bet = b))).toList()),
              const SizedBox(height: 6),
              Text(status, style: const TextStyle(color: Colors.tealAccent, fontSize: 12)),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 42)),
                onPressed: () {
                  if (AppState.coins < bet) { setG(() => status = 'Not enough Coins! Recharge first.'); return; }
                  SystemSound.play(SystemSoundType.click);
                  setG(() => AppState.coins -= bet);
                  widget.onUpd();
                  if (Random().nextInt(100) < 35) {
                    final pick = symbols.elementAt(Random().nextInt(symbols.length));
                    final win = bet * 2;
                    HapticFeedback.heavyImpact();
                    SystemSound.play(SystemSoundType.alert);
                    setG(() { AppState.coins += win; reels = List<String>.of({pick, pick, pick}); status = '🎉 WINNER! Won +$win Coins!'; });
                    setRoomS(() => roomMsgs.add('🎮 ${AppState.userName} won +$win Coins in Room Slot!'));
                    widget.onUpd();
                  } else {
                    setG(() { reels = List<String>.of({symbols.elementAt(0), symbols.elementAt(1), symbols.elementAt(2)}); status = 'Try again! Next spin could win!'; });
                  }
                },
                child: Text('SPIN ($bet Coins)'),
              ),
            }),
          ),
        ),
      ),
    );
  }

  Future<void> _startZegoAudio(String roomId) async {
    await Permission.microphone.request();
    await ZegoExpressEngine.createEngineWithProfile(ZegoEngineProfile(zegoAppID, ZegoScenario.HighQualityChatroom, appSign: zegoAppSign));
    await ZegoExpressEngine.instance.loginRoom(roomId, ZegoUser(AppState.userId, AppState.userName));
    await ZegoExpressEngine.instance.startPublishingStream('${roomId}_${AppState.userId}');
  }

  Future<void> _stopZegoAudio(String roomId) async {
    await ZegoExpressEngine.instance.stopPublishingStream();
    await ZegoExpressEngine.instance.logoutRoom(roomId);
  }

  void _openLiveVoiceRoom(Map<String, String> r) {
    final roomId = r['id'] ?? 'room_jimma_1';
    final chatCtrl = TextEditingController();
    final roomMsgs = List<String>.of({'🎙️ ${r['host']} started Live Voice Room', '🔊 HD Real-Time Voice Connected!'});
    final seats = List<String?>.filled(8, null);
    seats[0] = r['host'];
    bool micOn = false;

    _startZegoAudio(roomId);
    JimmaApiService.connectSocket(roomId, AppState.userId, (_) {}, (g) => roomMsgs.add('🎁 ${g['from']} sent ${g['giftName']}!'));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PopScope(
          onPopInvokedWithResult: (didPop, _) { if (didPop) _stopZegoAudio(roomId); },
          child: StatefulBuilder(
            builder: (ctx, setRoomS) => Scaffold(
              backgroundColor: const Color(0xFF090D16),
              appBar: AppBar(
                title: Text(r['title'] ?? 'Live Room', style: const TextStyle(fontSize: 15)),
                actions: List<Widget>.of({
                  IconButton(icon: const Icon(Icons.sports_esports, color: Colors.amber), onPressed: () => _openRoomMiniGame(ctx, setRoomS, roomMsgs)),
                }),
              ),
              body: Column(
                children: List<Widget>.of({
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 12, crossAxisSpacing: 10),
                      itemCount: 8,
                      itemBuilder: (_, idx) {
                        final occ = seats.elementAt(idx);
                        return InkWell(
                          onTap: () {
                            setRoomS(() {
                              if (occ == null) {
                                seats[idx] = AppState.userName;
                                micOn = true;
                                ZegoExpressEngine.instance.muteMicrophone(false);
                                roomMsgs.add('🎤 ${AppState.userName} joined Mic Seat ${idx + 1} (Speaking Live)');
                              } else if (occ == AppState.userName) {
                                seats[idx] = null;
                                micOn = false;
                                ZegoExpressEngine.instance.muteMicrophone(true);
                              }
                            });
                          },
                          child: Column(
                            children: List<Widget>.of({
                              CircleAvatar(radius: 26, backgroundColor: occ != null ? const Color(0xFFFFB703) : const Color(0xFF1E293B), child: Icon(occ != null ? Icons.mic : Icons.add, color: occ != null ? Colors.black : Colors.white54)),
                              const SizedBox(height: 4),
                              Text(occ ?? 'Seat ${idx + 1}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10)),
                            }),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      color: const Color(0xFF0F172A),
                      child: ListView.builder(itemCount: roomMsgs.length, itemBuilder: (_, idx) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Text(roomMsgs.elementAt(idx), style: const TextStyle(fontSize: 12)))),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    color: const Color(0xFF1E293B),
                    child: Row(
                      children: List<Widget>.of({
                        IconButton(icon: Icon(micOn ? Icons.mic : Icons.mic_off, color: micOn ? Colors.greenAccent : Colors.redAccent), onPressed: () { setRoomS(() => micOn = !micOn); ZegoExpressEngine.instance.muteMicrophone(!micOn); }),
                        Expanded(child: TextField(controller: chatCtrl, decoration: const InputDecoration(hintText: 'Say Hello (Free)...', isDense: true, border: InputBorder.none))),
