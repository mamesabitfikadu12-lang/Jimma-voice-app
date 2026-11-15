import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
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
          if (c.text.trim() == '2730') {
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
  String? _sellerProof;
  final _picker = ImagePicker();
  final _exCustomCtrl = TextEditingController(text: '1000000');

  final Map<String, String> _localBanks = {
    'USDT (TRC20)': TronVerifyHelper.wallet,
    'Binance Pay': TronVerifyHelper.wallet,
    'Telebirr': '+251919108311',
    'CBEBirr': '+251919108311',
    'CBE': '1000273060937',
    'Awash Bank': '014251157710000',
    'Dashen Bank': '2952945930711',
  };

  final _usdTiers = List<Map<String, dynamic>>.of({
    {'coins': 100000, 'usd': 10.0, 'tag': 'MIN'},
    {'coins': 990000, 'usd': 100.0, 'tag': ''},
    {'coins': 1980000, 'usd': 200.0, 'tag': ''},
    {'coins': 9900000, 'usd': 1000.0, 'tag': ''},
    {'coins': 14850000, 'usd': 1500.0, 'tag': ''},
    {'coins': 30000000, 'usd': 3000.0, 'tag': 'Senior Seller'},
  });

  final _etbTiers = List<Map<String, dynamic>>.of({
    {'coins': 10000, 'etb': 180, 'tag': 'MIN'},
    {'coins': 100000, 'etb': 1800, 'tag': ''},
    {'coins': 1000000, 'etb': 18000, 'tag': ''},
    {'coins': 5000000, 'etb': 90000, 'tag': ''},
    {'coins': 15000000, 'etb': 270000, 'tag': ''},
    {'coins': 30000000, 'etb': 540000, 'tag': 'Senior Seller'},
  });

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
    final customPrice = isCrypto ? '\$${usdNeeded.toStringAsFixed(1)} USDT' : '${((customCoins / 10000) * 180).toStringAsFixed(0)} ETB';

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: const Text('Coin Seller')),
        body: Column(children: List<Widget>.of({
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: <Color>[Color(0xFF78350F), Color(0xFFB45309)]), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.amber)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List<Widget>.of({
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: List<Widget>.of({
                const Text('My Balance', style: TextStyle(fontSize: 12, color: Colors.white70)),
                Text('🪙 ${AppState.coins}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
                Text('Current level: $_sellerLevel', style: const TextStyle(fontSize: 11, color: Colors.amber)),
              })),
              const Text('🪙', style: TextStyle(fontSize: 42)),
            })),
          ),
          const TabBar(
            indicatorColor: Colors.tealAccent,
            labelColor: Colors.tealAccent,
            tabs: <Tab>[Tab(text: 'Transfer'), Tab(text: 'Recharge'), Tab(text: 'Exchange')],
          ),
          Expanded(
            child: TabBarView(children: List<Widget>.of({
              ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
                Row(children: List<Widget>.of({
                  const Text('Sales Method: ', style: TextStyle(fontWeight: FontWeight.bold)),
                  ChoiceChip(label: const Text('User'), selected: _salesType == 'User', selectedColor: Colors.tealAccent, labelStyle: TextStyle(color: _salesType == 'User' ? Colors.black : Colors.white), onSelected: (_) => setState(() => _salesType = 'User')),
                  const SizedBox(width: 8),
                  ChoiceChip(label: const Text('Coinseller'), selected: _salesType == 'Coinseller', selectedColor: Colors.tealAccent, labelStyle: TextStyle(color: _salesType == 'Coinseller' ? Colors.black : Colors.white), onSelected: (_) => setState(() => _salesType = 'Coinseller')),
                })),
                const SizedBox(height: 10),
                Row(children: List<Widget>.of({
                  Expanded(child: TextField(controller: _toIdCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Recipient User ID'), onChanged: (_) => setState(() => _toChecked = false))),
                  TextButton(onPressed: () {
                    if (_toIdCtrl.text.trim().length >= 5) {
                      setState(() => _toChecked = true);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('Verified $_salesType ID: ${_toIdCtrl.text.trim()}')));
                    }
                  }, child: Text(_toChecked ? 'Verified ✅' : 'Check', style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold))),
                })),
                TextField(controller: _trAmtCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Coin Amount (x1,000 Coins, e.g. 10 = 10,000)'), onChanged: (_) => setState(() {})),
                const SizedBox(height: 6),
                Text('Total Coins to Send: 🪙 ${(int.tryParse(_trAmtCtrl.text) ?? 0) * 1000}', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 48)), onPressed: () {
                  final sendCoins = (int.tryParse(_trAmtCtrl.text) ?? 0) * 1000;
                  if (!_toChecked || sendCoins < 1000 || AppState.coins < sendCoins) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('Verify ID & check your Coin balance!')));
                    return;
                  }
                  setState(() { AppState.coins -= sendCoins; AppState.isCoinSeller = true; });
                  widget.onUpd();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('Transferred $sendCoins Coins to $_salesType (${_toIdCtrl.text})!')));
                }, child: const Text('Transfer', style: TextStyle(fontWeight: FontWeight.bold))),
              })),

              ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
                DropdownButtonFormField<String>(
                  value: _payMethod,
                  decoration: const InputDecoration(labelText: 'Payment Method (USDT Auto or ETB Screenshot)'),
                  items: _localBanks.keys.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                  onChanged: (v) => setState(() {
                    _payMethod = v ?? 'USDT (TRC20)';
                    _customCoinsCtrl.text = (_payMethod == 'USDT (TRC20)' || _payMethod == 'Binance Pay') ? '100000' : '10000';
                  }),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tiers.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 2.1),
                  itemBuilder: (_, i) {
                    final t = tiers.elementAt(i);
                    final sel = _selectedTier == i;
                    final priceLabel = isCrypto ? '\$${(t['usd'] as double).toInt()}' : '${t['etb']} ETB';
                    return InkWell(
                      onTap: () => setState(() { _selectedTier = i; _customCoinsCtrl.text = '${t['coins']}'; }),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: sel ? Colors.amber.withOpacity(0.22) : const Color(0xFF1E293B), borderRadius: BorderRadius.circular(12), border: Border.all(color: sel ? Colors.amber : Colors.white12, width: sel ? 2 : 1)),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: List<Widget>.of({
                          if ((t['tag'] as String).isNotEmpty) Text(t['tag'] as String, style: const TextStyle(fontSize: 9, color: Colors.amber, fontWeight: FontWeight.bold)),
                          Text('🪙 ${t['coins']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text(priceLabel, style: const TextStyle(color: Colors.tealAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                        })),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _customCoinsCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: isCrypto ? 'Custom Coins (Min 100,000 = \$10)' : 'Custom Coins (Min 10,000 = 180 ETB)'),
                  onChanged: (_) => setState(() {}),
                ),
                Card(
                  color: const Color(0xFF1E293B),
                  child: ListTile(
                    title: Text('$_payMethod • Pay: $customPrice', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text(_localBanks[_payMethod] ?? '', style: const TextStyle(fontSize: 11.5)),
                    trailing: IconButton(icon: const Icon(Icons.copy, color: Colors.tealAccent), onPressed: () { Clipboard.setData(ClipboardData(text: _localBanks[_payMethod] ?? '')); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account / Address Copied!'))); }),
                  ),
                ),
                if (isCrypto) ...<Widget>[
                  TextField(controller: _sellerHashCtrl, decoration: const InputDecoration(labelText: 'TronScan 64-char TxID Hash (Instant Auto-Release)')),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 48)),
                    onPressed: _verifyingUsdt ? null : () async {
                      if (customCoins < 100000) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Min 100,000 Coins (\$10) required!'))); return; }
                      setState(() => _verifyingUsdt = true);
                      final ok = await TronVerifyHelper.verifyUsdtAuto(_sellerHashCtrl.text, usdNeeded);
                      setState(() => _verifyingUsdt = false);
                      if (ok) {
                        setState(() { AppState.coins += customCoins; AppState.isCoinSeller = true; _sellerHashCtrl.clear(); });
                        widget.onUpd();
                        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('TronScan Confirmed! +$customCoins Coins Released Automatically!')));
                      } else {
                        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('USDT not found on TronScan or already used!')));
                      }
                    },
                    child: Text(_verifyingUsdt ? 'Verifying on TronScan...' : 'Auto-Verify USDT & Release $customCoins Coins', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ] else ...<Widget>[
                  OutlinedButton.icon(
                    onPressed: () async {
                      final XFile? f = await _picker.pickImage(source: ImageSource.gallery);
                      if (f != null) setState(() => _sellerProof = f.path);
                    },
                    icon: const Icon(Icons.upload_file, color: Colors.amber),
                    label: Text(_sellerProof == null ? 'Upload ETB Bank Screenshot (Required)' : 'Screenshot Attached ✅'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 48)),
                    onPressed: () {
                      if (customCoins < 10000 || _sellerProof == null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('Min 10,000 Coins (180 ETB) & Bank Screenshot required!')));
                        return;
                      }
                      AppState.pendingRecharges.insert(0, {
                        'uid': AppState.userId,
                        'name': '${AppState.userName} (Agency/Seller)',
                        'coins': '$customCoins',
                        'paid': '$customPrice ($_payMethod)',
                        'proof': _sellerProof!,
                        'time': DateTime.now().toString().substring(0, 19),
                      });
                      setState(() { _sellerProof = null; AppState.isCoinSeller = true; });
                      widget.onUpd();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('ETB Receipt sent! Admin will confirm receipt & release Coins.')));
                    },
                    child: Text('Submit ETB Screenshot ($customCoins Coins • $customPrice)', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              })),

              ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
                Text('My Points: 💎 ${AppState.points.toStringAsFixed(3)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.tealAccent)),
                const SizedBox(height: 10),
                TextField(controller: _exCustomCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Custom Points to Exchange (Min 10,000)'), onChanged: (_) => setState(() {})),
                const SizedBox(height: 10),
                ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 46)), onPressed: () {
                  final pts = double.tryParse(_exCustomCtrl.text) ?? 0;
                  if (pts >= 10000 && AppState.points >= pts) {
                    final coinsOut = (pts * _exchangeRate).toInt();
                    setState(() { AppState.points -= pts; AppState.coins += coinsOut; AppState.isCoinSeller = true; });
                    widget.onUpd();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('Exchanged ${pts.toInt()} Points -> $coinsOut Coins!')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Min 10,000 Points required!')));
                  }
                }, child: const Text('Exchange', style: TextStyle(fontWeight: FontWeight.bold))),
                const SizedBox(height: 16),
                Card(
                  color: const Color(0xFF1E293B),
                  child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const <Widget>[
                    Text('Exchange Rules', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.amber)),
                    Divider(),
                    Text('• Beginner: 💎 10,000 = 🪙 9,600 (Single recharge < 2M)', style: TextStyle(fontSize: 12)),
                    SizedBox(height: 4),
                    Text('• Standard: 💎 10,000 = 🪙 9,800 (Single recharge ≥ 2,000,000)', style: TextStyle(fontSize: 12)),
                    SizedBox(height: 4),
                    Text('• Senior: 💎 10,000 = 🪙 10,000 (Single recharge ≥ 30,000,000)', style: TextStyle(fontSize: 12, color: Colors.tealAccent)),
                  ])),
                ),
              })),
            })),
          ),
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
  final _exPts = TextEditingController(text: '10000');
  final _agId = TextEditingController(), _trPts = TextEditingController(text: '100000');
  String _method = 'Telebirr';
  bool _agChecked = false;
  bool _hideFrozen = false;

    void _openWa(String msg) {
    Clipboard.setData(ClipboardData(text: '+251919108311 • $msg'));
  }


  @override
  Widget build(BuildContext context) {
    final p = double.tryParse(_pts.text) ?? 0;
    final payout = _method == 'USDT (TRC20)' ? '\$${(p / 10000).toStringAsFixed(2)} USDT' : 'Br ${((p / 10000) * 140).toStringAsFixed(1)}';
    final trAmt = double.tryParse(_trPts.text) ?? 0;
    final agReceive = (trAmt * 0.98).toStringAsFixed(0);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: const Text('Points')),
        body: Column(children: List<Widget>.of({
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: <Color>[Color(0xFF0D9488), Color(0xFF2DD4BF)]), borderRadius: BorderRadius.circular(18)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: List<Widget>.of({
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List<Widget>.of({
                const Text('Points Balance', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                InkWell(
                  onTap: () => _openWa('Hello Ethio-Voice Official Payroll, please check my Points history (ID: ${AppState.userId}).'),
                  child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)), child: const Text('Details', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0D9488)))),
                ),
              })),
              const SizedBox(height: 6),
              Text('💎 ${AppState.points.toStringAsFixed(3)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.black)),
              const SizedBox(height: 6),
              InkWell(
                onTap: () => setState(() => _hideFrozen = !_hideFrozen),
                child: Text(_hideFrozen ? 'Frozen Points: **** 👁️' : 'Frozen Points: 0.00 👁️', style: const TextStyle(fontSize: 12, color: Colors.black87)),
              ),
            })),
          ),
          const TabBar(
            indicatorColor: Colors.tealAccent,
            labelColor: Colors.tealAccent,
            unselectedLabelColor: Colors.white60,
            tabs: <Tab>[Tab(text: 'Cash out'), Tab(text: 'Exchange'), Tab(text: 'Transfer')],
          ),
          Expanded(
            child: TabBarView(children: List<Widget>.of({
              ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
                const Text('Direct Platform Payroll Cash Out (10,000 Pts = 140 ETB)', style: TextStyle(fontSize: 12, color: Colors.amber)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(value: _method, items: List<String>.of({'Telebirr', 'CBEBirr', 'CBE', 'Awash Bank', 'Dashen Bank', 'USDT (TRC20)'}).map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(), onChanged: (v) => setState(() => _method = v ?? 'Telebirr')),
                TextField(controller: _pts, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Points to Sell (Min 100,000)'), onChanged: (_) => setState(() {})),
                TextField(controller: _acc, decoration: InputDecoration(labelText: _method == 'USDT (TRC20)' ? 'TRC20 Wallet Address' : 'Your Phone or Account Number')),
                const SizedBox(height: 14),
                ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))), onPressed: () {
                  if (p >= 100000 && AppState.points >= p && _acc.text.isNotEmpty) {
                    final now = DateTime.now().toString().substring(0, 19);
                    final orderId = '2026${DateTime.now().millisecondsSinceEpoch}';
                    setState(() {
                      AppState.points -= p;
                      AppState.systemReceipts.insert(0, {'amount': payout, 'status': 'Done', 'orderId': orderId, 'applicant': AppState.userName, 'method': _method, 'appTime': now, 'notarizeTime': now, 'finishTime': now, 'agentWa': '251919108311'});
                      AppState.officialNotices.insert(0, {'title': 'Withdrawal received', 'body': 'Direct Platform Payroll ($payout via $_method, Order: $orderId) submitted!', 'time': now});
                    });
                    widget.onUpd();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('Cash Out ($payout) Sent! Check System Message!')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Min 100,000 Points & Account required!')));
                  }
                }, child: Text('Cash Out $payout', style: const TextStyle(fontWeight: FontWeight.bold))),
              })),
              ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
                const Text('Exchange Points to Coins Instantly (10,000 Pts = 10,000 Coins)', style: TextStyle(fontSize: 12, color: Colors.amber)),
                TextField(controller: _exPts, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Points to Exchange (Min 1,000)')),
                const SizedBox(height: 14),
                ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))), onPressed: () {
                  final ex = double.tryParse(_exPts.text) ?? 0;
                  if (ex >= 1000 && AppState.points >= ex) {
                    setState(() { AppState.points -= ex; AppState.coins += ex.toInt(); });
                    widget.onUpd();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('Exchanged ${ex.toInt()} Points -> ${ex.toInt()} Coins!')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not enough Points (Min 1,000)!')));
                  }
                }, child: const Text('Exchange Now', style: const TextStyle(fontWeight: FontWeight.bold))),
              })),
              ListView(padding: const EdgeInsets.all(14), children: List<Widget>.of({
                const Text('User ID:', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(children: List<Widget>.of({
                  Expanded(child: TextField(controller: _agId, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'Enter Agency User ID'), onChanged: (_) => setState(() => _agChecked = false))),
                  TextButton(onPressed: () {
                    if (_agId.text.trim().length >= 5 && _agId.text.trim() != AppState.userId) {
                      setState(() => _agChecked = true);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('Verified Agency ID: ${_agId.text.trim()}')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.red, content: Text('Enter valid Agency User ID!')));
                    }
                  }, child: Text(_agChecked ? 'Verified ✅' : 'Check', style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold))),
                })),
                const SizedBox(height: 10),
                const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                  Text('Amount', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Fee: 2%', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                ]),
                TextField(controller: _trPts, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'Enter Amount (Min 100,000)'), onChanged: (_) => setState(() {})),
                const SizedBox(height: 8),
                Text('The Agency will receive: 💎 $agReceive', style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                const Text('1. Transfer fee: 2%. Minimum transfer >= 100,000 points.\n2. Click transfer button to transfer the corresponding points to your agents.\n3. After the transfer finished, it can\'t be cancelled or withdrawn.', style: TextStyle(fontSize: 11, color: Colors.white60)),
                const SizedBox(height: 14),
                ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.tealAccent, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))), onPressed: () {
                  if (!_agChecked) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tap "Check" to verify Agency ID first!'))); return; }
                  if (trAmt >= 100000 && AppState.points >= trAmt) {
                    final now = DateTime.now().toString().substring(0, 19);
                    final orderId = '2026${DateTime.now().millisecondsSinceEpoch}';
                    setState(() {
                      AppState.points -= trAmt;
                      AppState.systemReceipts.insert(0, {'amount': '💎 $agReceive Pts', 'status': 'Done', 'orderId': orderId, 'applicant': '${AppState.userName} ➔ Agency ${_agId.text.trim()}', 'method': 'Agency Transfer (2% Fee)', 'appTime': now, 'notarizeTime': now, 'finishTime': now, 'agentWa': '251919108311'});
                      AppState.officialNotices.insert(0, {'title': 'Agency Points Transfer', 'body': 'Transferred $agReceive Points (after 2% fee) to Agency ID ${_agId.text.trim()}.', 'time': now});
                    });
                    widget.onUpd();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('Transferred $agReceive Points to Agency ${_agId.text.trim()}!')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Min 100,000 Points required!')));
                  }
                }, child: const Text('Transfer Points', style: TextStyle(fontWeight: FontWeight.bold))),
              })),
            })),
          ),
        })),
      ),
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
                  if (AppState.coins >= price) {
                    setState(() { AppState.coins -= price; AppState.vipLevel = lv; AppState.wealthLv += lv * 2; });
                    AppState.officialNotices.insert(0, {'title': 'VIP Upgraded!', 'body': 'Congratulations! You unlocked VIP $lv (${v['name']})!', 'time': DateTime.now().toString().substring(0, 19)});
                    widget.onUpd();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not enough Coins!')));
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
                    if (AppState.coins >= price) { setState(() { AppState.coins -= price; AppState.wealthLv += 1; }); widget.onUpd(); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Equipped ${it['name']}!'))); }
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
