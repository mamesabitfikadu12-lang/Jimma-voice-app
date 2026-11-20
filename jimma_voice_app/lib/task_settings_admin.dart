import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';

class TaskCenterPage extends StatefulWidget {
  final VoidCallback onUpd;
  const TaskCenterPage({super.key, required this.onUpd});
  @override
  State<TaskCenterPage> createState() => _TaskCenterPageState();
}

class _TaskCenterPageState extends State<TaskCenterPage> {
  late Timer _timer;
  Duration _left = const Duration(hours: 24);

  @override
  void initState() {
    super.initState();
    _calcRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(_calcRemaining);
    });
  }

  void _calcRemaining() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final diff = tomorrow.difference(now);
    if (diff.inSeconds <= 1) {
      AppState.claimedTasks.clear();
    }
    _left = diff;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _fmtDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  void _claimTask(String id, int coins, double pts, String title) {
    if (AppState.claimedTasks.contains(id)) return;
    setState(() {
      AppState.claimedTasks.add(id);
      AppState.coins += coins;
      AppState.points += pts;
    });
    widget.onUpd();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.green, content: Text('Claimed: $title!')),
    );
  }

  Widget _taskTile({
    required String id,
    required String icon,
    required String title,
    required String prog,
    required String rewardText,
    required bool ready,
    int coins = 0,
    double pts = 0,
  }) {
    final done = AppState.claimedTasks.contains(id);
    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: Colors.amber.withOpacity(0.15),
          child: Text(icon, style: const TextStyle(fontSize: 20)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: Colors.white)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(prog, style: const TextStyle(fontSize: 11, color: Colors.white60)),
            const SizedBox(height: 3),
            Text(rewardText, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amber)),
          ],
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: done ? Colors.white12 : (ready ? Colors.tealAccent : Colors.white24),
            foregroundColor: done ? Colors.white54 : Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: done
              ? null
              : () {
                  if (ready) {
                    _claimTask(id, coins, pts, title);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.orange.shade800,
                        content: Text('Complete task first: $title ($prog)'),
                      ),
                    );
                  }
                },
          child: Text(
            done ? 'Done' : (ready ? 'Claim' : 'Locked'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final doneCount = AppState.claimedTasks.length;
    final hostMins = AppState.roomMinutesToday;
    final giftPts = AppState.points.toInt();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Task Center'),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                  child: Text('Reset: ${_fmtDuration(_left)}', style: const TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [Tab(text: 'Tasks'), Tab(text: 'Host Tasks'), Tab(text: 'VIP Tasks')],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.all(14),
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF7F4F24), Color(0xFFCA6702)]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Beginner & Daily Chests', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      const Text('Complete tasks to unlock 3 treasure chests!', style: TextStyle(fontSize: 12, color: Colors.white70)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                            onPressed: doneCount >= 3 ? () => _claimTask('chest3', 300, 0, '3 Tasks Chest') : null,
                            icon: const Icon(Icons.card_giftcard, size: 16),
                            label: Text('3 Tasks ($doneCount/3)'),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                            onPressed: doneCount >= 6 ? () => _claimTask('chest6', 800, 0, '6 Tasks Chest') : null,
                            icon: const Icon(Icons.card_giftcard, size: 16),
                            label: Text('6 Tasks ($doneCount/6)'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Text('Daily Tasks (Resets in 24h)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 8),
                _taskTile(id: 'daily_checkin', icon: '📅', title: 'Daily Check-in Bonus', prog: '(1/1)', rewardText: '+100 Coins', ready: true, coins: 100),
                _taskTile(id: 'stay_room', icon: '🎙️', title: 'Stay in a Voice Room for 5 Mins', prog: '(${hostMins >= 5 ? 5 : hostMins}/5 Mins)', rewardText: '+200 Coins', ready: hostMins >= 5, coins: 200),
                _taskTile(id: 'play_ocean', icon: '🐠', title: 'Play Ocean Hunt Once', prog: '(${AppState.gamesPlayedToday >= 1 ? 1 : 0}/1)', rewardText: '+200 Coins', ready: AppState.gamesPlayedToday >= 1, coins: 200),
                _taskTile(id: 'win_jungle', icon: '🦁', title: 'Win 10,000 Coins in Jungle Hunt', prog: '(${AppState.coins >= 10000 ? "10K" : AppState.coins}/10K)', rewardText: '+400 Coins', ready: AppState.coins >= 10000, coins: 400),
                _taskTile(id: 'play_royal', icon: '👑', title: 'Play Royal Battle', prog: '(${AppState.gamesPlayedToday >= 2 ? 2 : AppState.gamesPlayedToday}/2)', rewardText: '+300 Coins', ready: AppState.gamesPlayedToday >= 2, coins: 300),
                _taskTile(id: 'play_garo', icon: '🎰', title: 'Play Garo Gems III', prog: '(${AppState.gamesPlayedToday >= 3 ? 3 : AppState.gamesPlayedToday}/3)', rewardText: '+300 Coins', ready: AppState.gamesPlayedToday >= 3, coins: 300),
                _taskTile(id: 'win_fishing', icon: '🎣', title: 'Win 500 Coins in Fishing Tycoon', prog: '(${AppState.coins >= 500 ? 500 : AppState.coins}/500)', rewardText: '+250 Coins', ready: AppState.coins >= 500, coins: 250),
                _taskTile(id: 'vip_once', icon: '💎', title: 'Purchase VIP Once', prog: '(${AppState.vipLevel >= 1 ? 1 : 0}/1)', rewardText: '+500 Coins', ready: AppState.vipLevel >= 1, coins: 500),
              ],
            ),
            ListView(
              padding: const EdgeInsets.all(14),
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('On Mic Today: $hostMins / 120 Mins', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          Text('$giftPts Pts', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.tealAccent)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Hourly Salary Tiers: 600/h -> 1200/h -> 3000/h -> 5000/h', style: TextStyle(fontSize: 12, color: Colors.white70)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _taskTile(id: 'host_2h', icon: '🎤', title: 'On Mic for 2 Hours', prog: '($hostMins/120 Mins)', rewardText: '+1,500 Pts', ready: hostMins >= 120, pts: 1500),
                _taskTile(id: 'host_crown', icon: '👑', title: 'Join Party & Crowned for 1 Hour', prog: '(${hostMins >= 60 ? 60 : hostMins}/60 Mins)', rewardText: '+1,000 Pts', ready: hostMins >= 60, pts: 1000),
                _taskTile(id: 'host_1m', icon: '💎', title: '1M Points Earnings Milestone', prog: '($giftPts/1M)', rewardText: '+25,000 Pts', ready: giftPts >= 1000000, pts: 25000),
              ],
            ),
            ListView(
              padding: const EdgeInsets.all(14),
              children: [
                _taskTile(id: 'ev_invite', icon: '🤝', title: 'Invite 1 Friend to Voice Chat ET', prog: '(${AppState.inviteClaimed ? 1 : 0}/1)', rewardText: '+500 Coins', ready: AppState.inviteClaimed, coins: 500),
                _taskTile(id: 'ev_jackpot', icon: '🎰', title: 'Win 100,000 Coins in Jungle Hunt', prog: '(${AppState.coins}/100K)', rewardText: '+2,000 Coins', ready: AppState.coins >= 100000, coins: 2000),
                _taskTile(id: 'ev_ocean200', icon: '🐳', title: 'Win 200,000 Coins in Ocean Hunt', prog: '(${AppState.coins}/200K)', rewardText: '+5,000 Coins', ready: AppState.coins >= 200000, coins: 5000),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AgencyCenterPage extends StatefulWidget {
  final VoidCallback onUpd;
  const AgencyCenterPage({super.key, required this.onUpd});
  @override
  State<AgencyCenterPage> createState() => _AgencyCenterPageState();
}

class _AgencyCenterPageState extends State<AgencyCenterPage> {
  final _name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agency Center')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.business, color: Colors.amber),
                    title: Text('Agency Commission: 15% on Host Gifts'),
                  ),
                  TextField(controller: _name, decoration: const InputDecoration(labelText: 'New Agency Name')),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                    onPressed: () {
                      if (_name.text.trim().isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Agency "${_name.text}" Registered!')),
                        );
                      }
                    },
                    child: const Text('Create Agency'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContactCenterPage extends StatefulWidget {
  const ContactCenterPage({super.key});
  @override
  State<ContactCenterPage> createState() => _ContactCenterPageState();
}

class _ContactCenterPageState extends State<ContactCenterPage> {
  final _refCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final inviteLink = 'https://google.com{AppState.userId}';

    return Scaffold(
      appBar: AppBar(title: const Text('Invite Friends & Support')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Card(
            color: const Color(0xFF1E293B),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Invite Friends & Earn 500 Coins!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 6),
                  Text('Your Invite Code (User ID): ${AppState.userId}', style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  SelectableText(inviteLink, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: inviteLink));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(backgroundColor: Colors.green, content: Text('Copied Link with ID ${AppState.userId}!')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy Invite Link'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: const Color(0xFF1E293B),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enter Friend User ID (Get +500 Bonus Coins)', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _refCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter Friend User ID (e.g. 1048293)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black),
                    onPressed: () {
                      final enteredId = _refCtrl.text.trim();
                      if (enteredId == AppState.userId) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(backgroundColor: Colors.red, content: Text('You cannot enter your own User ID!')),
                        );
                        return;
                      }
                      if (enteredId.length >= 5 && !AppState.inviteClaimed) {
                        setState(() {
                          AppState.inviteClaimed = true;
                          AppState.coins += 500;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(backgroundColor: Colors.green, content: Text('Success! +500 Bonus Coins Added!')),
                        );
                      } else if (AppState.inviteClaimed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(backgroundColor: Colors.orange, content: Text('Referral bonus already claimed!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(backgroundColor: Colors.red, content: Text('Enter a valid Friend User ID!')),
                        );
                      }
                    },
                    child: const Text('Claim 500 Referral Coins', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: const Color(0xFF1E293B),
            child: ListTile(
              leading: const Icon(Icons.support_agent, color: Colors.tealAccent, size: 32),
              title: const Text('24/7 Official Customer Support', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              subtitle: const Text('Telegram & WhatsApp: +251919108311\nTap to copy support number', style: TextStyle(color: Colors.white70, fontSize: 12)),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black),
                onPressed: () {
                  Clipboard.setData(const ClipboardData(text: '+251919108311'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(backgroundColor: Colors.green, content: Text('Copied Support Number (+251919108311)! Open Telegram or WhatsApp to chat.')),
                  );
                },
                child: const Text('Copy & Chat'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SuperAdminPanel extends StatefulWidget {
  final VoidCallback onUpd;
  const SuperAdminPanel({super.key, required this.onUpd});
  @override
  State<SuperAdminPanel> createState() => _SuperAdminPanelState();
}

class _SuperAdminPanelState extends State<SuperAdminPanel> {
  final _idCtrl = TextEditingController(text: AppState.userId);
  final _amtCtrl = TextEditingController(text: '100000');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Super Admin Control')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          TextField(controller: _idCtrl, decoration: const InputDecoration(labelText: 'Target User ID')),
          TextField(controller: _amtCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Coins Amount')),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
            onPressed: () {
              final add = int.tryParse(_amtCtrl.text) ?? 0;
              if (_idCtrl.text.trim() == AppState.userId) AppState.coins += add;
              widget.onUpd();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Added $add Coins to ID ${_idCtrl.text}!')),
              );
            },
            child: const Text('Add Coins Immediately'),
          ),
        ],
      ),
    );
  }
}
