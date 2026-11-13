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
  String _bank = 'Telebirr';
  bool _seller = false;
  bool _verifying = false;

  final Map<String, String> _accounts = {
    'Telebirr': '+251919108311',
    'CBEBirr': '+251919108311',
    'CBE': '1000273060937',
    'Awash Bank': '014251157710000',
    'Dashen Bank': '2952945930711',
    'USDT (TRC20)': 'TYdr3JdbDzhxjfsGeU3yazNAmTbkHBuNcE',
  };

  Future<void> _handleVerify() async {
    final ref = _tx.text.trim();
    if (ref.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter valid Transaction ID / Hash')));
      return;
    }
    setState(() => _verifying = true);
    final add = _bank == 'USDT (TRC20)' ? 50000 : 10000;

    try {
      final res = await JimmaApiService.verifyShegerPay(
        userId: AppState.userId,
        referenceId: ref,
        provider: _bank.toLowerCase(),
        coinsToAdd: add,
      );
      if (res['success'] == true) {
        setState(() {
          AppState.coins = res['newBalance'] ?? (AppState.coins + add);
          _tx.clear();
          _verifying = false;
        });
        AppState.addNotif(context, 'ShegerPay Verified (+$add Coins)', 'Paid via $_bank • Ref: $ref');
        widget.onUpd();
        return;
      } else {
        setState(() => _verifying = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['error'] ?? 'Verification pending or invalid ref')));
        return;
      }
    } catch (_) {
      setState(() => _verifying = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Server connecting... Please try again in 10 seconds.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final etb = _seller ? 150 : 180;
    final accNumber = _accounts[_bank] ?? '';

    return DefaultTabController(length: 3, child: Scaffold(
      appBar: AppBar(title: const Text('Coin Seller & Wallet'), bottom: const TabBar(tabs: [Tab(text: 'Recharge'), Tab(text: 'Transfer'), Tab(text: 'Exchange')])),
      body: TabBarView(children: [
        ListView(padding: const EdgeInsets.all(14), children: [
          SwitchListTile(
            title: const Text('Coin Seller Rate (150 ETB = 10k)'),
            subtitle: const Text('Regular: 180 ETB = 10k | USDT Min \$5 = 50k'),
            value: _seller,
            onChanged: (v) => setState(() => _seller = v),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _bank,
            decoration: const InputDecoration(labelText: 'Select Payment Method', border: OutlineInputBorder()),
            items: _accounts.keys.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
            onChanged: (v) => setState(() => _bank = v ?? 'Telebirr'),
          ),
          const SizedBox(height: 12),
          Card(
            color: const Color(0xFF1E293B),
            child: ListTile(
              title: Text('$_bank Account / Address', style: const TextStyle(fontSize: 12, color: Colors.amber)),
              subtitle: SelectableText(accNumber, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
              trailing: IconButton(
                icon: const Icon(Icons.copy, color: Colors.amber),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: accNumber));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied $_bank: $accNumber')));
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _tx,
            decoration: const InputDecoration(
              labelText: 'Transaction ID / Receipt Reference',
              hintText: 'e.g. BBE89X21... or TRC20 TxHash',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 14)),
            onPressed: _verifying ? null : _handleVerify,
            child: _verifying
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                : Text(_bank == 'USDT (TRC20)' ? 'Verify via ShegerPay (\$5 / 50k Coins)' : 'Verify via ShegerPay ($etb ETB / 10k Coins)'),
          ),
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
