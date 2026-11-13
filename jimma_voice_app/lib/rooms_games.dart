import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';
import 'main.dart';
import 'api_service.dart';

class RoomsTab extends StatefulWidget {
  final VoidCallback onUpd;
  const RoomsTab({super.key, required this.onUpd});
  @override
  State<RoomsTab> createState() => _RoomsTabState();
}

class _RoomsTabState extends State<RoomsTab> {
  // ZEGOCLOUD Live Voice Keys (AppID: 1984661954)
  static const int zegoAppID = 1984661954;
  static const String zegoAppSign = '9622d13c976d8545df95eb0baceb5c540087650f952ddb4b633b35d3199ea2f5';


  String _country = 'All';
  final _countries = ['All', 'Ethiopia', 'Kenya', 'UAE', 'Saudi Arabia', 'USA', 'UK', 'Germany', 'South Africa', 'Nigeria'];
  final _rooms = [
    {'id': 'room_jimma_1', 'title': 'Oromia & Jimma Coffee Lounge ☕', 'host': 'Abba Jifar Heritage', 'country': 'Ethiopia', 'tag': 'Live PK'},
    {'id': 'room_finfinnee_2', 'title': 'Finfinnee Night Party 🎶', 'host': 'Queen Selam', 'country': 'Ethiopia', 'tag': 'Music'},
    {'id': 'room_global_3', 'title': 'Global Afro-Oromo Vibes 🌍', 'host': 'DJ Bekele', 'country': 'Global', 'tag': 'Chill & Chat'},
    {'id': 'room_dubai_4', 'title': 'Dubai & Riyadh Habesha Room 🇦🇪', 'host': 'Nadia M.', 'country': 'UAE', 'tag': 'Make Friends'},
    {'id': 'room_kenya_5', 'title': 'Nairobi East Africa Lounge 🇰🇪', 'host': 'Kiprop Live', 'country': 'Kenya', 'tag': 'Dating'},
    {'id': 'room_usa_6', 'title': 'London & USA Diaspora Hub 🇺🇸', 'host': 'Dawit T.', 'country': 'USA', 'tag': 'World Cup 2026'},
  ];

