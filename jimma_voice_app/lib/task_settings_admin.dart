import 'package:flutter/material.dart';
import 'main.dart';

class TaskCenterPage extends StatefulWidget {
  final VoidCallback onUpd;
  const TaskCenterPage({super.key, required this.onUpd});
  @override
  State<TaskCenterPage> createState() => _TaskCenterPageState();
}
class _TaskCenterPageState extends State<TaskCenterPage> {
  final Set<String> _done = {};
  Widget _row(String t, int c, double p) {
    final ok = _done.contains(t);
    return Card(child: ListTile(title: Text(t), trailing: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: ok ? Colors.grey : Colors.green), onPressed: ok ? null : () { setState(() => _done.add(t)); AppState.coins += c; AppState.points += p; widget.onUpd(); }, child: Text(ok ? 'Done' : 'Go'))));
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3, child: Scaffold(
      appBar: AppBar(title: const Text('Task Center'), bottom: const TabBar(tabs: [Tab(text: 'Tasks'), Tab(text: 'Host Tasks'), Tab(text: 'Events')])),
      body: TabBarView(children: [
        ListView(children: [_row('Playing Royal Battle (+500 Coins)', 500, 0), _row('Recharge Once X1 Day (+1,000 Coins)', 1000, 0), _row('Send Jebena Lucky Gifts (+800 Coins)', 800, 0), _row('Win Coins in Abba Jifar Slot (+600 Coins)', 600, 0)]),
        ListView(children: [_row('Host on Mic 2 Hours (+3,000 Pts)', 0, 3000), _row('Party Crown Room Goal (+5,000 Pts)', 0, 5000), _row('1M / 2M Monthly Target (+20,000 Pts)', 0, 20000)]),
        ListView(children: [_row('Oromia & Ethiopia Cultural Festival (+1,500 Coins)', 1500, 0)]),
      ]),
    ));
  }
}

class SettingsPage extends StatefulWidget {
  final VoidCallback onUpd;
  const SettingsPage({super.key, required this.onUpd});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}
class _SettingsPageState extends State<SettingsPage> {
  final _name = TextEditingController(text: AppState.userName);
  void _pol(String t, String b) => showDialog(context: context, builder: (_) => AlertDialog(title: Text(t), content: Text(b), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))]));
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Settings')), body: ListView(padding: const EdgeInsets.all(14), children: [
      TextField(controller: _name, decoration: const InputDecoration(labelText: 'Display Name')),
      ElevatedButton(onPressed: () { AppState.userName = _name.text.trim(); widget.onUpd(); }, child: const Text('Save Name')),
      const ListTile(title: Text('Account Password • Security PIN • Mail'), trailing: Text('Set >')),
      SwitchListTile(title: const Text('Top Message Banner'), value: AppState.msgBanner, onChanged: (v) => setState(() => AppState.msgBanner = v)),
      SwitchListTile(title: const Text('Sounds & Vibration'), value: AppState.msgSound, onChanged: (v) => setState(() => AppState.msgSound = v)),
      ListTile(title: const Text('1. Privacy Policy'), onTap: () => _pol('Privacy Policy', 'Jimma Voice Chat Family protects Ethiopian & global user data and voice privacy.')),
      ListTile(title: const Text('2. User Service Terms'), onTap: () => _pol('User Service Terms', 'Users must be 18+ and follow Jimma Voice Chat Family community rules.')),
      ListTile(title: const Text('3. Streaming Protocol / Host Agreement'), onTap: () => _pol('Streaming Protocol', 'Fair hourly and gift point rewards for verified hosts.')),
      ListTile(title: const Text('4. Child Safety Policy'), onTap: () => _pol('Child Safety Policy', 'Zero tolerance for minor exploitation. Strict 18+ age rule.')),
      ListTile(title: const Text('5. User Recharge Agreement'), onTap: () => _pol('User Recharge Agreement', 'Coins purchased via Telebirr, CBE, or USDT are instant and non-refundable.')),
    ]));
  }
}

class SuperAdminPanel extends StatefulWidget {
  final VoidCallback onUpd;
  const SuperAdminPanel({super.key, required this.onUpd});
  @override
  State<SuperAdminPanel> createState() => _SuperAdminPanelState();
}
class _SuperAdminPanelState extends State<SuperAdminPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Super Admin Control Panel')), body: ListView(padding: const EdgeInsets.all(14), children: [
      ListTile(title: const Text('Mint 100,000 Test Coins'), trailing: ElevatedButton(onPressed: () { AppState.coins += 100000; widget.onUpd(); setState(() {}); }, child: const Text('+100k'))),
      ListTile(title: Text('Agency: ${AppState.pendingAgencyName} (${AppState.pendingNationalId})'), trailing: ElevatedButton(onPressed: () { AppState.agencyStatus = 'Approved'; widget.onUpd(); setState(() {}); }, child: const Text('Approve'))),
    ]));
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
    final inviteLink = 'https://github.io{AppState.userId}';
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
