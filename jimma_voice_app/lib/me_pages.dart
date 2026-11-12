import 'task_settings_admin.dart';
import 'task_settings_admin.dart';
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
          ElevatedButton(onPressed: () {
            if (_tx.text.length >= 5) {
              final add = _bank == 'Binance USDT' ? 50000 : 10000;
              AppState.coins += add;
              AppState.addNotif(context, 'Coins Recharged (+$add Coins)', 'Paid via $_bank • Ref: ${_tx.text.trim()}');
              widget.onUpd();
              setState(() => _tx.clear());
            }
          }, child: Text('Auto-Verify ($etb ETB / 10k)')),
        ]),
        ListView(padding: const EdgeInsets.all(14), children: [
          TextField(controller: _to, decoration: const InputDecoration(labelText: 'Recipient User ID')),
          TextField(controller: _amt, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount (x 1,000 Coins)')),
          ElevatedButton(onPressed: () {
            final k = (int.tryParse(_amt.text) ?? 0) * 1000;
            if (k > 0 && AppState.coins >= k && _to.text.isNotEmpty) {
              AppState.coins -= k;
              AppState.addNotif(context, 'Coins Transferred (-$k Coins)', 'Sent to User ID: ${_to.text.trim()}');
              widget.onUpd();
              setState(() {});
            }
          }, child: const Text('Transfer Coins')),
        ]),
        Center(child: ElevatedButton(onPressed: () {
          if (AppState.points >= 1000) {
            final c = (AppState.points * 0.98).round();
            AppState.coins += c;
            AppState.addNotif(context, 'Points Exchanged (+$c Coins)', 'Converted ${AppState.points.toStringAsFixed(0)} Agent Points to Coins');
            AppState.points = 0;
            widget.onUpd();
            setState(() {});
          }
        }, child: const Text('Exchange Agent Points to Coins (98%)'))),
      ]),
    ));
  }
}

class AgencyCenterPage extends StatefulWidget {
  final VoidCallback onUpd;
  const AgencyCenterPage({super.key, required this.onUpd});
  @override
  State<AgencyCenterPage> createState() => _AgencyCenterPageState();
}
class _AgencyCenterPageState extends State<AgencyCenterPage> {
  final _ag = TextEditingController(), _id = TextEditingController(), _agentId = TextEditingController(), _ptsCtrl = TextEditingController(text: '1000');
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Agency Center & Points')), body: ListView(padding: const EdgeInsets.all(14), children: [
      Card(child: ListTile(title: Text('Status: ${AppState.agencyStatus} • My Points: ${AppState.points.toStringAsFixed(0)}'), subtitle: const Text('Commission: 12% ➔ 16% • Official Jimma Voice Support'))),
      const Text('Send Host Points to Agent (Hala Style)', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
      TextField(controller: _agentId, decoration: const InputDecoration(labelText: 'Agent ID')),
      TextField(controller: _ptsCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Points Amount to Send')),
      ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black), onPressed: () {
        final p = double.tryParse(_ptsCtrl.text) ?? 0;
        if (p > 0 && AppState.points >= p && _agentId.text.isNotEmpty) {
          AppState.points -= p;
          AppState.pointHistory.insert(0, {'title': 'Sent to Agent ${_agentId.text}', 'amt': '-${p.toStringAsFixed(0)} Pts'});
          AppState.addNotif(context, 'Points Sent to Agent', 'Transferred ${p.toStringAsFixed(0)} Pts to Agent ID: ${_agentId.text}');
          widget.onUpd();
          setState(() {});
        }
      }, child: const Text('Send Points to Agent')),
      const Divider(),
      TextField(controller: _ag, decoration: const InputDecoration(labelText: 'New Agency Name')),
      TextField(controller: _id, decoration: const InputDecoration(labelText: 'Ethiopian National ID (FAN/FIN)')),
      ElevatedButton(onPressed: () { if (_ag.text.isNotEmpty && _id.text.isNotEmpty) { AppState.agencyStatus = 'Pending'; AppState.pendingAgencyName = _ag.text; AppState.pendingNationalId = _id.text; setState(() {}); } }, child: const Text('Register Agency')),
      const Divider(),
      const Text('Detail of Points (All • Cash out • Transfer)', style: TextStyle(color: Colors.amber)),
      ...AppState.pointHistory.map((h) => ListTile(title: Text(h['title']!), trailing: Text(h['amt']!))),
    ]));
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

class StorePage extends StatelessWidget {
  final VoidCallback onUpd;
  const StorePage({super.key, required this.onUpd});
  @override
  Widget build(BuildContext context) {
    final items = ['Abba Jifar Palace Theme (4,200)', 'Jimma Royal Stool Frame (15,000)', 'Oromo Royal Horse Ride (30,000)', 'Jebena Gold ChatBubble (10,000)', 'Ethiopian Lion Room Card (7,000)'];
    return Scaffold(appBar: AppBar(title: const Text('Oromia & Ethiopia Luxury Store')), body: ListView(padding: const EdgeInsets.all(14), children: items.map((e) => Card(child: ListTile(title: Text(e), trailing: const Text('Equip')))).toList()));
  }
}
