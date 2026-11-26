import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class MeTabPage extends StatefulWidget {
  final VoidCallback onUpd;
  const MeTabPage({super.key, required this.onUpd});

  @override
  State<MeTabPage> createState() => _MeTabPageState();
}

class _MeTabPageState extends State<MeTabPage> {
  static const String serverUrl = 'https://onrender.com';

  @override
  Widget build(BuildContext context) {
    final wLv = (AppState.coins ~/ 10000) + 1;
    final cLv = (AppState.points.toInt() ~/ 500) + 1;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Me • Profile & Center', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutAppPage())),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.amber,
                        child: Icon(Icons.person, size: 34, color: Colors.black),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppState.userName.isEmpty ? 'Voice Chat User' : AppState.userName,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: AppState.userId));
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ID Copied!')));
                              },
                              child: Text('ID: ${AppState.userId} 📋', style: const TextStyle(color: Colors.white70)),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: Colors.amber.shade700, borderRadius: BorderRadius.circular(10)),
                                  child: Text('Wealth Lv.$wLv', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black)),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: Colors.pinkAccent, borderRadius: BorderRadius.circular(10)),
                                  child: Text('Charm Lv.$cLv', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24, color: Colors.white12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text('${AppState.coins}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
                          const Text('My Coins', style: TextStyle(color: Colors.white60, fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          Text(AppState.points.toStringAsFixed(2), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
                          const Text('My Diamonds', style: TextStyle(color: Colors.white60, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.account_balance_wallet, color: Colors.amber),
                  title: const Text('Wallet & Recharge (CBE / Telebirr / USDT)'),
                  subtitle: const Text('Instant Coin Top-Up via Server'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WalletRechargePage(onUpd: () { setState(() {}); widget.onUpd(); }))),
                ),
                const Divider(height: 1, color: Colors.white12),
                ListTile(
                  leading: const Icon(Icons.payments, color: Colors.cyanAccent),
                  title: const Text('Diamonds Cash Out & Payroll'),
                  subtitle: const Text('Withdraw to CBE, Telebirr or USDT TRC20'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PointsCashOutPage(onUpd: () { setState(() {}); widget.onUpd(); }))),
                ),
                const Divider(height: 1, color: Colors.white12),
                ListTile(
                  leading: const Icon(Icons.verified_user, color: Colors.greenAccent),
                  title: const Text('Official Coin Sellers'),
                  subtitle: const Text('Verified Trusted Top-Up Agents'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OfficialCoinSellersPage())),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.business_center, color: Colors.orangeAccent),
                  title: const Text('Agency Center & Coin Credit'),
                  subtitle: const Text('15% Commission • 70% Host Payout • Coin Loan'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AgencyWebPortalPage(onUpd: () { setState(() {}); widget.onUpd(); }))),
                ),
                const Divider(height: 1, color: Colors.white12),
                ListTile(
                  leading: const Icon(Icons.mic, color: Colors.purpleAccent),
                  title: const Text('Host Center & Revenue Split'),
                  subtitle: const Text('Manage Host Salary & Agency Targets'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HostCenterPage(onUpd: () { setState(() {}); widget.onUpd(); }))),
                ),
                const Divider(height: 1, color: Colors.white12),
                ListTile(
                  leading: const Icon(Icons.task_alt, color: Colors.lightBlueAccent),
                  title: const Text('Task Center & Daily Rewards'),
                  subtitle: const Text('Complete daily missions for free coins'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskCenterFullPage(onUpd: () { setState(() {}); widget.onUpd(); }))),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.workspace_premium, color: Colors.amber),
                  title: const Text('Wealth & Charm Levels'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WealthCharmLevelPage())),
                ),
                const Divider(height: 1, color: Colors.white12),
                ListTile(
                  leading: const Icon(Icons.card_giftcard, color: Colors.pinkAccent),
                  title: const Text('Invitation Rewards'),
                  trailing: const Icon(Icons.chevron_right),
cat << 'EOF' > jimma_voice_app/lib/me_pages.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class MeTabPage extends StatefulWidget {
  final VoidCallback onUpd;
  const MeTabPage({super.key, required this.onUpd});
  @override
  State<MeTabPage> createState() => _MeTabPageState();
}

class _MeTabPageState extends State<MeTabPage> {
  static const String serverUrl = 'https://Jimma-voice-app.onrender.com';
  @override
  Widget build(BuildContext context) {
    final wLv = (AppState.coins ~/ 10000) + 1;
    final cLv = (AppState.points.toInt() ~/ 500) + 1;
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Me • Profile & Center'),
        actions: [IconButton(icon: const Icon(Icons.info_outline), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutAppPage())))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Card(
            color: const Color(0xFF1E293B),
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.amber, child: Icon(Icons.person, color: Colors.black)),
              title: Text(AppState.userName.isEmpty ? 'Voice Chat User' : AppState.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('ID: ${AppState.userId} • Wealth Lv.$wLv • Charm Lv.$cLv\nCoins: ${AppState.coins} | Diamonds: ${AppState.points.toStringAsFixed(2)}'),
            ),
          ),
          Card(
            color: const Color(0xFF1E293B),
            child: Column(
              children: [
                ListTile(leading: const Icon(Icons.account_balance_wallet, color: Colors.amber), title: const Text('Wallet & Recharge (CBE / Telebirr / USDT)'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WalletRechargePage(onUpd: () { setState(() {}); widget.onUpd(); })))),
                ListTile(leading: const Icon(Icons.payments, color: Colors.cyanAccent), title: const Text('Diamonds Cash Out & Payroll'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PointsCashOutPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
                ListTile(leading: const Icon(Icons.verified_user, color: Colors.greenAccent), title: const Text('Official Coin Sellers'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OfficialCoinSellersPage()))),
                ListTile(leading: const Icon(Icons.business_center, color: Colors.orangeAccent), title: const Text('Agency Center & Coin Loan'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AgencyWebPortalPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
                ListTile(leading: const Icon(Icons.mic, color: Colors.purpleAccent), title: const Text('Host Center'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HostCenterPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
                ListTile(leading: const Icon(Icons.task_alt, color: Colors.lightBlueAccent), title: const Text('Task Center'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskCenterFullPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
                ListTile(leading: const Icon(Icons.workspace_premium, color: Colors.amber), title: const Text('Wealth & Charm Levels'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WealthCharmLevelPage()))),
                ListTile(leading: const Icon(Icons.card_giftcard, color: Colors.pinkAccent), title: const Text('Invitation Rewards'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => InvitationBonusPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
                ListTile(leading: const Icon(Icons.backpack, color: Colors.tealAccent), title: const Text('My Backpack'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BackpackPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
                ListTile(leading: const Icon(Icons.casino, color: Colors.redAccent), title: const Text('Lucky Island Spin'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LuckyIslandPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
                ListTile(leading: const Icon(Icons.military_tech, color: Colors.amberAccent), title: const Text('My Badges'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BadgeCollectionPage()))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WalletRechargePage extends StatefulWidget {
  final VoidCallback onUpd;
  const WalletRechargePage({super.key, required this.onUpd});
  @override
  State<WalletRechargePage> createState() => _WalletRechargePageState();
}

class _WalletRechargePageState extends State<WalletRechargePage> {
  static const String serverUrl = 'https://onrender.com';
  final _txCtrl = TextEditingController();
  int _coins = 1000;
  String _method = 'CBE';
  bool _busy = false;

  Future<void> _send() async {
    if (_txCtrl.text.trim().isEmpty) return;
    setState(() => _busy = true);
    try {
      await http.post(Uri.parse('$serverUrl/api/recharge'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'userId': AppState.userId, 'coins': _coins, 'method': _method, 'txRef': _txCtrl.text.trim()})).timeout(const Duration(seconds: 20));
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('✅ Sent to Server!')));
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Queued! Contact @EthioVoiceAlertBot')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet & Recharge')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Card(
            color: const Color(0xFF1E293B),
            child: ListTile(
              title: const Text('CBE: 1000273060937 (MOHAMMEDSABIT)'),
              subtitle: const Text('USDT TRC20: TYdr3JdbDzhxjfsGeU3yazNAmTbkHBuNcE'),
              trailing: IconButton(icon: const Icon(Icons.copy), onPressed: () => Clipboard.setData(const ClipboardData(text: '1000273060937'))),
            ),
          ),
          DropdownButtonFormField<int>(
            initialValue: _coins,
            items: const [DropdownMenuItem(value: 1000, child: Text('1,000 Coins (150 ETB)')), DropdownMenuItem(value: 5000, child: Text('5,000 Coins (700 ETB)')), DropdownMenuItem(value: 10000, child: Text('10,000 Coins (1,350 ETB)'))],
            onChanged: (v) => setState(() => _coins = v ?? 1000),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: _method,
            items: const [DropdownMenuItem(value: 'CBE', child: Text('CBE')), DropdownMenuItem(value: 'Telebirr', child: Text('Telebirr')), DropdownMenuItem(value: 'USDT_TRC20', child: Text('USDT TRC20'))],
            onChanged: (v) => setState(() => _method = v ?? 'CBE'),
          ),
          const SizedBox(height: 10),
          TextField(controller: _txCtrl, decoration: const InputDecoration(labelText: 'Transaction ID / TXID', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _busy ? null : _send, child: Text(_busy ? 'Sending...' : 'Confirm Recharge')),
        ],
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
  static const String serverUrl = 'https://onrender.com';
  final _amtCtrl = TextEditingController();
  final _accCtrl = TextEditingController();
  String _method = 'CBE';

  Future<void> _out() async {
    final amt = double.tryParse(_amtCtrl.text.trim()) ?? 0;
    if (amt <= 0 || amt > AppState.points || _accCtrl.text.trim().isEmpty) return;
    try {
      await http.post(Uri.parse('$serverUrl/api/cashout'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'userId': AppState.userId, 'diamonds': amt, 'method': _method, 'account': _accCtrl.text.trim()})).timeout(const Duration(seconds: 20));
      AppState.points -= amt;
      widget.onUpd();
      if (mounted) Navigator.pop(context);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diamonds Cash Out')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          DropdownButtonFormField<String>(initialValue: _method, items: const [DropdownMenuItem(value: 'CBE', child: Text('CBE')), DropdownMenuItem(value: 'Telebirr', child: Text('Telebirr')), DropdownMenuItem(value: 'USDT', child: Text('USDT TRC20'))], onChanged: (v) => setState(() => _method = v ?? 'CBE')),
          const SizedBox(height: 10),
          TextField(controller: _amtCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Diamonds Amount', border: OutlineInputBorder())),
          const SizedBox(height: 10),
          TextField(controller: _accCtrl, decoration: const InputDecoration(labelText: 'Account / Phone / TRC20', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _out, child: const Text('Submit Withdrawal')),
        ],
      ),
    );
  }
}

class OfficialCoinSellersPage extends StatelessWidget {
  const OfficialCoinSellersPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Official Coin Sellers')), body: const ListTile(title: Text('Voice Chat ET Official Desk'), subtitle: Text('Bot: @EthioVoiceAlertBot • +251919108311\nCBE: 1000273060937 (MOHAMMEDSABIT)')));
}

class AgencyWebPortalPage extends StatefulWidget {
  final VoidCallback onUpd;
  const AgencyWebPortalPage({super.key, required this.onUpd});
  @override
  State<AgencyWebPortalPage> createState() => _AgencyWebPortalPageState();
}

class _AgencyWebPortalPageState extends State<AgencyWebPortalPage> {
  static const String serverUrl = 'https://onrender.com';
  final _nameCtrl = TextEditingController();
  final _tgCtrl = TextEditingController();

  Future<void> _reg() async {
    if (_nameCtrl.text.trim().isEmpty) return;
    try {
      await http.post(Uri.parse('$serverUrl/api/agency/register'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'userId': AppState.userId, 'agencyName': _nameCtrl.text.trim(), 'telegram': _tgCtrl.text.trim()})).timeout(const Duration(seconds: 20));
    } catch (_) {}
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('✅ Agency Sent! Message @EthioVoiceAlertBot')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agency & Coin Loan')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          const Card(color: Color(0xFF1E293B), child: ListTile(title: Text('15% Agency Commission • 70% Host Payout'), subtitle: Text('Coin Credit & Advance available for registered agencies!'))),
          const SizedBox(height: 10),
          TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Agency Name', border: OutlineInputBorder())),
          const SizedBox(height: 10),
          TextField(controller: _tgCtrl, decoration: const InputDecoration(labelText: 'Telegram / Phone', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _reg, child: const Text('Register Agency & Coin Loan')),
        ],
      ),
    );
  }
}

class TaskCenterFullPage extends StatefulWidget {
  final VoidCallback onUpd;
  const TaskCenterFullPage({super.key, required this.onUpd});
  @override
  State<TaskCenterFullPage> createState() => _TaskCenterFullPageState();
}

class _TaskCenterFullPageState extends State<TaskCenterFullPage> {
  bool _done = false;
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Task Center')), body: ListTile(title: const Text('Daily Check-In (+50 Coins)'), trailing: ElevatedButton(onPressed: _done ? null : () { AppState.coins += 50; widget.onUpd(); setState(() => _done = true); }, child: Text(_done ? 'Claimed' : 'Claim'))));
}

class WealthCharmLevelPage extends StatelessWidget {
  const WealthCharmLevelPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Wealth & Charm Levels')), body: ListTile(title: Text('Wealth Lv.${(AppState.coins ~/ 10000) + 1} • Charm Lv.${(AppState.points.toInt() ~/ 500) + 1}'), subtitle: const Text('VIP Entry Banner & Red Packet Privileges')));
}

class HostCenterPage extends StatelessWidget {
  final VoidCallback onUpd;
  const HostCenterPage({super.key, required this.onUpd});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Host Center')), body: ListTile(title: Text('Diamonds: ${AppState.points.toStringAsFixed(2)}'), subtitle: const Text('70% Direct Host Payout • 15% Agency Bonus'), trailing: ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PointsCashOutPage(onUpd: onUpd))), child: const Text('Cash Out'))));
}

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('About Voice Chat ET')), body: const Padding(padding: EdgeInsets.all(16), child: Text('Voice Chat ET (v3.0.9)\nServer: https://onrender.com\nSupport: @EthioVoiceAlertBot | +251919108311')));
}

class InvitationBonusPage extends StatelessWidget {
  final VoidCallback onUpd;
  const InvitationBonusPage({super.key, required this.onUpd});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Invitation Rewards')), body: Center(child: ElevatedButton(onPressed: () => Clipboard.setData(ClipboardData(text: 'ET${AppState.userId}')), child: Text('Copy Code: ET${AppState.userId}'))));
}

class BackpackPage extends StatelessWidget {
  final VoidCallback onUpd;
  const BackpackPage({super.key, required this.onUpd});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('My Backpack')), body: const ListTile(title: Text('Golden Lion Entry Car'), subtitle: Text('Active • 7 Days')));
}

class LuckyIslandPage extends StatelessWidget {
  final VoidCallback onUpd;
  const LuckyIslandPage({super.key, required this.onUpd});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Lucky Island Spin')), body: Center(child: ElevatedButton(onPressed: () { if (AppState.coins >= 100) { AppState.coins += 100; onUpd(); } }, child: const Text('Spin (100 Coins)'))));
}

class BadgeCollectionPage extends StatelessWidget {
  const BadgeCollectionPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('My Badges')), body: const ListTile(title: Text('Pioneer Member Badge'), subtitle: Text('Unlocked on registration')));
}
