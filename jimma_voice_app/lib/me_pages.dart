import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'games_moments.dart';

Widget MeTab({required VoidCallback onUpd}) => MeTabPage(onUpd: onUpd);

class MeTabPage extends StatefulWidget {
  final VoidCallback onUpd;
  const MeTabPage({super.key, required this.onUpd});
  @override
  State<MeTabPage> createState() => _MeTabPageState();
}

class _MeTabPageState extends State<MeTabPage> {
  final int _following = 14;
  final int _followers = 62;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _showPromoDialog());
  }

  void _showPromoDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1B4B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22), side: const BorderSide(color: Colors.amber, width: 2)),
        title: const Text('🎁 Invite & Play Rewards!', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        content: const Text('• Invite Friends & Get +2,000 Coins!\n• Play This Game & Win up to 100,000 Coins!\n• Agency Rate: 10,000 Coins = 190 ETB!'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => GamesLobbyPage(onUpd: widget.onUpd)));
            },
            child: const Text('Play & Win'),
          ),
        ],
      ),
    );
  }

  Widget _gridTile(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(14), border: Border.all(color: color, width: 1.2)),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 5),
          Text(label, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Colors.white)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wLv = (AppState.coins ~/ 10000) + 1;
    final cLv = (AppState.points.toInt() ~/ 500) + 1;
    return Scaffold(
      backgroundColor: const Color(0xFF090E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1B4B),
        title: const Text('Me • Royal Profile'),
        actions: [
          IconButton(icon: const Icon(Icons.campaign, color: Colors.amber), onPressed: _showPromoDialog),
          IconButton(icon: const Icon(Icons.settings), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AppSettingsPage()))),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(colors: [Color(0xFF312E81), Color(0xFF701A75)]),
              border: Border.all(color: Colors.amber, width: 1.5),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Colors.amber, Colors.orange])),
                      child: const CircleAvatar(radius: 30, backgroundColor: Color(0xFF0F172A), child: Icon(Icons.person, size: 32, color: Colors.amber)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${AppState.userName.isEmpty ? 'Voice User' : AppState.userName} 🇪🇹', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 4),
                          InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: AppState.userId));
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('✅ ID:${AppState.userId} Copied!')));
                            },
                            child: Text('ID:${AppState.userId} 📋', style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 4),
                          Text('Following: $_following  •  Followers: $_followers', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WalletRechargePage(onUpd: () { setState(() {}); widget.onUpd(); }))),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: const LinearGradient(colors: [Color(0xFF15803D), Color(0xFF16A34A)]),
                      border: Border.all(color: Colors.amberAccent),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [const Icon(Icons.monetization_on, color: Colors.amber), const SizedBox(width: 8), Text('Recharge  •  ${AppState.coins} Coins', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white))]),
                        const Icon(Icons.arrow_forward, color: Colors.amber),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VipClubFullPage(onUpd: () { setState(() {}); widget.onUpd(); }))),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: const LinearGradient(colors: [Color(0xFF292524), Color(0xFF78350F)]), border: Border.all(color: Colors.amber)),
                    child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.workspace_premium, color: Colors.amber), SizedBox(width: 6), Text('SVIP', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 16))]),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VipClubFullPage(onUpd: () { setState(() {}); widget.onUpd(); }))),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: const LinearGradient(colors: [Color(0xFF7F1D1D), Color(0xFFB45309)]), border: Border.all(color: Colors.amberAccent)),
                    child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.verified, color: Colors.amberAccent), SizedBox(width: 6), Text('VIP', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16))]),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            color: const Color(0xFF151C2F),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                childAspectRatio: 0.9,
                children: [
                  _gridTile(Icons.account_balance_wallet, 'Wallet', Colors.amber, () => Navigator.push(context, MaterialPageRoute(builder: (_) => WalletRechargePage(onUpd: () { setState(() {}); widget.onUpd(); })))),
                  _gridTile(Icons.storefront, 'Mall 50M', Colors.pinkAccent, () => Navigator.push(context, MaterialPageRoute(builder: (_) => LuxuryStorePage(onUpd: () { setState(() {}); widget.onUpd(); })))),
                  _gridTile(Icons.business_center, 'Agency ETB', Colors.greenAccent, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AgencyWebPortalPage()))),
                  _gridTile(Icons.verified_user, 'Coin Seller', Colors.cyanAccent, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OfficialCoinSellersPage()))),
                  _gridTile(Icons.sports_esports, 'Game Lv.$wLv', Colors.purpleAccent, () => Navigator.push(context, MaterialPageRoute(builder: (_) => GamesLobbyPage(onUpd: widget.onUpd)))),
                  _gridTile(Icons.trending_up, 'Wealth Lv.$wLv', Colors.orangeAccent, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WealthCharmLevelPage()))),
                  _gridTile(Icons.favorite, 'Charm Lv.$cLv', Colors.redAccent, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WealthCharmLevelPage()))),
                  _gridTile(Icons.task_alt, 'Game Tasks', Colors.lightBlueAccent, () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskCenterFullPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
                  _gridTile(Icons.card_giftcard, 'Invite & Win', Colors.amberAccent, () => Navigator.push(context, MaterialPageRoute(builder: (_) => InvitationBonusPage(onUpd: () { setState(() {}); widget.onUpd(); })))),
                  _gridTile(Icons.chat, 'Private Chat', Colors.tealAccent, () => Navigator.push(context, MaterialPageRoute(builder: (_) => MomentsTab(onUpd: widget.onUpd)))),
                  _gridTile(Icons.backpack, 'Backpack', Colors.indigoAccent, () => Navigator.push(context, MaterialPageRoute(builder: (_) => LuxuryStorePage(onUpd: () { setState(() {}); widget.onUpd(); })))),
                  _gridTile(Icons.settings, 'Settings', Colors.grey, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AppSettingsPage()))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VipClubFullPage extends StatelessWidget {
  final VoidCallback onUpd;
  const VipClubFullPage({super.key, required this.onUpd});

  @override
  Widget build(BuildContext context) {
    final privs = ['Customer Support', 'Daily Coins (8,500)', 'Global Entry Tag', 'Global Bullet Screen', 'Room Bullet Screen', 'More Admin', 'Greeting Limit', 'People Following', 'VIP Badge', 'Online User', 'Entry Tag', 'Entrance Effect', 'Profile Wings', 'Profile Card', 'Profile Frame', 'VIP Tag', 'Anti-Kick out', 'Mystery Man', 'Chat Bubble'];
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(backgroundColor: const Color(0xFF16A34A), title: const Text('VIP Club • SVIP / VIP3')),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.all(12), child: Text('✦ VIP Privileges (19/19) ✦', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber))),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1.05),
              itemCount: privs.length,
              itemBuilder: (_, i) => Column(
                children: [
                  const CircleAvatar(radius: 24, backgroundColor: Color(0xFF292524), child: Icon(Icons.workspace_premium, color: Colors.amber)),
                  const SizedBox(height: 4),
                  Text(privs[i], textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Colors.white70)),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            color: const Color(0xFF1C1917),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('🪙 240,000 / 30 Days', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber)), Text('Claim 8,500 coins daily', style: TextStyle(fontSize: 12, color: Colors.white70))]),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                  onPressed: () {
                    if (AppState.coins >= 240000) {
                      AppState.coins -= 240000;
                      onUpd();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('✅ VIP Activated!')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Need 240,000 Coins')));
                    }
                  },
                  child: const Text('Purchase', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LuxuryStorePage extends StatelessWidget {
  final VoidCallback onUpd;
  const LuxuryStorePage({super.key, required this.onUpd});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'name': 'Rose Heart Gift', 'price': 100},
      {'name': 'Golden Crown Avatar Frame', 'price': 10000},
      {'name': 'Phoenix Royal Wings Frame', 'price': 500000},
      {'name': 'Super Golden Spaceship', 'price': 5000000},
      {'name': 'Emperor Galaxy Throne (50M)', 'price': 50000000},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Mall • Frames & Gifts (Up to 50M)')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: items.map((it) => Card(
          color: const Color(0xFF1E293B),
          child: ListTile(
            leading: const Icon(Icons.auto_awesome, color: Colors.amber, size: 32),
            title: Text(it['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${it['price']} Coins'),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
              onPressed: () {
                final p = it['price'] as int;
                if (AppState.coins >= p) {
                  AppState.coins -= p;
                  onUpd();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('✅ Equipped ${it['name']}!')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Need $p Coins')));
                }
              },
              child: const Text('Buy'),
            ),
          ),
        )).toList(),
      ),
    );
  }
}

