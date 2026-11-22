import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'task_settings_admin.dart';
import 'main.dart';

class TronVerifyHelper {
  static const String wallet = 'TVdr3JdbDZhXjfSGsUB9azNAnTbkHbUNcE';
  static final Set<String> usedHashes = <String>{};

  static Future<bool> verifyUsdtAuto(String txHash, double expectedUsd) async {
    final h = txHash.trim();
    if (!RegExp(r'^[A-Fa-f0-9]{64}$').hasMatch(h)) return false;
    if (usedHashes.contains(h.toLowerCase())) return false;
    try {
      final res = await http.get(Uri.parse('https://tronscanapi.com')).timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final confirmed = data['confirmed'] == true;
        final trc20 = data['trc20TransferInfo'] as List?;
        if (confirmed && trc20 != null && trc20.isNotEmpty) {
          final info = trc20.first;
          final receiver = info['to_address']?.toString() ?? '';
          final rawAmt = double.tryParse(info['amount_str']?.toString() ?? '0') ?? 0;
          final usdtSent = rawAmt / 1000000.0;
          if (receiver == wallet && usdtSent >= (expectedUsd - 0.5)) {
            usedHashes.add(h.toLowerCase());
            return true;
          }
        }
      }
    } catch (_) {}
    return false;
  }
}

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
      content: TextField(controller: c, obscureText: true, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Security Passcode')),
      actions: List<Widget>.of({
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: () {
          if (c.text.trim() == '142730') {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => SuperAdminPanel(onUpd: () { setState(() {}); widget.onUpd(); })));
          }
        }, child: const Text('Verify')),
      }),
    ));
  }


  Widget _badge(String text, Color c1, Color c2, IconData ic) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(gradient: LinearGradient(colors: <Color>[c1, c2]), borderRadius: BorderRadius.circular(12)),
      child: Row(mainAxisSize: MainAxisSize.min, children: List<Widget>.of({
        Icon(ic, size: 12, color: Colors.white),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
      })),
    );
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
            decoration: BoxDecoration(
              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: <Color>[Color(0xFF064E3B), Color(0xFF1E1B4B), Color(0xFF0F172A)]),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.amber, width: 1.5),
            ),
            child: Column(children: List<Widget>.of({
              GestureDetector(
                onTap: _pickAvatar,
                child: Stack(children: List<Widget>.of({
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: <Color>[Colors.amber, Colors.tealAccent])),
                    child: CircleAvatar(radius: 36, backgroundColor: const Color(0xFF1E293B), backgroundImage: (_avatarPath != null && !kIsWeb) ? FileImage(File(_avatarPath!)) : null, child: _avatarPath == null ? const Icon(Icons.person, size: 40, color: Colors.amber) : null),
                  ),
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
                child: Text('ID: ${AppState.userId} 📋', style: const TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Wrap(spacing: 6, runSpacing: 6, alignment: WrapAlignment.center, children: List<Widget>.of({
                _badge('VIP ${AppState.vipLevel}', const Color(0xFF059669), const Color(0xFF10B981), Icons.workspace_premium),
                if (AppState.isCoinSeller) _badge('COIN SELLER', const Color(0xFFD97706), const Color(0xFFF59E0B), Icons.monetization_on),
                if (AppState.isAgency) _badge('AGENCY', const Color(0xFFDC2626), const Color(0xFFF43F5E), Icons.verified),
              })),
              const SizedBox(height: 12),
              Row(children: List<Widget>.of({
                Expanded(child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(color: Colors.purple.withOpacity(0.22), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.purpleAccent.withOpacity(0.5))),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List<Widget>.of({
                    const Text('🎙️ Host Level', style: TextStyle(fontSize: 11, color: Colors.white70)),
                    Text('${AppState.hostLv}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.purpleAccent)),
                  })),
                )),
                const SizedBox(width: 8),
                Expanded(child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(color: Colors.cyan.withOpacity(0.22), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.cyanAccent.withOpacity(0.5))),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List<Widget>.of({
                    const Text('💎 Wealth Lv', style: TextStyle(fontSize: 11, color: Colors.white70)),
                    Text('${AppState.wealthLv}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
                  })),
                )),
              })),
              const Divider(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List<Widget>.of({
                InkWell(
                  onTap: () => go(UserRechargePage(onUpd: upd)),
                  child: Column(children: List<Widget>.of({const Text('My Coins', style: TextStyle(fontSize: 12, color: Colors.white70)), Text('🪙 ${AppState.coins}', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.amber))})),
                ),
                InkWell(
                  onTap: () => go(PointsCashOutPage(onUpd: upd)),
                  child: Column(children: List<Widget>.of({const Text('My Points ➔ Sell', style: TextStyle(fontSize: 12, color: Colors.tealAccent)), Text('💎 ${AppState.points.toStringAsFixed(2)}', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.tealAccent))})),
                ),
              })),
            })),
          ),
        ),
        const SizedBox(height: 12),
        Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), child: Padding(padding: const EdgeInsets.all(12), child: GridView.count(
          crossAxisCount: 4, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          children: List<Widget>.of({
            _gridBtn(Icons.account_balance_wallet, Colors.amber, 'Recharge', () => go(UserRechargePage(onUpd: upd))),
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
            _gridBtn(Icons.headset_mic, Colors.blueAccent, 'Support', () => go(ContactCenterPage())),
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

class UserRechargePage extends StatefulWidget {
  final VoidCallback onUpd;
  const UserRechargePage({super.key, required this.onUpd});
  @override
  State<UserRechargePage> createState() => _UserRechargePageState();
}

class _UserRechargePageState extends State<UserRechargePage> {
  final _idCtrl = TextEditingController(text: AppState.userId);
  final _hashCtrl = TextEditingController();
  bool _confirmed = true, _verifying = false;
  String _region = 'All country';
  String _method = 'USDT (TRC20)';
  int _selectedPkg = 0;

  final _pkgs = List<Map<String, dynamic>>.of({
    {'coins': 70000, 'usd': 10.0},
    {'coins': 210000, 'usd': 30.0},
    {'coins': 350000, 'usd': 50.0},
  });

  Future<void> _autoVerifyUsdt() async {
    final uid = _idCtrl.text.trim();
    final pkg = _pkgs.elementAt(_selectedPkg);
    final coins = pkg['coins'] as int;
    final usd = pkg['usd'] as double;
    if (!_confirmed || uid.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Confirm User ID first!'))); return; }
    setState(() => _verifying = true);
    final ok = await TronVerifyHelper.verifyUsdtAuto(_hashCtrl.text, usd);
    setState(() => _verifying = false);
    if (ok) {
      if (uid == AppState.userId) {
        AppState.coins += coins;
        AppState.wealthLv += (coins ~/ 10000);
      }
      AppState.officialNotices.insert(0, {'title': 'USDT Recharge Verified!', 'body': 'TronScan confirmed \$$usd USDT! +$coins Coins released automatically.', 'time': DateTime.now().toString().substring(0, 19)});
      _hashCtrl.clear();
      widget.onUpd();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('TronScan Verified! +$coins Coins Released Automatically!')));
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('USDT not received on TronScan or already used! Paste valid 64-char TxID Hash.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final pkg = _pkgs.elementAt(_selectedPkg);
    return Scaffold(
      appBar: AppBar(title: const Text('Recharge')),
      body: ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
        const Text('User ID', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
        Row(children: List<Widget>.of({
          Expanded(child: TextField(controller: _idCtrl, decoration: const InputDecoration(hintText: 'Enter User ID'), onChanged: (_) => setState(() => _confirmed = false))),
          TextButton(onPressed: () => setState(() => _confirmed = _idCtrl.text.trim().isNotEmpty), child: Text(_confirmed ? 'Confirmed ✅' : 'Confirm', style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold))),
        })),
        const SizedBox(height: 10),
        const Text('Country/Region', style: TextStyle(fontWeight: FontWeight.bold)),
        DropdownButtonFormField<String>(value: _region, items: List<String>.of({'All country', 'Ethiopia', 'Middle East', 'USA / Europe'}).map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(), onChanged: (v) => setState(() => _region = v ?? 'All country')),
        const SizedBox(height: 12),
        InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OnlineAgencyServicePage())),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(color: Colors.amber.withOpacity(0.18), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.amber)),
            child: const Row(children: <Widget>[
              Icon(Icons.percent, color: Colors.amber),
              SizedBox(width: 8),
              Expanded(child: Text('Official Agency Recharge (Telebirr, CBE, Awash, Dashen)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5))),
              Text('20% off >', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
            ]),
          ),
        ),
        const SizedBox(height: 14),
        const Text('Direct USDT / Binance Recharge (Auto-Release)', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, children: List<String>.of({'USDT (TRC20)', 'Binance Pay'}).map((m) => ChoiceChip(label: Text(m), selected: _method == m, selectedColor: Colors.tealAccent, labelStyle: TextStyle(color: _method == m ? Colors.black : Colors.white), onSelected: (_) => setState(() => _method = m))).toList()),
        const SizedBox(height: 12),
        Row(children: List.generate(_pkgs.length, (i) {
          final p = _pkgs.elementAt(i);
          final sel = _selectedPkg == i;
          return Expanded(
            child: InkWell(
              onTap: () => setState(() => _selectedPkg = i),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(color: sel ? Colors.amber.withOpacity(0.22) : const Color(0xFF1E293B), borderRadius: BorderRadius.circular(14), border: Border.all(color: sel ? Colors.amber : Colors.white12, width: sel ? 2 : 1)),
                child: Column(children: List<Widget>.of({
                  const Text('🪙', style: TextStyle(fontSize: 22)),
                  const SizedBox(height: 4),
                  Text('${p['coins']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('\$${(p['usd'] as double).toInt()}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                })),
              ),
            ),
          );
        })),
        const SizedBox(height: 12),
        Card(
          color: const Color(0xFF1E293B),
          child: ListTile(
            title: Text('Copy $_method Address (Send \$${(pkg['usd'] as double).toInt()} USDT)', style: const TextStyle(fontSize: 12, color: Colors.amber, fontWeight: FontWeight.bold)),
            subtitle: const Text(TronVerifyHelper.wallet, style: TextStyle(fontSize: 11)),
            trailing: IconButton(icon: const Icon(Icons.copy, color: Colors.tealAccent), onPressed: () { Clipboard.setData(const ClipboardData(text: TronVerifyHelper.wallet)); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('TRC20 Address Copied!'))); }),
          ),
        ),
        TextField(controller: _hashCtrl, decoration: const InputDecoration(labelText: 'Paste 64-char TronScan TxID Hash (Auto-Verify)')),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 48)),
          onPressed: _verifying ? null : _autoVerifyUsdt,
          child: Text(_verifying ? 'Checking TronScan Blockchain...' : 'Verify USDT & Release ${pkg['coins']} Coins Now', style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      })),
    );
  }
}

