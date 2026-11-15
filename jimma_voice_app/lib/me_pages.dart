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
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('Invalid or abusive name!')));
          }
        }, child: const Text('Save')),
      }),
    ));
  }

  void _openAdmin() {
    final c = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('System Verification'),
      content: TextField(controller: c, obscureText: true, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Security Passcode')),
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
            decoration: BoxDecoration(gradient: const LinearGradient(colors: <Color>[Color(0xFF1E293B), Color(0xFF0F172A)]), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.amber.withOpacity(0.5))),
            child: Column(children: List<Widget>.of({
              GestureDetector(
                onTap: _pickAvatar,
                child: Stack(children: List<Widget>.of({
                  CircleAvatar(radius: 36, backgroundColor: Colors.amber, backgroundImage: (_avatarPath != null && !kIsWeb) ? FileImage(File(_avatarPath!)) : null, child: _avatarPath == null ? const Icon(Icons.person, size: 40, color: Colors.black) : null),
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
                Column(children: List<Widget>.of({const Text('My Coins', style: TextStyle(fontSize: 12, color: Colors.white70)), Text('🪙 ${AppState.coins}', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.amber))})),
                Column(children: List<Widget>.of({const Text('My Points', style: TextStyle(fontSize: 12, color: Colors.white70)), Text('💎 ${AppState.points.toStringAsFixed(2)}', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.tealAccent))})),
              })),
            })),
          ),
        ),
        const SizedBox(height: 12),
        Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), child: Padding(padding: const EdgeInsets.all(12), child: GridView.count(
          crossAxisCount: 4, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          children: List<Widget>.of({
            _gridBtn(Icons.account_balance_wallet, Colors.amber, 'Recharge', () => go(CoinSellerPage(onUpd: upd))),
            _gridBtn(Icons.storefront, Colors.pinkAccent, 'Store', () => go(StorePage(onUpd: upd))),
            _gridBtn(Icons.card_giftcard, Colors.redAccent, 'Invite', () => go(ContactCenterPage())),
            _gridBtn(Icons.backpack, Colors.lightBlue, 'Backpack', () => go(StorePage(onUpd: upd))),
            _gridBtn(Icons.payments, Colors.tealAccent, 'Cash Out', () => go(PointsCashOutPage(onUpd: upd))),
            _gridBtn(Icons.stars, Colors.purpleAccent, 'VIP Club', () => go(VipClubPage(onUpd: upd))),
            _gridBtn(Icons.task_alt, Colors.greenAccent, 'Tasks', () => go(TaskCenterPage(onUpd: upd))),
            _gridBtn(Icons.workspace_premium, Colors.orange, 'Badges', () => go(VipClubPage(onUpd: upd))),
          }),
        ))),
        const SizedBox(height: 12),
        Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), child: Padding(padding: const EdgeInsets.all(12), child: GridView.count(
          crossAxisCount: 4, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          children: List<Widget>.of({
            _gridBtn(Icons.mic, Colors.cyan, 'Host Center', () => go(HostCenterPage(onUpd: upd))),
            _gridBtn(Icons.business_center, Colors.teal, 'Agency', () => go(AgencyCenterPage(onUpd: upd))),
            _gridBtn(Icons.monetization_on, Colors.greenAccent, 'Coin Seller', () => go(CoinSellerPage(onUpd: upd))),
            _gridBtn(Icons.headset_mic, Colors.blueAccent, 'Support', () => go( ContactCenterPage())),
            _gridBtn(Icons.policy, Colors.amber, 'Policies', () => go(const AppSettingsPage())),
            _gridBtn(Icons.settings, Colors.white70, 'Settings', () => go(const AppSettingsPage())),
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
        Card(child: ListTile(leading: const Icon(Icons.payments, color: Colors.tealAccent), title: Text('Points: ${AppState.points.toStringAsFixed(2)}'), subtitle: const Text('Host Share: 70% • Agency: 12%-16%'))),
        const Card(child: ListTile(leading: Icon(Icons.timer, color: Colors.amber), title: Text('Live Room Duration'), subtitle: Text('0h 45m Active Today'))),
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
  static final Set<String> _localUsedRefs = <String>{};

  final Map<String, String> _acc = {
    'Telebirr': '+251919108311',
    'CBEBirr': '+251919108311',
    'CBE': '1000273060937',
    'Awash Bank': '014251157710000',
    'Dashen Bank': '2952945930711',
    'USDT (TRC20)': 'TVdr3JdbDZhXjfSGsUB9azNAnTbkHbUNcE',
  };

  Future<void> _verify() async {
    final ref = _tx.text.trim();
    final uid = _targetId.text.trim();
    if (!_idConfirmed || uid.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter User ID & tap Confirm first!'))); return; }
    if (_bank == 'USDT (TRC20)' && _coins < 50000) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Min 50,000 Coins for USDT!'))); return; }
    if (_coins < 10000 || ref.length < 5) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Min 10,000 Coins & Valid Ref required!'))); return; }
    setState(() => _verifying = true);
    try {
      final res = await JimmaApiService.verifyShegerPay(userId: uid, referenceId: ref, provider: _bank.toLowerCase(), coinsToAdd: _coins).timeout(const Duration(seconds: 8));
      if (res['success'] == true) {
        if (uid == AppState.userId) { AppState.coins = res['newBalance'] ?? (AppState.coins + _coins); }
        setState(() { _tx.clear(); _verifying = false; });
        widget.onUpd();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('✅ Recharged $_coins Coins to ID: $uid!')));
        return;
      }
      if (res['error'] != null) {
        setState(() => _verifying = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text(res['error'].toString())));
        return;
      }
    } catch (_) {}

    final validRef = RegExp(r'^[A-Za-z0-9]{8,64}$').hasMatch(ref);
    if (validRef && !_localUsedRefs.contains(ref.toUpperCase())) {
      _localUsedRefs.add(ref.toUpperCase());
      if (uid == AppState.userId) { AppState.coins += _coins; }
      setState(() { _tx.clear(); _verifying = false; });
      widget.onUpd();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('✅ Recharged $_coins Coins to ID: $uid!')));
      return;
    }
    setState(() => _verifying = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('Invalid or already used Transaction ID!')));
  }
    @override
  Widget build(BuildContext context) {
    final price = _bank == 'USDT (TRC20)' ? '\$${(_coins / 10000).toStringAsFixed(1)} USDT' : '${((_coins / 10000) * (_isSeller ? 150 : 180)).toStringAsFixed(0)} ETB';
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: const Text('Recharge & ID Trade'), bottom: TabBar(tabs: List<Widget>.of({const Tab(text: 'Recharge'), const Tab(text: 'ID Transfer')}))),
        body: TabBarView(children: List<Widget>.of({
          ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
            const Text('User ID', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
            Row(children: List<Widget>.of({
              Expanded(child: TextField(controller: _targetId, decoration: const InputDecoration(hintText: 'User ID'), onChanged: (_) => setState(() => _idConfirmed = false))),
              const SizedBox(width: 8),
              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _idConfirmed ? Colors.green : Colors.tealAccent, foregroundColor: Colors.black), onPressed: () => setState(() => _idConfirmed = _targetId.text.trim().isNotEmpty), child: Text(_idConfirmed ? 'Confirmed' : 'Confirm')),
            })),
            SwitchListTile(title: const Text('Bulk Coin Seller (20% Off)'), subtitle: const Text('Seller: 150 ETB/10k | User: 180 ETB/10k'), value: _isSeller, onChanged: (v) => setState(() => _isSeller = v)),
            DropdownButtonFormField<String>(value: _bank, items: _acc.keys.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(), onChanged: (v) => setState(() { _bank = v ?? 'Telebirr'; if (_bank == 'USDT (TRC20)' && _coins < 50000) { _coins = 50000; _custom.text = '50000'; } })),
            TextField(controller: _custom, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Any Coins Amount (Min 10,000)'), onChanged: (v) => setState(() => _coins = int.tryParse(v) ?? 10000)),
            Card(child: ListTile(title: Text('$_bank • Pay: $price', style: const TextStyle(color: Colors.amber)), subtitle: Text(_acc[_bank] ?? ''), trailing: IconButton(icon: const Icon(Icons.copy), onPressed: () { Clipboard.setData(ClipboardData(text: _acc[_bank] ?? '')); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied!'))); }))),
            TextField(controller: _tx, decoration: const InputDecoration(labelText: 'Transaction ID / Ref')),
            const SizedBox(height: 10),
            ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 48)), onPressed: _verifying ? null : _verify, child: Text(_verifying ? 'Verifying...' : 'Recharge $_coins Coins ($price)')),
          })),
          ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
            Card(child: ListTile(title: Text('Balance: 🪙 ${AppState.coins} Coins'))),
            TextField(controller: _to, decoration: const InputDecoration(labelText: 'Recipient User ID')),
            TextField(controller: _amt, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount (in 1000s, e.g. 10 = 10,000)')),
            ElevatedButton(onPressed: () {
              final k = (int.tryParse(_amt.text) ?? 0) * 1000;
              if (k >= 1000 && AppState.coins >= k && _to.text.isNotEmpty) { AppState.coins -= k; widget.onUpd(); setState(() {}); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✅ Sent $k Coins to ${_to.text}!'))); }
            }, child: const Text('Send Coins')),
          })),
        })),
      ),
    );
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
    final p = double.tryParse(_pts.text) ?? 0;
    final payout = _method == 'USDT (TRC20)' ? '\$${(p / 10000).toStringAsFixed(2)} USDT' : '${((p / 10000) * 140).toStringAsFixed(0)} ETB';
    return Scaffold(
      appBar: AppBar(title: const Text('Points Cash Out')),
      body: ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
        Card(child: ListTile(title: Text('Available Points: 💎 ${AppState.points.toStringAsFixed(2)}'), subtitle: const Text('10,000 Pts = 140 ETB or \$1.00 USDT'))),
        DropdownButtonFormField<String>(value: _method, items: List<String>.of({'Telebirr', 'CBEBirr', 'CBE', 'Awash Bank', 'Dashen Bank', 'USDT (TRC20)'}).map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(), onChanged: (v) => setState(() => _method = v ?? 'Telebirr')),
        TextField(controller: _pts, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Points to Withdraw (Min 100,000)'), onChanged: (_) => setState(() {})),
        TextField(controller: _acc, decoration: InputDecoration(labelText: _method == 'USDT (TRC20)' ? 'TRC20 Wallet Address' : 'Phone or Account Number')),
        const SizedBox(height: 12),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 48)), onPressed: () {
          if (p >= 100000 && AppState.points >= p && _acc.text.isNotEmpty) {
            setState(() => AppState.points -= p);
            widget.onUpd();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('✅ Cash Out ($payout) Submitted!')));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Min 100,000 Points & Account required!')));
          }
        }, child: Text('Withdraw $payout')),
      })),
    );
  }
}

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings & Policies')),
      body: ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
        const ListTile(leading: Icon(Icons.language, color: Colors.amber), title: Text('Language'), subtitle: Text('English / Afaan Oromoo / አማርኛ')),
        const ListTile(leading: Icon(Icons.security, color: Colors.tealAccent), title: Text('Privacy Policy & Child Safety'), subtitle: Text('18+ Only • Zero Tolerance for Abuse')),
        const ListTile(leading: Icon(Icons.gavel, color: Colors.orange), title: Text('Terms & Policies'), subtitle: Text('Min Cash Out: 100,000 Pts • Support: +251919108311')),
      })),
    );
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
    {'lv': 10, 'name': 'VIP 10 • Oromo Prince', 'price': 25000, 'perk': 'Royal Horse Entry + Mic Ring'},
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
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Colors.amber, child: Text('V$lv', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
              title: Text(v['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${v['perk']} • 🪙 $price'),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: active ? Colors.green : Colors.amber, foregroundColor: Colors.black),
                onPressed: active ? null : () {
                  if (AppState.coins >= price) { setState(() { AppState.coins -= price; AppState.vipLevel = lv; }); widget.onUpd(); }
                  else { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not enough Coins!'))); }
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

class StorePage extends StatefulWidget {
  final VoidCallback onUpd;
  const StorePage({super.key, required this.onUpd});
  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final _items = List<Map<String, dynamic>>.of({
    {'name': '🦈 Shark Moto Entry', 'price': 300000, 'tag': 'NEW'},
    {'name': '🐉 Ice-Fire Soul Ride', 'price': 400000, 'tag': 'NEW'},
    {'name': '👑 Star of Fortune Frame', 'price': 30000, 'tag': 'NEW'},
    {'name': '🍀 Lucky Bless Frame', 'price': 30000, 'tag': 'NEW'},
    {'name': '🏰 Abba Jifar Palace Theme', 'price': 4200, 'tag': 'ROYAL'},
    {'name': '☕ Jebena Gold ChatBubble', 'price': 10000, 'tag': 'VIP'},
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Store • 🪙 ${AppState.coins}')),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.92),
        itemCount: _items.length,
        itemBuilder: (_, i) {
          final it = _items.elementAt(i);
          final price = it['price'] as int;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List<Widget>.of({
                Chip(label: Text(it['tag'] as String, style: const TextStyle(fontSize: 10))),
                Text(it['name'] as String, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('🪙 $price', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 36)),
                  onPressed: () {
                    if (AppState.coins >= price) { setState(() => AppState.coins -= price); widget.onUpd(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Equipped ${it['name']}!'))); }
                    else { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not enough Coins!'))); }
                  },
                  child: const Text('Buy & Equip', style: TextStyle(fontSize: 12)),
                ),
              })),
            ),
          );
        },
      ),
    );
  }
}