class AgencyWebPortalPage extends StatefulWidget {
  const AgencyWebPortalPage({super.key});
  @override
  State<AgencyWebPortalPage> createState() => _AgencyWebPortalPageState();
}

class _AgencyWebPortalPageState extends State<AgencyWebPortalPage> {
  final _customCtrl = TextEditingController();
  double _customEtb = 0;

  @override
  Widget build(BuildContext context) {
    const tiers = [10000, 20000, 50000, 100000, 500000, 1000000, 10000000];
    return Scaffold(
      appBar: AppBar(title: const Text('Agency Coin Rate (ETB)')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          const Card(color: Color(0xFF1E293B), child: ListTile(title: Text('Agency Base Rate: 10,000 Coins = 190 ETB'), subtitle: Text('15% Agency Commission • 70% Host Payout'))),
          ...tiers.map((c) {
            final etb = (c / 10000) * 190;
            return Card(
              color: const Color(0xFF0F172A),
              child: ListTile(
                leading: const Icon(Icons.monetization_on, color: Colors.amber),
                title: Text('$c Coins'),
                trailing: Text('${etb.toStringAsFixed(0)} ETB', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent, fontSize: 15)),
              ),
            );
          }),
          const SizedBox(height: 10),
          TextField(
            controller: _customCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Custom Coins Amount (e.g. 250000)', border: OutlineInputBorder()),
            onChanged: (v) => setState(() => _customEtb = ((double.tryParse(v) ?? 0) / 10000) * 190),
          ),
          const SizedBox(height: 8),
          Text('Custom Total: ${_customEtb.toStringAsFixed(2)} ETB', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
        ],
      ),
    );
  }
}

