import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
  String? _avatarPath;
  final _picker = ImagePicker();

  Future<void> _pickAvatar() async {
    final XFile? f = await _picker.pickImage(source: ImageSource.gallery);
    if (f != null) {
      setState(() => _avatarPath = f.path);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile Photo Updated!')));
    }
  }

  void _editName() {
    final c = TextEditingController(text: AppState.userName);
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Edit Username'),
      content: TextField(controller: c, decoration: const InputDecoration(labelText: 'Your Name')),
      actions: List<Widget>.of({
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: () {
          if (c.text.trim().isNotEmpty && !AppState.hasProfanity(c.text)) {
            setState(() => AppState.userName = c.text.trim());
            widget.onUpd();
            Navigator.pop(context);
          }
        }, child: const Text('Save')),
      }),
    ));
  }

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
      appBar: AppBar(title: const Text('ኢትዮ-ድምጽ • My Profile')),
      body: ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
        GestureDetector(
          onLongPress: _openAdmin,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: <Color>[Color(0xFF1E293B), Color(0xFF0F172A)]), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.amber.withOpacity(0.4))),
            child: Column(children: List<Widget>.of({
              GestureDetector(
                onTap: _pickAvatar,
                child: Stack(children: List<Widget>.of({
                  CircleAvatar(radius: 36, backgroundColor: Colors.amber, backgroundImage: (_avatarPath != null && !kIsWeb) ? FileImage(File(_avatarPath!)) : null, child: _avatarPath == null ? const Icon(Icons.person, size: 38, color: Colors.black) : null),
                  const Positioned(bottom: 0, right: 0, child: CircleAvatar(radius: 12, backgroundColor: Colors.tealAccent, child: Icon(Icons.camera_alt, size: 14, color: Colors.black))),
                })),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _editName,
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: List<Widget>.of({
                  Text(AppState.userName, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(width: 6),
                  const Icon(Icons.edit, size: 16, color: Colors.amber),
                })),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: () { Clipboard.setData(ClipboardData(text: AppState.userId)); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied ID: ${AppState.userId}'))); },
                child: Text('ID: ${AppState.userId} 📋 • VIP ${AppState.vipLevel} • Wealth Lv.${AppState.wealthLv}', style: const TextStyle(color: Colors.amber, fontSize: 12)),
              ),
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
  final _targetId = TextEditingController(text: AppState.userId);
  final _tx = TextEditingController(), _to = TextEditingController(), _amt = TextEditingController(text: '10'), _custom = TextEditingController(text: '10000');
  String _bank = 'Telebirr';
  bool _isSeller = false, _verifying = false, _idConfirmed = true;
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
    final uid = _targetId.text.trim();
    if (!_idConfirmed || uid.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter User ID & tap Confirm!'))); return; }
    if (_bank == 'USDT (TRC20)' && _coins < 50000) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('USDT Min \$5 (50,000 Coins)'))); return; }
    if (_coins < 10000 || ref.length < 5) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Min 10,000 Coins & valid Ref'))); return; }
    setState(() => _verifying = true);
    try {
      final res = await JimmaApiService.verifyShegerPay(userId: uid, referenceId: ref, provider: _bank.toLowerCase(), coinsToAdd: _coins);
      if (res['success'] == true) {
        if (uid == AppState.userId) { AppState.coins = res['newBalance'] ?? (AppState.coins + _coins); }
        setState(() { _tx.clear(); _verifying = false; });
        widget.onUpd();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✅ Recharged $_coins Coins to ID: $uid!')));
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
          const Text('User ID', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
          const SizedBox(height: 6),
          Row(children: List<Widget>.of({
            Expanded(child: TextField(controller: _targetId, decoration: const InputDecoration(hintText: 'Enter User ID (e.g. 3712956)', isDense: true), onChanged: (_) => setState(() => _idConfirmed = false))),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _idConfirmed ? Colors.green : Colors.tealAccent, foregroundColor: Colors.black),
              onPressed: () { if (_targetId.text.trim().isNotEmpty) { setState(() => _idConfirmed = true); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✅ Confirmed ID: ${_targetId.text.trim()}'))); } },
              child: Text(_idConfirmed ? 'Confirmed ✓' : 'Confirm'),
            ),
          })),
          const Divider(height: 20),
          SwitchListTile(title: const Text('Official Agency / Bulk Rate (20% Off)'), subtitle: const Text('Seller: 150 ETB/10k | User: 180 ETB/10k'), value: _isSeller, onChanged: (v) => setState(() => _isSeller = v)),
          DropdownButtonFormField<String>(value: _bank, items: _acc.keys.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(), onChanged: (v) => setState(() => _bank = v ?? 'Telebirr')),
          TextField(controller: _custom, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Any Coins Amount (Min 10,000)'), onChanged: (v) => setState(() => _coins = int.tryParse(v) ?? 10000)),
          Card(child: ListTile(title: Text('$_bank • Pay: $price', style: const TextStyle(color: Colors.amber)), subtitle: SelectableText(_acc[_bank] ?? ''), trailing: IconButton(icon: const Icon(Icons.copy), onPressed: () => Clipboard.setData(ClipboardData(text: _acc[_bank] ?? ''))))),
          TextField(controller: _tx, decoration: const InputDecoration(labelText: 'Transaction ID / Ref')),
          const SizedBox(height: 10),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black), onPressed: _verifying ? null : _verify, child: Text(_verifying ? 'Verifying...' : 'Recharge $_coins Coins to ID ${_targetId.text}')),
        })),
        ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
          Card(child: ListTile(title: Text('Balance: 🪙 ${AppState.coins} Coins'))),
          TextField(controller: _to, decoration: const InputDecoration(labelText: 'Recipient User ID')),
          TextField(controller: _amt, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Coins (×1,000)')),
          ElevatedButton(onPressed: () {
            final k = (int.tryParse(_amt.text) ?? 0) * 1000;
            if (k >= 1000 && AppState.coins >= k && _to.text.isNotEmpty) { AppState.coins -= k; widget.onUpd(); setState(() {}); }
          }, child: const Text('Send Coins')),
        })),
      })),
    ));
  }
}

