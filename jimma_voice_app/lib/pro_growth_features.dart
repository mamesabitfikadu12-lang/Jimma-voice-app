import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart';

class GrowthState {
  static Set<int> lockedSeats = <int>{};
  static Set<String> mutedUsers = <String>{};
  static Set<String> kickedUsers = <String>{};
  static Set<String> followingIds = <String>{'10001', '10002'};
  static Map<String, List<String>> dmChats = <String, List<String>>{};
  static String activeFrame = 'None';
  static String activeEntry = 'None';
  static bool pkActive = false;
  static int pkRedScore = 1200;
  static int pkBlueScore = 950;
  static int pkSeconds = 300;
  static String agencyCode = 'ETH-AG-77';
  static int agencyMembers = 14;
  static int agencyCommissionEtb = 4850;
}

class ProGrowthHubSheet extends StatefulWidget {
  final String roomTitle;
  final VoidCallback onChanged;
  const ProGrowthHubSheet({super.key, required this.roomTitle, required this.onChanged});

  @override
  State<ProGrowthHubSheet> createState() => _ProGrowthHubSheetState();
}

class _ProGrowthHubSheetState extends State<ProGrowthHubSheet> with SingleTickerProviderStateMixin {
  late TabController _tab;
  Timer? _pkTimer;
  final TextEditingController _dmCtrl = TextEditingController();
  String _selectedFriend = 'Selam (ID:10001)';

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 5, vsync: this);
    if (GrowthState.pkActive) _startPkTicker();
  }

  void _startPkTicker() {
    _pkTimer?.cancel();
    _pkTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (GrowthState.pkSeconds > 0 && GrowthState.pkActive) {
          GrowthState.pkSeconds--;
        } else {
          GrowthState.pkActive = false;
          _pkTimer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _pkTimer?.cancel();
    _tab.dispose();
    _dmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: const BoxDecoration(
        color: Color(0xFF101624),
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(children: <Widget>[
        const SizedBox(height: 10),
        Container(width: 44, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4))),
        const SizedBox(height: 8),
        const Text('🚀 Ethio-Voice Pro Growth Center', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber)),
        TabBar(
          controller: _tab,
          isScrollable: true,
          indicatorColor: Colors.amber,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.white60,
          tabs: const <Tab>[
            Tab(text: '🛡️ Room Admin'),
            Tab(text: '⚔️ PK Battle'),
            Tab(text: '👑 VIP Store'),
            Tab(text: '💬 Follow & DM'),
            Tab(text: '🏢 Agency'),
          ],
        ),
        Expanded(
          child: TabBarView(controller: _tab, children: <Widget>[
            _buildRoomAdminTab(),
            _buildPkBattleTab(),
            _buildVipStoreTab(),
            _buildFollowDmTab(),
            _buildAgencyTab(),
          ]),
        ),
      ]),
    );
  }

  Widget _buildRoomAdminTab() {
    return ListView(padding: const EdgeInsets.all(14), children: <Widget>[
      const Text('Lock / Unlock Mic Seats (Seat 2–8)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.tealAccent)),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List<Widget>.generate(7, (idx) {
          final seat = idx + 2;
          final locked = GrowthState.lockedSeats.contains(seat);
          return ActionChip(
            avatar: Icon(locked ? Icons.lock : Icons.lock_open, size: 16, color: locked ? Colors.redAccent : Colors.tealAccent),
            label: Text('Seat $seat ${locked ? "(Locked)" : "(Open)"}'),
            onPressed: () {
              setState(() {
                if (locked) {
                  GrowthState.lockedSeats.remove(seat);
                } else {
                  GrowthState.lockedSeats.add(seat);
                }
              });
              widget.onChanged();
            },
          );
        }),
      ),
      const Divider(height: 24, color: Colors.white12),
      const Text('Active Speakers Control (Mute / Kick)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
      const SizedBox(height: 8),
      ...<String>['Selam', 'Dawit', 'Hana', 'Robel'].map((user) {
        final muted = GrowthState.mutedUsers.contains(user);
        final kicked = GrowthState.kickedUsers.contains(user);
        return Card(
          color: Colors.white10,
          child: ListTile(
            title: Text(user, style: TextStyle(color: kicked ? Colors.redAccent : Colors.white)),
            subtitle: Text(kicked ? 'Removed from room' : (muted ? 'Mic Muted by Host' : 'Active in room'), style: const TextStyle(fontSize: 11)),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              IconButton(
                icon: Icon(muted ? Icons.mic_off : Icons.mic, color: muted ? Colors.orange : Colors.tealAccent),
                onPressed: () => setState(() => muted ? GrowthState.mutedUsers.remove(user) : GrowthState.mutedUsers.add(user)),
              ),
              IconButton(
                icon: Icon(kicked ? Icons.undo : Icons.person_remove, color: Colors.redAccent),
                onPressed: () => setState(() => kicked ? GrowthState.kickedUsers.remove(user) : GrowthState.kickedUsers.add(user)),
              ),
            ]),
          ),
        );
      }),
    ]);
  }

  Widget _buildPkBattleTab() {
    final total = (GrowthState.pkRedScore + GrowthState.pkBlueScore).clamp(1, 9999999);
    final redRatio = GrowthState.pkRedScore / total;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(children: <Widget>[
        Text(
          GrowthState.pkActive ? '🔥 LIVE PK TIME: ${GrowthState.pkSeconds}s' : '⚔️ 5-Minute Room PK Battle',
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.amber),
        ),
        const SizedBox(height: 14),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
          Text('🔴 ${widget.roomTitle}: ${GrowthState.pkRedScore}', style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          Text('🔵 Addis Stars: ${GrowthState.pkBlueScore}', style: const TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold)),
        ]),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(value: redRatio, minHeight: 16, backgroundColor: Colors.blueAccent, color: Colors.redAccent),
        ),
        const SizedBox(height: 18),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            icon: const Icon(Icons.bolt, color: Colors.white),
            label: const Text('+200 Red', style: TextStyle(color: Colors.white)),
            onPressed: () => setState(() => GrowthState.pkRedScore += 200),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            icon: const Icon(Icons.bolt, color: Colors.white),
            label: const Text('+200 Blue', style: TextStyle(color: Colors.white)),
            onPressed: () => setState(() => GrowthState.pkBlueScore += 200),
          ),
        ]),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: const EdgeInsets.symmetric(vertical: 12)),
            onPressed: () {
              setState(() {
                GrowthState.pkActive = !GrowthState.pkActive;
                if (GrowthState.pkActive) {
                  GrowthState.pkSeconds = 300;
                  _startPkTicker();
                }
              });
            },
            child: Text(GrowthState.pkActive ? 'End PK Battle' : 'Start 5-Min PK Battle', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ),
      ]),
    );
  }

  Widget _buildVipStoreTab() {
    final items = <Map<String, dynamic>>[
      <String, dynamic>{'name': 'Golden Lion Frame', 'type': 'Frame', 'price': 500, 'icon': Icons.workspace_premium},
      <String, dynamic>{'name': 'Abyssinia Crown Frame', 'type': 'Frame', 'price': 1200, 'icon': Icons.auto_awesome},
      <String, dynamic>{'name': 'Royal Sports Car Entry', 'type': 'Entry', 'price': 2500, 'icon': Icons.directions_car},
      <String, dynamic>{'name': 'Roaring Lion Entry', 'type': 'Entry', 'price': 5000, 'icon': Icons.local_fire_department},
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final it = items[i];
        final equipped = GrowthState.activeFrame == it['name'] || GrowthState.activeEntry == it['name'];
        return Card(
          color: Colors.white10,
          child: ListTile(
            leading: CircleAvatar(backgroundColor: Colors.amber, child: Icon(it['icon'] as IconData, color: Colors.black)),
            title: Text(it['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${it['type']} • ${it['price']} Coins'),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: equipped ? Colors.teal : Colors.amber),
              onPressed: () {
                setState(() {
                  if (it['type'] == 'Frame') {
  Widget _buildVipStoreTab() {
    final items = <Map<String, dynamic>>[
      <String, dynamic>{'name': 'Golden Lion Frame', 'type': 'Frame', 'price': 500, 'icon': Icons.workspace_premium},
      <String, dynamic>{'name': 'Abyssinia Crown Frame', 'type': 'Frame', 'price': 1200, 'icon': Icons.auto_awesome},
      <String, dynamic>{'name': 'Royal Sports Car Entry', 'type': 'Entry', 'price': 2500, 'icon': Icons.directions_car},
      <String, dynamic>{'name': 'Roaring Lion Entry', 'type': 'Entry', 'price': 5000, 'icon': Icons.local_fire_department},
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final it = items[i];
        final equipped = GrowthState.activeFrame == it['name'] || GrowthState.activeEntry == it['name'];
        return Card(
          color: Colors.white10,
          child: ListTile(
            leading: CircleAvatar(backgroundColor: Colors.amber, child: Icon(it['icon'] as IconData, color: Colors.black)),
            title: Text(it['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${it['type']} • ${it['price']} Coins'),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: equipped ? Colors.teal : Colors.amber),
              onPressed: () {
                setState(() {
                  if (it['type'] == 'Frame') {
                    GrowthState.activeFrame = it['name'] as String;
                  } else {
                    GrowthState.activeEntry = it['name'] as String;
                  }
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Equipped ${it['name']}!')));
              },
              child: Text(equipped ? 'Equipped' : 'Equip', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFollowDmTab() {
    final friends = <String>['Selam (ID:10001)', 'Dawit (ID:10002)', 'Hana (ID:10003)'];
    final msgs = GrowthState.dmChats[_selectedFriend] ?? <String>['Selam: Welcome to Ethio-Voice!'];
    return Column(children: <Widget>[
      SizedBox(
        height: 48,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          children: friends.map((f) {
            final isFollowing = GrowthState.followingIds.contains(f);
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ChoiceChip(
                label: Text('$f ${isFollowing ? "✓" : "+Follow"}'),
                selected: _selectedFriend == f,
                onSelected: (_) {
                  setState(() {
                    _selectedFriend = f;
                    GrowthState.followingIds.add(f);
                  });
                },
              ),
            );
          }).toList(),
        ),
      ),
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: msgs.length,
          itemBuilder: (_, i) => Container(
            margin: const EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)),
            child: Text(msgs[i]),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Row(children: <Widget>[
          Expanded(child: TextField(controller: _dmCtrl, decoration: const InputDecoration(hintText: 'Private message...', isDense: true))),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.amber),
            onPressed: () {
              if (_dmCtrl.text.trim().isEmpty) return;
              setState(() {
                GrowthState.dmChats.putIfAbsent(_selectedFriend, () => <String>[]).add('${AppState.userName}: ${_dmCtrl.text.trim()}');
                _dmCtrl.clear();
              });
            },
          ),
        ]),
      ),
    ]);
  }

  Widget _buildAgencyTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Card(
          color: const Color(0xFF1B263B),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Text('🏢 Agency Code: ${GrowthState.agencyCode}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber)),
              const SizedBox(height: 6),
              Text('Active Hosts: ${GrowthState.agencyMembers} Hosts'),
              Text('Weekly Agency Payroll: ${GrowthState.agencyCommissionEtb} ETB', style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
            ]),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, padding: const EdgeInsets.symmetric(vertical: 12)),
            icon: const Icon(Icons.account_balance_wallet, color: Colors.black),
            label: const Text('Request Weekly Agency Payout (Telebirr / Bank)', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Weekly Agency Payroll Request Sent to Admin!')));
            },
          ),
        ),
      ]),
    );
  }
}