class OfficialCoinSellersPage extends StatelessWidget {
  const OfficialCoinSellersPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Official Coin Sellers')),
    body: ListView(
      padding: const EdgeInsets.all(14),
      children: const [
        Card(color: Color(0xFF1E293B), child: ListTile(leading: Icon(Icons.verified, color: Colors.amber), title: Text('Official Desk (USD & ETB)'), subtitle: Text('USD Rate Active • Agency Base: 10,000 Coins = 190 ETB\nBot: @EthioVoiceAlertBot • +251919108311\nCBE: 1000273060937 (MOHAMMEDSABIT)'))),
      ],
    ),
  );
}

class WalletRechargePage extends StatefulWidget {
  final VoidCallback onUpd;
  const WalletRechargePage({super.key, required this.onUpd});
  @override
  State<WalletRechargePage> createState() => _WalletRechargePageState();
}

class _WalletRechargePageState extends State<WalletRechargePage> {
  static const String serverUrl = 'https://mosabitshob.com';
  final _txCtrl = TextEditingController();
  int _coins = 10000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet & USDT Recharge')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Card(
            color: const Color(0xFF1E293B),
            child: ListTile(
              title: const Text('USDT TRC20: TYdr3JdbDzhxjfsGeU3yazNAmTbkHBuNcE'),
              subtitle: const Text('CBE: 1000273060937 (MOHAMMEDSABIT)'),
              trailing: IconButton(icon: const Icon(Icons.copy), onPressed: () => Clipboard.setData(const ClipboardData(text: 'TYdr3JdbDzhxjfsGeU3yazNAmTbkHBuNcE'))),
            ),
          ),
          DropdownButtonFormField<int>(
            initialValue: _coins,
            items: const [
              DropdownMenuItem(value: 10000, child: Text('10,000 Coins (\$1.50 USDT)')),
              DropdownMenuItem(value: 50000, child: Text('50,000 Coins (\$7.50 USDT)')),
              DropdownMenuItem(value: 100000, child: Text('100,000 Coins (\$15.00 USDT)')),
              DropdownMenuItem(value: 1000000, child: Text('1,000,000 Coins (\$150.00 USDT)')),
            ],
            onChanged: (v) => setState(() => _coins = v ?? 10000),
          ),
          const SizedBox(height: 10),
          TextField(controller: _txCtrl, decoration: const InputDecoration(labelText: 'USDT TXID / Bank Reference', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              if (_txCtrl.text.trim().isEmpty) return;
              try {
                await http.post(Uri.parse('$serverUrl/api/recharge'), headers: {'Content-Type': 'application/json'}, body: jsonEncode({'userId': AppState.userId, 'coins': _coins, 'method': 'USDT_TRC20', 'txRef': _txCtrl.text.trim()}));
              } catch (_) {}
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text('✅ Recharge Sent!')));
            },
            child: const Text('Confirm Recharge'),
          ),
        ],
      ),
    );
  }
}

