import 'package:flutter/material.dart';
import 'main.dart';

class MeTab extends StatefulWidget {
  final VoidCallback onUpd;
  const MeTab({super.key, required this.onUpd});
  @override
  State<MeTab> createState() => _MeTabState();
}

class _MeTabState extends State<MeTab> {
  void _openAdminPrompt() {
    final c = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('System Verification'),
      content: TextField(controller: c, obscureText: true, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'Security Code')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: () {
          if (c.text.trim() == '2730') {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => SuperAdminPanel(onUpd: () { setState(() {}); widget.onUpd(); })));
          }
        }, child: const Text('Verify')),
      ],
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: ListView(padding: const EdgeInsets.all(14), children: [
        GestureDetector(onLongPress: _openAdminPrompt, child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
          Text(AppState.userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('${AppState.userId} • VIP ${AppState.vipLevel} • Wealth Lv.${AppState.wealthLv}', style: const TextStyle(color: Colors.amber, fontSize: 12)),
          const Divider(),
          const Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [Text('0 Followed'), Text('0 Following'), Text('0 Friends')]),
        ])))),
        ListTile(leading: const Icon(Icons.storefront, color: Colors.amber), title: Text('Coin Seller & Wallet (${AppState.coins} Coins)'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CoinSellerPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
        ListTile(leading: const Icon(Icons.groups, color: Colors.cyan), title: Text('Agency Center (${AppState.points.toStringAsFixed(0)} Pts)'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AgencyCenterPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
        ListTile(leading: const Icon(Icons.workspace_premium, color: Colors.orange), title: const Text('VIP Club (VIP1 – VIP19)'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VipClubPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
        ListTile(leading: const Icon(Icons.shopping_bag, color: Colors.pinkAccent), title: const Text('Oromia & Ethiopia Luxury Store'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StorePage(onUpd: () { setState(() {}); widget.onUpd(); })))),
        ListTile(leading: const Icon(Icons.task_alt, color: Colors.greenAccent), title: const Text('Task Center (Tasks • Host • Events)'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskCenterPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
        ListTile(leading: const Icon(Icons.settings, color: Colors.white70), title: const Text('Settings (Account • Message • Policies)'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
      ]),
    );
  }
}
class CoinSellerPage extends StatefulWidget {
  final VoidCallback onUpd;
  const CoinSellerPage({super.key, required this.onUpd});
  @override
  State<CoinSellerPage> createState() => _CoinSellerPageState();
}
class _CoinSellerPageState extends State<CoinSellerPage> {
  final _tx = TextEditingController(), _to = TextEditingController(), _amt = TextEditingController(text: '10');
  String _bank = 'Telebirr'; bool _seller = false;
  @override
  Widget build(BuildContext context) {
    final etb = _seller ? 150 : 180;
    return DefaultTabController(length: 3, child: Scaffold(
      appBar: AppBar(title: const Text('Coin Seller & Wallet'), bottom: const TabBar(tabs: [Tab(text: 'Recharge'), Tab(text: 'Transfer'), Tab(text: 'Exchange')])),
      body: TabBarView(children: [
        ListView(padding: const EdgeInsets.all(14), children: [
          SwitchListTile(title: const Text('Coin Seller Rate (150 ETB = 10k)'), subtitle: const Text('Regular: 180 ETB = 10k | USDT Min \$5 = 50k'), value: _seller, onChanged: (v) => setState(() => _seller = v)),
          DropdownButtonFormField<String>(value: _bank, items: ['Telebirr', 'CBEBirr', 'Siinqee Plus', 'CBE', 'Awash', 'Dashen', 'Binance USDT'].map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(), onChanged: (v) => setState(() => _bank = v ?? 'Telebirr')),
          TextField(controller: _tx, decoration: const InputDecoration(labelText: 'Receipt / Transaction ID')),
          ElevatedButton(onPressed: () { if (_tx.text.length >= 5) { AppState.coins += (_bank == 'Binance USDT' ? 50000 : 10000); widget.onUpd(); setState(() => _tx.clear()); } }, child: Text('Auto-Verify ($etb ETB / 10k)')),
        ]),
        ListView(padding: const EdgeInsets.all(14), children: [
          TextField(controller: _to, decoration: const InputDecoration(labelText: 'Recipient User ID')),
          TextField(controller: _amt, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount (x 1,000 Coins)')),
          ElevatedButton(onPressed: () { final k = (int.tryParse(_amt.text) ?? 0) * 1000; if (k > 0 && AppState.coins >= k) { AppState.coins -= k; widget.onUpd(); setState(() {}); } }, child: const Text('Transfer Coins')),
        ]),
        Center(child: ElevatedButton(onPressed: () { if (AppState.points >= 1000) { AppState.coins += (AppState.points * 0.98).round(); AppState.points = 0; widget.onUpd(); setState(() {}); } }, child: const Text('Exchange Points to Coins (98%)'))),
      ]),
    ));
  }
}
class StorePage extends StatelessWidget {
  final VoidCallback onUpd;
  const StorePage({super.key, required this.onUpd});
  @override
  Widget build(BuildContext context) {
    final items = ['Abba Jifar Palace Theme (4,200)', 'Jimma Royal Stool Frame (15,000)', 'Oromo Royal Horse Ride (30,000)', 'Jebena Gold ChatBubble (10,000)', 'Ethiopian Lion Room Card (7,000)'];
    return Scaffold(appBar: AppBar(title: const Text('Oromia & Ethiopia Luxury Store')), body: ListView(padding: const EdgeInsets.all(14), children: items.map((e) => Card(child: ListTile(title: Text(e), trailing: const Text('Equip')))).toList()));
  }
}
class VipClubPage extends StatelessWidget {
  final VoidCallback onUpd;
  const VipClubPage({super.key, required this.onUpd});
  @override
  Widget build(BuildContext context) {
    final p = ['Daily Coins (2,000/day)', 'Room Bullet Screen', 'More Room Admins', 'VIP Badge', 'Entry Tag', 'Anti-Kick Out', 'Mystery Man', 'Global Entry Tag', 'Oromo ChatBubble', 'Profile Wings'];
    return Scaffold(appBar: AppBar(title: const Text('VIP Club (VIP1–VIP19)')), body: ListView(padding: const EdgeInsets.all(14), children: [
      ElevatedButton(onPressed: () { if (AppState.coins >= 51000) { AppState.coins -= 51000; AppState.vipLevel = 19; onUpd(); } }, child: const Text('Activate VIP 19 (51,000 Coins / 30 Days)')),
      ...p.map((e) => ListTile(leading: const Icon(Icons.verified, color: Colors.amber), title: Text(e))),
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
  final _ag = TextEditingController(), _id = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Agency Center & Points')), body: ListView(padding: const EdgeInsets.all(14), children: [
      Card(child: ListTile(title: Text('Status: ${AppState.agencyStatus}'), subtitle: const Text('Commission: 12% ➔ 16% • Jimma Voice Official'))),
      TextField(controller: _ag, decoration: const InputDecoration(labelText: 'Agency Name')),
      TextField(controller: _id, decoration: const InputDecoration(labelText: 'Ethiopian National ID (FAN/FIN)')),
      ElevatedButton(onPressed: () { if (_ag.text.isNotEmpty && _id.text.isNotEmpty) { AppState.agencyStatus = 'Pending'; AppState.pendingAgencyName = _ag.text; AppState.pendingNationalId = _id.text; setState(() {}); } }, child: const Text('Register Agency')),
      const Text('Detail of Points (All • Cash out • Transfer): 0 Points', style: TextStyle(color: Colors.amber)),
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
