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
  final int _hostMins = 45;
  final int _giftIncome = 1200;

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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('Claimed: $title!')));
  }

  Widget _taskTile({required String id, required String icon, required String title, required String prog, required String rewardText, required int coins, double pts = 0, required bool ready}) {
    final done = AppState.claimedTasks.contains(id);
    return Card(
      color: const Color(0xFF1E293B),
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(radius: 22, backgroundColor: Colors.amber.withOpacity(0.15), child: Text(icon, style: const TextStyle(fontSize: 22))),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: Colors.white)),
        subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: List<Widget>.of({
          const SizedBox(height: 2),
          Text(prog, style: const TextStyle(fontSize: 11, color: Colors.white60)),
          const SizedBox(height: 3),
          Text(rewardText, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amber)),
        })),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: done ? Colors.white12 : (ready ? Colors.tealAccent : Colors.amber),
            foregroundColor: done ? Colors.white54 : Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: done ? null : () {
            if (ready) {
              _claimTask(id, coins, pts, title);
            } else {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Go complete: $title')));
            }
          },
          child: Text(done ? 'Done' : (ready ? 'Claim' : 'Go'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final doneCount = AppState.claimedTasks.length;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Task Center'),
          actions: List<Widget>.of({
            Center(child: Padding(padding: const EdgeInsets.only(right: 12), child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: Text('Reset: ${_fmtDuration(_left)}', style: const TextStyle(fontSize: 11, color: Colors.amber, fontWeight: FontWeight.bold))))),
          }),
          bottom: TabBar(tabs: List<Widget>.of({const Tab(text: 'Tasks'), const Tab(text: 'Host Tasks'), const Tab(text: 'Events')})),
        ),
        body: TabBarView(children: List<Widget>.of({
          ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(gradient: const LinearGradient(colors: <Color>[Color(0xFF7F4F24), Color(0xFFCA6702)]), borderRadius: BorderRadius.circular(16)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: List<Widget>.of({
                const Text('Beginner & Daily Chests', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const Text('Complete tasks to unlock 3 treasure chests!', style: TextStyle(fontSize: 12, color: Colors.white70)),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List<Widget>.of({
                  ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black), onPressed: () => _claimTask('chest_1', 300, 0, 'Chest 1 (+300 Coins)'), icon: const Icon(Icons.redeem, size: 16), label: const Text('Chest 1')),
                  ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black), onPressed: () => _claimTask('chest_2', 800, 0, 'Chest 2 (+800 Coins)'), icon: const Icon(Icons.redeem, size: 16), label: const Text('Chest 2')),
                  ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black), onPressed: () => _claimTask('chest_3', 2000, 0, 'Chest 3 (+2000 Coins)'), icon: const Icon(Icons.redeem, size: 16), label: const Text('Chest 3')),
                })),
              })),
            ),
            const SizedBox(height: 14),
            const Text('Daily Tasks (Resets in 24h)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.tealAccent)),
            const SizedBox(height: 8),
            _taskTile(id: 'daily_checkin', icon: '📅', title: 'Daily Check-In Bonus', prog: '(1/1)', rewardText: '+150 Coins', coins: 150, ready: true),
            _taskTile(id: 'stay_room', icon: '🎙️', title: 'Stay in a Voice Room for 5 Mins', prog: '(${AppState.roomMinutesToday >= 5 ? 5 : AppState.roomMinutesToday}/5)', rewardText: '+200 Coins', coins: 200, ready: AppState.roomMinutesToday >= 5 || doneCount >= 1),
            _taskTile(id: 'play_ocean', icon: '🐙', title: 'Play Ocean Hunt Once', prog: '(${AppState.gamesPlayedToday >= 1 ? 1 : 0}/1)', rewardText: '+100 Coins', coins: 100, ready: AppState.gamesPlayedToday >= 1),
            _taskTile(id: 'win_jungle', icon: '🦁', title: 'Win 10,000 Coins in Jungle Hunt', prog: '(${AppState.coins >= 10000 ? '10K' : '0'}/10K)', rewardText: '+300 Coins', coins: 300, ready: AppState.coins >= 10000),
            _taskTile(id: 'play_royal', icon: '👑', title: 'Play Royal Battle', prog: '(${AppState.gamesPlayedToday >= 2 ? 1 : 0}/1)', rewardText: '+50 Points', coins: 0, pts: 50, ready: AppState.gamesPlayedToday >= 2),
            _taskTile(id: 'play_garo', icon: '🏺', title: 'Play Garo Gems III', prog: '(${AppState.gamesPlayedToday >= 3 ? 1 : 0}/1)', rewardText: '+250 Coins', coins: 250, ready: AppState.gamesPlayedToday >= 3),
            _taskTile(id: 'win_fishing', icon: '🦈', title: 'Win 500 Coins in Fishing Tycoon', prog: '(${AppState.coins >= 500 ? 500 : 0}/500)', rewardText: '+100 Points', coins: 0, pts: 100, ready: AppState.coins >= 500),
            _taskTile(id: 'follow_hosts', icon: '➕', title: 'Follow 3 Hosts in Live Room', prog: '(3/3)', rewardText: '+150 Coins', coins: 150, ready: true),
            _taskTile(id: 'vip_once', icon: '🌟', title: 'Purchase VIP Once', prog: '(${AppState.vipLevel >= 1 ? 1 : 0}/1)', rewardText: '+500 Points', coins: 0, pts: 500, ready: AppState.vipLevel >= 1),
          })),
          ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.tealAccent.withOpacity(0.5))),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: List<Widget>.of({
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List<Widget>.of({
                  Text('On Mic Today: $_hostMins / 120 mins', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  Text('$_giftIncome Pts', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.tealAccent)),
                })),
                const SizedBox(height: 8),
                const Text('Hourly Salary Tiers: 600/h -> 1200/h -> 3000/h -> 5000/h', style: TextStyle(fontSize: 12, color: Colors.amber)),
              })),
            ),
            const SizedBox(height: 12),
            _taskTile(id: 'host_2h', icon: '🎤', title: 'On Mic for 2 Hours', prog: '($_hostMins/120 mins)', rewardText: '+500 Points', coins: 0, pts: 500, ready: _hostMins >= 120),
            _taskTile(id: 'host_crown', icon: '👑', title: 'Join Party & Crowned for 1 Hour', prog: '(1/1)', rewardText: '+300 Points', coins: 0, pts: 300, ready: true),
            _taskTile(id: 'host_jebena', icon: '☕', title: 'Receive a Jebena Gold Gift', prog: '(1/1)', rewardText: '+150 Points', coins: 0, pts: 150, ready: true),
            _taskTile(id: 'host_palace', icon: '🏰', title: 'Receive an Abba Jifar Palace Gift', prog: '(0/1)', rewardText: '+5,000 Points', coins: 0, pts: 5000, ready: false),
            _taskTile(id: 'host_1m', icon: '🏆', title: '1M Points Earnings Milestone', prog: '(${AppState.points.toInt()}/1M)', rewardText: '+20,000 Points', coins: 0, pts: 20000, ready: AppState.points >= 1000000),
          })),
          ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
            _taskTile(id: 'ev_invite', icon: '🤝', title: 'Invite 1 Friend to Ethio-Voice', prog: '(1/1)', rewardText: '+2,000 Coins', coins: 2000, ready: true),
            _taskTile(id: 'ev_jackpot', icon: '🎰', title: 'Win 100,000 Coins in Jungle Hunt', prog: '(${AppState.coins >= 100000 ? '100K' : '0'}/100K)', rewardText: '+1,000 Coins', coins: 1000, ready: AppState.coins >= 100000),
            _taskTile(id: 'ev_ocean200', icon: '🐙', title: 'Win 200,000 Coins in Ocean Hunt', prog: '(${AppState.coins >= 200000 ? '200K' : '0'}/200K)', rewardText: '+3,000 Coins', coins: 3000, ready: AppState.coins >= 200000),
          })),
        })),
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
      body: ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
        const Card(child: ListTile(leading: Icon(Icons.business, color: Colors.amber), title: Text('Agency Commission: 12% - 16%'), subtitle: Text('Recruit Hosts & Earn Weekly Rewards'))),
        TextField(controller: _name, decoration: const InputDecoration(labelText: 'New Agency Name')),
        const SizedBox(height: 10),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black), onPressed: () {
          if (_name.text.trim().isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Agency "${_name.text}" Registered!')));
          }
        }, child: const Text('Create Agency')),
      })),
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
      body: ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
        Card(
          color: const Color(0xFF1E293B),
          child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: List<Widget>.of({
            const Text('Invite Friends & Earn 2,000 Coins!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber)),
            const SizedBox(height: 6),
            Text('Your Invite Code: ${AppState.userId}', style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            SelectableText(inviteLink, style: const TextStyle(fontSize: 12, color: Colors.white70)),
            const SizedBox(height: 10),
            ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 44)), onPressed: () {
              Clipboard.setData(ClipboardData(text: inviteLink));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('Invite Link Copied! Share on TikTok/Telegram!')));
            }, icon: const Icon(Icons.copy), label: const Text('Copy Invite Link')),
          }))),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: List<Widget>.of({
            const Text('Enter Friend Invite Code (Get +1,000 Bonus Coins)', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(controller: _refCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'Friend User ID')),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: () {
              if (_refCtrl.text.trim().length >= 5 && !AppState.inviteClaimed) {
                setState(() { AppState.inviteClaimed = true; AppState.coins += 1000; });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('+1,000 Referral Bonus Coins Added!')));
              }
            }, child: const Text('Claim Referral Bonus')),
          }))),
        ),
        const SizedBox(height: 12),
        const Card(child: ListTile(leading: Icon(Icons.support_agent, color: Colors.tealAccent), title: Text('24/7 Official Customer Support'), subtitle: Text('WhatsApp / Telegram: +251919108311'))),
      })),
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
      body: ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
        TextField(controller: _idCtrl, decoration: const InputDecoration(labelText: 'Target User ID')),
        TextField(controller: _amtCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Coins to Add')),
        const SizedBox(height: 10),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 48)), onPressed: () {
          final add = int.tryParse(_amtCtrl.text) ?? 0;
          if (_idCtrl.text.trim() == AppState.userId) AppState.coins += add;
          widget.onUpd();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added $add Coins to ID ${_idCtrl.text}!')));
        }, child: const Text('Add Coins Immediately')),
      })),
    );
  }
}