class WealthCharmLevelPage extends StatelessWidget {
  const WealthCharmLevelPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Wealth & Charm Levels')), body: ListTile(title: Text('Wealth Lv.${(AppState.coins ~/ 10000) + 1} • Charm Lv.${(AppState.points.toInt() ~/ 500) + 1}'), subtitle: const Text('Royal Entrance Banner & Red Packet Privileges')));
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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Game & Daily Tasks')),
    body: ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Card(color: const Color(0xFF1E293B), child: ListTile(title: const Text('Daily Check-In (+500 Coins)'), trailing: ElevatedButton(onPressed: _done ? null : () { AppState.coins += 500; widget.onUpd(); setState(() => _done = true); }, child: Text(_done ? 'Claimed' : 'Claim')))),
        Card(color: const Color(0xFF1E293B), child: ListTile(title: const Text('Play 3 Rounds of TeenPattiPro / Lucky77'), subtitle: const Text('Reward: +10,000 Coins'), trailing: ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GamesLobbyPage(onUpd: widget.onUpd))), child: const Text('Play')))),
      ],
    ),
  );
}

class InvitationBonusPage extends StatelessWidget {
  final VoidCallback onUpd;
  const InvitationBonusPage({super.key, required this.onUpd});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Invite & Get Reward')), body: Center(child: ElevatedButton(onPressed: () { Clipboard.setData(ClipboardData(text: 'ET${AppState.userId}')); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Invite Code Copied!'))); }, child: Text('Invite Friends • Code: ET${AppState.userId}'))));
}

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Settings')), body: const ListTile(title: Text('Voice Chat ET v3.3.0 (Build 15)'), subtitle: Text('Server: https://mosabitshob.com')));
}

Widget MessagesTab({required VoidCallback onUpd}) => MomentsTab(onUpd: onUpd);

class PointsCashoutPayrollPage extends StatefulWidget {
  final VoidCallback onUpd;
  const PointsCashoutPayrollPage({super.key, required this.onUpd});
  @override
  State<PointsCashoutPayrollPage> createState() => _PointsCashoutPayrollPageState();
}

class _PointsCashoutPayrollPageState extends State<PointsCashoutPayrollPage> {
  static const String serverUrl = 'https://mosabitshob.com';
  String _channel = 'Agency';
  String _method = 'CBE Bank';
  final _ptsCtrl = TextEditingController(text: '100000');
  final _receiverIdCtrl = TextEditingController();
  final _accCtrl = TextEditingController();
  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    final pts = double.tryParse(_ptsCtrl.text.trim()) ?? 0;
    final grossEtb = (pts / 10000) * 190;
    final taxRate = _channel == 'Payroll Admin' ? 0.05 : 0.10;
    final taxEtb = grossEtb * taxRate;
    final netEtb = grossEtb - taxEtb;

