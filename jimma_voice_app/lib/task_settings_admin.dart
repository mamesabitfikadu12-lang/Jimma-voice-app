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
