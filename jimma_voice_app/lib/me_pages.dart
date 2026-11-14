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
      actions: List<Widget>.of({
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: () {
          if (c.text.trim() == '2730') {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => SuperAdminPanel(onUpd: () { setState(() {}); widget.onUpd(); })));
          }
        }, child: const Text('Verify')),
      }),
    ));
  }

  Widget _gridBtn(IconData ic, Color col, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: List<Widget>.of({
        CircleAvatar(radius: 20, backgroundColor: col.withOpacity(0.18), child: Icon(ic, color: col, size: 22)),
        const SizedBox(height: 6),
        Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
      })),
    );
  }

  @override
  Widget build(BuildContext context) {
    void go(Widget p) => Navigator.push(context, MaterialPageRoute(builder: (_) => p));
    void upd() { setState(() {}); widget.onUpd(); }

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
        GestureDetector(
          onLongPress: _openAdmin,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: <Color>[Color(0xFF1E293B), Color(0xFF0F172A)]), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.amber.withOpacity(0.4))),
            child: Column(children: List<Widget>.of({
              Text(AppState.userName, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 4),
              Text('ID: ${AppState.userId} • VIP ${AppState.vipLevel} • Wealth Lv.${AppState.wealthLv}', style: const TextStyle(color: Colors.amber, fontSize: 12)),
              const Divider(height: 22),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List<Widget>.of({
                Column(children: List<Widget>.of({const Text('My Coins', style: TextStyle(fontSize: 12, color: Colors.white70)), const SizedBox(height: 4), Text('🪙 ${AppState.coins}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber))})),
                Column(children: List<Widget>.of({const Text('My Points', style: TextStyle(fontSize: 12, color: Colors.white70)), const SizedBox(height: 4), Text('💎 ${AppState.points.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.tealAccent))})),
              })),
            })),
          ),
        ),
        const SizedBox(height: 12),
        Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), child: Padding(padding: const EdgeInsets.all(10), child: GridView.count(
          crossAxisCount: 4, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          children: List<Widget>.of({
            _gridBtn(Icons.account_balance_wallet, Colors.amber, 'Recharge', () => go(CoinSellerPage(onUpd: upd))),
            _gridBtn(Icons.storefront, Colors.pinkAccent, 'Store', () => go(StorePage(onUpd: upd))),
            _gridBtn(Icons.card_giftcard, Colors.redAccent, 'Invite', () => go(const ContactCenterPage())),
            _gridBtn(Icons.backpack, Colors.lightBlue, 'Backpack', () => go(StorePage(onUpd: upd))),
            _gridBtn(Icons.payments, Colors.tealAccent, 'Cash Out', () => go(PointsCashOutPage(onUpd: upd))),
            _gridBtn(Icons.stars, Colors.purpleAccent, 'VIP Club', () => go(VipClubPage(onUpd: upd))),
            _gridBtn(Icons.task_alt, Colors.greenAccent, 'Tasks', () => go(TaskCenterPage(onUpd: upd))),
            _gridBtn(Icons.workspace_premium, Colors.orange, 'Badges', () => go(VipClubPage(onUpd: upd))),
          }),
        ))),
        const SizedBox(height: 12),
        Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), child: Padding(padding: const EdgeInsets.all(10), child: GridView.count(
          crossAxisCount: 4, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          children: List<Widget>.of({
            _gridBtn(Icons.mic, Colors.cyan, 'Host Center', () => go(HostCenterPage(onUpd: upd))),
            _gridBtn(Icons.business_center, Colors.teal, 'Agency', () => go(AgencyCenterPage(onUpd: upd))),
            _gridBtn(Icons.monetization_on, Colors.greenAccent, 'Coin Seller', () => go(CoinSellerPage(onUpd: upd))),
            _gridBtn(Icons.headset_mic, Colors.blueAccent, 'Support', () => go(const ContactCenterPage())),
            _gridBtn(Icons.policy, Colors.amber, 'Policies', () => go(AppSettings5Page(onUpd: upd))),
            _gridBtn(Icons.settings, Colors.white70, 'Settings', () => go(AppSettings5Page(onUpd: upd))),
          }),
        ))),
      })),
    );
  }
}