    return Scaffold(
      backgroundColor: const Color(0xFF090E1A),
      appBar: AppBar(backgroundColor: const Color(0xFF1E1B4B), title: const Text('💎 Sell / Transfer Points & Cashout')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Card(
            color: const Color(0xFF1E293B),
            child: ListTile(
              leading: const Icon(Icons.diamond, color: Colors.cyanAccent, size: 32),
              title: Text('Available Diamonds: ${AppState.points.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
              subtitle: const Text('Minimum Transfer: 100,000 Diamonds • 10,000 = 190 ETB'),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: _channel,
            decoration: const InputDecoration(labelText: 'Sell / Transfer Points To', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'Agency', child: Text('Sell to Agency (Enter Agency ID • 10% Tax)')),
              DropdownMenuItem(value: 'Coin Seller', child: Text('Sell to Official Coin Seller (Enter Seller ID • 10% Tax)')),
              DropdownMenuItem(value: 'Payroll Admin', child: Text('Direct Payroll Admin Cashout (5% Tax)')),
            ],
            onChanged: (v) => setState(() => _channel = v ?? 'Agency'),
          ),
          if (_channel != 'Payroll Admin') ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _receiverIdCtrl,
                    decoration: InputDecoration(
                      labelText: 'Paste $_channel ID (Copy & Paste)',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16)),
                  icon: const Icon(Icons.paste, size: 18),
                  label: const Text('Paste ID', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    final clip = await Clipboard.getData('text/plain');
                    if (clip?.text != null && clip!.text!.trim().isNotEmpty) {
                      setState(() => _receiverIdCtrl.text = clip.text!.trim());
                    }
                  },
                ),
              ],
            ),
          ],
          const SizedBox(height: 10),
          TextField(
            controller: _ptsCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Diamonds to Transfer (Min: 100,000)', border: OutlineInputBorder()),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: _method,
            decoration: const InputDecoration(labelText: 'Receive Payment Via', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'CBE Bank', child: Text('CBE Bank Account')),
              DropdownMenuItem(value: 'Telebirr', child: Text('Telebirr Phone Number')),
              DropdownMenuItem(value: 'USDT TRC20', child: Text('USDT (TRC20 Wallet)')),
            ],
            onChanged: (v) => setState(() => _method = v ?? 'CBE Bank'),
          ),
          const SizedBox(height: 10),
          TextField(controller: _accCtrl, decoration: const InputDecoration(labelText: 'Your Account Number / Telebirr / Wallet', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFF151C2F), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.amber)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gross Value: ${grossEtb.toStringAsFixed(2)} ETB', style: const TextStyle(color: Colors.white70)),
                Text('Tax Deducted (${(taxRate * 100).toInt()}%): -${taxEtb.toStringAsFixed(2)} ETB', style: const TextStyle(color: Colors.redAccent)),
                const Divider(color: Colors.white24),
                Text('Net Payout: ${netEtb.toStringAsFixed(2)} ETB', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 14)),
            onPressed: _sending ? null : () async {
              if (pts < 100000) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.redAccent, content: Text('❌ Minimum transfer is 100,000 Diamonds!')));
                return;
              }
              if (_channel != 'Payroll Admin' && _receiverIdCtrl.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please paste $_channel ID first')));
                return;
              }
              if (_accCtrl.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter your payment account details')));
                return;
              }
              if (AppState.points < pts) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Insufficient Diamonds balance (Need >= 100,000)')));
                return;
              }
              setState(() => _sending = true);
              AppState.points -= pts;
              widget.onUpd();
              try {
                await http.post(
                  Uri.parse('$serverUrl/api/cashout'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({
                    'userId': AppState.userId,
                    'userName': AppState.userName,
                    'channel': _channel,
                    'receiverId': _receiverIdCtrl.text.trim(),
                    'diamonds': pts,
                    'grossEtb': grossEtb.toStringAsFixed(2),
                    'taxEtb': taxEtb.toStringAsFixed(2),
                    'netEtb': netEtb.toStringAsFixed(2),
                    'method': _method,
                    'account': _accCtrl.text.trim(),
                  }),
                );
              } catch (_) {}
              if (!mounted) return;
              setState(() => _sending = false);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text('✅ Transferred ${pts.toStringAsFixed(0)} Diamonds (${netEtb.toStringAsFixed(2)} ETB) to $_channel (ID: ${_receiverIdCtrl.text.trim()})!')));
              Navigator.pop(context);
            },
            child: Text(_sending ? 'Transferring...' : 'Transfer ${pts.toStringAsFixed(0)} Diamonds to $_channel', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ],
      ),
    );
  }
}
