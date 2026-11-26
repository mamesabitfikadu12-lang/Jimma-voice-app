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
  static const String serverUrl = 'https://api.mosabitshob.com';

  void _copyId() {
    Clipboard.setData(ClipboardData(text: AppState.userId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.green, content: Text('✅ ID (${AppState.userId}) Copied!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wLv = (AppState.coins ~/ 10000) + 1;
    final cLv = (AppState.points.toInt() ~/ 500) + 1;
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Me • Profile & Center'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AppSettingsPage())),
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
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    children: [
                      const CircleAvatar(radius: 28, backgroundColor: Colors.amber, child: Icon(Icons.person, size: 30, color: Colors.black)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppState.userName.isEmpty ? 'Voice Chat User' : AppState.userName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            InkWell(
                              onTap: _copyId,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('ID: ${AppState.userId}', style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.w600)),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.copy, size: 15, color: Colors.amberAccent),
                                  const SizedBox(width: 4),
                                  const Text('Copy', style: TextStyle(fontSize: 11, color: Colors.white60)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('Wealth Lv.$wLv  •  Charm Lv.$cLv', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20, color: Colors.white12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [Text('${AppState.coins}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.amber)), const Text('Coins', style: TextStyle(fontSize: 12, color: Colors.white60))]),
                      Column(children: [Text(AppState.points.toStringAsFixed(2), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.cyanAccent)), const Text('Diamonds', style: TextStyle(fontSize: 12, color: Colors.white60))]),
                      Column(children: [Text('Lv.$wLv', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.pinkAccent)), const Text('VIP Rank', style: TextStyle(fontSize: 12, color: Colors.white60))]),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            color: const Color(0xFF1E293B),
            child: Column(
              children: [
                ListTile(leading: const Icon(Icons.account_balance_wallet, color: Colors.amber), title: const Text('Wallet & Recharge (CBE / Telebirr / USDT)'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WalletRechargePage(onUpd: () { setState(() {}); widget.onUpd(); })))),
                ListTile(leading: const Icon(Icons.payments, color: Colors.cyanAccent), title: const Text('Diamonds Cash Out & Payroll'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PointsCashOutPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
                ListTile(leading: const Icon(Icons.verified_user, color: Colors.greenAccent), title: const Text('Official Coin Sellers'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OfficialCoinSellersPage()))),
                ListTile(leading: const Icon(Icons.storefront, color: Colors.deepOrangeAccent), title: const Text('VIP Store & Mall (Rides & Frames)'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VipStoreMallPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
                ListTile(leading: const Icon(Icons.workspace_premium, color: Colors.amber), title: const Text('VIP Membership Center'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VipMembershipPage()))),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Card(
            color: const Color(0xFF1E293B),
            child: Column(
              children: [
                ListTile(leading: const Icon(Icons.business_center, color: Colors.orangeAccent), title: const Text('Agency Center & Coin Loan'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AgencyWebPortalPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
                ListTile(leading: const Icon(Icons.mic, color: Colors.purpleAccent), title: const Text('Host Center & Host Tasks'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HostCenterPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
                ListTile(leading: const Icon(Icons.task_alt, color: Colors.lightBlueAccent), title: const Text('Daily Task Center'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskCenterFullPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
                ListTile(leading: const Icon(Icons.celebration, color: Colors.pinkAccent), title: const Text('Events & Tournaments Center'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EventsCenterPage()))),
                ListTile(leading: const Icon(Icons.groups, color: Colors.tealAccent), title: const Text('Family / Guild Center'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FamilyCenterPage()))),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Card(
            color: const Color(0xFF1E293B),
            child: Column(
              children: [
                ListTile(leading: const Icon(Icons.trending_up, color: Colors.amber), title: const Text('Wealth & Charm Levels'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WealthCharmLevelPage()))),
                ListTile(leading: const Icon(Icons.card_giftcard, color: Colors.pinkAccent), title: const Text('Invitation Rewards'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => InvitationBonusPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
                ListTile(leading: const Icon(Icons.backpack, color: Colors.tealAccent), title: const Text('My Backpack'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BackpackPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
                ListTile(leading: const Icon(Icons.casino, color: Colors.redAccent), title: const Text('Lucky Island Spin'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LuckyIslandPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
                ListTile(leading: const Icon(Icons.military_tech, color: Colors.amberAccent), title: const Text('My Badges'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BadgeCollectionPage()))),
                ListTile(leading: const Icon(Icons.support_agent, color: Colors.greenAccent), title: const Text('Customer Service & Feedback'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutAppPage()))),
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
  static const String serverUrl = 'https://api.mosabitshob.com';
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
          DropdownButtonFormField<int>(initialValue: _coins, items: const [DropdownMenuItem(value: 1000, child: Text('1,000 Coins (150 ETB)')), DropdownMenuItem(value: 5000, child: Text('5,000 Coins (700 ETB)')), DropdownMenuItem(value: 10000, child: Text('10,000 Coins (1,350 ETB)'))], onChanged: (v) => setState(() => _coins = v ?? 1000)),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(initialValue: _method, items: const [DropdownMenuItem(value: 'CBE', child: Text('CBE')), DropdownMenuItem(value: 'Telebirr', child: Text('Telebirr')), DropdownMenuItem(value: 'USDT_TRC20', child: Text('USDT TRC20'))], onChanged: (v) => setState(() => _method = v ?? 'CBE')),
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
  static const String serverUrl = 'https://api.mosabitshob.com';
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

class VipStoreMallPage extends StatelessWidget {
  final VoidCallback onUpd;
  const VipStoreMallPage({super.key, required this.onUpd});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('VIP Store & Mall')), body: ListView(padding: const EdgeInsets.all(14), children: [Card(color: const Color(0xFF1E293B), child: ListTile(leading: const Icon(Icons.directions_car, color: Colors.amber), title: const Text('Golden Lion Entry Ride (7 Days)'), subtitle: const Text('500 Coins'), trailing: ElevatedButton(onPressed: () { if (AppState.coins >= 500) { AppState.coins -= 500; onUpd(); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Purchased Golden Lion Ride!'))); } }, child: const Text('Buy'))))]));
}

class VipMembershipPage extends StatelessWidget {
  const VipMembershipPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('VIP Membership')), body: const ListTile(leading: Icon(Icons.workspace_premium, color: Colors.amber), title: Text('SVIP Royal Privileges'), subtitle: Text('Exclusive Entry Effect, Colored Chat Bubble & Priority Mic')));
}

class EventsCenterPage extends StatelessWidget {
  const EventsCenterPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Events & Tournaments')), body: const ListTile(leading: Icon(Icons.emoji_events, color: Colors.amber), title: Text('Weekly Top Gifter & Host PK Battle'), subtitle: Text('Win up to 50,000 Bonus Coins every Sunday!')));
}

class FamilyCenterPage extends StatelessWidget {
  const FamilyCenterPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Family / Guild Center')), body: const ListTile(leading: Icon(Icons.groups, color: Colors.tealAccent), title: Text('Create or Join a Voice Family'), subtitle: Text('Compete in weekly Family PK tournaments together!')));
}

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('App Settings')), body: const ListTile(title: Text('Voice Chat ET v3.1.0 (Build 13)'), subtitle: Text('Server: https://api.mosabitshob.com')));
}

class AgencyWebPortalPage extends StatefulWidget {
  final VoidCallback onUpd;
  const AgencyWebPortalPage({super.key, required this.onUpd});
  @override
  State<AgencyWebPortalPage> createState() => _AgencyWebPortalPageState();
}

class _AgencyWebPortalPageState extends State<AgencyWebPortalPage> {
  static const String serverUrl = 'https://api.mosabitshob.com';
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
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Agency & Coin Loan')), body: ListView(padding: const EdgeInsets.all(14), children: [const Card(color: Color(0xFF1E293B), child: ListTile(title: Text('15% Agency Commission • 70% Host Payout'), subtitle: Text('Coin Credit & Advance available!'))), const SizedBox(height: 10), TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Agency Name', border: OutlineInputBorder())), const SizedBox(height: 10), TextField(controller: _tgCtrl, decoration: const InputDecoration(labelText: 'Telegram / Phone', border: OutlineInputBorder())), const SizedBox(height: 12), ElevatedButton(onPressed: _reg, child: const Text('Register Agency & Coin Loan'))]));
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
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Daily Task Center')), body: ListTile(title: const Text('Daily Check-In (+50 Coins)'), trailing: ElevatedButton(onPressed: _done ? null : () { AppState.coins += 50; widget.onUpd(); setState(() => _done = true); }, child: Text(_done ? 'Claimed' : 'Claim'))));
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
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Host Center & Tasks')), body: ListView(padding: const EdgeInsets.all(14), children: [ListTile(title: Text('Diamonds: ${AppState.points.toStringAsFixed(2)}'), subtitle: const Text('70% Direct Host Payout • 15% Agency Bonus'), trailing: ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PointsCashOutPage(onUpd: onUpd))), child: const Text('Cash Out'))), const ListTile(title: Text('Weekly Host Target: 10 Hours Live Mic'), subtitle: Text('Bonus: +2,000 Diamonds'))]));
}

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Customer Service & About')), body: const Padding(padding: EdgeInsets.all(16), child: Text('Voice Chat ET (v3.1.0)\nServer: https://api.mosabitshob.com\nSupport Bot: @EthioVoiceAlertBot | +251919108311')));
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

Widget MeTab({required VoidCallback onUpd}) => MeTabPage(onUpd: onUpd);
