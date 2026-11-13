import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';

class RoomsTab extends StatefulWidget {
  final VoidCallback onUpd;
  const RoomsTab({super.key, required this.onUpd});
  @override
  State<RoomsTab> createState() => _RoomsTabState();
}

class _RoomsTabState extends State<RoomsTab> {
  String _country = 'All';
  final _countries = ['All', 'Ethiopia', 'Kenya', 'UAE', 'Saudi Arabia', 'USA', 'UK', 'Germany', 'South Africa', 'Nigeria', 'India', 'Global'];
  final _rooms = [
    {'title': 'Oromia & Jimma Coffee Lounge ☕', 'host': 'Abba Jifar Heritage', 'country': 'Ethiopia', 'users': '48', 'tag': 'Music & Culture'},
    {'title': 'Finfinnee Night Party 👑', 'host': 'Queen Selam', 'country': 'Ethiopia', 'users': '62', 'tag': 'Live PK'},
    {'title': 'Global Afro-Oromo Vibes 🌍', 'host': 'DJ Bekele', 'country': 'Global', 'users': '35', 'tag': 'Chill & Chat'},
    {'title': 'Dubai & Riyadh Habesha Room 🇦🇪', 'host': 'Nadia M.', 'country': 'UAE', 'users': '29', 'tag': 'Make Friends'},
    {'title': 'Nairobi East Africa Lounge 🇰🇪', 'host': 'Kiprop Live', 'country': 'Kenya', 'users': '19', 'tag': 'Dating & Fun'},
    {'title': 'London & USA Diaspora Hub 🇬🇧', 'host': 'Dawit T.', 'country': 'USA', 'users': '41', 'tag': 'World Cup 2026'},
  ];

  void _openLiveRoom(Map<String, String> r) {
    int mySeat = -1;
    bool isMuted = false;
    final chatCtrl = TextEditingController();
    final roomMsgs = <String>['👑 ${r['host']} opened the room', '☕ Welcome to Jimma Voice Chat Family!'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.88,
            child: Column(
              children: [
                AppBar(
                  title: Text(r['title']!, style: const TextStyle(fontSize: 16)),
                  automaticallyImplyLeading: false,
                  actions: [
                    if (mySeat != -1)
                      IconButton(
                        icon: Icon(isMuted ? Icons.mic_off : Icons.mic, color: isMuted ? Colors.red : Colors.greenAccent),
                        onPressed: () { SystemSound.play(SystemSoundType.click); setS(() => isMuted = !isMuted); },
                      ),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(6),
                  child: Text('👑 Tap Seat 2–8 to Join Mic (Free) • Abba Jifar Royal Theme', style: TextStyle(color: Colors.amber, fontSize: 12)),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10),
                  itemCount: 8,
                  itemBuilder: (_, i) {
                    final occupied = i == 0 || i == mySeat;
                    final label = i == 0 ? 'Host' : (i == mySeat ? AppState.userName : 'Seat ${i + 1}');
                    return InkWell(
                      onTap: i == 0 ? null : () {
                        SystemSound.play(SystemSoundType.click);
                        setS(() {
                          if (mySeat == i) {
                            mySeat = -1;
                            roomMsgs.add('🚪 ${AppState.userName} left Seat ${i + 1}');
                          } else {
                            mySeat = i;
                            isMuted = false;
                            roomMsgs.add('🎤 ${AppState.userName} joined Seat ${i + 1} (Free)');
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: occupied ? const Color(0xFF78350F) : const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: occupied ? Colors.amber : Colors.white24),
                        ),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(i == 0 ? Icons.record_voice_over : (i == mySeat ? (isMuted ? Icons.mic_off : Icons.mic) : Icons.mic_none), color: occupied ? Colors.amber : Colors.white54),
                          const SizedBox(height: 4),
                          Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        ]),
                      ),
                    );
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    itemCount: roomMsgs.length,
                    itemBuilder: (_, idx) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(10)),
                        child: Text(roomMsgs[idx], style: const TextStyle(fontSize: 12, color: Colors.white)),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  color: const Color(0xFF1E293B),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: chatCtrl,
                          decoration: const InputDecoration(hintText: 'Say something (Free)...', isDense: true, border: OutlineInputBorder()),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.amber),
                        onPressed: () {
                          if (chatCtrl.text.trim().isNotEmpty) {
                            setS(() { roomMsgs.add('${AppState.userName}: ${chatCtrl.text.trim()}'); chatCtrl.clear(); });
                          }
                        },
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                        icon: const Icon(Icons.card_giftcard, size: 18),
                        label: const Text('Gift (100)'),
                        onPressed: () {
                          if (AppState.coins >= 100) {
                            AppState.coins -= 100;
                            AppState.wealthLv = (AppState.wealthLv + 1).clamp(1, 30);
                            SystemSound.play(SystemSoundType.click);
                            widget.onUpd();
                            setS(() => roomMsgs.add('🎁 ${AppState.userName} sent ☕ Jebena Gift (100 Coins)!'));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('0 Coins! Chat & Mic Seats are FREE; Recharge in Me tab for Gifts.')));
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
      appBar: AppBar(title: const Text('Jimma Voice Chat Family')),
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
                    trailing: Chip(label: Text('🔥 ${r['users']}'), backgroundColor: Colors.teal.shade800),
                    onTap: () => _openLiveRoom(r),
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