  // Mini-Game Kutaa Haasaa Keessaa (Bet 100 - 10,000 Coins, Galii Appii 65%)
  void _openRoomMiniGame(BuildContext context, StateSetter setRoomS, List<String> roomMsgs) {
    int bet = 100;
    final bets = [100, 500, 1000, 5000, 10000];
    final symbols = ['☕ Jebena', '🏰 Palace', '🐎 Horse', '👑 Crown', '💎 Gem'];
    List<String> reels = ['☕ Jebena', '🏰 Palace', '🐎 Horse'];
    String status = 'Select bet (100 - 10,000) & SPIN!';

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setG) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('🎮 Live Room Royal Slot', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber)),
                Text('🪙 ${AppState.coins}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
              ]),
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
                  if (AppState.coins < bet) {
                    setG(() => status = 'Not enough Coins! Recharge first.');
                    return;
                  }
                  SystemSound.play(SystemSoundType.click);
                  setG(() => AppState.coins -= bet);
                  widget.onUpd();

                  // Galii Appichaa 65% eeguuf carraan mo'achuu 35%
                  if (Random().nextInt(100) < 35) {
                    final pick = symbols[Random().nextInt(symbols.length)];
                    final win = bet * 2;
                    HapticFeedback.heavyImpact();
                    SystemSound.play(SystemSoundType.alert);
                    setG(() {
                      AppState.coins += win;
                      reels = [pick, pick, pick];
                      status = '🎉 WINNER! Won +$win Coins!';
                    });
                    setRoomS(() => roomMsgs.add('🎮 ${AppState.userName} won +$win Coins in Room Slot!'));
                    widget.onUpd();
                  } else {
                    setG(() {
                      reels = [symbols[0], symbols[1], symbols[2]];
                      status = 'Try again! Next spin could win!';
                    });
                  }
                },
                child: Text('SPIN ($bet Coins)'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Kutaa Haasaa Sagalee Dhugaa (ZEGOCLOUD Real-Time Audio + Chat + Gifts + Game)
  void _openLiveVoiceRoom(Map<String, String> r) {
    final roomId = r['id'] ?? 'room_jimma_1';
    final chatCtrl = TextEditingController();
    final roomMsgs = <String>['🎙️ ${r['host']} started Live Voice Room', '👋 Welcome to ${r['title']}!'];

    JimmaApiService.connectSocket(
      roomId,
      AppState.userId,
      (roomData) {},
      (giftData) {
        roomMsgs.add('🎁 ${giftData['from']} sent ${giftData['giftName']}!');
      },
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StatefulBuilder(
          builder: (ctx, setRoomS) => Scaffold(
            backgroundColor: const Color(0xFF090D16),
            appBar: AppBar(
              title: Text(r['title'] ?? 'Live Room', style: const TextStyle(fontSize: 15)),
              actions: [
                IconButton(
                  icon: const Icon(Icons.sports_esports, color: Colors.amber),
                  tooltip: 'Play Live Mini-Game',
                  onPressed: () => _openRoomMiniGame(ctx, setRoomS, roomMsgs),
                ),
              ],
            ),
            body: Column(
              children: [
                // 1. ZEGOCLOUD SAGALEE DHUGAA (8 Mic Seats)
                Expanded(
                  flex: 5,
                  child: ZegoUIKitPrebuiltLiveAudioRoom(
                    appID: zegoAppID,
                    appSign: zegoAppSign,
                    userID: AppState.userId,
                    userName: AppState.userName,
                    roomID: roomId,
                    config: ZegoUIKitPrebuiltLiveAudioRoomConfig.audience()
                      ..takeSeatIndexWhenJoining = -1
                      ..layoutConfig.rowConfigs = [
                        ZegoLiveAudioRoomLayoutRowConfig(count: 4, alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
                        ZegoLiveAudioRoomLayoutRowConfig(count: 4, alignment: ZegoLiveAudioRoomLayoutAlignment.spaceAround),
                      ],
                  ),
                ),
                // 2. LIVE CHAT & GIFTS BAR
                Container(
                  height: 140,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  color: const Color(0xFF0F172A),
                  child: ListView.builder(
                    itemCount: roomMsgs.length,
                    itemBuilder: (_, idx) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(roomMsgs[idx], style: const TextStyle(fontSize: 12, color: Colors.white)),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  color: const Color(0xFF1E293B),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: chatCtrl,
                          decoration: const InputDecoration(hintText: 'Say Hello (Free)...', isDense: true, border: InputBorder.none),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.amber),
                        onPressed: () {
                          if (chatCtrl.text.trim().isNotEmpty) {
                            setRoomS(() {
                              roomMsgs.add('💬 ${AppState.userName}: ${chatCtrl.text.trim()}');
                              chatCtrl.clear();
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.sports_esports, color: Colors.purpleAccent),
                        onPressed: () => _openRoomMiniGame(ctx, setRoomS, roomMsgs),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                        icon: const Icon(Icons.card_giftcard, size: 16),
                        label: const Text('Gift (100)'),
                        onPressed: () {
                          if (AppState.coins >= 100) {
                            AppState.coins -= 100;
                            AppState.wealthLv = (AppState.wealthLv + 1).clamp(1, 30);
                            SystemSound.play(SystemSoundType.click);
                            JimmaApiService.sendGift(roomId, AppState.userId, r['host'] ?? 'host', 100, 'Jebena Coffee');
                            widget.onUpd();
                            setRoomS(() => roomMsgs.add('🎁 ${AppState.userName} sent ☕ Jebena Gift (100 Coins)!'));
                          } else {                            ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('0 Coins! Chat & Mic are Free.')));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _country == 'All' ? _rooms : _rooms.where((r) => r['country'] == _country).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Jimma Voice Chat Party')),
      body: Column(
        children: [
          SizedBox(
            height: 46,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              itemCount: _countries.length,
              itemBuilder: (_, i) {
                final c = _countries[i];
                final sel = c == _country;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(c),
                    selected: sel,
                    selectedColor: const Color(0xFFFFB703),
                    labelStyle: TextStyle(color: sel ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
                    onSelected: (_) => setState(() => _country = c),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final r = filtered[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    leading: const CircleAvatar(backgroundColor: Color(0xFFFFB703), child: Icon(Icons.graphic_eq, color: Colors.black)),
                    title: Text(r['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${r['host']} • ${r['country']} • ${r['tag']}'),
                    trailing: const Chip(label: Text('🎙️ Live'), backgroundColor: Color(0xFF065F46)),
                    onTap: () => _openLiveVoiceRoom(r),
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