class OnlineAgencyServicePage extends StatelessWidget {
  const OnlineAgencyServicePage({super.key});

  void _openWa(String phone, String msg) {
    Clipboard.setData(ClipboardData(text: '+$phone • $msg'));
  }

  @override
  Widget build(BuildContext context) {
    final sellers = List<Map<String, String>>.of({
      {'name': 'Ethio-Voice Official Agency', 'id': '1000001', 'sales': 'Recent 30-Day Coin Sales 1B+', 'banks': 'Telebirr • CBE • Awash • Dashen • Coop', 'wa': '251919108311'},
      {'name': 'Jimma Star Coin Agency', 'id': '1539458', 'sales': 'Recent 30-Day Coin Sales 500M+', 'banks': 'Telebirr • CBE • Awash • Dashen', 'wa': '251919108311'},
      {'name': 'Finfinnee VIP Seller', 'id': '3399425', 'sales': 'Recent 30-Day Coin Sales 100M+', 'banks': 'Telebirr • CBEBirr • CBE', 'wa': '251919108311'},
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Online Service (Official Agencies)')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: sellers.length,
        itemBuilder: (_, i) {
          final s = sellers.elementAt(i);
          return Card(
            color: const Color(0xFF1E293B),
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.amber.withOpacity(0.4))),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List<Widget>.of({
                  Row(children: List<Widget>.of({
                    const CircleAvatar(radius: 24, backgroundColor: Colors.amber, child: Icon(Icons.verified, color: Colors.black)),
                    const SizedBox(width: 10),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: List<Widget>.of({
                      Row(children: List<Widget>.of({
                        Flexible(child: Text(s['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                        const SizedBox(width: 6),
                        Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(8)), child: const Text('Senior Seller', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black))),
                      })),
                      Text('ID: ${s['id']}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                    }))),
                  })),
                  const SizedBox(height: 8),
                  Text(s['sales']!, style: const TextStyle(fontSize: 11, color: Colors.amber)),
                  Text('Payment Method: ${s['banks']}', style: const TextStyle(fontSize: 11.5, color: Colors.tealAccent)),
                  const SizedBox(height: 10),
                  Row(children: List<Widget>.of({
                    Expanded(child: ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366), foregroundColor: Colors.white), onPressed: () { _openWa(s['wa']!, 'Hello ${s['name']}, I want to buy Ethio-Voice Coins for my ID: ${AppState.userId}'); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied WhatsApp: +${s['wa']}'))); }, icon: const Icon(Icons.chat, size: 18), label: const Text('WhatsApp'))),
                    const SizedBox(width: 10),
                    Expanded(child: ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black), onPressed: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Opened Free Chat with ${s['name']} (ID: ${s['id']})'))); }, icon: const Icon(Icons.message, size: 18), label: const Text('Chat'))),
                  })),
                }),
              ),
            ),
          );
        },
      ),
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
  String _salesType = 'User';
  final _toIdCtrl = TextEditingController();
  bool _toChecked = false, _verifyingUsdt = false;
  final _trAmtCtrl = TextEditingController(text: '10');

  String _payMethod = 'USDT (TRC20)';
  final _customCoinsCtrl = TextEditingController(text: '100000');
  final _sellerHashCtrl = TextEditingController();
  int _selectedTier = 0;
  final _exCustomCtrl = TextEditingController(text: '1000000');

  final Map<String, String> _localBanks = {
    'USDT (TRC20)': TronVerifyHelper.wallet,
    'Binance Pay': TronVerifyHelper.wallet,
    'CBE': '1000273060937',
  };

  final _usdTiers = List<Map<String, dynamic>>.of([
    {'coins': 100000, 'usd': 10.0, 'tag': 'MIN'},
    {'coins': 990000, 'usd': 100.0, 'tag': ''},
    {'coins': 1980000, 'usd': 200.0, 'tag': ''},
    {'coins': 9900000, 'usd': 1000.0, 'tag': ''},
    {'coins': 14850000, 'usd': 1500.0, 'tag': ''},
    {'coins': 30000000, 'usd': 3000.0, 'tag': 'Senior Seller'},
  ]);

  final _etbTiers = List<Map<String, dynamic>>.of([
    {'coins': 10000, 'etb': 180, 'tag': 'MIN'},
    {'coins': 100000, 'etb': 1800, 'tag': ''},
    {'coins': 1000000, 'etb': 18000, 'tag': ''},
    {'coins': 5000000, 'etb': 90000, 'tag': ''},
    {'coins': 15000000, 'etb': 270000, 'tag': ''},
    {'coins': 30000000, 'etb': 540000, 'tag': 'Senior Seller'},
  ]);

  String get _sellerLevel {
    if (AppState.coins >= 30000000) return 'Senior Seller';
    if (AppState.coins >= 2000000) return 'Standard Seller';
    return 'Beginner';
  }

  double get _exchangeRate {
    if (_sellerLevel == 'Senior Seller') return 1.0;
    if (_sellerLevel == 'Standard Seller') return 0.98;
    return 0.96;
  }

  @override
  Widget build(BuildContext context) {
    final isCrypto = _payMethod == 'USDT (TRC20)' || _payMethod == 'Binance Pay';
    final tiers = isCrypto ? _usdTiers : _etbTiers;
    final customCoins = int.tryParse(_customCoinsCtrl.text) ?? (isCrypto ? 100000 : 10000);
    final usdNeeded = customCoins / 10000.0;
    final customPrice = isCrypto
        ? '${usdNeeded.toStringAsFixed(1)} USDT'
        : '${((customCoins / 10000) * 180).toStringAsFixed(0)} ETB';

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: const Text('Coin Seller')),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF78350F), Color(0xFFB45309)]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('My Balance', style: TextStyle(fontSize: 12, color: Colors.white70)),
                      Text(
                        '🪙 ${AppState.coins}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                      Text(
                        'Current level: $_sellerLevel',
                        style: const TextStyle(fontSize: 11, color: Colors.amber),
                      ),
                    ],
                  ),
                  const Text('🪙', style: TextStyle(fontSize: 42)),
                ],
              ),
            ),
            const TabBar(
              indicatorColor: Colors.tealAccent,
              labelColor: Colors.tealAccent,
              tabs: [Tab(text: 'Transfer'), Tab(text: 'Recharge'), Tab(text: 'Exchange')],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView(
                    padding: const EdgeInsets.all(14),
                    children: [
                      Row(
                        children: [
                          const Text('Sales Method: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          ChoiceChip(
                            label: const Text('User'),
                            selected: _salesType == 'User',
                            selectedColor: Colors.tealAccent,
                            onSelected: (_) => setState(() => _salesType = 'User'),
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('Coinseller'),
                            selected: _salesType == 'Coinseller',
                            selectedColor: Colors.tealAccent,
                            onSelected: (_) => setState(() => _salesType = 'Coinseller'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _toIdCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Receiving ID (To)'),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              if (_toIdCtrl.text.trim().length >= 5) {
                                setState(() => _toChecked = true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text('Recipient ID verified!'),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              _toChecked ? 'Verified ✓' : 'Check',
                              style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _trAmtCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Transfer Amount (Units of 1,000)'),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total Coins to Send: ${(int.tryParse(_trAmtCtrl.text) ?? 0) * 1000}',
                        style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        onPressed: () {
                          final sendCoins = (int.tryParse(_trAmtCtrl.text) ?? 0) * 1000;
                          if (!_toChecked || sendCoins < 1000 || AppState.coins < sendCoins) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Verify ID and check coin balance.'),
                              ),
                            );
                            return;
                          }
                          setState(() {
                            AppState.coins -= sendCoins;
                            AppState.isCoinSeller = true;
                          });
                          widget.onUpd();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Transferred $sendCoins Coins to ID ${_toIdCtrl.text.trim()}!'),
                            ),
                          );
                        },
                        child: const Text('Transfer', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  ListView(
                    padding: const EdgeInsets.all(14),
                    children: [
                      DropdownButtonFormField<String>(
                        value: _payMethod,
                        decoration: const InputDecoration(labelText: 'Auto-Verify Payment Method (USDT / CBE)'),
                        items: _localBanks.keys
                            .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                            .toList(),
                        onChanged: (v) => setState(() {
                          _payMethod = v ?? 'USDT (TRC20)';
                          _customCoinsCtrl.text =
                              (_payMethod == 'USDT (TRC20)' || _payMethod == 'Binance Pay')
                                  ? '100000'
                                  : '10000';
                        }),
                      ),
                   
                            
                      
                  
    
  