class HostCenterPage extends StatelessWidget {
  final VoidCallback onUpd;
  const HostCenterPage({super.key, required this.onUpd});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Host Center')),
      body: ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
        Card(child: ListTile(leading: const Icon(Icons.payments, color: Colors.tealAccent), title: Text('Points: ${AppState.points.toStringAsFixed(2)}'), subtitle: const Text('Tap to Cash Out ETB / USDT'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PointsCashOutPage(onUpd: onUpd))))),
        const Card(child: ListTile(leading: Icon(Icons.timer, color: Colors.amber), title: Text('Live Room Duration'), trailing: Text('0 mins'))),
      })),
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
  final _tx = TextEditingController(), _to = TextEditingController(), _amt = TextEditingController(text: '10'), _custom = TextEditingController(text: '10000');
  String _bank = 'Telebirr';
  bool _isSeller = false, _verifying = false;
  int _coins = 10000;

  final Map<String, String> _acc = {
    'Telebirr': '+251919108311',
    'CBEBirr': '+251919108311',
    'CBE': '1000273060937',
    'Awash Bank': '014251157710000',
    'Dashen Bank': '2952945930711',
    'USDT (TRC20)': 'TYdr3JdbDzhxjfsGeU3yazNAmTbkHBuNcE',
  };

  Future<void> _verify() async {
    final ref = _tx.text.trim();
    if (_bank == 'USDT (TRC20)' && _coins < 50000) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('USDT Min \$5 (50,000 Coins)'))); return; }
    if (_coins < 10000 || ref.length < 5) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Min 10,000 Coins & valid Ref'))); return; }
    setState(() => _verifying = true);
    try {
      final res = await JimmaApiService.verifyShegerPay(userId: AppState.userId, referenceId: ref, provider: _bank.toLowerCase(), coinsToAdd: _coins);
      if (res['success'] == true) {
        setState(() { AppState.coins = res['newBalance'] ?? (AppState.coins + _coins); _tx.clear(); _verifying = false; });
        widget.onUpd();
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['error'] ?? 'Invalid Ref')));
    } catch (_) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Server error'))); }
    setState(() => _verifying = false);
  }

  @override
  Widget build(BuildContext context) {
    final price = _bank == 'USDT (TRC20)' ? '\$${(_coins / 10000).toStringAsFixed(1)} USDT' : '${((_coins / 10000) * (_isSeller ? 150 : 180)).toStringAsFixed(0)} ETB';
    return DefaultTabController(length: 2, child: Scaffold(
      appBar: AppBar(title: const Text('Recharge & ID Trade'), bottom: TabBar(tabs: List<Widget>.of({const Tab(text: 'Recharge'), const Tab(text: 'ID Transfer')})),
      body: TabBarView(children: List<Widget>.of({
        ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
          SwitchListTile(title: const Text('Bulk Coin Seller Rate'), subtitle: const Text('Seller: 150 ETB/10k | User: 180 ETB/10k'), value: _isSeller, onChanged: (v) => setState(() => _isSeller = v)),
          DropdownButtonFormField<String>(value: _bank, items: _acc.keys.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(), onChanged: (v) => setState(() => _bank = v ?? 'Telebirr')),
          TextField(controller: _custom, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Custom Coins (Min 10,000)'), onChanged: (v) => setState(() => _coins = int.tryParse(v) ?? 10000)),
          Card(child: ListTile(title: Text('$_bank • Pay: $price', style: const TextStyle(color: Colors.amber)), subtitle: SelectableText(_acc[_bank] ?? ''), trailing: IconButton(icon: const Icon(Icons.copy), onPressed: () => Clipboard.setData(ClipboardData(text: _acc[_bank] ?? ''))))),