class PointsCashOutPage extends StatefulWidget {
  final VoidCallback onUpd;
  const PointsCashOutPage({super.key, required this.onUpd});
  @override
  State<PointsCashOutPage> createState() => _PointsCashOutPageState();
}

class _PointsCashOutPageState extends State<PointsCashOutPage> {
  final _pts = TextEditingController(text: '100000'), _acc = TextEditingController();
  String _method = 'Telebirr';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Points Cash Out')),
      body: ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
        Card(child: ListTile(title: Text('Points: ${AppState.points.toStringAsFixed(2)}'), subtitle: const Text('Min: 100,000 Points'))),
        DropdownButtonFormField<String>(value: _method, items: List<String>.of({'Telebirr', 'CBEBirr', 'CBE', 'Awash Bank', 'Dashen Bank', 'USDT'}).map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(), onChanged: (v) => setState(() => _method = v ?? 'Telebirr')),
        TextField(controller: _acc, decoration: const InputDecoration(labelText: 'Account / Phone / USDT')),
        TextField(controller: _pts, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Points (Multiple of 100,000)')),
        ElevatedButton(onPressed: () {
          final a = double.tryParse(_pts.text) ?? 0;
          if (a >= 100000 && AppState.points >= a && _acc.text.isNotEmpty) { AppState.points -= a; widget.onUpd(); setState(() {}); }
        }, child: const Text('Withdraw')),
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
  final _ag = TextEditingController(), _id = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Agency Center')), body: ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
      Card(child: ListTile(title: Text('Status: ${AppState.agencyStatus}'), subtitle: const Text('Commission: 12% ➔ 16%'))),
      TextField(controller: _ag, decoration: const InputDecoration(labelText: 'Agency Name')),
      TextField(controller: _id, decoration: const InputDecoration(labelText: 'National ID (FAN/FIN)')),
      ElevatedButton(onPressed: () { if (_ag.text.isNotEmpty && _id.text.isNotEmpty) setState(() => AppState.agencyStatus = 'Pending'); }, child: const Text('Register Agency')),
    })));
  }
}

class ContactCenterPage extends StatelessWidget {
  const ContactCenterPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Support & Admin')), body: ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
      Card(child: ListTile(title: const Text('WhatsApp & Telegram Admin'), subtitle: const Text('+251919108311'), trailing: IconButton(icon: const Icon(Icons.copy), onPressed: () => Clipboard.setData(const ClipboardData(text: '+251919108311'))))),
    })));
  }
}

class AppSettings5Page extends StatelessWidget {
  final VoidCallback onUpd;
  const AppSettings5Page({super.key, required this.onUpd});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Settings & Policies')), body: ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
      ListTile(title: const Text('1. Account & Security'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsPage(onUpd: onUpd)))),
      const ListTile(title: Text('2. Notifications & Audio')),
      const ListTile(title: Text('3. Privacy & Blacklist')),
      const ListTile(title: Text('4. Language (Afaan Oromoo / English)')),
      const ListTile(title: Text('5. Policies & Terms'), subtitle: Text('Min Cash Out: 100,000 Pts • Support: +251919108311')),
    })));
  }
}

