import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'task_settings_admin.dart';
import 'main.dart';
import 'api_service.dart';

class MeTab extends StatefulWidget {
  final VoidCallback onUpd;
  const MeTab({super.key, required this.onUpd});
  @override
  State<MeTab> createState() => _MeTabState();
}

class _MeTabState extends State<MeTab> {
  void _openAdmin() {
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
        GestureDetector(onLongPress: _openAdmin, child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
          Text(AppState.userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('${AppState.userId} • VIP ${AppState.vipLevel} • Wealth Lv.${AppState.wealthLv}', style: const TextStyle(color: Colors.amber, fontSize: 12)),
          const Divider(),
          const Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [Text('0 Followed'), Text('0 Following'), Text('0 Friends')]),
        ])))),
        ListTile(leading: const Icon(Icons.storefront, color: Colors.amber), title: Text('Coin Seller & Wallet (${AppState.coins} Coins)'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CoinSellerPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
        ListTile(leading: const Icon(Icons.groups, color: Colors.cyan), title: Text('Agency Center (${AppState.points.toStringAsFixed(0)} Pts)'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AgencyCenterPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
        ListTile(leading: const Icon(Icons.workspace_premium, color: Colors.orange), title: const Text('VIP Club (VIP1 – VIP19)'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VipClubPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
        ListTile(leading: const Icon(Icons.shopping_bag, color: Colors.pinkAccent), title: const Text('Oromia & Ethiopia Luxury Store'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StorePage(onUpd: () { setState(() {}); widget.onUpd(); })))),
        ListTile(leading: const Icon(Icons.task_alt, color: Colors.greenAccent), title: const Text('Task Center'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskCenterPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
        ListTile(leading: const Icon(Icons.settings, color: Colors.white70), title: const Text('Settings'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
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
  String _bank = 'Telebirr';
  bool _seller = false, _verifying = false;

  final Map<String, String> _accounts = {
    'Telebirr': '+251919108311',
    'CBEBirr': '+251919108311',
    'CBE': '1000273060937',
    'Awash Bank': '014251157710000',
    'Dashen Bank': '2952945930711',
    'USDT (TRC20)': 'TYdr3JdbDzhxjfsGeU3yazNAmTbkHBuNcE',
  };

  Future<void> _verify() async {
    final ref = _tx.text.trim();
    if (ref.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter valid Transaction ID')));
      return;
    }
    setState(() => _verifying = true);
    final add = _bank == 'USDT (TRC20)' ? 50000 : 10000;
    try {
      final res = await JimmaApiService.verifyShegerPay(userId: AppState.userId, referenceId: ref, provider: _bank.toLowerCase(), coinsToAdd: add);
      if (res['success'] == true) {
        setState(() { AppState.coins = res['newBalance'] ?? (AppState.coins + add); _tx.clear(); _verifying = false; });
        AppState.addNotif(context, 'ShegerPay Verified (+$add Coins)', 'Paid via $_bank • Ref: $ref');
        widget.onUpd();
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['error'] ?? 'Invalid ref')));
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Server connecting... Try again.')));
    }
    setState(() => _verifying = false);
  }

  @override
  Widget build(BuildContext context) {
    final etb = _seller ? 150 : 180;
    final acc = _accounts[_bank] ?? '';
    return DefaultTabController(length: 3, child: Scaffold(
      appBar: AppBar(title: const Text('Coin Seller & Wallet'), bottom: const TabBar(tabs: [Tab(text: 'Recharge'), Tab(text: 'Transfer'), Tab(text: 'Exchange')])),
      body: TabBarView(children: [
        ListView(padding: const EdgeInsets.all(14), children: [
          SwitchListTile(title: const Text('Coin Seller Rate (150 ETB = 10k)'), subtitle: const Text('Regular: 180 ETB = 10k | USDT \$5 = 50k'), value: _seller, onChanged: (v) => setState(() => _seller = v)),
          DropdownButtonFormField<String>(value: _bank, items: _accounts.keys.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(), onChanged: (v) => setState(() => _bank = v ?? 'Telebirr')),
          Card(color: const Color(0xFF1E293B), child: ListTile(
            title: Text('$_bank Account', style: const TextStyle(fontSize: 12, color: Colors.amber)),
            subtitle: SelectableText(acc, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: IconButton(icon: const Icon(Icons.copy, color: Colors.amber), onPressed: () {
              Clipboard.setData(ClipboardData(text: acc));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied: $acc')));
            }),
          )),
          TextField(controller: _tx, decoration: const InputDecoration(labelText: 'Transaction ID / Reference')),
          const SizedBox(height: 10),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black), onPressed: _verifying ? null : _verify, child: Text(_verifying ? 'Verifying...' : 'Verify via ShegerPay ($etb ETB / 10k)')),
        ]),
        ListView(padding: const EdgeInsets.all(14), children: [
          TextField(controller: _to, decoration: const InputDecoration(labelText: 'Recipient User ID')),
          TextField(controller: _amt, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount (x 1,000 Coins)')),
          ElevatedButton(onPressed: () {
            final k = (int.tryParse(_amt.text) ?? 0) * 1000;
            if (k > 0 && AppState.coins >= k && _to.text.isNotEmpty) {
              AppState.coins -= k;
              AppState.addNotif(context, 'Coins Transferred (-$k)', 'To: ${_to.text.trim()}');
              widget.onUpd();
              setState(() {});
            }
          }, child: const Text('Transfer Coins')),
        ]),
        Center(child: ElevatedButton(onPressed: () {
          if (AppState.points >= 1000) {
            final c = (AppState.points * 0.98).round();
            AppState.coins += c;
            AppState.points = 0;
            widget.onUpd();
            setState(() {});
          }
        }, child: const Text('Exchange Points to Coins (98%)'))),
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
  final _ag = TextEditingController(), _id = TextEditingController(), _aid = TextEditingController(), _pts = TextEditingController(text: '1000');
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Agency Center')), body: ListView(padding: const EdgeInsets.all(14), children: [
      Card(child: ListTile(title: Text('Status: ${AppState.agencyStatus} • Points: ${AppState.points.toStringAsFixed(0)}'))),
      TextField(controller: _aid, decoration: const InputDecoration(labelText: 'Agent ID')),
      TextField(controller: _pts, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Points')),
      ElevatedButton(onPressed: () {
        final p = double.tryParse(_pts.text) ?? 0;
        if (p > 0 && AppState.points >= p && _aid.text.isNotEmpty) {
          AppState.points -= p;
          AppState.pointHistory.insert(0, {'title': 'Sent to ${_aid.text}', 'amt': '-${p.toStringAsFixed(0)}'});
          widget.onUpd();
          setState(() {});
        }
      }, child: const Text('Send Points')),
      const Divider(),
      TextField(controller: _ag, decoration: const InputDecoration(labelText: 'Agency Name')),
      TextField(controller: _id, decoration: const InputDecoration(labelText: 'National ID')),
      ElevatedButton(onPressed: () {
        if (_ag.text.isNotEmpty && _id.text.isNotEmpty) {          AppState.agencyStatus = 'Pending';
          AppState.pendingAgencyName = _ag.text;
          AppState.pendingNationalId = _id.text;
          setState(() {});
        }
      }, child: const Text('Register Agency')),
      ...AppState.pointHistory.map((h) => ListTile(title: Text(h['title']!), trailing: Text(h['amt']!))),
    ]));
  }
}

class VipClubPage extends StatefulWidget {
  final VoidCallback onUpd;
  const VipClubPage({super.key, required this.onUpd});
  @override
  State<VipClubPage> createState() => _VipClubPageState();
}

class _VipClubPageState extends State<VipClubPage> {
  final _vips = List<Map<String, dynamic>>.of({
    {'lv': 1, 'name': 'VIP 1 • Bronze Noble', 'price': 2000, 'perk': 'Bronze Badge + Entry Tag'},
    {'lv': 3, 'name': 'VIP 3 • Silver Knight', 'price': 5000, 'perk': 'Silver Frame + Daily 300 Coins'},
    {'lv': 5, 'name': 'VIP 5 • Golden Duke', 'price': 10000, 'perk': 'Gold ChatBubble + Bullet Screen'},
    {'lv': 10, 'name': 'VIP 10 • Oromo Prince', 'price': 25000, 'perk': 'Royal Horse Entry + VIP Mic Ring'},
    {'lv': 15, 'name': 'VIP 15 • Finfinnee Emperor', 'price': 38000, 'perk': 'Profile Wings + Anti-Kick Shield'},
    {'lv': 19, 'name': 'VIP 19 • Supreme King', 'price': 51000, 'perk': 'All Luxury Rides, Frames & 2,000 Daily Coins'},
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('VIP Club • Current: VIP ${AppState.vipLevel}')),
      body: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: _vips.length,
        itemBuilder: (_, i) {
          final v = _vips.elementAt(i);
          final lv = v['lv'] as int;
          final price = v['price'] as int;
          final active = AppState.vipLevel >= lv;
          return Card(
            color: active ? Colors.amber.withOpacity(0.18) : const Color(0xFF1E293B),
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Colors.amber, child: Text('V$lv', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
              title: Text(v['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${v['perk']}\nPrice: 🪙 $price Coins', style: const TextStyle(fontSize: 12)),
              isThreeLine: true,
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: active ? Colors.green : Colors.amber, foregroundColor: Colors.black),
                onPressed: active ? null : () {
                  if (AppState.coins >= price) {
                    setState(() { AppState.coins -= price; AppState.vipLevel = lv; });
                    widget.onUpd();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Activated ${v['name']}!')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not enough Coins! Recharge first.')));
                  }
                },
                child: Text(active ? 'Active' : 'Buy'),
              ),
            ),
          );
        },
      ),
    );
  }
}
