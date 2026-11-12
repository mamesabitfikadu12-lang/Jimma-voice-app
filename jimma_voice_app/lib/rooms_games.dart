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
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: const Color(0xFF0F172A), builder: (_) => StatefulBuilder(
      builder: (ctx, setS) => SizedBox(height: MediaQuery.of(context).size.height * 0.85, child: Column(children: [
        AppBar(title: Text(r['title']!), automaticallyImplyLeading: false, actions: [IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx))]),
        const Padding(padding: EdgeInsets.all(8), child: Text('👑 Abba Jifar Royal Palace Theme • 8 Mic Seats Open', style: TextStyle(color: Colors.amber))),
        Expanded(child: GridView.builder(padding: const EdgeInsets.all(16), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 12, crossAxisSpacing: 12), itemCount: 8, itemBuilder: (_, i) => Container(
          decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.amber.withOpacity(0.4))),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(i == 0 ? Icons.record_voice_over : Icons.mic_none, color: i == 0 ? Colors.amber : Colors.white54), Text(i == 0 ? 'Host' : 'Seat ${i + 1}', style: const TextStyle(fontSize: 11))]),
        ))),
        Padding(padding: const EdgeInsets.all(12), child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
          icon: const Icon(Icons.card_giftcard),
          label: const Text('Send Jebena Gift (100 Coins)'),
          onPressed: () { if (AppState.coins >= 100) { AppState.coins -= 100; AppState.wealthLv = (AppState.wealthLv + 1).clamp(1, 30); SystemSound.play(SystemSoundType.click); widget.onUpd(); setS(() {}); } },
        )),
      ])),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _country == 'All' ? _rooms : _rooms.where((r) => r['country'] == _country).toList();
    return Scaffold(appBar: AppBar(title: const Text('Jimma Voice Chat Family')), body: Column(children: [
      SizedBox(height: 46, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), itemCount: _countries.length, itemBuilder: (_, i) {
        final c = _countries[i]; final sel = c == _country;
        return Padding(padding: const EdgeInsets.only(right: 6), child: ChoiceChip(label: Text(c), selected: sel, selectedColor: const Color(0xFFFFB703), labelStyle: TextStyle(color: sel ? Colors.black : Colors.white), onSelected: (_) => setState(() => _country = c)));
      })),
      Expanded(child: ListView.builder(padding: const EdgeInsets.all(12), itemCount: filtered.length, itemBuilder: (_, i) {
        final r = filtered[i];
        return Card(margin: const EdgeInsets.only(bottom: 10), child: ListTile(leading: const CircleAvatar(backgroundColor: Color(0xFFFFB703), child: Icon(Icons.graphic_eq, color: Colors.black)), title: Text(r['title']!), subtitle: Text('${r['host']} • ${r['country']}'), trailing: Chip(label: Text('🔥 ${r['users']}')), onTap: () => _openLiveRoom(r)));
      })),
    ]));
  }
}
